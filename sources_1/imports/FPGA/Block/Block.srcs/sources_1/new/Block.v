`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/16 19:32:17
// Design Name: 
// Module Name: Block
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


module Block16(
    input [15:0] In,
    input OE,
    output  [15:0] Out
    );
    
    
    
    assign Out=OE?In:16'bzzzz_zzzz_zzzz_zzzz;
    
    
endmodule
