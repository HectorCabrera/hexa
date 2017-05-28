`timescale 1ns / 1ps

module rgu_tb();

/* --- signal declaration for UUT --- */
	reg clk;
	reg rst;
	reg rqs_strobe;
	reg arb_ack;
	reg [7:0] addr;
	wire [4:0] rqs_vector;

/* --- UUT --- */
rgu UUT	(
	.clk(clk),
	.rst(rst),
	.rqs_strobe(rqs_strobe),
	.arb_ack(arb_ack),
	.addr(addr),
	.rqs_vector(rqs_vector)
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
	rqs_strobe = 0;
	arb_ack = 0;
	addr = 0;
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