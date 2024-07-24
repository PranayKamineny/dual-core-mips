`timescale 1ns / 1ps

module extmemory(
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
        $readmemb("gauss.dat", RAM);
        //R-type test
        /*
        // add $s1, $s2, $s3 -> s1 = s2 + s3 -> s1 = 50 + 11 -> 61 
        RAM[0] = 8'b00000000;
        RAM[1] = 8'b01000011;
        RAM[2] = 8'b00001000;
        RAM[3] = 8'b00100000;
        
        // sub $s3, $s1, $s0 -> s3 = s1 - s0 -> 61 - 0 -> 61
        RAM[4] = 8'b00000000;
        RAM[5] = 8'b00100000;
        RAM[6] = 8'b00011000;
        RAM[7] = 8'b00100010;
        // and s1, s2, s3 -> s1 = s2 & s3 -> 00110010 & 00111101 -> 00110000 -> 48
        RAM[8] = 8'b00000000;
        RAM[9] = 8'b01000011;
        RAM[10] = 8'b00001000;
        RAM[11] = 8'b00100100;
        // or s1, s2, s3 -> s1 = s2 & s3 -> 00110010 & 00111101 -> 00111111 -> 63
        RAM[12] = 8'b00000000;
        RAM[13] = 8'b01000011;
        RAM[14] = 8'b00001000;
        RAM[15] = 8'b00100101;
        // slt s1, s2, s3 -> set s1 = 1 if s2 < s3 -> 50 < 61 -> s1 = 1
        RAM[16] = 8'b00000000;
        RAM[17] = 8'b01000011;
        RAM[18] = 8'b00001000;
        RAM[19] = 8'b00101010;
        
        //LB/SB test
        //sb s3, offset(s0) -> mem[s0 + offset] = s3 -> gpio[258] = 11 
        RAM[0] = 8'b10100000;
        RAM[1] = 8'b00000011;
        RAM[2] = 8'b00000011;
        RAM[3] = 8'b00000010;
        
        // lb s1, offset(s0) -> s1 = mem[s0 + offset] -> s1 = gpio[258] -> s1 = 11
        RAM[4] = 8'b10000000;
        RAM[5] = 8'b00000001;
        RAM[6] = 8'b00000011;
        RAM[7] = 8'b00000010;
        
        // beq s3, s4, 10 -> PC = PC + 10 if s3 == s4
        RAM[0] = 8'b00010000;
        RAM[1] = 8'b01100100;
        RAM[2] = 8'b00000000;
        RAM[3] = 8'b00001010;
        
        // j 25 -> PC = 25
        RAM[0] = 8'b00001000;
        RAM[1] = 8'b00000000;
        RAM[2] = 8'b00000000;
        RAM[3] = 8'b00011001;
        
        // addi s1, s2, 30 -> s1 = s2 + 30 = 50 + 30 = 80
        RAM[0] = 8'b00100000;
        RAM[1] = 8'b01000001;
        RAM[2] = 8'b00000000;
        RAM[3] = 8'b00011110;
        */
        
    end
    
    
    always @ (posedge clk) begin
        if (memwrite) RAM[addr[8:0]] = writedata;
    end
endmodule
