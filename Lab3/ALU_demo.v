module ALU_demo(LEDR, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input [7:0] SW;
    input [2:0] KEY;
    output [7:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    wire [7:0] ALUout;

    assign LEDR = ALUout;

    ALU m0(
        .ALUout(ALUout),
        .A(SW[7:4]),
        .B(SW[3:0]),
        .select(KEY)
    );

    HEX_decoder H0(
        .SW(SW[3:0]),
        .HEX(HEX0)
    );

    HEX_decoder H1(
        .SW(4'b0000),
        .HEX(HEX1)
    );

    HEX_decoder H2(
        .SW(SW[7:4]),
        .HEX(HEX2)
    );

    HEX_decoder H3(
        .SW(4'b0000),
        .HEX(HEX3)
    );

    HEX_decoder H4(
        .SW(ALUout[3:0]),
        .HEX(HEX4)
    );

    HEX_decoder H5(
        .SW(ALUout[7:4]),
        .HEX(HEX5)
    );

endmodule

module ALU(ALUout, A, B, select);
    output reg [7:0] ALUout;
    input [3:0] A, B;
    input [2:0] select;
    wire [3:0] f1_out, f2_out;
    wire f1_carry, f2_carry;

    always @(*) begin
        case (select[2:0])
            3'b000: ALUout = {f1_carry, f1_out};
            3'b001: ALUout = {f2_carry, f2_out};
            3'b010: ALUout = A + B;
            3'b011: ALUout = {A|B, A^B};
            3'b100: ALUout = {|({A,B})};
            3'b101: ALUout = {A, B};
            default ALUout = 8'b00000000;
        endcase
    end

    fbrca a1(
        .S(f1_out),
        .cout(f1_carry),
        .A(A),
        .B(4'b0001),
        .cin(1'b0)
    );

    fbrca a2(
        .S(f2_out),
        .cout(f2_carry),
        .A(A),
        .B(B),
        .cin(1'b0)
    );

endmodule

module HEX_decoder(SW, HEX);
    input [3:0] SW;
    output [6:0] HEX;

    assign HEX[0] = (~SW[3]&~SW[2]&~SW[1]&SW[0]) | (~SW[3]&SW[2]&~SW[1]&~SW[0]) | (SW[3]&SW[2]&~SW[1]&SW[0]) | (SW[3]&~SW[2]&SW[1]&SW[0]);
    assign HEX[1] = (~SW[3]&SW[2]&~SW[1]&SW[0]) | (SW[2]&SW[1]&~SW[0]) | (SW[3]&SW[2]&~SW[0]) | (SW[3]&SW[1]&SW[0]);
    assign HEX[2] = (~SW[3]&~SW[2]&SW[1]&~SW[0]) | (SW[3]&SW[2]&~SW[0]) | (SW[3]&SW[2]&SW[1]);
    assign HEX[3] = (~SW[3]&SW[2]&~SW[1]&~SW[0]) | (SW[3]&~SW[2]&SW[1]&~SW[0]) | (~SW[2]&~SW[1]&SW[0]) | (SW[2]&SW[1]&SW[0]);
    assign HEX[4] = (~SW[3]&SW[2]&~SW[1]) | (~SW[2]&~SW[1]&SW[0]) | (~SW[3]&SW[0]);
    assign HEX[5] = (SW[3]&SW[2]&~SW[1]&SW[0]) | (~SW[3]&~SW[2]&SW[0]) | (~SW[3]&~SW[2]&SW[1]) | (~SW[3]&SW[1]&SW[0]);
    assign HEX[6] = (~SW[3]&~SW[2]&~SW[1]) | (~SW[3]&SW[2]&SW[1]&SW[0]) | (SW[3]&SW[2]&~SW[1]&~SW[0]);

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
    
