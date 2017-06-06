`timescale 1ns / 1ps


module hexa_harness();

parameter 	XCOR = 2,
			YCOR = 2,
			CYCLE  = 100,
			Tsetup = 15,
			Thold  = 5;

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
		rst(rst),
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
				.Thold(Thold)
			)
		xpos_in_channel
			(
				.clk 		(clk),
				.credit_in 	(credit_out_xpos_dout),
				.channel_out(channel_xpos_din)
			);


		sink
			#(
				.Thold(Thold)
			)
		xpos_out_channel
			(
				.clk 		(clk),
				.channel_in (channel_xpos_dout),
				.credit_out (credit_in_xpos_din)
			);

	// --- Canal y+ --- //
		source
			#(
				.Thold(Thold)
			)
		ypos_in_channel
			(
				.clk 		(clk),
				.credit_in 	(credit_out_ypos_dout),
				.channel_out(channel_ypos_din)
			);


		sink
			#(
				.Thold(Thold)
			)
		ypos_out_channel
			(
				.clk 		(clk),
				.channel_in (channel_ypos_dout),
				.credit_out (credit_in_ypos_din)
			);

	// --- Canal x- --- //
		source
			#(
				.Thold(Thold)
			)
		xneg_in_channel
			(
				.clk 		(clk),
				.credit_in 	(credit_out_xneg_dout),
				.channel_out(channel_xneg_din)
			);


		sink
			#(
				.Thold(Thold)
			)
		xneg_out_channel
			(
				.clk 		(clk),
				.channel_in (channel_xneg_dout),
				.credit_out (credit_in_xneg_din)
			);

	// --- Canal x- --- //
		source
			#(
				.Thold(Thold)
			)
		yneg_in_channel
			(
				.clk 		(clk),
				.credit_in 	(credit_out_yneg_dout),
				.channel_out(channel_yneg_din)
			);


		sink
			#(
				.Thold(Thold)
			)
		yneg_out_channel
			(
				.clk 		(clk),
				.channel_in (channel_yneg_dout),
				.credit_out (credit_in_yneg_din)
			);

	// --- Canal pe --- //
		source
			#(
				.Thold(Thold)
			)
		pe_in_channel
			(
				.clk 		(clk),
				.credit_in 	(credit_out_pe_dout),
				.channel_out(channel_pe_din)
			);


		sink
			#(
				.Thold(Thold)
			)
		pe_out_channel
			(
				.clk 		(clk),
				.channel_in (channel_pe_dout),
				.credit_out (credit_in_pe_din)
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
