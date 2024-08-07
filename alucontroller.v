`timescale 1ns / 1ps

module alucontroller(
    input [1:0] aluop,
    input [5:0] funct,
    output reg [2:0] alucontrol
    );
    
    always @(*) begin
        case(aluop)
            2'b00: alucontrol <= 3'b010; //lb, sb, and addi require add
            2'b01: alucontrol <= 3'b110; //beq requires subtraction to compare a and b
            default: case(funct)
                6'b100000: alucontrol <= 3'b010; //add
                6'b100010: alucontrol <= 3'b110; //sub
                6'b100100: alucontrol <= 3'b000; //and
                6'b100101: alucontrol <= 3'b001; //or
                6'b101010: alucontrol <= 3'b111; //slt
                default: alucontrol <= 3'b101; //shouldn't happen
            endcase
        endcase
    end
endmodule
