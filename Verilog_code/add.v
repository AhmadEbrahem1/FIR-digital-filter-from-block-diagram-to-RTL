module add(
	input 	wire 			    clk			, 
	input   wire                rst			,
	input   wire                adder_en	,
	input 	wire signed	[11:0] 	a 			,
	output 	reg  signed	[11:0] 	sum
);

always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        sum <= 'b0 		;
    end else if (adder_en) begin
        sum <= a + sum	;
	end else begin
		sum <= a ;
	end  
    
end


endmodule