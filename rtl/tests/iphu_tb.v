`timescale 1ns / 1ps

module iphu_tb();

/* --- signal declaration for UUT --- */
	reg clk;
	reg diff_pair_p;
	reg diff_pair_n;
	wire pipe_en;

/* --- UUT --- */
iphu UUT	(
	.clk(clk),
	.diff_pair_p(diff_pair_p),
	.diff_pair_n(diff_pair_n),
	.pipe_en(pipe_en)
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
	diff_pair_p = 0;
	diff_pair_n = 0;
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