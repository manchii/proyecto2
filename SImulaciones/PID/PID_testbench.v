`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:51:44 05/25/2015
// Design Name:   pid
// Module Name:   /home/kaalfaro/LabDigitales/Servo/ProyectoServo/PID_testbench.v
// Project Name:  ProyectoServo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pid
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module PID_testbench;

	// Inputs
	reg sclk;
	reg rst;
	reg enable;
	reg [17:0] yk;
	reg [17:0] rk;

	// Outputs
	wire [17:0] pid_output;

	// Instantiate the Unit Under Test (UUT)
	pid uut (
		.sclk(sclk), 
		.rst(rst), 
		.enable(enable), 
		.yk(yk), 
		.rk(rk), 
		.pid_output(pid_output)
	);


	reg [17:0] datos_yk [0:50];
	integer i,Output;
	
	initial begin
		// Initialize Inputs
		sclk = 0;
		rst = 1;
		enable = 0;
		yk = 0;
		rk = 0;
		$readmemb("test_pid.txt", datos_yk);
		Output = $fopen("output.txt","w");
		repeat(10) @(posedge sclk);
		rst = 0;
	end
      
	initial begin
	@(negedge rst);
		for(i = 0; i<51; i=i+1)
		begin
			@(posedge sclk);
			yk = datos_yk[i];
			enable = 1'b1;
			@(posedge sclk) $fwrite(Output,"%b\n",pid_output);
			enable = 1'b0;
			repeat(3)@(posedge sclk);
		end
		$stop;
	end
	
	initial forever begin
	#5 sclk = ~sclk;
	end
		
		
endmodule

