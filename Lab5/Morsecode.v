module Morsecode(CLOCK_50, SW, KEY, LEDR);
	input CLOCK_50;
	input [2:0] SW;
	input [1:0] KEY;
	output [0:0] LEDR;


	wire [24:0] in_wire;
	wire [13:0] bit_pattern;
	wire shift;

	reg enable;

	always @(negedge KEY[1]) begin
		if (KEY[1] == 0) 
			enable <= 1'b1;
	end

	
//	always @(negedge KEY[1], negedge KEY[0]) begin
//		if (KEY[0] == 0) 
//			enable <= 1'b0;
//		else if (KEY[1] == 0)
//			enable <= 1'b1;
//	end

	

	LUT lut(SW[2:0], bit_pattern);
	//RateDivider rd0(CLOCK_50, enable, KEY[0], 25'b1011111010111100000111111, in_wire);
	RateDivider rd_test(CLOCK_50, enable, KEY[0], 25'b0000000000000000000000000011, in_wire);
	
	assign shift = (in_wire == 25'b0) ? 1 : 0;
	
	ShiftRegister s0(bit_pattern, shift, enable, KEY[0], CLOCK_50, LEDR[0]);	
	
	
endmodule


module RateDivider(clock, enable, reset_n, load, Q);
	input clock, enable, reset_n;
	input [24:0] load;
	output reg [24:0] Q;

	always @(posedge clock, negedge reset_n) begin
		if (reset_n == 1'b0)
			Q <= 1'b0;
		else if (enable == 1'b1) begin
			if (Q == 28'b0000000000000000000000000000)
				Q <= load;
			else
				Q <= Q - 1'b1;
		end
	end

endmodule


module LUT(key, out);
	input [2:0] key;
	output reg [13:0] out;
	
	always @(*) begin
		case(key)
			3'b000: out = 14'b10101000000000; //S
			3'b001: out = 14'b11100000000000; //T
			3'b010: out = 14'b10101110000000; //U
			3'b011: out = 14'b10101011100000; //V
			3'b100: out = 14'b10111011100000; //W
			3'b101: out = 14'b11101010111000; //X
			3'b110: out = 14'b11101011101110; //Y
			3'b111: out = 14'b11101110101000; //Z
			default: out = 0;
		endcase
	end

endmodule


module ShiftRegister(letter, shift, enable, reset_n, clock, out);
	input [13:0] letter;
	input shift, enable, reset_n, clock;
	output reg out;

	reg [13:0] Q;

	always @(posedge clock, negedge reset_n) begin
		if (reset_n == 1'b0) begin
			out <= 1'b0;
			Q <= letter; 
		end	
		else if (shift == 1'b1 && enable == 1'b1) begin
			out <= Q[0];
			Q <= Q >> 1'b1;
		end
	end

endmodule

