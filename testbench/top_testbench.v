module top_FFE_TB();

	real h0=0.5,h1=-0.25,h2=0.15625,h3=-0.0625; // Variables of tabs
	
	////////////////////////////////////////////////
	/////  Port signal that connect to DUT    /////
	///////////////////////////////////////////////
	reg  						clk_TB    		;
	reg             			rst_TB    		;
	reg             			load_TB   		;
	reg  signed  	[11:0]  	DATA_IN_TB		;
	wire signed 	[11:0]  	DATA_OUT_TB 	;
	wire 						valid_output_TB;

	/////////////////////////////////////////////
	///////////// Temporary Signal //////////////
	/////////////////////////////////////////////
	reg tx_clk;
	real temp ;
	
	//////////////////////////////////////////////
	///////////// DUT instansiation //////////////
	/////////////////////////////////////////////
	top_FFE DUT (
		.clk(clk_TB)  			  , 
		.rst(rst_TB)  			  , 
		.load(load_TB) 		  ,    
		.DATA_IN(DATA_IN_TB)	  ,
		.DATA_OUT(DATA_OUT_TB)  ,
		.valid_out(valid_output_TB)
	);
	
	//////////////////////////////////////////
	//////////	Clock generation /////////////
	/////////////////////////////////////////
	always  #4 tx_clk=~tx_clk; //TX Clock
	always  #1 clk_TB=~clk_TB; //RX Clock
	
	/////////////////////////////////////////
	///////// Initialization Task //////////
	////////////////////////////////////////
	task initialization();
	begin
		clk_TB=0;
		tx_clk=0;
		rst_TB=1;
		load_TB=0;
		DATA_IN_TB=0;
	end
	endtask
	
	////////////////////////////////////////
	//////////// Rest Task ////////////////
	//////////////////////////////////////
	task reset ();
	begin
		@(posedge clk_TB);
		rst_TB=0;
		@(posedge clk_TB);
		rst_TB=1;
	end
	endtask
	
	
	initial begin
		initialization();
		reset();
		
	fork
		begin
			@(posedge tx_clk);
			#0;
			DATA_IN_TB='d15 * 'd64;
			load_TB=1;
			
			@(posedge tx_clk);
			#0;
			DATA_IN_TB='d20 * 'd64;
			load_TB=1;
			
			@(posedge tx_clk);
			load_TB=0;
			
			@(posedge tx_clk);
			DATA_IN_TB='d29 * 'd64;
			load_TB=1;
			
			@(posedge tx_clk);
			load_TB=0;	

			@(posedge tx_clk);
			DATA_IN_TB='d30 * 'd64;
			load_TB=1;

			@(posedge tx_clk);
			temp       = -16.5 ;
			DATA_IN_TB= -16.5 * 'd64;
			load_TB=1;
			
			@(posedge tx_clk);
			load_TB=0;			
		end
		
		begin
			@(negedge valid_output_TB);
			#1 ;
			$display("input data : %0d ",15);
			$display("output is %f" , DATA_OUT_TB/64.0);
			$display("result should be %f" , 15*h0);
			
			#1
			@(negedge valid_output_TB);
			$display("\n------------------------------------------\n");
			$display("input data : %0d ",20);
			$display("output is %f" , DATA_OUT_TB/64.0);
			$display("result should be %f" , 20*h0+15*h1);			
			
			#1
			@(negedge valid_output_TB);
			$display("\n------------------------------------------\n");
			$display("input data : %0d ",29);
			$display("output is %f" , DATA_OUT_TB/64.0);
			$display("result should be %f" , 29*h0+20*h1+15*h2);
			
			#1
			@(negedge valid_output_TB);
			$display("\n------------------------------------------\n");
			$display("input data : %0d ",30);
			$display("output is %f" , DATA_OUT_TB/64.0);
			$display("result should be %f" , 30*h0+29*h1+20*h2+15*h3);
			
			#1
			@(negedge valid_output_TB);
			$display("\n------------------------------------------\n");
			$display("input data is %0f ", temp);
			$display("output is %f" , DATA_OUT_TB/64.0);
			$display("result should be %f" , temp*h0+30*h1+29*h2+20*h3);
			$display("data in is : %d" , DATA_IN_TB) ;
		end
	join
		

		#10;
		$finish();
		
		
	end




endmodule