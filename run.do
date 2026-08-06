vlib work
vlog SPI_slave.v

vsim -voptargs=+acc work.SPI_slave

add wave sim:/SPI_slave/*

# Clock
force clk 0 0ns, 1 5ns -repeat 10ns

# Reset
force rst 0
force SS_n 1
force MOSI 0
force tx_data 8'h00
force tx_valid 0

run 20ns

# Release reset
force rst 1

# Select slave
force SS_n 0

# Command bit = 0 -> WRITE
force MOSI 0
run 10ns

# Send remaining 9 bits (example: 101100101)
force MOSI 0
run 10ns
force MOSI 1
run 10ns
force MOSI 0
run 10ns
force MOSI 1
run 10ns
force MOSI 1
run 10ns
force MOSI 0
run 10ns
force MOSI 0
run 10ns
force MOSI 1
run 10ns
force MOSI 0
run 10ns
force MOSI 1
run 10ns

# Deselect
force SS_n 1
run 20ns