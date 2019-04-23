module mux7to1_demo(LEDR, SW);
    output [9:0] LEDR;
    input [9:0] SW;

    mux7to1 m1(
        .Out(LEDR[0]),
        .Input(SW[6:0]),
        .MuxSelect(SW[9:7])
        );
        
endmodule

module mux7to1(Out, Input, MuxSelect);
    output Out;
    input [6:0] Input;
    input [2:0] MuxSelect;

    reg Out;
    always @(*) begin
        case (MuxSelect[2:0])
            3'b000: Out = Input[0];
            3'b001: Out = Input[1];
            3'b010: Out = Input[2];
            3'b011: Out = Input[3];
            3'b100: Out = Input[4];
            3'b101: Out = Input[5];
            3'b110: Out = Input[6];
            default: Out = 1'b0;
        endcase
    end

endmodule
