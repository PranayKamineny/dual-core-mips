`timescale 1ns / 1ps

module controller(
    input clk, reset,
    input [5:0] op,
    output reg memread, memwrite, branch, pcwrite, alusrcA, memtoreg, regwrite, I_or_D, regdest, 
    output reg [1:0] alusrcB, Aluop, PCSource,
    output reg [3:0] IRwrite
    );
    
    parameter FETCH1 = 4'b0001;
    parameter FETCH2 = 4'b0010;
    parameter FETCH3 = 4'b0011;
    parameter FETCH4 = 4'b0100;
    parameter DECODE = 4'b0101;
    parameter MEMADR = 4'b0110;
    parameter LBRD = 4'b0111;
    parameter LBWR = 4'b1000;
    parameter SBWR = 4'b1001;
    parameter RTYPEEX = 4'b1010;
    parameter RTYPEWR = 4'b1011;
    parameter BEQEX = 4'b1100;
    parameter JEX = 4'b1101;
    parameter ADDIWR = 4'b1110;
    
    parameter LB = 6'b100000;
    parameter SB = 6'b101000;
    parameter RTYPE = 6'b000000;
    parameter BEQ = 6'b000100;
    parameter J = 6'b000010;
    parameter ADDI = 6'b001000;
    
    reg [3:0] state, nextstate;
    
    always @(posedge clk or posedge reset) begin
        if (reset) state <= FETCH1;
        else state <= nextstate;
    end
    
    always @(*) begin
        IRwrite <= 4'b0000;
        pcwrite <= 0;
        regwrite <= 0; regdest <= 0;
        memread <= 0; memwrite <= 0;
        alusrcA <= 0; alusrcB <= 2'b00;
        Aluop <= 2'b00; PCSource <= 2'b00;
        I_or_D <= 0; memtoreg <= 0; branch <= 0;
        
        case(state)
            FETCH1: begin
                memread <= 1;
                IRwrite <= 4'b1000;
                alusrcB <= 2'b01;
                pcwrite <= 1;
                nextstate <= FETCH2;
            end
            FETCH2: begin
                memread <= 1;
                IRwrite <= 4'b0100;
                alusrcB <= 2'b01;
                pcwrite <= 1;
                nextstate <= FETCH3;
            end
            FETCH3: begin
                memread <= 1;
                IRwrite <= 4'b0010;
                alusrcB <= 2'b01;
                pcwrite <= 1;
                nextstate <= FETCH4;
            end        
            FETCH4: begin
                memread <= 1;
                IRwrite <= 4'b0001;
                alusrcB <= 2'b01;
                pcwrite <= 1;
                nextstate <= DECODE;
            end
            DECODE: begin
                alusrcA <= 2'b00;
                alusrcB <= 2'b11;
                Aluop <= 2'b00;
                
                case(op)
                    LB: begin
                        nextstate <= MEMADR;
                    end
                    SB: begin
                        nextstate <= MEMADR;
                    end
                    ADDI: begin
                        nextstate <= MEMADR;
                    end
                    RTYPE: begin
                        nextstate <= RTYPEEX;
                    end
                    BEQ: begin
                        nextstate <= BEQEX;
                    end
                    J: begin
                        nextstate <= JEX;
                    end
                    default: begin
                        nextstate <= FETCH1;
                    end
                endcase
            end
            MEMADR: begin
                alusrcA <= 1;
                alusrcB <= 2'b10;
                Aluop <= 2'b00;
                case(op)
                    LB: begin
                           nextstate <= LBRD;
                    end
                    SB: begin
                           nextstate <= SBWR;
                    end
                    ADDI: begin
                           nextstate <= ADDIWR;
                    end
                    default: begin
                           nextstate <= FETCH1;
                    end
                endcase
            end
            LBRD: begin
                memread <= 1;
                I_or_D <= 1;
                nextstate <= LBWR;
            end
            LBWR: begin
                regwrite <= 1;
                regdest <= 0;
                memtoreg <= 1;
                nextstate <= FETCH1;
            end
            SBWR: begin
                memwrite <= 1;
                I_or_D <= 1;
                nextstate <= FETCH1;
            end
            RTYPEEX: begin
                alusrcA <= 1;
                alusrcB <= 2'b00;
                Aluop <= 2'b10;
                nextstate <= RTYPEWR;
            end
            RTYPEWR: begin
                regdest <= 1;
                regwrite <= 1;
                memtoreg <= 0;
                nextstate <= FETCH1;
            end
            BEQEX: begin
                alusrcA <= 1;
                alusrcB <= 2'b00;
                Aluop <= 2'b01;
                branch <= 1;
                PCSource <= 1;
                nextstate <= FETCH1;
            end
            JEX: begin
                PCSource <= 2;
                pcwrite <= 1;
                nextstate <= FETCH1;
            end
            ADDIWR: begin
                memtoreg <= 0;
                regdest <= 0;
                regwrite <= 1;
                nextstate <= FETCH1;
            end
            default: begin
                nextstate <= FETCH1;
            end
        endcase
    end
endmodule
