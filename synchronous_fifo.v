`timescale 1ns / 1ps

module synchronous_fifo(
    input        clk,
    input        rst,
    input        wr_en,
    input        rd_en,
    input  [7:0] din,
    output reg [7:0] dout,
    output reg       full,
    output reg       empty
);

    reg [7:0] mem [0:7];
    reg [3:0] wr_ptr;
    reg [3:0] rd_ptr;
    reg [3:0] count;

    always @(posedge clk) begin

        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
            dout   <= 0;
        end

        else begin

            // Write operation
            if (wr_en && !full) begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
            end

            // Read operation
            if (rd_en && !empty) begin
                dout <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
            end

            // Count update
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1;
                2'b01: count <= count - 1;
                default: count <= count;
            endcase

        end
    end

    always @(*) begin
        empty = (count == 0);
        full  = (count == 8);
    end

endmodule