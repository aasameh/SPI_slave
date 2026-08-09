`timescale 1ns / 1ps

module SPI_Wrapper_tb();
reg clk ,rst ,MOSI ,SS_n;
wire MISO;
reg [7:0] received_miso_data;
integer i;

SPI_Wrapper SPI_Wrapper_tb (.clk(clk),.rst(rst),.MOSI(MOSI),.SS_n(SS_n),.MISO(MISO));

always #5 clk = ~clk;

task send_spi_frame(input [9:0] frame_data);
integer k;
begin
SS_n = 0;
#10;

MOSI = frame_data[9];
#10;

for (k = 8; k >= 0; k = k - 1)
MOSI = frame_data[k];
#10;
SS_n = 1;
#30;
end
endtask;
initial begin
clk = 0;
rst = 0;
MOSI = 0;
SS_n = 1;
received_miso_data = 8'b0;
#20;
rst = 1;
#20;
$display("---- STEP 1: Writing Address 0x0A ----");
send_spi_frame(10'b00_0000_1010);

$display("---- STEP 2: Writing Data 0x3C to Address 0x0A ----");
send_spi_frame(10'b01_0011_1100);

$display("---- STEP 3: Setting Read Address to 0x0A ----");
send_spi_frame(10'b10_0000_1010);

$display("---- STEP 4: Reading Data from RAM on MISO ----");
SS_n = 0;
#10;

MOSI = 1; #10;
MOSI = 1; #10;
MOSI = 1; #10;

for (i = 7; i >= 0; i = i - 1) begin
MOSI = 0;
#10;
received_miso_data[i] = MISO;
end

SS_n = 1;
#30;

$display("==========================================");
$display("WRAPPER TEST COMPLETE");
$display("Transmitted Data Written : 0x3C");
$display("Received Data from MISO  : 0x%h", received_miso_data);
$display("==========================================");

#50;
$stop;
end

endmodule