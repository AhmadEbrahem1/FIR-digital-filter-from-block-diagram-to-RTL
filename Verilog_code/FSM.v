module FSM (
	input 	wire 			clk  			, 
	input   wire            rst  			, 
	input   wire            load 			,
	output  reg             adder_en		,
	output 	reg		[1:0]	select_mux_1	,  
	output  reg     [1:0]   select_mux_2	,
	output  reg             valid_out      ,
	output  reg         	shift_load_en	
);

localparam state_reg_width 			=	3 ;

localparam [state_reg_width-1:0]	s0	= 3'd0,
									s1 	= 3'd1,
									s2  = 3'd2,
									s3  = 3'd3,
									s4  = 3'd4;

									
reg [state_reg_width-1:0] current_state , next_state ;

always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        current_state <= s0;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin

	shift_load_en 	= 'b0 ;
	select_mux_1  	= 'b0 ;
	select_mux_2  	= 'b0 ;
	adder_en 	   	= 'b1 ;
	valid_out     	= 'b0 ;
	
    case (current_state)    
		s0:begin
			if(load == 'd1) begin
				next_state 	= s1	;
				shift_load_en	= 'd1	;
			end else begin 
				next_state 	= s0	;
			end		
		end

		s1:begin
			adder_en       	= 'b0 ;
			select_mux_1 	= 'd0 ;
			select_mux_2 	= 'd0 ;
			next_state		= s2  ; 
		end
		s2:begin
			select_mux_1 	= 'd1 ;
			select_mux_2 	= 'd1 ;
			next_state		= s3  ; 
		end
		s3:begin
			select_mux_1 	= 'd2 ;
			select_mux_2 	= 'd2 ;
			next_state  = s4 ;
		end
		s4:begin
			select_mux_1 	= 'd3 ;
			select_mux_2 	= 'd3 ;
			valid_out     	= 'd1 ;
			if(load == 'd1) begin
				shift_load_en	= 'd1	;
				next_state		= s1  ;	
			end else begin
				next_state  = s0 ;
			end			
		end
		
    endcase
	
end								
endmodule



