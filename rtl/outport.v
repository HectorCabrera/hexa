
`timescale 1ns / 1ps

/* '''
Documentation
 '''*/

module outport
    (
        input wire clk,
        input wire rst,
        /* --- input --- */
        input wire arb_ack,
        input wire [31:0] xbar_data,

        /* --- output --- */
		output wire diff_pair_p,
		output wire diff_pair_n,        

        output wire [31:0] output_channel
    );

// --- signals ---//
    // --- output register --- //
    reg [31:0] xbar_data_reg;



// ---  opho --- //
// '''Documentation
ophu ophu	(
	.clk(clk),

	.arb_ack(arb_ack),

	.diff_pair_p(diff_pair_p),
	.diff_pair_n(diff_pair_n)
);


// ---  output register --- //
    always @(posedge clk)
        xbar_data_reg <= xbar_data;

    // --- output logic --- //
    assign output_channel = xbar_data_reg;


endmodule
