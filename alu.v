`timescale 1ns / 1ps
module alu(
    input [7:0] a,
    input [7:0] b,
    input [2:0] alucontrol,
    output zero,
    output reg [7:0] result
    );
    wire [7:0] b2, sum, slt;
    wire [8:0] output1, output2;
    lca lca1(.a(a), .b(b2), .s(output1));
    lca lca2(.a(output1[7:0]), .b({7'b0000000, alucontrol[2]}), .s(output2));
    assign b2 = alucontrol[2] ? ~b : b;
    assign sum = output2[7:0];
    assign slt = sum[7];
    assign zero = (result == 0) ? 1 : 0;
    
    always @(*) begin
        case(alucontrol[1:0])
            2'b00: result <= a & b;
            2'b01: result <= a | b;
            2'b10: result <= sum;
            2'b11: result <= slt;
            default: result <= 0;
        endcase
    end
endmodule
