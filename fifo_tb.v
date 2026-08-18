`timescale 1ns / 1ps

module fifo_tb;

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [7:0] din;

    wire [7:0] dout;
    wire full;
    wire empty;

    synchronous_fifo uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;

        // Reset
        #10;
        rst = 0;

        // Write 10
        wr_en = 1;
        din = 8'd10;
        #10;

        // Write 20
        din = 8'd20;
        #10;

        // Write 30
        din = 8'd30;
        #10;

        // Stop writing
        wr_en = 0;

        // Read
        rd_en = 1;
        #10;

        #10;

        #10;

        // Stop reading
        rd_en = 0;

        #10;

        $finish;

    end

endmodule