`timescale 1ns / 1ps

module SPI_Wrapper_tb();

    reg clk;
    reg rst;
    reg MOSI;
    reg SS_n;
    wire MISO;

    integer i;
    reg [9:0] payload;
    reg [7:0] rx_data_out;

    // Instantiation of SPI_Wrapper
    SPI_Wrapper uut (
        .clk(clk),
        .rst(rst),
        .MOSI(MOSI),
        .SS_n(SS_n),
        .MISO(MISO)
    );

    // Clock Generation (Period = 10ns)
    always #5 clk = ~clk;

    // Task to send 10-bit payload frame
    task send_frame;
        input [9:0] frame_payload;
        integer k;
        begin
            @(negedge clk);
            SS_n = 0;
            for (k = 9; k >= 0; k = k - 1) begin
                MOSI = frame_payload[k];
                @(negedge clk);
            end
            SS_n = 1;
            MOSI = 0;
            #30;
        end
    endtask

    initial begin
        // 0. System Initialization
        clk = 0;
        MOSI = 0;
        SS_n = 1;
        rx_data_out = 8'b0;

        // Reset Sequence
        rst = 0;
        #20;
        rst = 1;
        #10;

        // 1. Write Address (Address: 0x05)
        $display("--- 1. Writing Address (0x05) ---");
        send_frame(10'b00_0000_0101);

        // 2. Write Data (Data: 0xA5 at Address 0x05)
        $display("--- 2. Writing Data (0xA5) ---");
        send_frame(10'b01_1010_0101);

        // 3. Read Address (Address: 0x05)
        $display("--- 3. Setting Read Address (0x05) ---");
        send_frame(10'b10_0000_0101);

        // 4. Read Data Command & Sampling MISO
        $display("--- 4. Requesting Read Data & Checking MISO ---");
        payload = 10'b11_0000_0000;
        
        @(negedge clk);
        SS_n = 0;
        for (i = 9; i >= 0; i = i - 1) begin
            MOSI = payload[i];
            @(negedge clk);
        end

        // Wait 1 clock cycle for RAM output logic
        @(negedge clk);

        // Read 8 bits shifted out on MISO line
        $display("Reading MISO output stream:");
        for (i = 7; i >= 0; i = i - 1) begin
            rx_data_out[i] = MISO;
            $display("MISO Bit[%0d] = %b", i, MISO);
            @(negedge clk);
        end

        SS_n = 1;

        // Verification
        if (rx_data_out === 8'hA5) begin
            $display("[WRAPPER_TB PASS] Success! Data read from RAM matches: 0x%h", rx_data_out);
        end else begin
            $display("[WRAPPER_TB FAIL] Output mismatch! Expected: 0xA5, Got: 0x%h", rx_data_out);
        end

        #50;
        $display("Simulation Completed.");
        $stop;
    end

endmodule