`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 18:02:51
// Design Name: 
// Module Name: Reg12
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


module Reg16(   
input CLK,
input [15:0] DataIn,
input WE, 
output reg [15:0] DataOut
);
wire clk;
assign clk=(CLK & WE);
initial begin
    DataOut = 16'b0;
end
always @(posedge clk)
begin
    DataOut <= DataIn;
end
endmodule
