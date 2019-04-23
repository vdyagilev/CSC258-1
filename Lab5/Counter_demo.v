module Counter_demo(SW, KEY, HEX0, HEX1);
    input [1:0] SW;
    input [0:0] KEY;
    output [6:0] HEX0, HEX1;

    wire [7:0] wires;

    Counter c0(wires, KEY[0], SW[0], SW[1]);

    DEC H0(wires[3:0], HEX0);
    DEC H1(wires[7:4], HEX1);

endmodule

module Counter(Q, Clock, Clear_b, Enable);
    input Clock, Clear_b, Enable;
    output [7:0] Q;

    wire [6:0] wires;

    My_TFF t0(Q[0], Enable, Clock, Clear_b);
    and(wires[0], Enable, Q[0]);
    My_TFF t1(Q[1], wires[0], Clock, Clear_b);
    and(wires[1], wires[0], Q[1]);
    My_TFF t2(Q[2], wires[1], Clock, Clear_b);
    and(wires[2], wires[1], Q[2]);
    My_TFF t3(Q[3], wires[2], Clock, Clear_b);
    and(wires[3], wires[2], Q[3]);
    My_TFF t4(Q[4], wires[3], Clock, Clear_b);
    and(wires[4], wires[3], Q[4]);
    My_TFF t5(Q[5], , Clock, Clear_b);
    and(wires[5], wires[4], Q[5]);
    My_TFF t6(Q[6], wires[5], Clock, Clear_b);
    and(wires[6], wires[5], Q[6]);
    My_TFF t7(Q[7], wires[6], Clock, Clear_b);

endmodule

module My_TFF(Q, T, clk, reset_n);
    input T, clk, reset_n;
    output reg Q;

    always @(posedge clk, negedge reset_n) begin
        if (reset_n == 1'b0)
            Q <= 1'b0;
        else begin
            if (T == 1'b1)
                Q <= ~Q;
            else
                Q <= Q;
        end
    end

endmodule

module DEC(SW, HEX0);
    input [3:0] SW;
    output [6:0] HEX0;

    assign HEX0[0] = (~SW[3]&~SW[2]&~SW[1]&SW[0]) | (~SW[3]&SW[2]&~SW[1]&~SW[0]) | (SW[3]&SW[2]&~SW[1]&SW[0]) | (SW[3]&~SW[2]&SW[1]&SW[0]);
    assign HEX0[1] = (~SW[3]&SW[2]&~SW[1]&SW[0]) | (SW[2]&SW[1]&~SW[0]) | (SW[3]&SW[2]&~SW[0]) | (SW[3]&SW[1]&SW[0]);
    assign HEX0[2] = (~SW[3]&~SW[2]&SW[1]&~SW[0]) | (SW[3]&SW[2]&~SW[0]) | (SW[3]&SW[2]&SW[1]);
    assign HEX0[3] = (~SW[3]&SW[2]&~SW[1]&~SW[0]) | (SW[3]&~SW[2]&SW[1]&~SW[0]) | (~SW[2]&~SW[1]&SW[0]) | (SW[2]&SW[1]&SW[0]);
    assign HEX0[4] = (~SW[3]&SW[2]&~SW[1]) | (~SW[2]&~SW[1]&SW[0]) | (~SW[3]&SW[0]);
    assign HEX0[5] = (SW[3]&SW[2]&~SW[1]&SW[0]) | (~SW[3]&~SW[2]&SW[0]) | (~SW[3]&~SW[2]&SW[1]) | (~SW[3]&SW[1]&SW[0]);
    assign HEX0[6] = (~SW[3]&~SW[2]&~SW[1]) | (~SW[3]&SW[2]&SW[1]&SW[0]) | (SW[3]&SW[2]&~SW[1]&~SW[0]);

endmodule  