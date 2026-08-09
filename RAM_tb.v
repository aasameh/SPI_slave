`timescale 1ns / 1ps

module RAM_tb();
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;
    
    reg clk, rst, rx_valid;
    reg [9:0] din;
    wire tx_valid, read_addr_received;
    wire [7:0] dout;

    // RAM Module Instantiation
    RAM #(
        .MEM_DEPTH(MEM_DEPTH),
        .ADDR_SIZE(ADDR_SIZE)
    ) uut (
        .clk(clk),
        .rst(rst),
        .rx_valid(rx_valid),
        .din(din),
        .tx_valid(tx_valid),
        .dout(dout),
        .read_addr_received(read_addr_received)
    );

    // Clock Generation (Period = 10ns)
    always #5 clk = ~clk;

    initial begin
        // 1. Initial State Setup
        clk = 0;
        rst = 0;
        rx_valid = 0;
        din = 10'b0;

        // 2. Synchronous Reset
        #20;
        rst = 1;
        #10;

        // 3. Write Address Command (2'b00 + Addr: 0x05)
        @(negedge clk);
        din = {2'b00, 8'h05};
        rx_valid = 1;
        @(negedge clk);
        rx_valid = 0;

        // 4. Write Data Command (2'b01 + Data: 0xA5)
        @(negedge clk);
        din = {2'b01, 8'hA5};
        rx_valid = 1;
        @(negedge clk);
        rx_valid = 0;

        // 5. Read Address Command (2'b10 + Addr: 0x05)
        @(negedge clk);
        din = {2'b10, 8'h05};
        rx_valid = 1;
        @(negedge clk);
        rx_valid = 0;

        // Verify read_addr_received flag
        #1;
        if (read_addr_received === 1'b1)
            $display("[RAM_TB PASS] read_addr_received asserted successfully.");
        else
            $display("[RAM_TB FAIL] read_addr_received was not asserted!");

        // 6. Read Data Command (2'b11)
        @(negedge clk);
        din = {2'b11, 8'h00};
        rx_valid = 1;
        @(negedge clk);
        rx_valid = 0;

        // Verify Read Data and tx_valid output
        #1;
        if (tx_valid === 1'b1 && dout === 8'hA5)
            $display("[RAM_TB PASS] Read Data Success! Expected: 0xA5, Got: 0x%h", dout);
        else
            $display("[RAM_TB FAIL] Read Data Failed! Expected: 0xA5, Got: 0x%h (tx_valid = %b)", dout, tx_valid);

        #100;
        $stop;
    end

endmodule