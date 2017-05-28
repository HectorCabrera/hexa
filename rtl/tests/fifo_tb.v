`timescale 1ns / 1ps

module fifo_tb();

/* --- signal declaration for UUT --- */
	reg clk;
	reg rst;
	reg wr_strobe;
	reg rd_strobe;
	wire full;
	wire empty;

/* --- UUT --- */
fifo UUT	(
	.clk(clk),
	.rst(rst),
	.wr_strobe(wr_strobe),
	.rd_strobe(rd_strobe),
	.full(full),
	.empty(empty)
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
	wr_strobe = 0;
	rd_strobe = 0;
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