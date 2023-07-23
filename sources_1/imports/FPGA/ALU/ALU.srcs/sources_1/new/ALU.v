`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 19:05:42
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input [15:0] AIn,
    input [15:0] BIn,
    output  [15:0] Out,
    input PlusE,
    input SubE,
    output  F
    );
    wire [16:0] data=17'b0_0000_0000_0000_0000;
    wire set;
    wire oe;
    wire [16:0] ooo=PlusE? (AIn+BIn):(AIn-BIn);
    assign F = ooo[16];
    assign oe = PlusE^SubE;
    assign set = oe & PlusE ;
    assign Out = set?ooo[15:0]:16'bzzzz_zzzz_zzzz_zzzz;
    
    
endmodule
