`timescale 1ns / 1ps

module inOut_port_tb();

/* --- signal declaration for UUT --- */
	reg clk;
	reg rst;
	reg diff_pair_p_in;
	reg diff_pair_n_in;
	reg [31:0] input_channel;
    wire [31:0] data_out;
	reg credit_in;
	wire crt_out;
	wire diff_pair_p_out;
	wire diff_pair_n_out;
	wire [3:0] xbar_cfg_vector;

/* --- UUT --- */
inOut_port UUT	(
	.clk(clk),
	.rst(rst),
	.diff_pair_p_in(diff_pair_p_in),
	.diff_pair_n_in(diff_pair_n_in),
	.input_channel(input_channel),
    .data_out(data_out),
	.credit_in(credit_in),
    .diff_pair_p_out(diff_pair_p_out),
	.diff_pair_n_out(diff_pair_n_out),        
	.crt_out(crt_out),
	.xbar_cfg_vector(xbar_cfg_vector)
);

/* --- clock signal generator --- */
always begin
	clk = 1'b0;
	#(10);
	clk = 1'b1;
	#(10);
end

/* --- initial block --- */
initial begin
	clk = 0;
	rst = 1;
	diff_pair_p_in = 1;
	diff_pair_n_in = 0;
	input_channel = 0;
	credit_in = 0;

    repeat(20)
        posEdge();
    rst = 0;
    repeat(4)
        posEdge();

    diff_pair_p_in=~diff_pair_p_in;
    diff_pair_n_in=~diff_pair_n_in;
    input_channel = 32'h11000000;
    posEdge();
    input_channel = 32'h00FF0000;
    posEdge();
    input_channel = 32'h0000FF00;
    posEdge();
    input_channel = 32'h000000FF;
    posEdge();
    input_channel = 32'h00000000;

    
    repeat(20)
        posEdge();
    credit_in = 1;
    posEdge();

    credit_in = 0;
    #(2000)

	$stop;
end

/* --- Task Area --- */
task posEdge();
	begin
		@(posedge clk)
		#(2);
	end
endtask

endmodule
