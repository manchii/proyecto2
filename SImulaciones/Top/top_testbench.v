`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:57:18 06/02/2015
// Design Name:   top
// Module Name:   /home/kaalfaro/LabDigitales/Servo/ProyectoServo/top_testbench.v
// Project Name:  ProyectoServo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module top_testbench;

	// Inputs
	reg clk;
	reg rst;
	reg sdata_adc;
	reg [7:0] rk;

	// Outputs
	wire cs;
	wire sclk_adc;
	wire pwm_output;
	wire [7:0]pwm_data;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.rst(rst), 
		.sdata_adc(sdata_adc), 
		.cs(cs), 
		.sclk_adc(sclk_adc), 
		.rk(rk), 
		.pwm_output(pwm_output),
		.pwm_data(pwm_data)
	);


	reg [15:0] datos_adc [0:20];
	reg [15:0] aux_adc;
	integer Output_pwm;
	integer i,j;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		sdata_adc = 0;
		rk = 0;
		aux_adc = 16'h0800;
		$readmemb("test.txt", datos_adc);
		Output_pwm = $fopen("output_pwm.txt","w");
		repeat(10)@(posedge clk);
		rst = 0;
		i=0;
		j=0;
	end
      
	initial begin
		@(negedge cs);
		for(j=0;j<21;j=j+1)		
		begin
			@(negedge cs);
			aux_adc = datos_adc[j];
			for(i = 15; i>-1; i = i-1)
			begin
				sdata_adc = aux_adc[i];
				@(posedge sclk_adc);
			end
			$fwrite(Output_pwm,"%b\n",pwm_data);
		end
		$stop;
	end

	initial forever begin
		#5 clk = ~clk;
	end

endmodule


