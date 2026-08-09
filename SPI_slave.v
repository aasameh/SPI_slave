`timescale 1ns / 1ps

module SPI_slave #(
    parameter RX_SIZE = 10,
    parameter TX_SIZE = 8
) (
    input clk,
    input rst,
    input MOSI,
    input SS_n,
    input [TX_SIZE-1:0] tx_data,
    input tx_valid,
    input read_addr_received,
    output reg MISO,
    output reg [RX_SIZE-1:0] rx_data,
    output reg rx_valid
);

    function integer clog2;
        input integer value;
        integer i;
        begin
            value = value - 1;
            for (i = 0; value > 0; i = i + 1) value = value >> 1;
            clog2 = i;
        end
    endfunction

    localparam IDLE      = 3'b000;
    localparam CHK_CMD   = 3'b001;
    localparam WRITE     = 3'b010;
    localparam READ_DATA = 3'b011;
    localparam READ_ADD  = 3'b100;

    localparam SP_CNT_WIDTH = clog2(RX_SIZE + 1);
    localparam PS_CNT_WIDTH = clog2(TX_SIZE);

    reg [2:0] cs, ns;
    reg [SP_CNT_WIDTH-1:0] sp_counter;
    reg [PS_CNT_WIDTH-1:0] ps_counter;
    
    wire load;
    reg piso_loaded;
    wire piso_en;
    wire sipo_en;
    wire [RX_SIZE-1:0] sipo_output;

<<<<<<< HEAD
    // State memory block
=======
    //state memory block
>>>>>>> 6a7eac68678dc3ce7a134f7dbeb2f428449b45ee
    always @(posedge clk) begin
        if (~rst) begin
            cs <= IDLE;
        end else begin
            cs <= ns;
        end
    end

    // Next state logic block
    always @(*) begin
        ns = cs;
        case (cs)
            IDLE: begin
                if (SS_n) ns = IDLE;
                else ns = CHK_CMD;
            end

            CHK_CMD: begin
                if (SS_n) ns = IDLE;
                else begin
                    if (~MOSI) ns = WRITE;
                    else if (MOSI && ~read_addr_received) ns = READ_ADD;
                    else if (MOSI && read_addr_received) ns = READ_DATA;
                end
            end

            WRITE:     ns = (SS_n) ? IDLE : WRITE;
            READ_ADD:  ns = (SS_n) ? IDLE : READ_ADD;
            READ_DATA: ns = (SS_n) ? IDLE : READ_DATA;

            default: ns = IDLE;
        endcase
    end
    
<<<<<<< HEAD
    // (تعديل جوهري): إضافة CHK_CMD لتلقي أول بت من الـ Payload أثناء الانتقال
    assign sipo_en = ~SS_n && (cs == CHK_CMD || cs == WRITE || cs == READ_ADD || cs == READ_DATA);
    assign piso_en = ~SS_n && (cs == READ_DATA) && piso_loaded && (ps_counter < TX_SIZE - 1);
    assign load    = tx_valid && (cs == READ_DATA);
=======
assign sipo_en = ~SS_n && (cs != IDLE);
assign piso_en = ~SS_n && (cs == READ_DATA) && piso_loaded && (ps_counter < TX_SIZE - 1);
>>>>>>> 6a7eac68678dc3ce7a134f7dbeb2f428449b45ee

    // SUBMODULE INSTANTIATIONS
    SIPO #(.DATA_WIDTH(RX_SIZE)) sipo (
        .clk(clk),
        .rst(rst),
        .SI(MOSI),
        .shift_en(sipo_en),
        .PO(sipo_output)
    );

<<<<<<< HEAD
    PISO #(.DATA_WIDTH(TX_SIZE)) piso (
        .clk(clk),
        .rst(rst),
        .load(load),
        .PI(tx_data),
        .shift_en(piso_en),
        .SO(MISO)
    );
=======
    // SIPO #(.DATA_WIDTH(RX_SIZE)) sipo(
    //     .clk(clk),
    //     .rst(rst),
    //     .SI(MOSI),
    //     .shift_en(sipo_en),
    //     .PO(SIPO_register)
    // );
>>>>>>> 6a7eac68678dc3ce7a134f7dbeb2f428449b45ee

    // Counters
    always @(posedge clk) begin
<<<<<<< HEAD
        if (~rst || cs == IDLE) sp_counter <= 0;
=======
        if(~rst || cs == IDLE) sp_counter <= 0;
>>>>>>> 6a7eac68678dc3ce7a134f7dbeb2f428449b45ee
        else if (sipo_en) sp_counter <= sp_counter + 1'b1;
    end

    always @(posedge clk) begin
        if (~rst || cs == IDLE || load) ps_counter <= 0;
        else if (piso_en) ps_counter <= ps_counter + 1'b1;
    end

    always @(posedge clk) begin
        if (~rst || cs != READ_DATA)
            piso_loaded <= 1'b0;
        else if (load)
            piso_loaded <= 1'b1;
    end

    // Output logic block
    always @(posedge clk) begin
<<<<<<< HEAD
        if (~rst) begin
            rx_data  <= {RX_SIZE{1'b0}};
            rx_valid <= 1'b0;
=======
        if(~rst) SIPO_register <= {RX_SIZE{1'b0}};
        else if (sipo_en) SIPO_register <= {SIPO_register[RX_SIZE-2:0], MOSI};
    end

    assign PO = SIPO_register;


       //PISO 
    always @(posedge clk) begin
        if(~rst) begin
            PISO_register <= {TX_SIZE{1'b0}};
            MISO <= 1'b0;
        end
        else if(load) begin
            MISO <= tx_data[TX_SIZE-1];
            PISO_register <= {tx_data[TX_SIZE-2:0], 1'b0};
        end
        else if(piso_en) begin
            MISO <= PISO_register[TX_SIZE-1];
            PISO_register <= {PISO_register[TX_SIZE-2:0], 1'b0};
        end
    end


    always @(posedge clk) begin
        if(~rst) begin
            rx_data <= {RX_SIZE{1'b0}};
            rx_valid <= 0;
>>>>>>> 6a7eac68678dc3ce7a134f7dbeb2f428449b45ee
        end else begin
            rx_valid <= 1'b0;
            case (cs)
<<<<<<< HEAD
                WRITE, READ_ADD, READ_DATA: begin
                    if (sp_counter == RX_SIZE - 1) begin
                        rx_data  <= {sipo_output[RX_SIZE-2:0], MOSI};
                        rx_valid <= 1'b1;
                    end
                end
                default: ;
=======
                IDLE: begin
                    SIPO_register <= 0;
                end
            //try valid at sp_counter == RX_SIZE and check in waveform
            //if fail change to RX_SIZE-1
            //sp_counter is one cycle late
            //rx_data is also one cycle old so we reconstruct the next value
                WRITE: begin
                    if(sp_counter == RX_SIZE-1) begin
                        rx_data <= {SIPO_register[RX_SIZE-2:0], MOSI};
                        rx_valid <= 1'b1;
                    end
                    //write addr vs write data logic is in RAM module side depending on the first two bits
                end

                READ_ADD: begin
                    if(sp_counter == RX_SIZE-1) begin
                        rx_data <= {SIPO_register[RX_SIZE-2:0], MOSI};
                        rx_valid <= 1'b1;
                    end
                end

                READ_DATA: begin
                    if(sp_counter == RX_SIZE-1) begin
                        rx_data <= {SIPO_register[RX_SIZE-2:0], MOSI};
                        rx_valid <= 1'b1;
                    end

                    // MISO is connected to SO, shift en condition is assigned above, load condition in always block
                end

                default:; 
>>>>>>> 6a7eac68678dc3ce7a134f7dbeb2f428449b45ee
            endcase
        end
    end

endmodule

// Shift-left SIPO Register
module SIPO #(
    parameter DATA_WIDTH = 10
) (
    input clk,
    input rst,
    input SI,
    input shift_en,
    output reg [DATA_WIDTH-1:0] PO
);
    always @(posedge clk) begin
        if (~rst) begin
            PO <= {DATA_WIDTH{1'b0}};
        end else if (shift_en) begin
            PO <= {PO[DATA_WIDTH-2:0], SI};
        end
    end
endmodule

// Shift-left PISO Register
module PISO #(
    parameter DATA_WIDTH = 8
) (
    input clk,
    input rst,
    input load,
    input [DATA_WIDTH-1:0] PI,
    input shift_en,
    output reg SO
);
    reg [DATA_WIDTH-1:0] register;

    always @(posedge clk) begin
        if (~rst) begin
            register <= {DATA_WIDTH{1'b0}};
            SO       <= 1'b0;
        end else if (load) begin
            SO       <= PI[DATA_WIDTH-1];
            register <= {PI[DATA_WIDTH-2:0], 1'b0};
        end else if (shift_en) begin
            SO       <= register[DATA_WIDTH-1];
            register <= {register[DATA_WIDTH-2:0], 1'b0};
        end
    end
endmodule