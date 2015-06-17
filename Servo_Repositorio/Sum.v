`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Kaleb Alfaro e Irene Rivera
//
// Create Date: april/2015
// Design Name:
// Module Name: Sum
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
module Sum#(
	parameter Width = 16 //El ancho de bits
)
( 
	//Operandos
	input wire signed [Width-1:0] A, 
	input wire signed [Width-1:0] B,
	//Resultado
	output reg signed [Width-1:0] Y
);
	wire signed [Width-1:0] sum;
	//Señales de overflow
	wire overflow, underflow;
		//A y B positivos y el resultado negativo
	assign overflow = (~A[Width-1])&(~B[Width-1])&(sum[Width-1]);
		//A y B negativos y el resultado positivo 
	assign underflow = (A[Width-1])&(B[Width-1])&(~sum[Width-1]); 
	//Suma binaria
	assign sum = A+B;


always@*
begin
	Y = 	overflow 	? {1'b0,{(Width-1){1'b1}}} : //Si hay overflow se satura el resultado en 0111...
		underflow 	? {1'b1,{(Width-1){1'b0}}} : //Si hay underflow se satura el resultado en 1000...
		sum;					     //en caso contrario se deja el mismo resultado de la suma binaria
end
endmodule
