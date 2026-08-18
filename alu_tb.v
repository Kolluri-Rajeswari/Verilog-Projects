`timescale 1ns / 1ps

module alu_tb;

    reg [3:0] a;
    reg [3:0] b;
    reg [2:0] sel;

    wire [3:0] res;

    alu uut (
        .a(a),
        .b(b),
        .sel(sel),
        .res(res)
    );

    initial begin

        a = 4'b1010;
        b = 4'b0011;
        sel = 3'b000;
        #10;

        sel = 3'b001;
        #10;

        sel = 3'b010;
        #10;

        sel = 3'b011;
        #10;

        sel = 3'b100;
        #10;

        sel = 3'b101;
        #10;

        sel = 3'b110;
        #10;

        sel = 3'b111;
        #10;

        $finish;
    end

endmodule