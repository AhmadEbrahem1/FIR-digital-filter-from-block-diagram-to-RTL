module two_bit_sync (
	input 	wire	clk				,
	input 	wire    rst           	,
	input	wire 	async_signal	,
	output  wire    sync_signal   
);

reg t1 , t2 ; //temporary variable 

////////////////////////////////////////////////
////////////////  syncronyser /////////////////
///////////////////////////////////////////////
always @(posedge clk or negedge rst) begin 

	if(!rst)begin
		t1 <= 'b0 ;
		t2 <= 'b0 ;
	end else begin
		t1 <= async_signal ;
		t2 <= t1 ;
	end

end

assign sync_signal = t2 ;

endmodule