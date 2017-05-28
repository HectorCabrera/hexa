`timescale 1ns / 1ps

module arbiter_tb();

/* --- signal declaration for UUT --- */
	reg clk;
	reg credit_in;

/* --- UUT --- */
arbiter UUT	(
	.clk(clk),
	.credit_in(credit_in)
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
	credit_in = 0;
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