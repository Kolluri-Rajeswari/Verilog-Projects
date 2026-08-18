`timescale 1ns / 1ps

module alu(input [3:0]a,input [3:0]b,input [2:0]sel,output reg [3:0]res);
always@(*)
begin 
case(sel)
3'b000: res = a + b;   
        3'b001: res = a - b;   
        3'b010: res = a & b;   
        3'b011: res = a | b;   
        3'b100: res = a ^ b;   
        3'b101: res = ~a;      
        3'b110: res = a << 1;  
        3'b111: res = a >> 1;  

        default: res = 4'b0000;

    endcase
end
endmodule
