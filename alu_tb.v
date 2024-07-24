`timescale 1ns / 1ps
module alu_tb();
    reg [4:0] read_reg1 = 0, read_reg2 = 0, write_reg = 0;
    reg [7:0] write_data = 0;
    reg write_enable = 0, clk = 0, reset = 0;
    reg [2:0] alucontrol = 0;
    wire [7:0] read_data1, read_data2, result;
    regfile regs(.clk(clk), .reset(reset), .read_reg1(read_reg1), .read_reg2(read_reg2), .write_reg(write_reg),
    .write_data(write_data), .write_enable(write_enable), .read_data1(read_data1), .read_data2(read_data2));
    
    alu UUT(.a(read_data1), .b(read_data2), .alucontrol(alucontrol), .result(result));
    always #5 clk = ~clk;
    
    initial begin
        //Resetting before starting simulation
        #5 reset = 1;
        #5 reset = 0;
        
        #5 write_enable = 1;
        write_reg = 1;
        write_data = 94;
        
        #20 write_reg = 2;
        write_data = 12;
        
        #5 write_enable = 0;
        #15 read_reg1 = 1;
        read_reg2 = 2;
        alucontrol = 0;
        
        #20 write_enable = 1;
        write_reg = 3;
        write_data = result;
        
        #5 write_enable = 0;
        #15 read_reg1 = 3;
        read_reg2 = 0;
      
        #30 $finish;
    
    end
    
endmodule
