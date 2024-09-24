module multilpier (
	input 	wire signed		[11:0] 	x,y,
	output  wire signed 	[23:0] 	mul_out
);
	assign  mul_out = x * y;
endmodule
