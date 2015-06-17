`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Kaleb Alfaro e Irene Rivera
//
// Create Date: may/2015
// Design Name:
// Module Name: pwm
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

module pwm#(
	parameter PWM_Width = 8
)
(
	input wire clk,rst,
	input wire [PWM_Width-1:0] Data_in,
	output reg PWM_out
);

reg [PWM_Width-1:0] Counter;


//*********************************************************

reg [5:0] counter_clk;
reg clk_div;


always@(posedge clk, posedge rst)
begin
	if(rst)
	begin 
		counter_clk <= 6'b0;
		clk_div <= 1'b0;
	end	
	else
	begin
		counter_clk <= (counter_clk < 6'd38)? counter_clk + 1'b1 : 6'b0;
		clk_div <= (counter_clk < 6'd38);
	end
end

//*********************************************************

always@(posedge clk_div, posedge rst)
	if(rst)
	begin
		PWM_out <= 1'b0;
		Counter <= 0;
	end
	else 
	begin
		Counter <= Counter+1'b1;
		PWM_out <= (Counter < Data_in)? 1'b1 : 1'b0;
	end

endmodule
