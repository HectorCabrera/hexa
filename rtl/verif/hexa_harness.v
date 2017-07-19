`timescale 1ns / 1ps


module hexa_harness();

parameter 	XCOR = 2,
			YCOR = 2,
			CYCLE  = 100,
			Tsetup = 15,
			Thold  = 5,
			XPOS = 0,
			XNEG = 1,
			YPOS = 2,
			YNEG = 3,
			PE   = 4;


// --- local signals --- //
	reg clk;
	reg rst;

	wire diff_pair_pi [4:0];
	wire diff_pair_ni [4:0];
	wire crt_in [4:0];
	wire [31:0] input_channels  [4:0];

	wire diff_pair_po [4:0];
	wire diff_pair_no [4:0];
	wire crt_out [4:0];
	wire [31:0] output_channels [4:0];




// --- DUT --- //
/* '''
Documentation

PORT order:

  offset   port	
	0	-	x+
	1	-	x-
	2	-	y+
	3	-	y-
	4	-	pe

 '''*/

hexa 
	#(.XCOR(XCOR), .YCOR(YCOR))
hexa
	(
		.clk(clk),
		.rst(rst),
    // --- inputs --- //
        .diff_pair_pi({diff_pair_pi[4], diff_pair_pi[3], diff_pair_pi[2], diff_pair_pi[1], diff_pair_pi[0]}),					// [4:0]
        .diff_pair_ni({diff_pair_ni[4], diff_pair_ni[3], diff_pair_ni[2], diff_pair_ni[1], diff_pair_ni[0]}),					// [4:0]
        .crt_in({crt_in[4], crt_in[3], crt_in[2], crt_in[1], crt_in[0]}),														// [4:0]
        .input_channels({input_channels[4], input_channels[3], input_channels[2], input_channels[1], input_channels[0]}),		// [159:0]
    // --- outputs --- //
        .diff_pair_po({diff_pair_po[4], diff_pair_po[3], diff_pair_po[2], diff_pair_po[1], diff_pair_po[0]}),					// [4:0]
        .diff_pair_no({diff_pair_no[4], diff_pair_no[3], diff_pair_no[2], diff_pair_no[1], diff_pair_no[0]}),					// [4:0]
        .crt_out({crt_out[4], crt_out[3], crt_out[2], crt_out[1], crt_out[0]}),													// [4:0]
        .output_channels({output_channels[4], output_channels[3], output_channels[2], output_channels[1], output_channels[0]})	// [159:0]
    );





// --- Bus Behaivoral Model --- //

	// --- Canal x+ --- //
		source
			#(
				.Thold(Thold),
				.PORT(XPOS)
			)
		xpos_in_channel
			(
				.clk 		(clk),
				.credit_in 	(crt_out[0]),
				.channel_out(input_channels[0]),
				.diff_pair_out({diff_pair_pi[0], diff_pair_ni[0]})
			);


		sink
			#(
				.Thold(Thold)
			)
		xpos_out_channel
			(
				.clk 		(clk),
				.channel_in (output_channels[0]),
				.credit_out (crt_in[0]),
				.diff_pair_in({diff_pair_po[0], diff_pair_no[0]})
			);




	// --- Canal x- --- //
		source
			#(
				.Thold(Thold),
				.PORT(XNEG)
			)
		xneg_in_channel
			(
				.clk 		(clk),
				.credit_in 	(crt_out[1]),
				.channel_out(input_channels[1]),
				.diff_pair_out({diff_pair_pi[1], diff_pair_ni[1]})
			);


		sink
			#(
				.Thold(Thold)
			)
		xneg_out_channel
			(
				.clk 		(clk),
				.channel_in (output_channels[1]),
				.credit_out (crt_in[1]),
				.diff_pair_in({diff_pair_po[1], diff_pair_no[1]})
			);




	// --- Canal y+ --- //
		source
			#(
				.Thold(Thold),
				.PORT(YPOS)
			)
		ypos_in_channel
			(
				.clk 		(clk),
				.credit_in 	(crt_out[2]),
				.channel_out(input_channels[2]),
				.diff_pair_out({diff_pair_pi[2], diff_pair_ni[2]})
			);


		sink
			#(
				.Thold(Thold)
			)
		ypos_out_channel
			(
				.clk 		(clk),
				.channel_in (output_channels[2]),
				.credit_out (crt_in[2]),
				.diff_pair_in({diff_pair_po[2], diff_pair_no[2]})
			);




	// --- Canal y- --- //
		source
			#(
				.Thold(Thold),
				.PORT(YNEG)
			)
		yneg_in_channel
			(
				.clk 		(clk),
				.credit_in 	(crt_out[3]),
				.channel_out(input_channels[3]),
				.diff_pair_out({diff_pair_pi[3], diff_pair_ni[3]})
			);


		sink
			#(
				.Thold(Thold)
			)
		yneg_out_channel
			(
				.clk 		(clk),
				.channel_in (output_channels[3]),
				.credit_out (crt_in[3]),
				.diff_pair_in({diff_pair_po[3], diff_pair_no[3]})
			);




	// --- Canal pe --- //
		source
			#(
				.Thold(Thold),
				.PORT(PE)
			)
		pe_in_channel
			(
				.clk 		(clk),
				.credit_in 	(crt_out[4]),
				.channel_out(input_channels[4]),
				.diff_pair_out({diff_pair_pi[4], diff_pair_ni[4]})
			);


		sink
			#(
				.Thold(Thold)
			)
		pe_out_channel
			(
				.clk 		(clk),
				.channel_in (output_channels[4]),
				.credit_out (crt_in[4]),
				.diff_pair_in({diff_pair_po[4], diff_pair_no[4]})
			);






// -- Clock Generator --- //
	always 	
		begin
			#(CYCLE/2)	clk = 1'b0;
			#(CYCLE/2)	clk = 1'b1;
		end


// -- Sync Reset Generator --- //
	task sync_reset;
		begin


			reset <= 1'b1;
			repeat(4)
				begin
					@(posedge clk);
					#(Thold);
				end
			reset <= 1'b0;

		end	
	endtask : sync_reset



endmodule
