`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Kaleb Alfaro e Irene Rivera
//
// Create Date: april/2015
// Design Name:
// Module Name: Register
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module Reg#(
	parameter Width = 16 //Largo de palabra
)
( 
	input wire clk,rst,enable,//clk,rst,habilitación
	input wire [Width-1:0] A, //Entrada
	output wire [Width-1:0] Y //Salida
);

reg [Width-1:0] Data, Data_next;

always@(posedge clk, posedge rst)
	if(rst)
		Data <= {Width{1'b0}};//rst
	else
		Data <= Data_next;

always@*
begin
	Data_next = Data;//hold
	if(enable)
		Data_next = A;//load
end

assign Y = Data;

endmodule
