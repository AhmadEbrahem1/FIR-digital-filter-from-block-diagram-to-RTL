module shift_reg (
	input 	wire 						clk 			, 
	input 	wire 						rst 		  	,
	input 	wire 						shift_load_en 	,
	input 	wire signed 	[11:0] 		DATA_IN 		,
	output 	wire signed 	[47:0]		shift_reg_out
);

integer i ;
reg  [11:0]		DATA_OUT_BANK [3:0] ;

always @(posedge clk or negedge rst ) begin
    
	if (!rst) begin
        
		for(i = 0 ; i < 4 ; i = i + 1) begin
			DATA_OUT_BANK [i] <= 'b0 ;
		end
    
	end else if (shift_load_en) begin
		
		DATA_OUT_BANK [0] <= DATA_IN ;
		for(i = 1 ; i < 4 ; i = i + 1) begin
			DATA_OUT_BANK[i] <= DATA_OUT_BANK[i-1] ;
		end
		
    end

end

assign shift_reg_out = {DATA_OUT_BANK[3], DATA_OUT_BANK[2], DATA_OUT_BANK[1], DATA_OUT_BANK[0]} ;

endmodule