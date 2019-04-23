module mux4to1_final(SW, LEDR);
    input [9:0] SW;
    output [9:0] LEDR;

    mux4to1 m0(
	.u(SW[0]), 
	.v(SW[1]), 
	.w(SW[2]), 
	.x(SW[3]), 
	.s(SW[9:8]), 
	.m(LEDR[0])
	);

endmodule

module mux4to1(u, v, w, x, s, m);
    input u,v,w,x;
    input [1:0] s;
    output m;

    wire wire_1, wire_2;

    mux2to1 u0(
	.x(wire_1),
	.y(wire_2),
	.s(s[1]),
	.m(m)
	);

    mux2to1 u1(
    .x(u),
    .y(v),
	.s(s[0]),
	.m(wire_1)
	);

    mux2to1 u2(
	.x(w),
	.y(x),
	.s(s[0]),
	.m(wire_2)
	);
    
endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;

endmodule
