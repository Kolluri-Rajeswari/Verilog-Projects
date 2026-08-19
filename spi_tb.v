`timescale 1ns / 1ps

module spi_tb;

    reg clk;
    reg rst;
    reg start;

    reg [7:0] master_tx;
    reg [7:0] slave_tx;

    wire [7:0] master_rx;
    wire [7:0] slave_rx;

    wire mosi;
    wire miso;
    wire sclk;
    wire cs;

    wire master_done;
    wire slave_done;


    //==================================================
    // SPI MASTER
    //==================================================

    spi_master #(
        .CLK_DIV(4)
    ) master (
        .clk      (clk),
        .rst      (rst),
        .start    (start),
        .tx_data  (master_tx),
        .miso     (miso),

        .rx_data  (master_rx),
        .mosi     (mosi),
        .sclk     (sclk),
        .cs       (cs),
        .done     (master_done)
    );


    //==================================================
    // SPI SLAVE
    //==================================================

    spi_slave slave (
        .rst      (rst),
        .cs       (cs),
        .sclk     (sclk),
        .mosi     (mosi),

        .tx_data  (slave_tx),

        .miso     (miso),
        .rx_data  (slave_rx),
        .done     (slave_done)
    );


    //==================================================
    // CLOCK
    //==================================================

    always #5 clk = ~clk;


    //==================================================
    // TEST
    //==================================================

    initial begin

        clk = 0;
        rst = 1;
        start = 0;

        master_tx = 8'b1010_1100;
        slave_tx  = 8'b0101_0011;


        // Reset
        #20;
        rst = 0;


        // Start SPI communication
        #20;
        start = 1;

        #10;
        start = 0;


        // Wait for transmission
        wait(master_done);


        #20;


        // Display results
        $display("-----------------------------------");
        $display("SPI TRANSMISSION COMPLETE");
        $display("-----------------------------------");

        $display("Master TX = %b", master_tx);
        $display("Slave  RX = %b", slave_rx);

        $display("Slave  TX = %b", slave_tx);
        $display("Master RX = %b", master_rx);

        $display("-----------------------------------");


        // Check Master TX -> Slave RX
        if (slave_rx == master_tx)
            $display("MASTER -> SLAVE : PASS");
        else
            $display("MASTER -> SLAVE : FAIL");


        // Check Slave TX -> Master RX
        if (master_rx == slave_tx)
            $display("SLAVE -> MASTER : PASS");
        else
            $display("SLAVE -> MASTER : FAIL");


        $display("-----------------------------------");

        #50;

        $finish;

    end

endmodule