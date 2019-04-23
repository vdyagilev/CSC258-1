module fbrca_demo(LEDR, SW);
    output [9:0] LEDR;
    input [9:0] SW;

    fbrca m0(
        .S(LEDR[3:0]),
        .cout(LEDR[4]),
        .A(SW[7:4]),
        .B(SW[3:0]),
        .cin(SW[8])
    );

endmodule

module fbrca(S, cout, A, B, cin);
    output [3:0] S;
    output cout;
    input [3:0] A;
    input [3:0] B;
    input cin;
    wire c1, c2, c3;

    full_adder u0(
        .sum(S[0]),
        .cout(c1),
        .a(A[0]),
        .b(B[0]),
        .cin(cin)
    );

    full_adder u1(
        .sum(S[1]),
        .cout(c2),
        .a(A[1]),
        .b(B[1]),
        .cin(c1)
    );

    full_adder u2(
        .sum(S[2]),
        .cout(c3),
        .a(A[2]),
        .b(B[2]),
        .cin(c2)
    );

    full_adder u3(
        .sum(S[3]),
        .cout(cout),
        .a(A[3]),
        .b(B[3]),
        .cin(c3)
    );

endmodule

module full_adder(sum, cout, a, b, cin);
    output sum, cout;
    input a, b, cin;

    assign sum = a^b^cin;
    assign cout = (a&b)|(cin&(a^b));
endmodule
    
