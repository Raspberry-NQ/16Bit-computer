`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/02 22:51:10
// Design Name: 
// Module Name: PC
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


module PC(
    input CLK,
    output reg [15:0] STEP,
    input [15:0] JMP,
    input WE,
    input PP
    );

    initial begin
        STEP<=0;
    end
    //assign STEP = buffer;
    always@(posedge CLK)
    begin
        if(WE==1 & PP!=1) begin
            STEP = JMP;
        end
        else if(WE!= 1 & PP ==1)begin
            STEP=STEP+1;
        end
        else begin
        end
       
    end
endmodule
