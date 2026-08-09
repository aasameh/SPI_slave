vlib work
vlog RAM.v SPI_slave.v Wrapper.v Wrapper_tb.v
vsim -voptargs="+acc" work.SPI_Wrapper_tb

add wave -divider {External Signals}
add wave -hex /SPI_Wrapper_tb/clk
add wave -hex /SPI_Wrapper_tb/rst
add wave -hex /SPI_Wrapper_tb/SS_n
add wave -hex /SPI_Wrapper_tb/MOSI
add wave -hex /SPI_Wrapper_tb/MISO

add wave -divider {Internal Signals (Interconnects)}
add wave -hex /SPI_Wrapper_tb/uut/rx_data
add wave -hex /SPI_Wrapper_tb/uut/rx_valid
add wave -hex /SPI_Wrapper_tb/uut/read_addr_received
add wave -hex /SPI_Wrapper_tb/uut/tx_data
add wave -hex /SPI_Wrapper_tb/uut/tx_valid

add wave -divider {RAM Memory Location}
add wave -hex {/SPI_Wrapper_tb/uut/RAM/mem[5]}

add wave -divider {Testbench Register}
add wave -hex /SPI_Wrapper_tb/rx_data_out

run -all
wave zoom full