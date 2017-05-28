`timescale 1ns / 1ps


/* '''
Documentation

    ipcu - inport control unit
 '''*/
module ipcu
	(
		input wire clk,
		input wire rst,
	    // --- input  --- //
		input wire 	arb_ack,
		input wire 	pipe_en,
	    // --- output --- //
		output wire wr_strobe,
		output wire rd_strobe,
        output wire rqs_strobe,
		output wire crt_out
    );


// --- localparam --- //
    localparam IDLE=2'b00;
    localparam NEW =2'b01; 
    localparam ACK =2'b01;
    localparam PUSH=2'b10;
    localparam PULL=2'b10; 


// --- signals --- //
    // --- fsm packet receiver --- //
        reg [1:0] istate_next;
        reg [1:0] istate_reg;

    // --- fsm packet forwarder --- //
        reg [1:0] ostate_next;
        reg [1:0] ostate_reg;

    // --- inbound packet counter --- //
        wire icntr_sub;
        wire icntr_rst;
        
        reg  [1:0] icntr_reg=2'b11;    

    // --- out going packet counter --- //
        wire ocntr_sub;
        wire ocntr_rst;
        
        reg  [1:0] ocntr_reg=2'b11;

    // --- request strobe --- //
        wire fcntr_inc;
        wire fcntr_sub;
        wire fcntr_rst;
        
        reg  [2:0] fcntr_reg =3'b000;
        reg  [2:0] fcntr_next=3'b000;        



// --- inbound packet counter --- //
// '''Documentation
    always @(posedge clk)
        if (icntr_rst)
            icntr_reg<=2'b11;
        else if (icntr_sub)
            icntr_reg<=icntr_reg-1'b1;
        else
            icntr_reg<=icntr_reg;

    assign icntr_rst =(istate_reg==IDLE && istate_next==NEW) ? 1'b1 :
                      (istate_reg==PUSH && istate_next==NEW) ? 1'b1 :
                      1'b0;

    assign icntr_sub =(istate_reg==NEW  && istate_next==PUSH) ? 1'b1 :
                      (istate_reg==PUSH && istate_next==PUSH) ? 1'b1 :
                      1'b0;




// --- fsm packet receiver --- //
// '''Documentation

    // --- memory element --- //
    always @(posedge clk)
        if (rst)
            istate_reg<=IDLE;
        else
            istate_reg<=istate_next;

    // --- next state logic --- //
    always @(*) begin
        istate_next=istate_reg;
        case (istate_reg)
            IDLE:
                if (pipe_en)
                    istate_next=NEW;
            NEW:
                istate_next=PUSH;
            PUSH:
                if (~|icntr_reg && ~pipe_en)
                    istate_next=IDLE;
                else if (~|icntr_reg && pipe_en)
                    istate_next=NEW;
                else
                    istate_next=PUSH;
        endcase
    end

    // --- fsm output drivers --- //
    assign wr_strobe=(istate_reg==IDLE && istate_next==NEW)  ? 1'b1 :
                     (istate_reg==NEW  && istate_next==PUSH) ? 1'b1 :
                     (istate_reg==PUSH && istate_next==PUSH) ? 1'b1 :
                     (istate_reg==PUSH && istate_next==NEW)  ? 1'b1 :
                     1'b0;
        




// --- out going packet counter --- //
// '''Documentation
    always @(posedge clk)
        if (ocntr_rst)
            ocntr_reg<=2'b11;
        else if (ocntr_sub)
            ocntr_reg<=ocntr_reg-1'b1;
        else
            ocntr_reg<=ocntr_reg;


    assign ocntr_rst=(ostate_reg==IDLE && ostate_next==ACK)  ? 1'b1 :
                     (ostate_reg==PULL && ostate_next==ACK)  ? 1'b1 :
                     1'b0; 

    assign ocntr_sub=(ostate_reg==ACK  && ostate_next==PULL) ? 1'b1 :
                     (ostate_reg==PULL && ostate_next==PULL) ? 1'b1 :
                     1'b0;





// --- fsm packet forwarder --- //
    // --- memory element --- //
    always @(posedge clk)
        if (rst)
            ostate_reg<=IDLE;
        else
            ostate_reg<=ostate_next;

    // --- next state logic --- //
    always @(*) begin
        ostate_next=ostate_reg;
        case (ostate_reg)
            IDLE:
                if (arb_ack)
                    ostate_next=ACK;
            ACK:
                ostate_next=PULL;
            PULL:
                if (~|ocntr_reg && ~arb_ack)
                    ostate_next=IDLE;
                else if (~|ocntr_reg && arb_ack)
                    ostate_next=ACK;
                else
                    ostate_next=PULL;
        endcase
    end

    // --- output drivers --- //
    assign crt_out   = (ostate_reg==IDLE && ostate_next==ACK)   ? 1'b1 :
                       (ostate_reg==PULL && ostate_next==ACK)   ? 1'b1 :
                       1'b0;

    assign rd_strobe = (ostate_reg==IDLE && ostate_next==ACK)   ? 1'b1 :
                       (ostate_reg==ACK  && ostate_next==PULL)  ? 1'b1 :
                       (ostate_reg==PULL && ostate_next==PULL)  ? 1'b1 :
                       (ostate_reg==PULL && ostate_next==ACK)   ? 1'b1 :
                       1'b0;




// --- request strone --- //
// '''Documentation

    // flit counter   
    // --- memory element --- // 
    always @(posedge clk)
        fcntr_reg<=fcntr_next;
    
    // --- next state logic --- //
    assign fcntr_inc=(istate_reg==IDLE && istate_next==NEW) ? 1'b1 : 
                     (istate_reg==PUSH && istate_next==NEW) ? 1'b1 :
                     1'b0;
    assign fcntr_sub=(ostate_reg==IDLE && ostate_next==ACK) ? 1'b1 : 
                     (ostate_reg==PULL && ostate_next==ACK) ? 1'b1 :
                     1'b0;

    always @(*)
        case({fcntr_inc, fcntr_sub})
            2'b00:
                fcntr_next = fcntr_reg;
            2'b01: // decrement 
                fcntr_next = fcntr_reg - 1'b1;
            2'b10: // increment 
                fcntr_next = fcntr_reg + 1'b1;
            2'b11:
                fcntr_next = fcntr_reg;
        endcase

    // --- output drivers --- //
    assign rqs_strobe=(istate_reg==NEW && istate_next==PUSH) ? 1'b1 :
                      (~|ocntr_reg && |fcntr_reg)            ? 1'b1 :
                      1'b0;

endmodule
