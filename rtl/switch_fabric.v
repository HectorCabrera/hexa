
`timescale 1ns / 1ps

/* '''
Documentation
 '''*/

module switch_fabric
	(
    // --- inputs --- //
        input wire [31:0] dinA, // x+
        input wire [31:0] dinB, // x-
        input wire [31:0] dinC, // y+
        input wire [31:0] dinD, // y-
        input wire [31:0] dinE, // pe

        input wire [4:0]  sf_cfg_vecA,
        input wire [4:0]  sf_cfg_vecB,
        input wire [4:0]  sf_cfg_vecC,
        input wire [4:0]  sf_cfg_vecD,
        input wire [4:0]  sf_cfg_vecE,
    // --- outputs --- //
		output reg [31:0] doutA, // x+
		output reg [31:0] doutB, // x-
		output reg [31:0] doutC, // y+
		output reg [31:0] doutD, // y-
		output reg [31:0] doutE  // pe
    );


// --- localpara --- //
    localparam RQS0 = 5'b00001;
    localparam RQS1 = 5'b00010;
    localparam RQS2 = 5'b00100;
    localparam RQS3 = 5'b01000;
    localparam RQS4 = 5'b10000;



// --- A mux X+ --- //
    always @(*) begin
        doutA = {32{1'b0}};
        case (sf_cfg_vecA)
            RQS0:   doutA = dinA;
            RQS1:   doutA = dinB;
            RQS2:   doutA = dinC;
            RQS3:   doutA = dinD;
            RQS4:   doutA = dinE;
        endcase
    end


// --- B mux X- --- //
    always @(*) begin
        doutB = {32{1'b0}};
        case (sf_cfg_vecB)
            RQS0:   doutB = dinA;
            RQS1:   doutB = dinB;
            RQS2:   doutB = dinC;
            RQS3:   doutB = dinD;
            RQS4:   doutB = dinE;
        endcase
    end



// --- C mux Y+ --- //
    always @(*) begin
        doutC = {32{1'b0}};
        case (sf_cfg_vecC)
            RQS0:   doutC = dinA;
            RQS1:   doutC = dinB;
            RQS2:   doutC = dinC;
            RQS3:   doutC = dinD;
            RQS4:   doutC = dinE;
        endcase
    end



// --- D mux Y- --- //
    always @(*) begin
        doutD = {32{1'b0}};
        case (sf_cfg_vecD)
            RQS0:   doutD = dinA;
            RQS1:   doutD = dinB;
            RQS2:   doutD = dinC;
            RQS3:   doutD = dinD;
            RQS4:   doutD = dinE;
        endcase
    end



// --- E mux PE --- //
    always @(*) begin
        doutE = {32{1'b0}};
        case (sf_cfg_vecE)
            RQS0:   doutE = dinA;
            RQS1:   doutE = dinB;
            RQS2:   doutE = dinC;
            RQS3:   doutE = dinD;
            RQS4:   doutE = dinE;
        endcase
    end


endmodule
