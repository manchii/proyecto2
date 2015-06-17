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
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module Receive_adc(
	input wire sclk, rst,
	input wire sdata, rx_en,
	output wire rx_done_tick,
	output wire [10:0] dout,
	output reg cs
);

reg [10:0] reg_desp, reg_desp_next;


//Registro serial-paralelo
//Begin
always@(negedge sclk, posedge rst)
begin
	if(rst)
		reg_desp <= 11'h400;
	else
		reg_desp <= reg_desp_next;
end

always@*
begin
	reg_desp_next = reg_desp;
	if(state&(counter<4'd15))
		reg_desp_next = {reg_desp[9:0],sdata};
end


//End

reg state,state_next;
reg [3:0] counter, counter_next;

always@(posedge sclk, posedge rst)
	if(rst)
	begin
		state <= 1'b0;
		counter <= 4'b0;
	end
	else
	begin
		state <= state_next;
		counter <=counter_next;
	end

always@*
begin
	state_next = state;
	counter_next = 4'b0;
	cs = 1'b0;
	case(state)
		1'b0:
			begin
				cs = 1'b1;
				state_next=1'b1;
			end
		1'b1:
			begin
				counter_next = counter + 1'b1;
				if(counter==4'd15)
				begin
					state_next = 1'b0;
				end
			end
	endcase		
end

assign rx_done_tick = ~state & rx_en;
assign dout = reg_desp;

endmodule
