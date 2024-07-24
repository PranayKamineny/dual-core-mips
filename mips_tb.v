`timescale 1ns / 1ps
module mips_tb();
    reg Clk, Reset;
    single_core_top uut(.clk(Clk), .reset(Reset));    
    always #5 Clk = ~Clk;
    
    initial begin
        Clk = 0;
        #5 Reset = 1;
        #5 Reset = 0;
        #1000 $finish;
    end
endmodule
