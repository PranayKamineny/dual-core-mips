`timescale 1ns / 1ps

module pccontroller(
    input branch, pcwrite, zero,
    output pcen
    );
    
    assign pcen = (branch && zero) || pcwrite;
endmodule
