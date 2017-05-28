`timescale 1ns / 1ps

module inport_tb();

/* --- signal declaration for UUT --- */
	reg clk;
	reg rst;
	reg diff_pair_p;
	reg diff_pair_n;
	reg arb_ack;
	reg  [31:0] input_channel;
    wire [31:0] channel_data;
	wire crt_out;
	wire [3:0] port_rqs;
    wire pe_rqs;

/* --- UUT --- */
inport UUT	(
	.clk(clk),
	.rst(rst),
	.diff_pair_p(diff_pair_p),
	.diff_pair_n(diff_pair_n),
	.arb_ack(arb_ack),
	.input_channel(input_channel),
    .channel_data(channel_data),
	.crt_out(crt_out),
	.port_rqs(port_rqs),
    .pe_rqs(pe_rqs)
);

/* --- clock signal generator --- */
always begin
	clk = 1'b0;
	#(10);
	clk = 1'b1;
	#(10);
end

/* --- initial block --- */
initial begin
	clk = 0;
	rst = 1;
	diff_pair_p = 1;
	diff_pair_n = 0;
	arb_ack = 0;
	input_channel = 0;
    repeat(20)
        posEdge();
    rst = 0;
    repeat(4)
        posEdge();
    // --- basic functionality, receive 2 packages, rest for 20 cycles,
    // --- recive another package and get an acknwolage to send one 
    // --- package out
//    package();
//    package();
//    repeat(20)
//        posEdge();
//    package();
//    repeat(20)
//        posEdge();
//    arb_ack = 1;
//        posEdge();
//    arb_ack = 0;
//    repeat(6)
//        posEdge();
//    arb_ack = 1;
//        posEdge();
//    arb_ack = 0;
//    repeat(6)
//        posEdge();
//    arb_ack = 1;
//        posEdge();
//    arb_ack = 0;
//    repeat(6)
//        posEdge();
    
    // --- end of test ---------------------------------------------------------


    // --- Test ::  Packed recived, acceptance before all flits arrive.
    // ---          a second package arrive inmediatky after  
    // --- Node direction 22
    // --- 33 --- X+
        diff_pair_p=~diff_pair_p;
        diff_pair_n=~diff_pair_n;
        input_channel = 32'h33000000;
        posEdge();
        input_channel = 32'h00FF0000;
        posEdge();
        input_channel = 32'h0000FF00;
        posEdge();
        arb_ack = 1;
        input_channel = 32'h000000FF;
        posEdge();
        arb_ack = 0;
        input_channel = 32'h00000000;
          

   // --- 11 --- X-
      diff_pair_p=~diff_pair_p;
      diff_pair_n=~diff_pair_n;
      input_channel = 32'h11000000;
      posEdge();
      input_channel = 32'h00FF0000;
      posEdge();
      input_channel = 32'h0000FF00;
      posEdge();
      input_channel = 32'h000000FF;
      posEdge();
      input_channel = 32'h00000000;

    // --- end of test ---------------------------------------------------------

//        repeat(10)
//            posEdge();
//        arb_ack = 1;
//        posEdge();
//        arb_ack = 0;
//        repeat(5)
//            posEdge();

//   // --- 23 --- Y+
//       diff_pair_p=~diff_pair_p;
//       diff_pair_n=~diff_pair_n;
//       input_channel = 32'h23000000;
//       posEdge();
//       input_channel = 32'h00FF0000;
//       posEdge();
//       input_channel = 32'h0000FF00;
//       posEdge();
//       input_channel = 32'h000000FF;
//       posEdge();
//       input_channel = 32'h00000000;
//   // --- 21 --- Y-
//       diff_pair_p=~diff_pair_p;
//       diff_pair_n=~diff_pair_n;
//       input_channel = 32'h21000000;
//       posEdge();
//       input_channel = 32'h00FF0000;
//       posEdge();
//       input_channel = 32'h0000FF00;
//       posEdge();
//       input_channel = 32'h000000FF;
//       posEdge();
//       input_channel = 32'h00000000;
//
//   // --- make 4 reads to ensure the 4 request are made. The reads are made
//   // --- in intervals of 5 cycles, 4 for the transfer of the flits and 1
//   // --- extra cycle as a cold down cycle (not necessary, but helpful) to 
//   // --- see the transitions.
//       repeat(4) 
//           begin
//               arb_ack = 1;
//                   posEdge();
//               arb_ack = 0;
//               repeat(5)
//                   posEdge();
//           end




    #(200)
	$stop;
end

/* --- Task Area --- */
task posEdge();
	begin
		@(posedge clk)
		#(2);
	end
endtask

task package();
    begin
        diff_pair_p=~diff_pair_p;
        diff_pair_n=~diff_pair_n;
        input_channel = 32'hFF000000;
        posEdge();
        input_channel = 32'h00FF0000;
        posEdge();
        input_channel = 32'h0000FF00;
        posEdge();
        input_channel = 32'h000000FF;
        posEdge();
        input_channel = 32'h00000000;
    end
endtask

endmodule
