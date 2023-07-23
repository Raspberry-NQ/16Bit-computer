`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Rasp
// 
// Create Date: 2023/07/16 20:27:08
// Design Name: 
// Module Name: SuperBit
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

`include "C:/Users/raspb/Documents/FPGA/Comp/Comp.srcs/sources_1/imports/new/decoder.v"
/*module 1Decoder(	input [3:0] command,
				output clk,
				output  [15:0] ctrl_wrd
				);*/
`include "C:/Users/raspb/Documents/FPGA/Comp/Comp.srcs/sources_1/imports/FPGA/ALU/ALU.srcs/sources_1/new/ALU.v"
/*module ALU(
    input CLK,
    input [11:0] AIn,
    input [11:0] BIn,
    output reg [11:0] Out,
    input _PlusE,
    input _SubE,
    output reg F
    );*/
`include "C:/Users/raspb/Documents/FPGA/Comp/Comp.srcs/sources_1/imports/FPGA/Block/Block.srcs/sources_1/new/Block.v"
/*module Block16(
    input [15:0] In,
    input OE,
    output reg [15:0] Out
    );*/
`include "C:/Users/raspb/Documents/FPGA/Comp/Comp.srcs/sources_1/imports/FPGA/PC/PC.srcs/sources_1/new/PC.v"
/*module PC(
    input CLK,
    output reg [11:0] STEP,
    input [11:0] JMP,
    input WE,
    input PP
    );*/
`include "C:/Users/raspb/Documents/FPGA/Comp/Comp.srcs/sources_1/imports/FPGA/RAM/RAM.srcs/sources_1/new/RAM.v"
/*module RAM(
    (* DONT_TOUCH = "TRUE" *) input CLK,
    (* DONT_TOUCH = "TRUE" *) input [15:0] Data_In,
    (* DONT_TOUCH = "TRUE" *) input [11:0] ADDR,
                              output [15:0] D_Out,
    (* DONT_TOUCH = "TRUE" *) input WE
    );*/
`include "C:/Users/raspb/Documents/FPGA/Comp/Comp.srcs/sources_1/imports/FPGA/Reg/Reg.srcs/sources_1/new/Reg.v"
/*module Reg16(   
    input CLK,
    input [15:0] DataIn,
    input WE, 
    output reg [15:0] DataOut
    );*/
//---------------------------------------------------------------------------------
module IROM(
    input [15:0] ADDR,
    output [15:0] D_Out
    );
    
    reg [15:0] memory[65535:0];
    assign D_Out=memory[ADDR];
    initial begin
        memory[0]=16'b0000_0000_0000_0000;
        memory[1]=16'b0010_0000_0000_0001;
        memory[2]=16'b0111_0000_0000_0000;
        memory[3]=16'b0000_0000_0000_0010;
        memory[8]=16'b0000_0000_0000_0001;
    end
endmodule

module DROM(
    input [11:0] ADDR,
    output [15:0] D_Out
    );
    
    reg [15:0] memory[4095:0];
    assign D_Out=memory[ADDR];
    initial begin
        memory[0]=16'b0001_1000_1000_1000;
        memory[1]=16'b0000_0000_0000_1000;
        memory[2]=16'b1000_0000_0000_0000;
    end
endmodule
//---------------------------------------------------------------------------------
module SuperBit(
    input sclk,
    output [15:0] Out
    );
    wire clk;
    wire [15:0] pctoip;
    wire [15:0] iptoirom;
    wire [3:0] iromtodecoder;
    wire [11:0] iromtoramdrom;
    wire [15:0] ramtoblock;
    wire [15:0] dromtoblock;
    wire [15:0] BUS;
    wire SPIAddrIn,SPIDWrite,SPIDRead,DROMDRead,RAMDWrite,RAMDRead,PCpp,PCWrite,PlusOut,SubOut,ZeroSet,IPIn,PCIn,RCOut,RBIn,RAIn;
    wire [15:0] ratoalu,rbtoalu,rctoblock;
    wire JE,F;
    assign JE=(F^ZeroSet)&PCWrite;
    assign Out = BUS;
    
    PC pc(.CLK(clk),.STEP(pctoip),.JMP(BUS),.WE(JE),.PP(PCpp));
    Decoder decoder(.sclk(sclk),.command(iromtodecoder),.clk(clk),.ctrl_wrd({SPIAddrIn,SPIDWrite,SPIDRead,DROMDRead,RAMDWrite,RAMDRead,PCpp,PCWrite,PlusOut,SubOut,ZeroSet,IPIn,RCIn,RCOut,RBIn,RAIn}));
    
    Block16 DROM_Block(.In(dromtoblock),.OE(DROMDRead),.Out(BUS));
    Block16 RAM_Block(.In(ramtoblock),.OE(RAMDRead),.Out(BUS));
    Block16 RCBlock(.In(rctoblock),.OE(RCOut),.Out(BUS));
    
    Reg16 RA(.CLK(clk),.DataIn(BUS),.DataOut(ratoalu),.WE(RAIn));
    Reg16 RB(.CLK(clk),.DataIn(BUS),.DataOut(rbtoalu),.WE(RBIn));
    Reg16 RC(.CLK(clk),.DataIn(BUS),.DataOut(rctoblock),.WE(RCIn));
    Reg16 IP(.CLK(clk),.DataIn(pctoip),.DataOut(iptoirom),.WE(IPIn));
    
    DROM DROM(.ADDR(iromtoramdrom),.D_Out(dromtoblock));
    IROM IROM(.ADDR(iptoirom),.D_Out({iromtodecoder,iromtoramdrom}));
    RAM RAM(.CLK(clk),.Data_In(BUS),.ADDR(iromtoramdrom),.D_Out(ramtoblock),.WE(RAMDWrite));
    
    ALU ALU(.AIn(ratoalu),.BIn(rbtoalu),.Out(BUS),.PlusE(PlusOut),.SubE(SubOut),.F(F));
    
    
endmodule


