module Shifter_demo(SW, KEY, LEDR);
	input [9:0] SW;
	input [3:0] KEY;
	output [7:0] LEDR;

	Shifter s0(
		.Q(LEDR[7:0]),
		.LoadVal(SW[7:0]),
		.Load_n(KEY[1]),
		.ShiftRight(KEY[2]),
		.ASR(KEY[3]),
		.clk(KEY[0]),
		.reset_n(SW[9])
	);

endmodule


module Shifter(Q, LoadVal, Load_n, ShiftRight, ASR, clk, reset_n);
	input [7:0] LoadVal;
	input Load_n, ShiftRight, ASR, clk, reset_n;
	output [7:0] Q;

	wire connect; 

	mux2to1 m0(
		.x(ASR),
		.y(Q[7]),
		.s(ASR),
		.m(connect)
	);

	ShifterBit s7(
		.out(Q[7]),
		.in(connect),
		.load_val(LoadVal[7]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);

	ShifterBit s6(
		.out(Q[6]),
		.in(Q[7]),
		.load_val(LoadVal[6]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);

	ShifterBit s5(
		.out(Q[5]),
		.in(Q[6]),
		.load_val(LoadVal[5]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);

	ShifterBit s4(
		.out(Q[4]),
		.in(Q[5]),
		.load_val(LoadVal[4]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);

	ShifterBit s3(
		.out(Q[3]),
		.in(Q[4]),
		.load_val(LoadVal[3]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);

	ShifterBit s2(
		.out(Q[2]),
		.in(Q[3]),
		.load_val(LoadVal[2]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);

	ShifterBit s1(
		.out(Q[1]),
		.in(Q[2]),
		.load_val(LoadVal[1]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);

	ShifterBit s0(
		.out(Q[0]),
		.in(Q[1]),
		.load_val(LoadVal[0]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);

endmodule 


module ShifterBit(out, in, shift, load_val, load_n, clk, reset_n);
	input in, shift, load_val, load_n, clk, reset_n;
	output out;
	wire mux_mux, mux_flipflop;
	
	mux2to1 m0(
		.x(out),
		.y(in),
		.s(shift),
		.m(mux_mux)
	);

	mux2to1 m1(
		.x(load_val),
		.y(mux_mux),
		.s(load_n),
		.m(mux_flipflop)
	);

	DFlipFlop f0(
		.D(mux_flipflop),
		.reset_n(reset_n),
		.clk(clk),
		.Q(out)
		);

endmodule 


module mux2to1(x, y, s, m);
	input x, y, s;
	output m;
	
	assign m = x & ~s | y & s;

endmodule


module DFlipFlop(D, reset_n, clk, Q);
	input D, reset_n, clk;
	output Q;
	reg Q;
	
	always @(posedge clk)
	begin
		if(reset_n == 1'b0)
			Q <= 0;
		else 
			Q <= D;
	end

endmodule


