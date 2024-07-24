`timescale 1ns / 1ps

module datapath(
    input clk,
    input reset,
    input [7:0] readdata,
    input pcen,
    input alusrcA,
    input [1:0] alusrcB,
    input memtoreg,
    input [3:0] irwrite,
    input [1:0] pcsource,
    input regwrite,
    input i_or_d,
    input regdest,
    input [2:0] alucontrol,
    output [15:0] addr,
    output [7:0] writedata,
    output zero,
    output [31:0] instr
    );
    
    reg [31:0] instr_reg;
    reg [7:0] PC, A, B, MemData, ALUOut;
    wire [7:0] pc_in, pc_out, address, writedata_reg, read_data_1, read_data_2, alu_input_1, alu_input_2, aluresult;
    wire [15:0] i_type_addr;
    wire [4:0] read_reg_1, read_reg_2, dest_reg, write_reg;
    wire [2:0] address_ext;
    
    assign instr = instr_reg;
    assign address_ext = i_or_d ? (instr_reg[9:8]) : (2'b00);
    assign addr = {6'b000000, address_ext, address};
    assign read_reg_1 = instr_reg[25:21];
    assign read_reg_2 = instr_reg[20:16];
    assign dest_reg = instr_reg[15:11];
    assign i_type_addr = instr_reg[15:0];
    assign writedata = B;
    
     
    mux2to1 i_or_d_mux(.sel(i_or_d), .a(PC), .b(ALUOut), .out(address));
    
    mux2to1 #(5) reg_dest_mux(.sel(regdest), .a(read_reg_2), .b(dest_reg), .out(write_reg));
    
    mux2to1 mem_to_reg_mux(.sel(memtoreg), .a(ALUOut), .b(MemData), .out(writedata_reg));
    
    regfile rf(.clk(clk), .reset(reset), .read_reg1(read_reg_1), .read_reg2(read_reg_2), .write_reg(write_reg), 
    .write_data(writedata_reg), .write_enable(regwrite), .read_data1(read_data_1), .read_data2(read_data_2));
    
    mux2to1 alu_src_a_mux(.sel(alusrcA), .a(PC), .b(A), .out(alu_input_1));
    
    mux4to1 alu_src_b_mux(.s(alusrcB), .d0(B), .d1(8'b00000001), .d2(i_type_addr[7:0]), .d3(i_type_addr[7:0]), .y(alu_input_2));
    
    alu alu1(.a(alu_input_1), .b(alu_input_2), .alucontrol(alucontrol), .zero(zero), .result(aluresult));
    
    mux4to1 pc_source_mux(.s(pcsource), .d0(aluresult), .d1(ALUOut), .d2(instr_reg[7:0]), .d3(0), .y(pc_in));
    
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            MemData = 0;
            A = 0;
            B = 0;
            ALUOut = 0;
            instr_reg = 0;
            PC = 0;
        end else begin
            MemData = readdata;
            A = read_data_1;
            B = read_data_2;
            ALUOut = aluresult;
            if(irwrite[3]) instr_reg[31:24] = readdata;
            if(irwrite[2]) instr_reg[23:16] = readdata;
            if(irwrite[1]) instr_reg[15:8] = readdata;
            if(irwrite[0]) instr_reg[7:0] = readdata;
            if(pcen) PC = pc_in;
        end
    end
    
endmodule
