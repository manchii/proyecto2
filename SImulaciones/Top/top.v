`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Kaleb Alfaro e Irene Rivera
//
// Create Date: may/2015
// Design Name:
// Module Name: top
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

module top #(parameter Width = 18)
(
	input wire clk, rst,
	input wire sdata_adc, 
	output wire cs, sclk_adc,
	input wire signed [7:0] rk,
	output wire pwm_output,
	output wire [7:0] pwm_data
);

wire sclk, sclk_out, enable;
wire [10:0] data_adc;
reg [10:0] reg_data_adc;
wire signed [Width-1:0] pid_output;
wire signed [7:0] pid_offset;
reg signed [7:0] reg_pid_Amplitud;
wire signed [10:0] yk;
reg counter;

assign sclk_adc = sclk_out;

clk_div clk_div_modulo(
	.clk(clk), 
	.rst(rst),
	.sclk(sclk),
	.sclk_out(sclk_out)
	);

Receive_adc modulo_adc(
	.sclk(sclk),
	.rst(rst),
	.sdata(sdata_adc), 
	.rx_en(1'b1),
	.rx_done_tick(enable),
	.dout(data_adc),
	.cs(cs)
	);

always@(posedge clk, posedge rst)
begin
	if(rst)
	begin
		reg_data_adc <= 11'h400;
		reg_pid_Amplitud <= 8'h80;
		counter <= 1'b0;
	end
	else
	begin
		reg_data_adc <= (counter) ? data_adc : reg_data_adc;
		reg_pid_Amplitud <= (counter) ? pid_offset : reg_pid_Amplitud; 
		counter <= (~enable)? 1'b0 : (counter)? 1'b0: 1'b1; 
	end
end	
	
/*
Sum #(
	.Width(Width)
) Suma_quitar_offset 
(
	.A({{(Width-11){1'b0}},reg_data_adc}),
	.B({ {(Width-10){1'b1}} , {10{1'b0}} }),
	.Y(yk)
);
*/

assign yk = reg_data_adc - 11'b10000000000;

pid #(
	.Width(Width)
) modulo_PID
(
	.sclk(sclk), 
	.rst(rst), 
	.enable(enable), 
	.yk({{Width-11{yk[10]}},yk}), 
	.rk({{Width-12{rk[7]}},rk,4'b0000}), 
	.pid_output(pid_output)
);

assign pid_offset = pid_output[Width-1:Width-8] + 8'd128;

assign pwm_data = reg_pid_Amplitud;

pwm #(.PWM_Width(8))
modulo_pwm
(
	.clk(clk),
	.rst(rst),
	.Data_in({reg_pid_Amplitud}),
	.PWM_out(pwm_output)
);


endmodule
