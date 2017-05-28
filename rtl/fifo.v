`timescale 1ns / 1ps

/* '''
Documentation
 '''*/

module fifo #(parameter DWIDTH=32,
                        FDEPTH=16) 
    (   
        input  wire clk,
        input  wire rst,
    // --- inputs --- //
    	input  wire wr_strobe,
    	input  wire rd_strobe,
    	input  wire [DWIDTH-1:0] wr_data,
    // --- outputs --- //
    	output wire [DWIDTH-1:0] rd_data
    );


// --- localparam --- //
    localparam AWIDTH=clog2(FDEPTH-1);



// --- signals --- //

    // --- fifo controller --- ///
	   	wire full;
		wire empty;

		wire [AWIDTH-1:0] rd_addr;
    	wire [AWIDTH-1:0] wr_addr;
		
    // --- register file --- //
		reg [DWIDTH-1:0] REG_FILE [0:FDEPTH-1];

		wire push;

		integer rf_index;



// --- fifo controller --- //
// '''Documentation
	fifo_controller #(.DWIDTH(DWIDTH), .FDEPTH(FDEPTH)) fifo_controller
	    (   
	        .clk(clk),
	        .rst(rst),
	    // --- inputs --- //
	    	.wr_strobe(wr_strobe),
	    	.rd_strobe(rd_strobe),
	    // --- outputs --- //
		    .full(full),
	    	.empty(empty),
	    	.rd_addr(rd_addr),
	    	.wr_addr(wr_addr)
	    );



// --- register file --- //
// '''Documentation

	assign push = wr_strobe & ~full;

    // --- synchronous write port --- //
   	always @(posedge clk)
		if (push)
			REG_FILE[wr_addr] <= wr_data;

    // --- asynchronous read port --- //
    assign rd_data = REG_FILE[rd_addr];




// --- no synthesizable code ---------------------------------------------------

    // --- log2(x) function --- //
	function integer clog2;
		input integer depth;
			for (clog2=0; depth>0; clog2=clog2+1)
				depth = depth >> 1;
	endfunction
    

    // --- reg. file zero init function --- //
		initial
			for (rf_index = 0; rf_index < FDEPTH; rf_index = rf_index + 1)
				REG_FILE[rf_index] = {DWIDTH{1'b0}};     


endmodule
