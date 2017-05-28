`timescale 1ns / 1ps

module switch_fabric_tb();

/* --- signal declaration for UUT --- */
	reg [31:0] dinA;
	reg [31:0] dinB;
	reg [31:0] dinC;
	reg [31:0] dinD;
	reg [31:0] dinE;
	reg [3:0] sf_cfg_vecA;
	reg [3:0] sf_cfg_vecB;
	reg [3:0] sf_cfg_vecC;
	reg [3:0] sf_cfg_vecD;
	reg [3:0] sf_cfg_vecE;
	wire [31:0] doutA;
	wire [31:0] doutB;
	wire [31:0] doutC;
	wire [31:0] doutD;
	wire [31:0] doutE;

/* --- UUT --- */
switch_fabric UUT	(
	.dinA(dinA),
	.dinB(dinB),
	.dinC(dinC),
	.dinD(dinD),
	.dinE(dinE),
	.sf_cfg_vecA(sf_cfg_vecA),
	.sf_cfg_vecB(sf_cfg_vecB),
	.sf_cfg_vecC(sf_cfg_vecC),
	.sf_cfg_vecD(sf_cfg_vecD),
	.sf_cfg_vecE(sf_cfg_vecE),
	.doutA(doutA),
	.doutB(doutB),
	.doutC(doutC),
	.doutD(doutD),
	.doutE(doutE)
);

/* --- clock signal generator --- */
//always begin
//	clk = 1'b0;
//	#(10);
//	clk = 1'b1;
//	#(10);
//end

/* --- initial block --- */
initial begin

	sf_cfg_vecA = 0;
	sf_cfg_vecB = 0;
	sf_cfg_vecC = 0;
	sf_cfg_vecD = 0;
	sf_cfg_vecE = 0;

	dinA = 1;
	dinB = 2;
	dinC = 3;
	dinD = 4;
	dinE = 5;
    
    #(60);

	sf_cfg_vecA = 4'b0001;
    #(20);	
	sf_cfg_vecA = 4'b0010;
    #(20);	
	sf_cfg_vecA = 4'b0100;
    #(20);	
	sf_cfg_vecA = 4'b1000;
    #(20);	
	sf_cfg_vecA = 4'b0000;
    #(20);	


	sf_cfg_vecB = 4'b0001;
    #(20);	
	sf_cfg_vecB = 4'b0010;
    #(20);	
	sf_cfg_vecB = 4'b0100;
    #(20);	
	sf_cfg_vecB = 4'b1000;
    #(20);	
	sf_cfg_vecB = 4'b0000;
    #(20);	


	sf_cfg_vecC = 4'b0001;
    #(20);	
	sf_cfg_vecC = 4'b0010;
    #(20);	
	sf_cfg_vecC = 4'b0100;
    #(20);	
	sf_cfg_vecC = 4'b1000;
    #(20);	
	sf_cfg_vecC = 4'b0000;
    #(20);	


	sf_cfg_vecD = 4'b0001;
    #(20);	
	sf_cfg_vecD = 4'b0010;
    #(20);	
	sf_cfg_vecD = 4'b0100;
    #(20);	
	sf_cfg_vecD = 4'b1000;
    #(20);	
	sf_cfg_vecD = 4'b0000;
    #(20);	


	sf_cfg_vecE = 4'b0001;
    #(20);	
	sf_cfg_vecE = 4'b0010;
    #(20);	
	sf_cfg_vecE = 4'b0100;
    #(20);	
	sf_cfg_vecE = 4'b1000;
    #(20);	
	sf_cfg_vecE = 4'b0000;
    #(20);	




    #(500)
	$stop;
    
end

/* --- Task Area --- */
//task posEdge();
//	begin
//		@(posedge clk)
//		#(2);
//	end
//endtask

endmodule
