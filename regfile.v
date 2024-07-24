`timescale 1ns / 1ps
module regfile(
    input clk,
    input reset,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [7:0] write_data,
    input write_enable,
    output [7:0] read_data1,
    output [7:0] read_data2
);
 
    reg [7:0] d [7:0];
    wire [7:0] q [7:0];
    
    dff s0(.d(0), .clk(clk), .reset(reset), .q(q[0]));
    dff s1(.d(d[1]), .clk(clk), .reset(reset), .q(q[1]));
    dff s2(.d(d[2]), .clk(clk), .reset(reset), .q(q[2]));
    dff s3(.d(d[3]), .clk(clk), .reset(reset), .q(q[3]));
    dff s4(.d(d[4]), .clk(clk), .reset(reset), .q(q[4]));
    dff s5(.d(d[5]), .clk(clk), .reset(reset), .q(q[5]));
    dff s6(.d(d[6]), .clk(clk), .reset(reset), .q(q[6]));
    dff s7(.d(d[7]), .clk(clk), .reset(reset), .q(q[7]));

    always @(posedge reset) begin
        if (reset) begin
            d[1] <= 8'b00000000;
            d[2] <= 50;
            d[3] <= 11;
            d[4] <= 11;
            d[5] <= 8'b00000000;
            d[6] <= 8'b00000000;
            d[7] <= 8'b00000000;
        end
    end

    always @(posedge clk) begin
        if (write_enable && !reset) begin
            d[write_reg] <= write_data;
        end
    end
    
    assign read_data1 = q[read_reg1];
    assign read_data2 = q[read_reg2];

endmodule
