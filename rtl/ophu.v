
`timescale 1ns / 1ps

/* '''
Documentation

    ophu - outport protocol handler unit
 '''*/

module ophu
	(
		input wire clk,
    // --- inputs --- //
		input wire arb_ack,
    // --- outputs --- //
		output wire diff_pair_p,
		output wire diff_pair_n
	);

// --- Signal  --- //
    reg	diff_pair_p_reg = 1'b1;
    reg	diff_pair_n_reg = 1'b0;




// --- differential par handler --- //
    // --- memory logic --- //
    always @(posedge clk)
        if (arb_ack) 
            begin
       		    diff_pair_p_reg <= ~diff_pair_p_reg;
       		    diff_pair_n_reg <= ~diff_pair_n_reg;
       	    end
        else
            begin
       		    diff_pair_p_reg <= diff_pair_p_reg;
       		    diff_pair_n_reg <= diff_pair_n_reg;
       	    end

    // --- output logic --- //
    assign	diff_pair_p = diff_pair_p_reg;
    assign	diff_pair_n = diff_pair_n_reg;


endmodule
