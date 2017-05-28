`timescale 1ns / 1ps

module ipcu_tb();

/* --- signal declaration for UUT --- */
	reg clk;
	reg rst;
	reg arb_ack;
	reg pipe_en;
	wire wr_strobe;
	wire rd_strobe;
	wire rqs_strobe;
	wire crt_out;

/* --- UUT --- */
ipcu UUT	(
	.clk(clk),
	.rst(rst),
	.arb_ack(arb_ack),
	.pipe_en(pipe_en),
	.wr_strobe(wr_strobe),
	.rd_strobe(rd_strobe),
	.rqs_strobe(rqs_strobe),
	.crt_out(crt_out)
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
	rst = 0;
	arb_ack = 0;
	pipe_en = 0;
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