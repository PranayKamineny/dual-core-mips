`timescale 1ns / 1ps

module mux2to1 #(parameter size = 8)(
    input sel,
    input [size-1:0] a,
    input [size-1:0] b,
    output [size-1:0] out
    );
    
    assign out = sel ? a : b;
        
endmodule
