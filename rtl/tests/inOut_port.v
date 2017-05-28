`timescale 1ns / 1ps

module inOut_port
    (
        input wire clk,
        input wire rst,
        /* --- input --- */
		input wire diff_pair_p_in,
		input wire diff_pair_n_in,        
        input wire [31:0] input_channel,
        input wire  credit_in,
        
        /* --- output --- */
        output wire [31:0] data_out,
        output wire crt_out,
		output wire diff_pair_p_out,
		output wire diff_pair_n_out,        
		output wire [3:0]	xbar_cfg_vector
    );

/* --- INPORT --- */
wire [3:0] arb_ack;
wire [31:0] channel_data;
wire [31:0] xbar_data;
wire [3:0] port_rqs;
wire pe_rqs;
wire ack;

inport inport	(
	.clk(clk),
	.rst(rst),
	.diff_pair_p(diff_pair_p_in),
	.diff_pair_n(diff_pair_n_in),
	.arb_ack(ack),
	.input_channel(input_channel),
    .channel_data(xbar_data),
	.crt_out(crt_out),
	.port_rqs(port_rqs),
    .pe_rqs(pe_rqs)
);

arbiter arbiter
	(
		.clk(clk),
    /* --- inputs --- */
        .credit_in(credit_in),
		.port_rqs(port_rqs),
    /* --- outputs --- */
		.arb_ack(arb_ack),
		.xbar_cfg_vector(xbar_cfg_vector)
    );


/* --- UUT --- */
outport outport	(
	.clk(clk),
	.rst(rst),
	.arb_ack(ack),
	.xbar_data(xbar_data),
	.diff_pair_p(diff_pair_p_out),
	.diff_pair_n(diff_pair_n_out),
	.output_channel(data_out)
);


assign ack = |arb_ack;


endmodule// flow_handler

