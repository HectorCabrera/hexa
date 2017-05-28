`timescale 1ns / 1ps

/* '''
Documentation
 '''*/

module fifo_controller #(parameter DWIDTH=32,
                            	   FDEPTH=16) 
    (   
        input wire clk,
        input wire rst,
    // --- inputs --- //
    	input wire wr_strobe,
    	input wire rd_strobe,
    // --- outputs --- //
	    output wire full,
    	output wire empty,
    	output wire [AWIDTH-1:0] rd_addr,
    	output wire [AWIDTH-1:0] wr_addr
    );


// --- localparam --- //
    localparam AWIDTH=clog2(FDEPTH-1);

// --- signals --- //
    // --- control unit --- ///
	   	reg [AWIDTH-1:0] wr_ptr_reg;
		reg [AWIDTH-1:0] wr_ptr_next;
	    reg [AWIDTH-1:0] wr_ptr_succ;

		reg [AWIDTH-1:0] rd_ptr_reg;
		reg [AWIDTH-1:0] rd_ptr_next;
		reg [AWIDTH-1:0] rd_ptr_succ;

		reg full_reg;
		reg full_next;

		reg empty_reg;
		reg empty_next;




// --- fifo control unit --- //
// '''Documentation

    // --- memory elements --- //
	always @(posedge clk)
		if (rst) 
			begin
				full_reg    <= 1'b0;
				empty_reg 	<= 1'b1;

				wr_ptr_reg 	<= {AWIDTH{1'b0}};
				rd_ptr_reg 	<= {AWIDTH{1'b0}};
			end
		else 
			begin
				full_reg 	<= full_next;
				empty_reg 	<= empty_next;

				wr_ptr_reg 	<= wr_ptr_next;
				rd_ptr_reg 	<= rd_ptr_next;
			end




    // --- next state logic --- //
	always @(*) begin
		wr_ptr_succ = wr_ptr_reg + 1'b1;
		rd_ptr_succ = rd_ptr_reg + 1'b1;
		
		wr_ptr_next = wr_ptr_reg;
		rd_ptr_next = rd_ptr_reg;
		full_next 	= full_reg;
		empty_next	= empty_reg;

		case ({wr_strobe, rd_strobe})
			2'b00: begin // no op
				wr_ptr_next = wr_ptr_reg;
				rd_ptr_next = rd_ptr_reg;
				full_next 	= full_reg;
				empty_next	= empty_reg;
			end

			2'b01: begin// Read
				if(~empty_reg) begin
					rd_ptr_next	= rd_ptr_succ;
					full_next 	= 1'b0;
					if (rd_ptr_succ	== wr_ptr_reg)
						empty_next = 1'b1;
				end
			end

			2'b10: begin// Write
				if(~full_reg) begin
					wr_ptr_next	= wr_ptr_succ;
					empty_next	= 1'b0;
					if (wr_ptr_succ == rd_ptr_reg)
						full_next = 1'b1;
				end
			end

			2'b11: begin// Concurrent Read - Write
				wr_ptr_next = wr_ptr_succ;
				rd_ptr_next = rd_ptr_succ; 
			end

		endcase
	end


    // --- output drivers --- //
	assign full	 = full_reg;
	assign empty = empty_reg;

	assign wr_addr = wr_ptr_reg;
	assign rd_addr = rd_ptr_reg;




// --- no synthesizable code --- //

    // --- log2(x) function --- //
	function integer clog2;
		input integer depth;
			for (clog2=0; depth>0; clog2=clog2+1)
				depth = depth >> 1;
	endfunction


endmodule
