`timescale 1ns / 1ps

module mips(
    input clk, reset, cpu_no,
    input [7:0] memdata,
    output memread, memwrite,
    output [7:0] writedata,
    output [15:0] addr
    );
    wire Branch, Pcwrite, AlusrcA, Memtoreg, Regwrite, Iord, RegDest, Zero, Pcen;
    wire [1:0] AlusrcB, ALUOp, Pcsource;
    wire [2:0] ALUControl;
    wire [3:0] Irwrite;
    wire [31:0] Instr;
    wire [15:0] temp_addr;
    assign addr = {temp_addr[15:9], cpu_no, temp_addr[7:0]};
    
    controller cont(.clk(clk), .reset(reset), .op(Instr[31:26]), .memread(memread), .memwrite(memwrite), .branch(Branch), 
    .pcwrite(Pcwrite), .alusrcA(AlusrcA), .memtoreg(Memtoreg), .regwrite(Regwrite), 
    .I_or_D(Iord), .regdest(RegDest), .alusrcB(AlusrcB), .Aluop(ALUOp), 
    .PCSource(Pcsource), .IRwrite(Irwrite));
    
    datapath dp(
    .clk(clk), .reset(reset), .readdata(memdata), .pcen(Pcen),
    .alusrcA(AlusrcA), .alusrcB(AlusrcB), .memtoreg(Memtoreg), .irwrite(Irwrite),
    .pcsource(Pcsource), .regwrite(Regwrite), .i_or_d(Iord), .regdest(RegDest),
    .alucontrol(ALUControl), .addr(temp_addr), .writedata(writedata), .zero(Zero), .instr(Instr));
    
    pccontroller pcc(.branch(Branch), .pcwrite(Pcwrite), .zero(Zero), .pcen(Pcen));
    
    alucontroller ac(.aluop(ALUOp), .funct(Instr[5:0]), .alucontrol(ALUControl));
endmodule
