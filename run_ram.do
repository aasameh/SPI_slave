vlib work
vlog RAM.v RAM_tb.v
vsim -voptargs="+acc" work.RAM_tb

add wave -divider {Inputs}
add wave -hex /RAM_tb/clk
add wave -hex /RAM_tb/rst
add wave -hex /RAM_tb/rx_valid
add wave -hex /RAM_tb/din

add wave -divider {Outputs}
add wave -hex /RAM_tb/tx_valid
add wave -hex /RAM_tb/dout
add wave -hex /RAM_tb/read_addr_received

add wave -divider {Internal Memory Cell}
add wave -hex {/RAM_tb/uut/mem[5]}

run -all
wave zoom full