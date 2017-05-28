`timescale 1ns / 1ps

/* '''
Documentation
 '''*/

module inport
    (
        input wire clk,
        input wire rst,
        /* --- input --- */
		input wire diff_pair_p,
		input wire diff_pair_n,        

        input wire arb_ack,
        input wire [31:0] input_channel,
        /* --- output --- */
        output wire [31:0] channel_data,
        output wire crt_out,
        output wire [PORTS-1:0] port_rqs
    );

// --- localparam --- //
    localparam PORTS = 5;



// --- signals --- //
    // --- iphu --- //
        wire pipe_en;

    // --- ipcu --- //
        wire wr_strobe;
        wire rd_strobe;
        wire addr_src;
        wire rqs_strobe;

    // --- fifo --- //
        wire [31:0] rd_data;



// ---  iphu --- //
/* '''Documentation
    
    iphu - inport protocol handler unit
   '''*/

     iphu iphu
    	(
    		.clk(clk),
            // --- inputs --- //
    		.diff_pair_p(diff_pair_p),
    		.diff_pair_n(diff_pair_n),
            // --- outputs --- //    
    		.pipe_en(pipe_en)
    	);




// --- ipcu --- //
/* '''Documentation

    ipcu - inport control unit
   '''*/ 
    
    ipcu ipcu	
    (
    	.clk(clk),
    	.rst(rst),
        // --- inputs --- //
    	.arb_ack(arb_ack),
    	.pipe_en(pipe_en),
        // --- outputs --- //
    	.wr_strobe(wr_strobe),
    	.rd_strobe(rd_strobe),
    	.rqs_strobe(rqs_strobe),
    	.crt_out(crt_out)
    );




// --- FIFO --------------------------------------------------------------------
// '''Documentation

    fifo fifo	
    (
    	.clk(clk),
    	.rst(rst),
        /* --- inputs --- */
        .wr_data(input_channel),
    	.wr_strobe(wr_strobe),
    	.rd_strobe(rd_strobe),
        /* --- outputs --- */
        .rd_data(channel_data)
    );




// --- rgu ---------------------------------------------------------------------
/* '''Documentation

    rgu - request generator unit
   '''*/

    rgu rgu
    (
    	.clk(clk),
    	.rst(rst),
        // --- inputs --- // 
    	.rqs_strobe(rqs_strobe),
    	.arb_ack(arb_ack),
    	.addr(channel_data[31:24]),
        // --- outputs --- //
    	.rqs_vector(port_rqs)
    );


endmodule
