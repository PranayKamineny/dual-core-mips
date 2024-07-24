`timescale 1ns / 1ps

module mappedGPIO(
    input [15:0] addr,
    input [7:0] writedata,
    input clk,
    input memread,
    input memwrite,
    output [7:0] memdata
    );
   
    reg [7:0] RAM [511:0];
    assign memdata = memread ? RAM[addr[8:0]] : 8'bxxxxxxxx;
    initial begin
  
    end
    always @ (posedge clk) begin
        if (memwrite) RAM[addr[8:0]] = writedata;
    end
endmodule
