module DisplayCounter(SW, KEY, CLOCK_50, HEX0);
    input [1:0] KEY;
    input [9:0] SW;
    input CLOCK_50;
    output [6:0] HEX0;

    wire enable;
    wire [27:0] wire_1;
    wire [3:0] connection;

    RateDivider rd0(CLOCK_50, SW[1:0], SW[3], KEY[0], wire_1);
    assign enable = (wire_1 == 28'b0) ? 1 : 0; 
    Counter c0(SW[7:4], CLOCK_50, enable, ~KEY[1], KEY[0], connection);
    DEC H0(connection, HEX0);

endmodule


module Counter(d, clock, enable, par_load, reset_n, q);
    input clock, enable, reset_n, par_load;
    input [3:0] d;
    output reg [3:0] q;

    always @(posedge clock, negedge reset_n) begin
        if (reset_n == 1'b0)
            q <= 0;
        else if (par_load == 1'b1)
            q <= d;
        else if (enable == 1'b1) begin
            if (q == 4'b1111)
                q <= 0;
            else
                q <= q + 1'b1;
        end
    end

endmodule


module RateDivider(clock, select, enable, reset_n, q);
    input clock, reset_n, enable;
    input [1:0] select;
    output reg [27:0] q;
    
    reg [27:0] load;

    always @(*) begin
        case(select)
            //2'b00: load = 28'b0; 
            2'b00: load = 28'b0000000000000000000000000011;
            2'b01: load = 28'b0010111110101111000001111111;
            2'b10: load = 28'b0101111101011110000011111111;
            2'b11: load = 28'b1011111010111100000111111111;
        endcase
    end

    always @(posedge clock) begin
        if (reset_n == 1'b0)
            q <= load;
        else if (enable == 1'b1) begin
            if (q == 0)
                q <= load;
            else
                q <= q - 1'b1;
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
