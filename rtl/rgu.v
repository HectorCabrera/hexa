`timescale 1ns / 1ps

/* '''
Documentation

    rgu - request generator unit
 '''*/

module rgu    
#(
    parameter XCOR = 2,
    parameter YCOR = 2
)
    (
        input wire clk,
        input wire rst,
        /* --- inputs --- */
        input wire rqs_strobe,
        input wire arb_ack,
        input wire [7:0] addr,
        /* --- outputs --- */
        output wire [4:0] rqs_vector 
    );


// ---localparam --- //
    localparam NONE = 5'b00000;
    localparam XPOS = 5'b00001;
    localparam XNEG = 5'b00010;
    localparam YPOS = 5'b00100;
    localparam YNEG = 5'b01000;
    localparam PE   = 5'b10000;


// --- signals --- //    
    // --- dor xy --- //
    wire [4:0] sub_x;
    wire [4:0] sub_y;
    wire       zero_x;
    wire       zero_y;

    reg [4:0] rqs_next;
    reg [4:0] rqs_reg = 5'b00000;



// --- dor xy ----------------------------------------------------------
// '''Documentation
    // --- subtractors --- //
    assign sub_x = addr[7:4] - XCOR;
    assign sub_y = addr[3:0] - YCOR;

    assign zero_x = ~|sub_x;
    assign zero_y = ~|sub_y;
  

    // --- dor xy core --- //
    always @(*) begin
        rqs_next = NONE; // default no request 
        case({zero_x, zero_y, sub_x[4], sub_y[4]})
            4'b1100: // PE
                rqs_next = PE; 
            4'b0000: // X+
                rqs_next = XPOS; 
            4'b0001: // X+
                rqs_next = XPOS; 
            4'b0100: // X+
                rqs_next = XPOS; 
            4'b0010: // X-
                rqs_next = XNEG; 
            4'b0011: // X-
                rqs_next = XNEG; 
            4'b0110: // X-
                rqs_next = XNEG; 
            4'b1000: // Y+
                rqs_next = YPOS; 
            4'b1001: // Y-
                rqs_next = YNEG; 
            default:
                rqs_next = NONE;                 
        endcase
    end


    // --- request vector register --- //
    always @(posedge clk)
        if (arb_ack)
            rqs_reg = 5'b00000;
        else if (rqs_strobe)
            rqs_reg = rqs_next;


    // --- output drivers --- //
    assign rqs_vector = rqs_reg;


endmodule
