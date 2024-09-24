
module Mux_4_to_1 ( 
	input 	wire [11:0] 	i1,i2,i3,i4 ,
	input	wire [1:0] 		select		 ,
	output 	reg  [11:0]		mux_out
);

	always @(*)begin
		case(select)
			'd0: 	mux_out =  i1;
			'd1:	mux_out =  i2;
			'd2:	mux_out =  i3;
			'd3:	mux_out =  i4;
			default:mux_out =  i1;
		endcase
	end


endmodule