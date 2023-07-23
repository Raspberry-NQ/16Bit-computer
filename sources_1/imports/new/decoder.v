`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 21:29:07
// Design Name: 
// Module Name: decoder
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
module ROM(
    //input CLK,
    input [4:0] ADDR,
    output [15:0] D_Out
    );
    parameter SPIAddrIn=   16'b1000000000000000;
	parameter SPIDWrite=   16'b0100000000000000;
	parameter SPIDRead=    16'b0010000000000000;
	parameter DROMDRead=   16'b0001000000000000;
	parameter RAMDWrite=   16'b0000100000000000;
	parameter RAMDRead=    16'b0000010000000000;
	parameter PCpp=        16'b0000001000000000;
	parameter PCWrite=     16'b0000000100000000;
	parameter PlusOut=     16'b0000000010000000;
	parameter SubOut=      16'b0000000001000000;
	parameter ZeroSet=     16'b0000000000100000;
	parameter IPIn=        16'b0000000000010000;
	parameter RCIn=        16'b0000000000001000;//OPTION->1->SUBMIT;->0->PLUS
	parameter RCOut=       16'b0000000000000100;
	parameter RBIn=        16'b0000000000000010;
	parameter RAIn=        16'b0000000000000001;
	
    reg [15:0] memory[31:0];
    reg [15:0] od=0;
    //assign D_Out=od;
    
    initial begin
        od=0;
        memory[5'b00000]=IPIn;//DROMTA
        memory[5'b10000]=DROMDRead|RAIn|PCpp;
        
        memory[5'b00001]=IPIn;//DROMTB
        memory[5'b10001]=DROMDRead|RBIn|PCpp;
        
        memory[5'b00010]=IPIn;//DROMTC
        memory[5'b10010]=DROMDRead+RCIn+PCpp;
        
        memory[5'b00011]=IPIn;//RAMTA
        memory[5'b10011]=RAMDRead|RAIn|PCpp;
        
        memory[5'b00100]=IPIn;//RAMTB
        memory[5'b10100]=RAMDRead|RBIn|PCpp;
        
        memory[5'b00101]=IPIn;//RAMTC
        memory[5'b10101]=RAMDRead|RCIn|PCpp;
        
        //ATRAM->1110
        //BTRAM->1111
        memory[5'b00110]=IPIn;//CTRAM
        memory[5'b10110]=RCOut|RAMDRead|PCpp;
        
        memory[5'b00111]=IPIn;//JUMPTC_0
        memory[5'b10111]=RCOut|PCWrite|PCpp;
        
        memory[5'b01000]=IPIn;//JUMPTC_1
        memory[5'b11000]=RCOut|ZeroSet|PCWrite|PCpp;
        
        memory[5'b01001]=IPIn;//PLUSTRAM
        memory[5'b11001]=PlusOut|RAMDWrite;
        
        memory[5'b01010]=IPIn;//SUBTRAM
        memory[5'b11010]=SubOut|RAMDWrite;
        
        memory[5'b01011]=IPIn;//SPIADDRSET
        memory[5'b11011]=RAMDRead|SPIAddrIn;
        
        memory[5'b01100]=IPIn;//RAMTSPI
        memory[5'b11100]=RAMDRead|SPIDWrite;
        
        memory[5'b01101]=IPIn;//SPITRAM
        memory[5'b11101]=SPIDRead|RAMDWrite;
        
    end
    assign D_Out = memory[ADDR];

endmodule


//--------------------------------------------------------------------------------------------------------------
module Decoder(	input sclk,
                input [3:0] command,
				output clk,
				output  [15:0] ctrl_wrd
				);
	reg count;
	wire [15:0] promtoout;
	assign ctrl_wrd = promtoout;
	//reg _clk=0;
	//always#7 sclk=~sclk;
    assign clk=~sclk;
    
    wire [4:0] x;
	ROM prom(.ADDR(x),.D_Out(promtoout));
	assign x[4:4] = count;
	assign x[3:0] = command;
initial begin
    count <= 0;
end
always @ (posedge sclk)begin
        count=count+1;
    end



endmodule