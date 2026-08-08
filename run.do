vlib work
vlog SPI_slave.v

vsim -voptargs=+acc work.SPI_slave

# ============================================================
# WAVES
# ============================================================

add wave sim:/SPI_slave/clk
add wave sim:/SPI_slave/rst
add wave sim:/SPI_slave/SS_n
add wave sim:/SPI_slave/MOSI
add wave sim:/SPI_slave/MISO

add wave -radix binary sim:/SPI_slave/cs
add wave -radix binary sim:/SPI_slave/ns

add wave -radix unsigned sim:/SPI_slave/sp_counter
add wave -radix unsigned sim:/SPI_slave/ps_counter

add wave -radix binary sim:/SPI_slave/sipo_output
add wave -radix binary sim:/SPI_slave/rx_data
add wave sim:/SPI_slave/rx_valid

add wave -radix binary sim:/SPI_slave/tx_data
add wave sim:/SPI_slave/tx_valid

add wave sim:/SPI_slave/load
add wave sim:/SPI_slave/piso_loaded


# ============================================================
# CLOCK
# ============================================================

force clk 0 0ns, 1 5ns -repeat 10ns


# ============================================================
# RESET
# ============================================================

force rst 0
force SS_n 1
force MOSI 0

force read_addr_received 0

force tx_data 8'b00000000
force tx_valid 0

run 20ns


# ============================================================
# RELEASE RESET
# ============================================================

force rst 1


# ============================================================
# PRETEND RAM HAS A VALID READ ADDRESS
# This allows the READ command to enter READ_DATA
# ============================================================

force read_addr_received 1


# ============================================================
# SELECT SLAVE
# ============================================================

force SS_n 0


# ============================================================
# READ COMMAND BIT
# 1 = READ
# ============================================================

force MOSI 1
run 10ns


# ============================================================
# READ_DATA PAYLOAD
#
# 2 control bits + 8 dummy bits = 10 bits
#
# control = 11
# dummy   = 00000000
#
# Expected rx_data:
#
# 10'b1100000000
# ============================================================

# Control bit 1
force MOSI 1
run 10ns

# Control bit 2
force MOSI 1
run 10ns

# Dummy bit 1
force MOSI 0
run 10ns

# Dummy bit 2
force MOSI 0
run 10ns

# Dummy bit 3
force MOSI 0
run 10ns

# Dummy bit 4
force MOSI 0
run 10ns

# Dummy bit 5
force MOSI 0
run 10ns

# Dummy bit 6
force MOSI 0
run 10ns

# Dummy bit 7
force MOSI 0
run 10ns

# Dummy bit 8
force MOSI 0
run 10ns

# ============================================================
# RAM RETURNS DATA
# ============================================================

force tx_data 8'b10100110
force tx_valid 1

# Let SPI see tx_valid and load PISO
run 10ns

force tx_valid 0


# ============================================================
# TRANSMIT ONE BIT PER CLOCK
# ============================================================

# Bit 1 = MSB
run 10ns

# Bit 2
run 10ns

# Bit 3
run 10ns

# Bit 4
run 10ns

# Bit 5
run 10ns

# Bit 6
run 10ns

# Bit 7
run 10ns

# Bit 8 = LSB
run 10ns


# ============================================================
# END TRANSACTION
# ============================================================

force SS_n 1
run 20ns