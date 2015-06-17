`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Kaleb Alfaro e Irene Rivera
//
// Create Date: april/2015
// Design Name:
// Module Name: Mult
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
module Mult#(
	parameter f_A = 10, 	// Parte decimal
	parameter p_A = 5, 	//Parte entera
	parameter Width_A = f_A+p_A+1,	//El ancho de bits
	parameter f_B = 10,	//Parte decimal de la constante
	parameter p_B = 5,	//Parte entera de la constante
	parameter Width_B = f_B+p_B+1
)
( 
	//Operandos
	input wire signed [Width_A-1:0] A,
	input wire [Width_B-1:0] B,
	//Resultado
	output wire signed [Width_A-1:0] Y
);

	//Multiplicación binaria 
	wire signed [Width_A+Width_B-2:0] mult;
	wire signed [Width_A-1:0]B_aux;
	assign B_aux = {{p_A-p_B{B[Width_B-1]}},B}; //Extención del signo
	assign mult = A*B_aux;
	//Condición de overflow

	wire overflow, underflow;
	assign overflow = 	(A=={Width_A{1'b0}}||B=={Width_B{1'b0}})? 1'b0: //Caso con cero
				(A[Width_A-1]==B[Width_B-1]) ? (|mult[Width_A+Width_B-2:f_A+f_B+p_A]) : //Signo positivo
				1'b0 ;				//Overflow si no hay extensión de signo en el 2do bloque de magnitud
	assign underflow = 	(A=={Width_A{1'b0}}||B=={Width_B{1'b0}})? 1'b0 : //Caso con cero
				(A[Width_A-1]!=B[Width_B-1]) ? ~(&mult[Width_A+Width_B-2:f_A+f_B+p_A]) : //Signo negativo
				1'b0 ;					//Underflow si no hay extensión de signo en el 2do bloque de magnitud

	assign	Y = 	overflow 	? {1'b0,{(Width_A-1){1'b1}}} : //Si hay overflow se satura el resultado en 0111...
			underflow 	? {1'b1,{(Width_A-1){1'b0}}} : //Si hay underflow se satura el resultado en 1000...
			{mult[Width_A+Width_B-2],mult[Width_A+Width_B-3-p_B:f_B]};	   //en caso contrario se deja el mismo resultado de la multiplicación binaria
endmodule

