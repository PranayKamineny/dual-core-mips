`timescale 1ns / 1ps

class RType;    
    bit [5:0] opcode = 6'b000000;
    rand bit [4:0] rs;
    rand bit [4:0] rt;
    rand bit [4:0] rd;
    bit [4:0] shamt = 5'b00000;
    rand bit [5:0] func;

    constraint reg_constraint {
        rs > 0; rs < 8; 
        rt > 0; rt < 8;
        rd > 0; rd < 8;
    };    
    
    constraint func_constraint {
        func == 6'b100000 ||  // add
        func == 6'b100010 ||  // sub
        func == 6'b100100 ||  // and 
        func == 6'b100101 ||  // or
        func == 6'b101010;    // slt
    };
    
    function bit [31:0] get_instr();
        return {opcode, rs, rt, rd, shamt, func};
    endfunction

endclass

class IType;
    rand bit [5:0] opcode;
    rand bit [4:0] rs;
    rand bit [4:0] rt;
    rand bit [15:0] imd;
    
    constraint opcode_constraint {
        //opcode == 6'b000100 ||  // opcode 4 // beq was tested manually
        opcode == 6'b001000 ||  // opcode 8
        opcode == 6'b100000 ||  // opcode 32
        opcode == 6'b101000;    // opcode 40
    };
    
    constraint reg_constraint {
        rs > 0; rs < 8; 
        rt > 0; rt < 8;
    };
    
    constraint imd_constraint {imd > 0; imd < 13; imd % 4 == 0;};
    
    function bit [31:0] get_instr();
        return {opcode, rs, rt, imd};
    endfunction
endclass

//tested manually
/*
class JType;
    bit [5:0] opcode = 6'b000010;
    rand bit [25:0] addr;
    
    constraint addr_constraint {addr < 25; addr % 4 == 0;}; 
    
    function bit [31:0] get_instr();
        return {opcode, addr};
    endfunction

endclass
*/

module testbench();

    reg Clk, Reset;
    reg [7:0] In;
    wire [7:0] Out;
    
    //single_core_top uut(.clk(Clk), .reset(Reset), .in(In), .out(Out));
    wire Memread, Memwrite, memread_ram, memread_gpio, memwrite_ram, memwrite_gpio;
    wire [7:0] Writedata, memdata_ram, memdata_gpio, memdata;
    wire [15:0] Addr;
    
    assign memread_ram = Addr[9] ? 0 : Memread;
    assign memwrite_ram = Addr[9] ? 0 : Memwrite;
    assign memread_gpio = Addr[9] ? Memread : 0;
    assign memwrite_gpio = Addr[9] ? Memwrite : 0;
    assign memdata = Addr[9] ? memdata_gpio : memdata_ram;
    
    mips processor(.clk(Clk), .reset(Reset), .cpu_no(0), .memread(Memread), .memdata(memdata), 
    .memwrite(Memwrite), .writedata(Writedata), .addr(Addr));
    
    extmemory ram(.clk(Clk), .writedata(Writedata), .addr(Addr), .memread(memread_ram), .memwrite(memwrite_ram), .memdata(memdata_ram));
    mappedGPIO gpio(.clk(Clk), .writedata(Writedata), .addr(Addr), .memread(memread_gpio), .memwrite(memwrite_gpio), .memdata(memdata_gpio), .in(In), .out(Out));
    
    int i, type_sel;
    
    RType r_instr;
    IType i_instr;
    // JType j_instr; // tested manually
    
    reg [31:0] instruction;
    reg [31:0] prev_instruction;
    
    // jump and beq excluded because they were tested manually
    covergroup cg @(posedge Clk);
        c1: coverpoint instruction[31:26] {
            bins b1 = {6'b000000}; // R-type
            bins b2 = {6'b001000}; // addi
            bins b3 = {6'b100000}; // lb
            bins b4 = {6'b100010}; // sb
        }
        c2: coverpoint prev_instruction[31:26] {
            bins b1 = {6'b000000}; // R-type
            bins b2 = {6'b001000}; // addi
            bins b3 = {6'b100000}; // lb
            bins b4 = {6'b100010}; // sb
        }
        c1xc2: cross c1, c2;

    endgroup : cg
    
    cg cg0 = new();
      
    always #1 Clk = ~Clk;
    
    initial begin
        Clk = 0;
        In = 10;
        
        for (i = 0; i < 20; i = i + 1) begin
            type_sel = $urandom_range(0,1);
            prev_instruction = instruction;
            
            if (type_sel == 0) begin
                r_instr = new();
                r_instr.randomize();
                instruction = r_instr.get_instr();
            end else if (type_sel == 1) begin
                i_instr = new();
                i_instr.randomize();
                instruction = i_instr.get_instr();
            end 
            cg0.sample();
            $display("Instruction #%d: %b", i + 1, instruction);
            
            ram.RAM[4*i] = instruction[31:24];
            ram.RAM[(4*i) + 1] = instruction[23:16];
            ram.RAM[(4*i) + 2] = instruction[15:8];
            ram.RAM[(4*i) + 3] = instruction[7:0];
        end
        $display("Cross Coverage Percentage: %.2f%%", cg0.c1xc2.get_coverage());
        
        #1 Reset = 1;
        #1 Reset = 0;
        
        #2000 $finish;
    end

endmodule
