`timescale 1ns / 1ps

/* '''
Documentation

    ccs - crossbar control segment
 '''*/


module ccs
	(
		input wire 	clk,
    /* --- inputs --- */
        input wire  credit_in,
		input wire  [PORTS-1:0]	port_rqs,
    /* --- outputs --- */
		output wire [PORTS-1:0] arb_ack,
		output wire [PORTS-1:0]	xbar_cfg_vector
    );


    genvar index;

// --- local parameters --- //
    localparam PORTS   = 5;
    localparam CREDITS = 4;

    localparam IDLE = 2'b00;
    localparam NEW  = 2'b01;
    localparam PULL = 2'b10;

    localparam ZERO = 2'b00;
    localparam HOLD = 2'b01;
    localparam NEXT = 2'b10;

    localparam FULL = 2'b11;



// --- signals --- //

    // --- credit handler --- //
        wire any_crd;

        wire [2:0] crd_next;
        reg  [2:0] crd_reg = CREDITS;

    // --- arbiter --- //
        wire [PORTS-1:0] grant_vector_next;

        wire [PORTS-1:0] p_next;
        reg  [PORTS-1:0] p_reg = 1;

        wire [PORTS-1:0] arb1_grant;
        wire [PORTS-1:0] arb2_grant;

        wire [PORTS-1:0] arb1_cc;
        wire [PORTS-1:0] arb2_cc;

    // --- opcu --- //
        wire any_grant;
        wire any_rqs;
        wire arb_grant;

        reg  [1:0] fsm_cnt_reg = 2'b00;
        wire [1:0] fsm_cnt_next;

        wire [1:0] fsm_mux_cfg;

        reg  [1:0] state_reg = IDLE;
        reg  [1:0] state_next;

    // --- hold circuit --- //
        wire [PORTS-1:0] cfg_vector_next;
        reg  [PORTS-1:0] cfg_vector_reg = 0;




// --- credit handler --- //
// '''Documentation

    /* --- memory logic --- */
    always @(posedge clk)
        crd_reg <= crd_next;

    /* --- next state logic --- */
    assign crd_next = (credit_in)                              ? crd_reg + 1'b1 :
                      (state_reg == IDLE && state_next == NEW) ? crd_reg - 1'b1 :
                      (state_reg == PULL && state_next == NEW) ? crd_reg - 1'b1 :
                      crd_reg;

    /* --- output logic --- */
    assign any_crd = |crd_reg;





// --- arbiter --- //
// '''Documentation

    // --- priority encoder ---
        // --- memory logic --- //
        always @(posedge clk)
            p_reg <= p_next;
        
        // --- combinational logic --- //
        assign p_next = (state_reg == NEW && state_next == PULL) ? {cfg_vector_reg[PORTS-2:0], cfg_vector_reg[PORTS-1]} :
                        p_reg; 



    // --- arbiter --- //
        // --- arbiter slice 1 --- //
        generate
            for(index=0; index<PORTS; index=index+1)
                begin: arb1_grant_slice
                    assign arb1_grant[index] = (p_reg[index] | arb1_cc[index]) & port_rqs[index];
                end
        endgenerate

        assign arb1_cc[0] = 1'b0;
        generate
            for (index=1; index<PORTS; index=index+1)
                begin: arb1_cc_slice
                    assign arb1_cc[index] = (p_reg[index-1] | arb1_cc[index-1]) & ~port_rqs[index-1];
                end
        endgenerate

        
        // --- arbiter slice 2 --- //
        generate
            for(index=0; index<PORTS; index=index+1)
                begin: arb2_grant_slice
                    assign arb2_grant[index] = (p_reg[index] | arb2_cc[index]) & port_rqs[index];
                end
        endgenerate

        assign arb2_cc[0] = arb1_cc[PORTS-1]; 
        generate
            for (index=1; index<PORTS; index=index+1)
                begin: arb2_cc_slice
                    assign arb2_cc[index] = (p_reg[index-1] | arb2_cc[index-1]) & ~port_rqs[index-1];
                end
        endgenerate


        // --- output logic --- // 
        assign grant_vector_next = arb1_grant | arb2_grant;




// --- ccu --- //
/* '''
    Documentation
    
    ccu - crossbar control unit
   '''*/

    /* --- control --- */
    assign any_rqs   = |port_rqs;
    assign any_grant = |cfg_vector_reg;

    /* --- memory logic --- */
    always @(posedge clk)
        state_reg <= state_next;

    /* --- combinational logic --- */
    always @(*) begin
        state_next = IDLE;
        case (state_reg)
            IDLE: 
                if (any_rqs && any_crd)
                    state_next = NEW;
                else
                    state_next = IDLE;
            NEW:
                state_next = PULL;
            PULL:
                if (|fsm_cnt_reg)
                    state_next = PULL;
                else if (~|fsm_cnt_reg && any_rqs && any_crd)
                    state_next = NEW;
                else
                    state_next = IDLE; 
        endcase
    end

    /* --- output logic --- */
    assign fsm_mux_cfg  = (state_reg == IDLE && state_next == NEW)  ? NEXT :
                          (state_reg == PULL && state_next == NEW)  ? NEXT :
                          (state_reg == NEW  && state_next == PULL) ? HOLD :
                          (state_reg == PULL && state_next == PULL) ? HOLD :
                          ZERO;


    assign arb_grant   = (state_reg == NEW && state_next == PULL) ? 1'b1 :
                         (state_reg == PULL && state_next == NEW) ? 1'b1 :
                         1'b0;

    assign arb_ack     = {5{arb_grant}} & cfg_vector_reg;


    /* --- fsm counter memory logic --- */
    always @(posedge clk)
        fsm_cnt_reg <= fsm_cnt_next;

    /* --- fsm counter combinational logic --- */
    assign fsm_cnt_next = (state_reg == IDLE && state_next == NEW)  ? FULL               :
                          (state_reg == PULL && state_next == NEW)  ? FULL               :
                          (state_reg == NEW  && state_next == PULL) ? fsm_cnt_reg - 1'b1 :
                          (state_reg == PULL && state_next == PULL) ? fsm_cnt_reg - 1'b1 :
                          fsm_cnt_reg;





// --- hold circuit --- //
// '''Documentation

    /* --- bit slice --- */
    generate
        for (index=0; index<PORTS;index=index+1)
            begin: hold_slice
                assign cfg_vector_next[index] = (fsm_mux_cfg == NEXT) ? grant_vector_next[index]  :
                                                (fsm_mux_cfg == HOLD) ? cfg_vector_reg   [index]  :
                                                1'b0;
                always @(posedge clk)
                    cfg_vector_reg[index] <= cfg_vector_next[index];
            end
    endgenerate

/* --- output logic --- */
    assign xbar_cfg_vector = cfg_vector_reg;


endmodule
