`timescale 1ns / 1ps

module single_core_top(
    input clk, reset
    );
    
    wire Memread, Memwrite, memread_ram, memread_gpio, memwrite_ram, memwrite_gpio;
    wire [7:0] Writedata, memdata_ram, memdata_gpio, memdata;
    wire [15:0] Addr;
    
    assign memread_ram = Addr[9] ? 0 : Memread;
    assign memwrite_ram = Addr[9] ? 0 : Memwrite;
    assign memread_gpio = Addr[9] ? Memread : 0;
    assign memwrite_gpio = Addr[9] ? Memwrite : 0;
    assign memdata = Addr[9] ? memdata_gpio : memdata_ram;
    
    mips processor(.clk(clk), .reset(reset), .cpu_no(0), .memread(Memread), .memdata(memdata), 
    .memwrite(Memwrite), .writedata(Writedata), .addr(Addr));
    
    extmemory ram(.clk(clk), .writedata(Writedata), .addr(Addr), .memread(memread_ram), .memwrite(memwrite_ram), .memdata(memdata_ram));
    mappedGPIO gpio(.clk(clk), .writedata(Writedata), .addr(Addr), .memread(memread_gpio), .memwrite(memwrite_gpio), .memdata(memdata_gpio));
endmodule
