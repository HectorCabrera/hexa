`timescale 1ns / 1ps

/* '''
Documentation

    iphu - inport protocol handler unit
 '''*/
module iphu
	(
		input wire clk,
        // --- inputs --- //
		input wire diff_pair_p,
		input wire diff_pair_n,
        // --- outputs --- //
		output wire pipe_en
	);


// --- Signal declaration --- //
    reg	diff_pair_p_reg = 1'b1;
    reg	diff_pair_n_reg = 1'b0;

    wire pipe_enable;

// --- differential par handler --- //
    // --- memory logic --- //
    always @(posedge clk)
        if (pipe_enable) 
            begin
       		    diff_pair_p_reg <= ~diff_pair_p_reg;
       		    diff_pair_n_reg <= ~diff_pair_n_reg;
       	    end

    // --- next state logic --- //
    assign 	pipe_enable = ((diff_pair_p ^ diff_pair_p_reg) & (diff_pair_n ^ diff_pair_n_reg)) ? 1'b1 : 1'b0;
    
    // --- output logic --- //
    assign	pipe_en = pipe_enable;


endmodule
