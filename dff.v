`timescale 1ns / 1ps

module dff(
    input [7:0] d,
    input clk, reset,
    output reg [7:0] q
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset) q <= 0;
        else q <= d;
    end
    
endmodule
