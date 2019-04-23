// Part 2 skeleton

module part2
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
    // Instansiate datapath
	datapath d0(
		.data(SW[6:0]), 
		.color(SW[9:7]), 
		.clock(CLOCK_50), 
		.reset_n(KEY[0]),
		.enable(enable), 
		.ld_x(ld_x), 
		.ld_y(ld_y), 
		.ld_c(ld_c), 
		.X(x), 
		.Y(y), 
		.color_final(colour)
		);

    // Instansiate FSM control
    	control c0(
    		.KEY_3(~KEY[3]), 
    		.reset_n(KEY[0]),
    		.KEY_1(~KEY[1]),
    		.clock(CLOCK_50),
    		.enable(enable),
    		.ld_x(ld_x),
    		.ld_y(ld_y),
    		.ld_c(ld_c),
    		.plot(writeEn)
    		);
    
    
endmodule


module datapath(data, color, clock, reset_n, enable, ld_x, ld_y, ld_c, X, Y, color_final);
	input reset_n, enable, clock, ld_x, ld_y, ld_c;
	input [6:0] data;
	input [2:0] color;

	output [7:0] X;
	output [6:0] Y;
	output [2:0] color_final;

	reg [6:0] x1, y1;
	reg [2:0] co1;
	reg counter_reset_n;

	wire [3:0] c1;

	always @(posedge clock) begin
		if (!reset_n) begin
			x1 <= 7'b0;
			y1 <= 7'b0;
			co1 <= 3'b0;
			counter_reset_n <= 1'b0;
		end
		else begin
			if (ld_x)
				x1 <= data;
				counter_reset_n <= 1'b0;

			if (ld_y)
				y1 <= data;

			if (ld_c)
				co1 <= color;
				counter_reset_n <= 1'b1;
		end
	end

	counter m1(clock, counter_reset_n, enable, c1);
	assign X = {1'b0, x1} + c1[1:0];
	assign Y = y1 + c1[3:2];
	assign color_final = co1;

endmodule


module counter(clock, reset_n, enable, q);
	input clock, reset_n, enable;
	output reg 	[3:0] 	q;
	
	always @(posedge clock) begin
		if(reset_n == 1'b0)
			q <= 4'b0000;
		else if (enable == 1'b1)
		begin
		  if (q == 4'b1111)
			  q <= 4'b0000;
		  else
			  q <= q + 4'b0001;
		end
   end
endmodule


module rate_counter(clock,reset_n,enable,q); //Counts for 14.
		input clock;
		input reset_n;
		input enable;
		output reg [3:0] q;
		
		always @(posedge clock)
		begin
			if(reset_n == 1'b0)
				q <= 4'b1110;
			else if(enable ==1'b1)
			begin
			   if (q == 4'b0000)
					q <= 4'b1110;
				else
					q <= q - 1'b1;
			end
		end
endmodule




module control(KEY_3, reset_n, KEY_1, clock, enable, ld_x, ld_y, ld_c, plot);
	input KEY_3, reset_n, clock, KEY_1;

	output reg enable, ld_x, ld_y, ld_c, plot;

	reg [3:0] current_state, next_state;
	reg counter_enable, counter_reset_n;
	
	wire [3:0] q;
	wire state_clock;

	localparam S_LOAD_X = 4'd0,
		   S_LOAD_X_WAIT = 4'd1,
		   S_LOAD_Y = 4'd2,
		   S_LOAD_Y_WAIT = 4'd3,
		   COLOR = 4'd4,
		   DRAW = 4'd5;
	
	always @(*)
	begin: enable_signals
	if (!reset_n) begin
		ld_x = 1'b0;
		ld_y = 1'b0;
		ld_c = 1'b0;
		enable = 1'b0;
		plot = 1'b0;
		counter_reset_n = 1'b0;

	end

		case(current_state)
			S_LOAD_X: begin
				ld_x = 1'b1;
				ld_y = 1'b0;
				ld_c = 1'b0;
				enable = 1'b0;
				plot = 1'b0;
			end
			S_LOAD_Y: begin
				ld_y = 1'b1;
				ld_x = 1'b0;
				ld_c = 1'b0;
				enable = 1'b0;
				plot = 1'b0;
			end
			COLOR: begin
				ld_x = 1'b0;
				ld_y = 1'b0;
				ld_c = 1'b1;
				enable = 1'b0;
				plot = 1'b0;
			end
			DRAW: begin
				ld_x = 1'b0;
				ld_y = 1'b0;
				ld_c = 1'b0;
				enable = 1'b1;
				plot = 1'b1;
			end
		endcase
	end

	rate_counter m1(clock, counter_reset_n, counter_enable, q);

	always@(*)
	begin: state_table
			case(current_state)
				S_LOAD_X: next_state = KEY_3 ? S_LOAD_X_WAIT : S_LOAD_X;
				S_LOAD_X_WAIT: next_state = KEY_3 ? S_LOAD_X_WAIT : S_LOAD_Y;
				S_LOAD_Y: next_state = KEY_1 ? S_LOAD_Y_WAIT : S_LOAD_Y;
				S_LOAD_Y_WAIT: next_state = KEY_1 ? S_LOAD_Y_WAIT : COLOR;
				COLOR: next_state = DRAW;
				DRAW: next_state = S_LOAD_X;
			default: next_state = S_LOAD_X;
		endcase
	end	

	always @(posedge clock) begin
		if (current_state == DRAW) begin
			counter_enable <= 1'b1;
			counter_reset_n <= 1'b1;
			current_state <= (q == 4'b0000) ? next_state: current_state;
		end
		else begin
			counter_enable <= 1'b0;
			current_state <= next_state;
            counter_reset_n <= 1'b0;
		end
	end
endmodule

module test(data, color, reset_n, clock, KEY_3, KEY_1, X, Y, color_final);
	input [6:0] data;
	input [2:0] color;
	input reset_n, clock, KEY_3, KEY_1;
	output [7:0] X;
	output [6:0] Y;
	output [2:0] color_final;

	wire enable, ld_x, ld_y, ld_c, plot;

	control m1(KEY_3, reset_n, KEY_1, clock, enable, ld_x, ld_y, ld_c, plot);
	datapath m2(data, color, clock, reset_n, enable, ld_x, ld_y, ld_c, X, Y, color_final);

endmodule
