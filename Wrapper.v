module SPI_Wrapper (
    input clk,
    input rst,
    input MOSI,
    input SS_n,
    output MISO
);

wire [9:0] rx_data;
wire rx_valid;

wire [7:0] tx_data;
wire tx_valid;

wire read_addr_received;


SPI_slave #(
    .RX_SIZE(10),
    .TX_SIZE(8)
) SPI (
    .clk(clk),
    .rst(rst),
    .MOSI(MOSI),
    .MISO(MISO),
    .SS_n(SS_n),
    .rx_data(rx_data),
    .tx_data(tx_data),
    .rx_valid(rx_valid),
    .tx_valid(tx_valid),
    .read_addr_received(read_addr_received)
);


RAM #(
    .MEM_DEPTH(256),
    .ADDR_SIZE(8)
) RAM (
    .clk(clk),
    .rst(rst),
    .din(rx_data),
    .rx_valid(rx_valid),
    .dout(tx_data),
    .tx_valid(tx_valid),
    .read_addr_received(read_addr_received)
);

endmodule