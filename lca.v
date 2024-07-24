`timescale 1ns / 1ps

module lca(
    input [7:0] a,
    input [7:0] b,
    output wire [8:0] s
    );
    
    //generate & propogate
    wire [8:0] g, p, c;
    assign g = a & b;
    assign p = a ^ b;

    //carries
    assign c[0] = 0; //initial cin is 0
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = g[7] | (p[7] & c[7]);

    //sum
    assign s[0] = p[0] ^ c[0];
    assign s[1] = p[1] ^ c[1];
    assign s[2] = p[2] ^ c[2];
    assign s[3] = p[3] ^ c[3];
    assign s[4] = p[4] ^ c[4];
    assign s[5] = p[5] ^ c[5];
    assign s[6] = p[6] ^ c[6];
    assign s[7] = p[7] ^ c[7];
    assign s[8] = p[8] ^ c[8];
    
endmodule
