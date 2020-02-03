module project_demo
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		  LEDR,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,		//	VGA Blue[9:0]
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;
	output [9:0] LEDR;

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
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	
	
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] X;
	wire [6:0] Y;
	wire writeEn;
	wire clock_1;
	wire [26:0] connection; 
	wire [7:0] ram_connection_x;
	wire [6:0] ram_connection_y;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(SW[9]),
			.clock(CLOCK_50),
			.colour(colour),
			.x(X),
			.y(Y),
			.plot(1'b1),
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

	// Instantiate rate_divider for clock
	
    ram_top rt0(
        .clock(KEY[0]), 
        .enable(1'b1), 
        .reset_n(SW[9]), 
        .key_input(SW[3:0]),
		.direction(LEDR[9:6]),
		.erase_tail(erase_tail), 
		.update_ram(update_ram), 
		.show(show), 
		.x(ram_connection_x), 
		.y(ram_connection_y)

		);
    
    // Instansiate datapath
    datapath d0(
        .clock(KEY[0]), 
        .reset_n(SW[9]), 
        .ram_input_x(ram_connection_x), 
        .ram_input_y(ram_connection_y),
		.start(start), 
		.initiate(initiate), 
		.draw_head(draw_head), 
		.erase_tail(erase_tail),
		.plot(writeEn),
		.X(X), 
		.Y(Y), 
		.colour(colour)
		); 
        


    // Instansiate FSM control
    control c0(
        .clock(KEY[0]), 
        .reset_n(SW[9]), 
        .start(start), 
        .initiate(initiate), 
        .draw_head(draw_head),
		.erase_tail(erase_tail),
		.update_ram(update_ram),
        .show(show), 
        .current_state(LEDR[2:0]), 
        .next_state(LEDR[5:3]), 
        .plot(writeEN)
    );
	 
		
	// rate divider a 1Hz
	rate_divider rd0(
		.enable(1'b1), 
		.clock(CLOCK_50), 
		.reset_n(SW[9]), 
		.q(connection)
	);

	assign clock_1 = (connection == 27'd0) ? 1'b1 : 1'b0; 
	
	DEC x0(X[3:0], HEX0);
	DEC x1(X[7:4], HEX1);
	DEC y0(Y[3:0], HEX2);
	DEC y1({1'b0,Y[6:4]}, HEX3);
	DEC ra(ram_connection_x[3:0], HEX4);
	
endmodule

module DEC(SW, HEX0);
    input [3:0] SW;
    output [6:0] HEX0; assign HEX0[0] = (~SW[3]&~SW[2]&~SW[1]&SW[0]) | (~SW[3]&SW[2]&~SW[1]&~SW[0]) | (SW[3]&SW[2]&~SW[1]&SW[0]) | (SW[3]&~SW[2]&SW[1]&SW[0]);
        
    assign HEX0[1] = (~SW[3]&SW[2]&~SW[1]&SW[0]) | (SW[2]&SW[1]&~SW[0]) | (SW[3]&SW[2]&~SW[0]) | (SW[3]&SW[1]&SW[0]);
    assign HEX0[2] = (~SW[3]&~SW[2]&SW[1]&~SW[0]) | (SW[3]&SW[2]&~SW[0]) | (SW[3]&SW[2]&SW[1]);
    assign HEX0[3] = (~SW[3]&SW[2]&~SW[1]&~SW[0]) | (SW[3]&~SW[2]&SW[1]&~SW[0]) | (~SW[2]&~SW[1]&SW[0]) | (SW[2]&SW[1]&SW[0]);
    assign HEX0[4] = (~SW[3]&SW[2]&~SW[1]) | (~SW[2]&~SW[1]&SW[0]) | (~SW[3]&SW[0]);
    assign HEX0[5] = (SW[3]&SW[2]&~SW[1]&SW[0]) | (~SW[3]&~SW[2]&SW[0]) | (~SW[3]&~SW[2]&SW[1]) | (~SW[3]&SW[1]&SW[0]);
    assign HEX0[6] = (~SW[3]&~SW[2]&~SW[1]) | (~SW[3]&SW[2]&SW[1]&SW[0]) | (SW[3]&SW[2]&~SW[1]&~SW[0]);

endmodule 


module rate_divider(enable, clock, reset_n, q); // maybe used instead of CLOCK_50
    input enable, clock, reset_n;
    output reg [26:0] q;

    always @(posedge clock) begin
        if (reset_n == 1'b0)
            q <= 27'd100000000; // JP configure 1Hz
        else if (enable) begin
            if (q == 27'd0)
                q <= 27'd100000000;
            else
                q <= q - 27'd1;
        end
    end

endmodule



module datapath(clock, reset_n, ram_input_x, ram_input_y, start, initiate, erase_tail, draw_head, plot, X, Y, colour);
	input clock, reset_n, start, initiate, erase_tail, draw_head, plot;	
    input [7:0] ram_input_x;
    input [6:0] ram_input_y;
	output reg [7:0] X;
	output reg [6:0] Y;
	output reg [2:0] colour;
	reg [2:0] temp_colour;
//	output reg [3:0] direction; 
	
	//reg initiate_counter_reset_n;
	//wire dimension_clock;, connection3;
	//wire [1:0] connection1; 
	//wire connection2;

	//initiate_counter cx0(clock, initiate_counter_reset_n, 1'b1, connection1);
//	assign dimension_clock = (connection1 == 3'd7) ? 1'b1 : 1'b0;
//	initiate_counter_Y c0(clock, reset_n, dimension_clock, connection2);
    //square_counter c0(clock, square_counter_enable, square_counter_reset_n, connection3);

	always @(posedge clock) begin
		if (!reset_n) begin
			X <= 8'd0;
			Y <= 7'd0;
			colour <= 3'b000;
			temp_colour <= 3'b000;
			//initiate_counter_reset_n = 1'b0;
		end
		
		else begin
		    if (start) begin
		        //initiate_counter_reset_n = 1'b1;
			X <= 8'd20;
			Y <= 7'd20;
				colour <= 3'b010;
		    end
			
		    if (initiate) begin
				colour <= 3'b010;
				X <= X + 8'b00000001;
		    end
			 
			 if (!initiate && plot) begin
				X <= ram_input_x;
				Y <= ram_input_y;
				colour <= temp_colour;
		    end
			
		    if (erase_tail) begin
				temp_colour <= 3'b000;
		    end

		    if (draw_head) begin
				temp_colour <= 3'b010;
		    end
			 
		end
	end
		
endmodule

//module square_counter(clock, enable, reset_n, q);
//    input enable, reset_n, clock;
//    output reg q;
//
//    always @(posedge clock) begin
//        if (!reset_n)
//            q <= 1'b0;
//        else if (enable) begin
//            if (q == 1'b1)
//                q <= 1'b0;
//            else
//                q <= q + 1'b1;
//        end
//    end
//    
//endmodule	

//
//module initiate_counter(clock, reset_n, enable, q);
//	input clock, reset_n, enable;
//	output reg [1:0] q;
//
//	always @(posedge clock) begin
//		if (!reset_n)
//			q <= 2'd0;
//		else if (enable) begin
//			if (q == 2'd3) 				
//				q <= 2'd0;
//			else
//				q <= q + 2'd1;
//		end
//	end
//endmodule


//module initiate_counter_Y(clock, reset_n, enable, q);
//	input clock, reset_n, enable;
//	output reg q;
//
//	always @(posedge clock) begin
//		if (!reset_n)
//			q <= 1'd0;
//		else if (enable) begin
//			if (q == 1'd1)
//				q <= 1'd0;
//			else 
//				q <= 1'd1;
//		end
//	end
//endmodule


module control(clock, reset_n, start, initiate, draw_head, update_ram, erase_tail, show, current_state, next_state, plot);
	input clock, reset_n, show;
	output reg start, initiate, draw_head, update_ram, erase_tail, plot;
	output reg [2:0] current_state, next_state;
	wire [2:0] connection1;
	wire [1:0] connection2;
	reg initiate_clock_reset_n, draw_rate_counter_enable, draw_rate_counter_reset_n;
 //draw_head_counter_enable, draw_head_counter_reset_n,

	localparam 
	    START = 3'd0,
	    INITIATE = 3'd1,
	    DRAW_HEAD = 3'd2,
	    WAIT = 3'd3,
	    ERASE_TAIL = 3'd4,
        CHECK = 3'd5;
		

	always @(*) begin: enable_signals
	    if (!reset_n) begin
		plot = 1'b0;
		start = 1'b0;
		draw_head = 1'b0;
		erase_tail = 1'b0;
		initiate = 1'b0;
		update_ram = 1'b0;
		initiate_clock_reset_n = 1'b0;
		draw_rate_counter_enable = 1'b0;
		draw_rate_counter_reset_n = 1'b0;
		//draw_head_counter_reset_n = 1'b0;
		//draw_head_counter_enable = 1'b0;
	    end
	
	    case(current_state)
		START: begin
		    plot = 1'b0;
		    start = 1'b1;
		end
		INITIATE: begin
		    plot = 1'b1;
		    start = 1'b0;
		    initiate_clock_reset_n = 1'b1;
		    initiate = 1'b1;
		end

        ERASE_TAIL: begin
            plot = 1'b1;
            erase_tail = 1'b0;
			draw_rate_counter_enable = 1'b1;
			draw_rate_counter_reset_n = 1'b1;
        end

        WAIT: begin
            plot = 1'b0;
            draw_head = 1'b1;
            update_ram = 1'b1;
            erase_tail = 1'b0;
			draw_rate_counter_enable = 1'b0;
			draw_rate_counter_reset_n = 1'b0;
        end

		DRAW_HEAD: begin
            plot = 1'b1;
            draw_head = 1'b0;
			update_ram = 1'b0;
			draw_rate_counter_enable = 1'b1;
			draw_rate_counter_reset_n = 1'b1;
		end
			
		CHECK: begin
	    	plot = 1'b0;
		    initiate = 1'b0;
		    draw_head = 1'b0;
            update_ram = 1'b0;
            erase_tail = 1'b1;
			initiate_clock_reset_n = 1'b0;
			draw_rate_counter_enable = 1'b0;
			draw_rate_counter_reset_n = 1'b0;
		end	
            endcase
	end
		
	initial_state_rate_divider rd0(clock, initiate_clock_reset_n, 1'b1, connection1);
	draw_rate_divider rd1(clock, draw_rate_counter_reset_n, draw_rate_counter_enable, connection2); 

	always@(*) begin: state_table
		case(current_state)
			START: next_state = INITIATE;
			INITIATE: next_state = (connection1 == 3'd0) ? CHECK : INITIATE;
            ERASE_TAIL: next_state = (connection2 == 2'b00) ? WAIT : ERASE_TAIL;
            WAIT: next_state = (show == 1'b1) ? DRAW_HEAD : WAIT;
			DRAW_HEAD: next_state = (connection2 == 2'b00) ? CHECK : DRAW_HEAD;
           	CHECK: next_state = (show == 1'b1) ? ERASE_TAIL : CHECK;
			default: next_state = START;
		endcase
	end	

	always @(posedge clock) begin
        if (!reset_n)
            current_state <= START;
        else
            current_state <= next_state;
        end

endmodule



module initial_state_rate_divider(clock, reset_n, enable, q);
	input clock;
	input reset_n;
	input enable;
	output reg [2:0] q;
	
	always @(posedge clock) begin
		if(!reset_n)
			q <= 3'd4;
		else if(enable ==1'b1) begin
		   if (q == 2'd0)
				q <= 3'd4;
			else
				q <= q - 3'd1;
		end
	end
endmodule


module draw_rate_divider(clock, reset_n, enable, q);
    input clock, reset_n, enable;
    output reg [1:0] q;

	always @(posedge clock) begin
		if(!reset_n)
			q <= 2'b10;
		else if (enable == 1'b1) begin
			if (q == 2'b00)
				q <= 2'b10;
			else
				q <= q - 2'b01;
		end
	end
endmodule


//module change_direction_clock(clock, reset_n, enable, q);
//	input clock, reset_n, enable;
//	output reg [1:0] q;
//	
//	always @(posedge clock) begin
//		if(!reset_n)
//			q <= 2'd2;
//		else if (enable == 1'b1) begin
//			if (q == 2'd0)
//				q <= 2'd2;
//			else
//				q <= q - 2'd1;
//		end
//	end
//endmodule

//module draw_head_rate_divider(clock, reset_n, enable, q);
//	input clock, reset_n, enable;
//	output reg [1:0] q;
//
//	always @(posedge clock) begin
//		if (!reset_n)
//			q <= 2'd3;
//		else if (enable == 1'b1) begin
//			if (q == 2'd0)
//				q <= 2'd3;
//			else
//				q <= q - 2'd1;
//		end
//	end
//endmodule


module ram_top(clock, enable, reset_n, key_input, direction, erase_tail, update_ram, show, x, y, current_state, next_state);
	input clock, reset_n, enable, erase_tail, update_ram;
    	input [3:0] key_input;
	reg [6:0] address, tail;
	reg [14:0] input_data, temp_data;
	reg wren;
    	output reg [3:0] direction;
    	output reg show;
    	output [7:0] x;
    	output [6:0] y;
		output reg [4:0] current_state, next_state;

    	wire [14:0] output_ram;

    	assign x = output_ram[14:7];
    	assign y = output_ram[6:0];

	ram100x7 r0(
        .address(address),
        .clock(clock),
        .data(input_data),
        .wren(wren),
        .q(output_ram)
    	);

	localparam
		INIT_HEAD = 5'd0,
		INIT_BODY_1 = 5'd1,
		INIT_BODY_2 = 5'd2,
		INIT_BODY_3 = 5'd3,
		INIT_TAIL = 5'd4,
		SHOW = 5'd5,
		SHOW_WAIT = 5'd6,
		WAIT = 5'd7,
       	READ_TAIL = 5'd8,
        DEC_ADDRESS_1 = 5'd9,
        TEMP_STORE = 5'd10,
        UPDATE_RAM = 5'd11,
        DEC_ADDRESS_2 = 5'd12,
		READ_HEAD = 5'd13,
        UPDATE_HEAD = 5'd14,
		WAIT_RAM = 5'd15;


	always @(posedge clock) begin
		if (!reset_n) begin
			address <= 7'd0;
			input_data <= 15'd0;
			wren <= 1'b0;
			show <= 1'b0;
			direction <= 4'b0001;
		end

		else begin
			case (current_state)
                INIT_HEAD: begin
                    address <= 7'd0;
                    input_data <= 15'b000110000010100; //Setting head at 24x20. 
               	    wren <= 1'b1;
		    	    direction <= 4'b0001;
                end

				INIT_BODY_1: begin
					address <= 7'd1;
					input_data <= 15'b000101110010100; //Setting body_1 at 23 x 20.
					wren <= 1'b1;
				end
	
				INIT_BODY_2: begin
					address <= 7'd2;
					input_data <= 15'b000101100010100; //Setting body_2 at 22 x20.
					wren <= 1'b1;
				end

				INIT_BODY_3: begin
					address <= 7'd3;
					input_data <= 15'b000101010010100; //setting body_3 at 21 x 20.
					wren <= 1'b1;
				end
	
				INIT_TAIL: begin
					address <= 7'd4;
					input_data <= 15'b000101000010100; //Setting tail at 20x20.
					wren <= 1'b1;
					tail <= 7'd4;
				end

        	    READ_TAIL: begin
        	        wren <= 1'b0;
					show <= 1'b0;
        	        address <= tail;
        	    end
	
        	    DEC_ADDRESS_1: begin
        	        address <= address - 7'd1;
					show <= 1'b0;
				end

        	    TEMP_STORE: begin
        	        temp_data <= output_ram;
				end

        	    UPDATE_RAM: begin
        	        address <= address + 7'd1;
					input_data <= temp_data;
        	        wren <= 1'b1;
        	    end

        	    DEC_ADDRESS_2: begin
        	        wren <= 1'b0;
        	        address <= address - 7'd2;
        	    end

				READ_HEAD: begin
					wren <= 1'b0;
				end

        	    UPDATE_HEAD: begin 
					address <= 7'd0;
        	        input_data <= temp_data + {7'd0, direction[0], 6'd0, direction[1]} - {7'd0, direction[3], 6'd0, direction[2]};   
        	        wren <= 1'b1;
        	    end
	
        	    WAIT: begin
					show <= 1'b0;
					if (direction == 4'b0001 || direction == 4'b1000) begin
						if (key_input == 4'b0010 || key_input == 4'b0100)
							direction <= key_input;
					end
					else if (direction == 4'b0100 || direction == 4'b0010) begin
						if (key_input == 4'b1000 || key_input == 4'b0001)
							direction <= key_input;
					end
        	    end

				SHOW: begin
					show <= 1'b1;
				end
		    endcase
	end
    end


	always @(*) begin
		case (current_state)
			INIT_HEAD: next_state = INIT_BODY_1;
	    	INIT_BODY_1: next_state = INIT_BODY_2;
			INIT_BODY_2: next_state = INIT_BODY_3;
			INIT_BODY_3: next_state = INIT_TAIL;
			INIT_TAIL : next_state = WAIT;
            WAIT: begin
          	    if (erase_tail)
					next_state = READ_TAIL;
          	    else if (update_ram)
                    next_state = DEC_ADDRESS_1;
				else
					next_state = WAIT;
            end
			SHOW: next_state = SHOW_WAIT;
			SHOW_WAIT: next_state = WAIT;
            READ_TAIL: next_state = SHOW;
            DEC_ADDRESS_1: next_state = WAIT_RAM;
			WAIT_RAM: begin
				if (address == 7'b1111111)
					next_state = UPDATE_HEAD;
			    else
					next_state = TEMP_STORE;
			end
            TEMP_STORE: next_state = UPDATE_RAM; 
            UPDATE_RAM: next_state = DEC_ADDRESS_2;
            DEC_ADDRESS_2: next_state = WAIT_RAM;
            UPDATE_HEAD: next_state = READ_HEAD;
			READ_HEAD: next_state = SHOW;
			default: next_state = INIT_HEAD;
		endcase
	end

	always @(posedge clock) begin
        if (!reset_n)
            current_state <= INIT_HEAD;
        else
            current_state <= next_state;
    end

endmodule


//module ram_wait_counter(clock, reset_n, enable, q);
//    input clock, reset_n, enable;
//    output reg q;
//
//	always @(posedge clock) begin
//		if(!reset_n)
//			q <= 1'b1;
//		else if (enable == 1'b1) begin
//			if (q == 1'b0)
//				q <= 1'b1;
//			else
//				q <= q - 1'b1;
//		end
//	end
//endmodule


module test(CLOCK_50, SW, KEY, direction, current_state, next_state, current_state_ram, next_state_ram, X, Y, colour);
	input CLOCK_50;
	input [9:0] SW;
	input [0:0] KEY;
	output [7:0] X;
	output [6:0] Y;
	output [2:0] colour;
	output [2:0] current_state, next_state;
	output [4:0] current_state_ram, next_state_ram;

	output [3:0] direction;
	wire plot;
	wire [7:0] connection_x;
	wire [6:0] connection_y;

	ram_top r0(
		.clock(CLOCK_50), 
		.enable(1'b1), 
		.reset_n(SW[9]), 
		.key_input(SW[3:0]), 
		.direction(direction),
		.erase_tail(erase_tail), 
		.update_ram(update_ram), 
		.show(show), 
		.x(connection_x), 
		.y(connection_y),
		.current_state(current_state_ram),
		.next_state(next_state_ram)
		);
	datapath d0(
		.clock(CLOCK_50), 
		.reset_n(SW[9]), 
		.ram_input_x(connection_x), 
		.ram_input_y(connection_y), 
		.start(start), 
		.initiate(initiate), 
		.draw_head(draw_head), 
		.erase_tail(erase_tail), 
		.plot(plot),
		.X(X), 
		.Y(Y), 
		.colour(colour)
		);
	control c0(
		.clock(CLOCK_50), 
		.reset_n(SW[9]), 
		.start(start), 
		.initiate(initiate), 
		.draw_head(draw_head), 
		.erase_tail(erase_tail), 
		.update_ram(update_ram), 
		.show(show), 
		.current_state(current_state), 
		.next_state(next_state), 
		.plot(plot)
		);

       
endmodule

