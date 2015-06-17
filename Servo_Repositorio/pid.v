module pid #(parameter Width = 18)
(
	input wire sclk,rst,enable,
	input wire signed [Width-1:0]  yk,rk,
	output wire signed [Width-1:0] pid_output
);

wire signed [Width-1:0] negpk,negdk,ik,ek;
wire signed [Width-1:0] neg_yk,neg_yk1,ik1;
wire signed [Width-1:0] sum_yk_negyk1,kiek;
wire signed [Width-1:0] sum_negpk_negdk;

assign neg_yk = -yk;

//******************************************************************
//Pk


Mult  #(.f_A(0),.p_A(Width-1),.f_B(0),.p_B(6)) 
mult_pk
(
    .A(yk), 
    .B(-7'sd9), 
    .Y(negpk)
);


//******************************************************************
//Dk

Reg #(
	.Width(Width)
) reg_negyk	//-yk1
(
	.A(neg_yk),
	.Y(neg_yk1),
	.clk(sclk),
	.rst(rst),
	.enable(enable)
	);

Sum #(
	.Width(Width)
) Suma_sum_yk_negyk1 // yk-yk1
(
	.A(yk),
	.B(neg_yk1),
	.Y(sum_yk_negyk1)
);

Mult  #(.f_A(0),.p_A(Width-1),.f_B(0),.p_B(8)) 
mult_dk
(
    .A(sum_yk_negyk1), 
    .B(- 9'sd75), 
    .Y(negdk)
);

//******************************************************************
//Ik

Sum #(
	.Width(Width)
) Suma_ek // rk-yk
(
	.A(rk),
	.B(neg_yk),
	.Y(ek)
);

Mult  #(.f_A(0),.p_A(Width-1),.f_B(0),.p_B(3)) 
mult_kiek
(
    .A(ek), 
    .B(4'd4), 
    .Y(kiek)
);

Sum #(
	.Width(Width)
) Suma_ik
(
	.A(kiek),
	.B(ik1),
	.Y(ik)
);


Reg #(
	.Width(Width)
) reg_ik1	//ik1
(
	.A(ik),
	.Y(ik1),
	.clk(sclk),
	.rst(rst),
	.enable(enable)
);

//******************************************************************
//PID

Sum #(
	.Width(Width)
) Suma_sum_negpk_negdk
(
	.A(negpk),
	.B(negdk),
	.Y(sum_negpk_negdk)
);

Sum #(
	.Width(Width)
) Suma_PID
(
	.A(ik),
	.B(sum_negpk_negdk),
	.Y(pid_output)
);


endmodule
