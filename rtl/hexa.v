`timescale 1ns / 1ps

/* '''
Documentation
 '''*/

module hexa #(  parameter XCOR = 2,
                parameter YCOR = 2
            )
	(
		input wire 	clk,
		input wire 	rst,
    /* --- inputs --- */
        input wire [0:PORTS-1] diff_pair_pi,
        input wire [0:PORTS-1] diff_pair_ni,
        input wire [0:PORTS-1] crt_in,
        input wire [0:(32*PORTS)-1] input_channels,
    /* --- outputs --- */
        output wire [0:PORTS-1] diff_pair_po,
        output wire [0:PORTS-1] diff_pair_no,
        output wire [0:PORTS-1] crt_out,
        output wire [0:(32*PORTS)-1] output_channels
    );




// --- globals --- //
    genvar index;
    localparam PORTS = 5;

// --- signals --- //
    // --- inports --- //
    wire [31:0]      inport_data   [0:PORTS-1];
    wire [PORTS-1:0] port_rqs      [0:PORTS-1];

    wire pe_rqs  [0:PORTS-1];
    wire arb_ack [0:PORTS-1];

    wire [PORTS-1:0] rqs2arbiters [0:PORTS-1];


    // --- ccs --- //
    wire [PORTS-1:0] xbar_cfg_vector [0:PORTS-1];
    wire [PORTS-1:0] arb_ackf        [0:PORTS-1];

    // --- switch fabric --- //
    wire [31:0] xbar_data   [0:PORTS-1];

    // --- pack acknowlage for each inport --- //
    wire [0:PORTS-1] ack2inports;

    // --- outports --- //
    wire [31:0] output_channel [0:PORTS-1];




// --- unpack input channels to individual buses --- //
    wire [31:0] input_data [0:PORTS-1];

    generate
        for(index=0; index<PORTS; index=index+1)
            begin
                assign input_data[index] = input_channels[index*32:(index*32)+31];
            end
    endgenerate




// --- inport instances --- //
    
    generate
        for (index=0; index<PORTS; index=index+1)
            begin: inport_inst
                inport #(.XCOR(XCOR), .YCOR(YCOR)) 
                inport (
                	.clk(clk),
                	.rst(rst),
                    // --- inputs --- //
                	.diff_pair_p(diff_pair_pi[index]),
                	.diff_pair_n(diff_pair_ni[index]),
                	.arb_ack(ack2inports[index]),
                	.input_channel(input_data[index]),
                    // --- outputs ---//
                	.channel_data(inport_data[index]),
                	.crt_out(crt_out[index]),
                	.port_rqs(port_rqs[index])
                );
            end
    endgenerate

    
    // --- pack request for each arbiter --- //
        generate
            for (index=0; index<PORTS; index=index+1)
                begin: rqs2arbiters_inst
                    assign rqs2arbiters[index] = { port_rqs[0][index],  // request from port x+
                                                   port_rqs[1][index],  // request from port x-
                                                   port_rqs[2][index],  // request from port y+
                                                   port_rqs[3][index],  // request from port y-
                                                   port_rqs[4][index]   // request from port pe
                                                  }; 
                end 
        endgenerate




// --- ccs instances --- //
    generate 
        for (index=0; index<PORTS; index=index+1)
            begin: ccs_inst
                ccs ccs	(
                	.clk(clk),
                    // --- input --- //
                	.credit_in(crt_in [index]),
                	.port_rqs(rqs2arbiters[index]),
                    // --- output --- //
                	.arb_ack(arb_ackf[index]),
                	.xbar_cfg_vector(xbar_cfg_vector[index])
                );
            end
    endgenerate
        
    generate
        for (index=0; index<PORTS; index=index+1)
            begin: ack2inports_inst
                assign ack2inports[index] = arb_ackf[0][index] |
                                            arb_ackf[1][index] |
                                            arb_ackf[2][index] |
                                            arb_ackf[3][index] |
                                            arb_ackf[4][index];
            end 
    endgenerate    




// --- switch fabric (xbar) --- //
    switch_fabric switch_fabric	(
    	.dinA(inport_data[0]),
    	.dinB(inport_data[1]),
    	.dinC(inport_data[2]),
    	.dinD(inport_data[3]),
    	.dinE(inport_data[4]),
    	.sf_cfg_vecA(xbar_cfg_vector[0]),
    	.sf_cfg_vecB(xbar_cfg_vector[1]),
    	.sf_cfg_vecC(xbar_cfg_vector[2]),
    	.sf_cfg_vecD(xbar_cfg_vector[3]),
    	.sf_cfg_vecE(xbar_cfg_vector[4]),
    	.doutA(xbar_data[0]),
    	.doutB(xbar_data[1]),
    	.doutC(xbar_data[2]),
    	.doutD(xbar_data[3]),
    	.doutE(xbar_data[4])
    );





// --- outport instances --- //
    generate 
        for (index=0; index<PORTS; index=index+1)
            begin: outport_inst
                outport outport (
                    .clk(clk),
                    .rst(rst),
                    // --- input --- //
                    .arb_ack(ack2inports[index]),
                    .xbar_data(xbar_data[index]),

                    // --- output --- //
                    .diff_pair_p(diff_pair_po[index]),
                    .diff_pair_n(diff_pair_no[index]),        

                    .output_channel(output_channel[index])
                );  
            end
    endgenerate




// --- packing output channels to output bus --- //
    assign  output_channels = { output_channel[4], 
                                output_channel[3], 
                                output_channel[2], 
                                output_channel[1], 
                                output_channel[0]
                              };
  

endmodule
