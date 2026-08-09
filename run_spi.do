vlib work
vlog SPI_slave.v SPI_slave_tb.v
vsim -voptargs="+acc" work.SPI_slave_tb

add wave -divider {Inputs}
add wave -hex /SPI_slave_tb/clk
add wave -hex /SPI_slave_tb/rst
add wave -hex /SPI_slave_tb/SS_n
add wave -hex /SPI_slave_tb/MOSI
add wave -hex /SPI_slave_tb/tx_data
add wave -hex /SPI_slave_tb/tx_valid

add wave -divider {Outputs}
add wave -hex /SPI_slave_tb/MISO
add wave -hex /SPI_slave_tb/rx_data
add wave -hex /SPI_slave_tb/rx_valid
add wave -hex /SPI_slave_tb/read_addr_received

add wave -divider {Internal FSM & Counter}
add wave -hex /SPI_slave_tb/uut/cs
add wave -hex /SPI_slave_tb/uut/counter

run -all
wave zoom full