design

[x]SPI slave skeleton  
[x]write data path mosi to rx_data and rx_valid  
[x]read_add data path mosi to rx_data  
[x]read_data data path tx_data to miso  
[x]single port async RAM skeleton  
[x] RAM logic  
[x] spi wrapper connecting  

verification:  
verification using testing principles:
1. decision table -> n switch coverage of valid and invalid transitions
2. shift-left/early testing of each new code
3. each test cases is traceable to a function in the spec

N-switch coverage:
IDLE -> IDLE  
IDLE -> CHK_CMD -> READ_DATA -> IDLE  
IDLE -> CHK_CMD -> READ_DATA -> READ_DATA -> IDLE  
IDLE -> CHK_CMD -> READ_ADD -> IDLE  
IDLE -> CHK_CMD -> READ_ADD -> READ_ADD -> IDLE  
IDLE -> CHK_CMD -> WRITE -> IDLE  
IDLE -> CHK_CMD -> WRITE -> WRITE -> IDLE  

Decision table:  
conditions/actions - tc1 - tc2 - tc3 - tc4 - tc5  

linting  
questasim waveforms  
elaboration schematic  
synthesis schematic  
implementation on artix-7  
debug core  
timing report  
(optimization)  
utilization report  
power report  
area report  
