`timescale 1ns / 1ps

module membus(
        input clk, reset, memread0, memwrite0, request0, memread1, memwrite1, request1,
        input [7:0] readdata_ext, readdata_gpio, writedata0, writedata1,
        input [15:0] addr0, addr1,
        output memread_ext, memwrite_ext, memread_gpio, memwrite_gpio, grant0, grant1,
        output [7:0] readdata0, readdata1, writedata_ext, writedata_gpio,
        output [15:0] addr_ext, addr_gpio
    );
    
    reg memread_ext_out, memwrite_ext_out, memread_gpio_out, memwrite_gpio_out, grant0_out, grant1_out;
    reg [7:0] readdata0_out, readdata1_out, writedata_ext_out, writedata_gpio_out;
    reg [15:0] addr_ext_out, addr_gpio_out;
    
    reg priority = 0;
    
    assign memread_ext = memread_ext_out, memwrite_ext = memwrite_ext_out;
    assign memread_gpio = memread_gpio_out, memwrite_gpio = memwrite_gpio_out;
    assign grant0 = grant0_out, grant1 = grant1_out;
    assign readdata0 = readdata0_out, readdata1 = readdata1_out, writedata_ext = writedata_ext_out, writedata_gpio = writedata_gpio_out;
    assign addr_ext = addr_ext_out, addr_gpio = addr_gpio_out;
    
    always @(posedge clk) begin
        if (request0 && !request1) begin
            if (!addr0[9]) begin
                memread_ext_out <= memread0;
                memwrite_ext_out <= memwrite0;
                addr_ext_out <= addr0;
                readdata0_out <= readdata_ext;
                writedata_ext_out <= writedata0;
            end else begin
                memread_gpio_out <= memread0;
                memwrite_gpio_out <= memwrite0;
                addr_gpio_out <= addr0;
                readdata0_out <= readdata_gpio;
                writedata_gpio_out <= writedata0;
            end 
            grant0_out <= 1;
            grant1_out <= 0;
        end else if (!request0 && request1) begin
            if (!addr1[9]) begin
                memread_ext_out <= memread1;
                memwrite_ext_out <= memwrite1;
                addr_ext_out <= addr1;
                readdata1_out <= readdata_ext;
                writedata_ext_out <= writedata1;
            end else begin
                memread_gpio_out <= memread1;
                memwrite_gpio_out <= memwrite1;
                addr_gpio_out <= addr1;
                readdata1_out <= readdata_gpio;
                writedata_gpio_out <= writedata1;
            end
            grant0_out <= 0;
            grant1_out <= 1;
        end else if (request0 && request1) begin
            if (priority) begin
                if (!addr0[9]) begin
                    memread_ext_out <= memread0;
                    memwrite_ext_out <= memwrite0;
                    addr_ext_out <= addr0;
                    readdata0_out <= readdata_ext;
                    writedata_ext_out <= writedata0;
                end else begin
                    memread_gpio_out <= memread0;
                    memwrite_gpio_out <= memwrite0;
                    addr_gpio_out <= addr0;
                    readdata0_out <= readdata_gpio;
                    writedata_gpio_out <= writedata0;
                end 
                grant0_out <= 1;
                grant1_out <= 0;
            end else begin
                if (!addr0[9]) begin
                    memread_ext_out <= memread1;
                    memwrite_ext_out <= memwrite1;
                    addr_ext_out <= addr1;
                    readdata1_out <= readdata_ext;
                    writedata_ext_out <= writedata1;
                end else begin
                    memread_gpio_out <= memread1;
                    memwrite_gpio_out <= memwrite1;
                    addr_gpio_out <= addr1;
                    readdata1_out <= readdata_gpio;
                    writedata_gpio_out <= writedata1;
                end 
                grant0_out <= 0;
                grant1_out <= 1;                
            end
            priority = !priority;
        end else begin
                grant0_out <= 0;
                grant1_out <= 0;
                memread_ext_out <= 0;
                memread_gpio_out <= 0;
                memwrite_ext_out <= 0;
                memwrite_gpio_out <= 0;
                writedata_ext_out <= 0;
                writedata_gpio_out <= 0;
        end
    end
endmodule
