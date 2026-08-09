`timescale 1ns / 1ps

module SPI_slave_tb();
    parameter RX_SIZE = 10;
    parameter TX_SIZE = 8;

    reg clk, rst, MOSI, SS_n, tx_valid, read_addr_received;
    reg [TX_SIZE-1:0] tx_data;
    wire MISO;
    wire [RX_SIZE-1:0] rx_data;
    wire rx_valid;

// initial block
    integer i;
    reg [9:0] payload;

    // SPI Slave Instantiation
    SPI_slave #(
        .RX_SIZE(RX_SIZE),
        .TX_SIZE(TX_SIZE)
    ) uut (
        .clk(clk),
        .rst(rst),
        .MOSI(MOSI),
        .SS_n(SS_n),
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .read_addr_received(read_addr_received),
        .MISO(MISO),
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

    // Clock Generation (Period = 10ns)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 0;
        MOSI = 0;
        SS_n = 1;
        tx_data = 8'b0;
        tx_valid = 0;
        read_addr_received = 0;

        // Synchronous Reset
        #20;
        rst = 1;
        #10;

        // 1. Test WRITE Frame (Ctrl: 0, Payload: 10'b00_0000_1010)
        $display("--- Sending WRITE Frame ---");
        payload = 10'b00_0000_1010;
        
        @(negedge clk);
        SS_n = 0;
        MOSI = 0; // Control Bit for CHK_CMD (0 = Write)

        @(negedge clk); // Allow transition

        // Send 10 Payload Bits
        for (i = 9; i >= 0; i = i - 1) begin
            MOSI = payload[i];
            @(negedge clk);
        end

        // Check if data is received correctly
        if (rx_valid && rx_data == payload) begin
            $display("[SPI_TB PASS] WRITE Frame received correctly: 10'b%b", rx_data);
        end else begin
            $display("[SPI_TB FAIL] WRITE Frame Failed! Expected: 10'b%b, Got: 10'b%b", payload, rx_data);
        end

        // End Transaction
        SS_n = 1;
        MOSI = 0;
        @(negedge clk);
        #20;

        // 2. Test READ_ADD Frame (Ctrl: 1, Payload: 10'b10_0000_0101)
        $display("--- Sending READ_ADD Frame ---");
        payload = 10'b10_0000_0101;
        
        @(negedge clk);
        SS_n = 0;
        MOSI = 1; // Control Bit for CHK_CMD (1 = Read)

        @(negedge clk); // Allow transition

        // Send 10 Payload Bits
        for (i = 9; i >= 0; i = i - 1) begin
            MOSI = payload[i];
            @(negedge clk);
        end

        // Check if data is received correctly
        if (rx_valid && rx_data == payload) begin
            $display("[SPI_TB PASS] READ_ADD Frame received correctly: 10'b%b", rx_data);
        end else begin
            $display("[SPI_TB FAIL] READ_ADD Frame Failed! Expected: 10'b%b, Got: 10'b%b", payload, rx_data);
        end

        // End Transaction
        SS_n = 1;
        MOSI = 0;
        @(negedge clk);
        #20;

        // 3. Test READ_DATA Frame & MISO Shifting (Ctrl: 1, Payload: 10'b11_0000_0000)
        $display("--- Sending READ_DATA Frame & Checking MISO ---");
        
        read_addr_received = 1; // Simulate RAM setting read_addr_received
        payload = 10'b11_0000_0000;
        
        @(negedge clk);
        SS_n = 0;
        MOSI = 1; // Control Bit for CHK_CMD (1 = Read)

        @(negedge clk); // Allow transition

        // Send 10 Payload Bits
        for (i = 9; i >= 0; i = i - 1) begin
            MOSI = payload[i];
            @(negedge clk);
        end

        if (rx_valid && rx_data == payload) begin
            $display("[SPI_TB PASS] READ_DATA Command received correctly.");
        end else begin
            $display("[SPI_TB FAIL] READ_DATA Command Failed!");
        end

        // Simulate RAM providing the requested data to be shifted out
        tx_data = 8'hC3; // Data to be read (11000011)
        tx_valid = 1;
        @(negedge clk);
        tx_valid = 0;

        // Keep SS_n low and check MISO bit shifting over 8 clock cycles
        $display("Reading 8 bits from MISO:");
        for (i = 7; i >= 0; i = i - 1) begin
            @(negedge clk);
            $display("MISO Bit[%0d] = %b", i, MISO);
        end

        // End Transaction
        SS_n = 1;
        read_addr_received = 0;
        #50;

        $display("Simulation Completed Successfully.");
        $stop;
    end

endmodule