`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/02 19:59:17
// Design Name: 
// Module Name: RAM
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


module RAM(
    (* DONT_TOUCH = "TRUE" *) input CLK,
    (* DONT_TOUCH = "TRUE" *) input [15:0] Data_In,
    (* DONT_TOUCH = "TRUE" *) input [11:0] ADDR,
                              output [15:0] D_Out,
    (* DONT_TOUCH = "TRUE" *) input WE
    //(* DONT_TOUCH = "TRUE" *) input RE
    //output DDDDDZ
    );
    //reg [15:0] buffer;
    reg [15:0] memory[11:0];
    initial begin
        memory[4]<=19;
    end
    assign D_Out = memory[ADDR];
    always@(posedge CLK)
    begin
        
        if(WE==1)
        begin
            memory[ADDR]=Data_In;
        end
        else begin
            
        end
        /*
        if(RE==0)
        begin
            buffer = memory[ADDR];
        end
        */
    end          
    
endmodule
