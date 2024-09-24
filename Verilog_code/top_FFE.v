module top_FFE(
	
	input 	wire 						clk  			, 
	input   wire            			rst  			, 
	input   wire            			load 			,    
	input 	wire signed		[11:0]  	DATA_IN			,
	output  wire                        valid_out      ,
	output 	wire signed		[11:0]  	DATA_OUT  
);

	///////////////////////////////////////////
	///////////// Control signals ////////////
	//////////////////////////////////////////
	wire	[1:0]	select_mux_1 	;
	wire 	[1:0]	select_mux_2 	;
	wire    		shift_load_en 	; 
	wire            adder_en  	    ;
	wire 			sync_load     	;
	
	
	wire    signed   [11:0]	 mux1_out 		;
	wire 	signed	 [11:0]  mux2_out 		;
	

	////////////////////////////////////////
	//////// Multiplication output  /////// 
	///////////////////////////////////////
	wire signed	[23:0] 	mul_out	 ;
	
	
	//////////////////////////////////////
	///////////	taps values //////////////
	/////////////////////////////////////
	/*************************************
		we assuming that fraction length 
		equal integer length equal "6" 
	**************************************/
	wire signed	[11:0] 	reg_h0	=	12'h020	,//h0 = 0.5
						reg_h1	=	12'hff0	,//h1 = -.25
						reg_h2	=	12'h00a	,//h2 = 0.1562
						reg_h3	=	12'hffc	;//h3 = -0.0625
						
					
	///////////////////////////////////////
	/////////// shift registers //////////
	//////////////////////////////////////	
	wire signed	[47:0] 	shift_reg      ;

	
	////////////////////////////////////////
	////// instansiation of submodules /////
	////////////////////////////////////////
	
	two_bit_sync U_sync_two_bit (
		.clk 			(clk)		,
		.rst 		   	(rst)      	,
		.async_signal 	(load)		,
		.sync_signal  	(sync_load)
	);

	FSM inst0 (
	  .clk				(clk)			,
	  .rst				(rst)			,
	  .adder_en        (adder_en)    	,
	  .load				(sync_load)	,
	  .valid_out       (valid_out)   	,
	  .select_mux_1	(select_mux_1)	,
	  .select_mux_2	(select_mux_2)	,
	  .shift_load_en	(shift_load_en)
	);

	
	shift_reg U_shift_reg(
		.clk				(clk)				,
		.rst				(rst)				,
		.shift_load_en		(shift_load_en)	,
		.DATA_IN			(DATA_IN)          	,
		.shift_reg_out   	(shift_reg)  
	);


	Mux_4_to_1  Mux_1(
		.i1			(shift_reg[11:0])	,
		.i2			(shift_reg[23:12])	,
		.i3			(shift_reg[35:24])	,
		.i4			(shift_reg[47:36]) ,
		.select		(select_mux_1)	,
		.mux_out	(mux1_out)
	);

	
	Mux_4_to_1  Mux_2(
		.i1			(reg_h0)		,
		.i2			(reg_h1)		,
		.i3			(reg_h2)		,
		.i4			(reg_h3) 		,
		.select		(select_mux_2)	,
		.mux_out	(mux2_out)
	);


	multilpier mul_inst (
		.x		 (mux1_out),
		.y		 (mux2_out),
		.mul_out(mul_out)
	);		

	add adder(
		.clk				(clk)			,
		.rst				(rst)			,
		.adder_en        	(adder_en)    	,	
		.a					(mul_out[17:6]),
		.sum				(DATA_OUT)
	);




endmodule
