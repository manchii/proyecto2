`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Kaleb Alfaro e Irene Rivera
//
// Create Date: april/2015
// Design Name:
// Module Name: Receive_ADC
// Project Name:
// Target Devices:
// Tool versions:
// Description:100MHz/133 -> /17050 ->cs
//17
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module clk_div(
	input wire clk, rst,
	output wire sclk,sclk_out
);

reg[13:0] counter_sclk, counter_sclk_next;
reg new_clk, new_clk_next;
wire pulse_sclk;


always@(posedge clk, posedge rst)
begin
	if(rst)
	begin
		counter_sclk <= 14'b0;
		new_clk <= 1'b0;
	end	
	else
	begin
		counter_sclk <= counter_sclk_next;
		new_clk <= new_clk_next;	
	end
end

always@*
begin
	counter_sclk_next = (pulse_sclk)? 14'b0 : counter_sclk + 1'b1;
	new_clk_next = (pulse_sclk)? ~new_clk : new_clk;
end

assign pulse_sclk = (counter_sclk==14'd14706);

assign sclk_out = new_clk;

assign sclk = new_clk;

endmodule
