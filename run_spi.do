vlib work
vlog SPI_slave.v SPI_slave_tb.v
vsim -voptargs="+acc" work.SPI_slave_tb

add wave -divider {Inputs}
add wave -binary /SPI_slave_tb/clk
add wave -binary /SPI_slave_tb/rst
add wave -binary /SPI_slave_tb/SS_n
add wave -binary /SPI_slave_tb/MOSI
add wave -binary /SPI_slave_tb/tx_data
add wave -binary /SPI_slave_tb/tx_valid

add wave -divider {Outputs}
add wave -binary /SPI_slave_tb/MISO
add wave -binary /SPI_slave_tb/rx_data
add wave -binary /SPI_slave_tb/rx_valid
add wave -binary /SPI_slave_tb/read_addr_received

add wave -divider {Internal FSM & Counter}
add wave -binary /SPI_slave_tb/uut/cs
add wave -binary /SPI_slave_tb/uut/sp_counter
add wave -binary /SPI_slave_tb/uut/ps_counter
add wave -binary /SPI_slave_tb/uut/sipo_en
add wave -binary /SPI_slave_tb/uut/SIPO_register

run -all
wave zoom full