module spi_slave (
    input  wire       rst,
    input  wire       cs,
    input  wire       sclk,
    input  wire       mosi,

    input  wire [7:0] tx_data,

    output reg        miso,
    output reg [7:0]  rx_data,
    output reg        done
);

    reg [7:0] tx_shift;
    reg [7:0] rx_shift;

    reg [2:0] bit_count;

    // Detect CS going LOW
    always @(negedge cs or posedge rst) begin

        if (rst) begin

            tx_shift  <= 8'b0;
            rx_shift  <= 8'b0;
            rx_data   <= 8'b0;

            bit_count <= 3'b0;

            miso      <= 1'b0;
            done      <= 1'b0;

        end

        else begin

            // Load slave transmit data
            tx_shift <= tx_data;

            // First MSB must be ready before
            // master's first rising SCLK edge
            miso <= tx_data[7];

            rx_shift <= 8'b0;

            bit_count <= 3'b0;

            done <= 1'b0;
        end
    end


    // Receive data on rising edge
    always @(posedge sclk or posedge rst) begin

        if (rst) begin

            rx_shift  <= 8'b0;
            rx_data   <= 8'b0;

            bit_count <= 3'b0;
            done      <= 1'b0;

        end

        else if (!cs) begin

            rx_shift <= {rx_shift[6:0], mosi};

            if (bit_count == 3'd7) begin

                rx_data <= {rx_shift[6:0], mosi};

                done <= 1'b1;

            end

            else begin

                bit_count <= bit_count + 1'b1;

            end
        end
    end


    // Change MISO on falling edge
    always @(negedge sclk or posedge rst) begin

        if (rst) begin

            tx_shift <= 8'b0;
            miso     <= 1'b0;

        end

        else if (!cs) begin

            if (bit_count < 3'd7) begin

                tx_shift <= {tx_shift[6:0], 1'b0};

                miso <= tx_shift[6];

            end
        end

        else begin

            miso <= 1'b0;

        end
    end

endmodule