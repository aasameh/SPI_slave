module RAM #(
    // Parameters
    parameter MEM_DEPTH = 256,
    parameter ADDR_SIZE = 8
) (
    // Inputs and Outputs
    input clk,  rst, rx_valid,
    input [9:0] din,
    output reg tx_valid,
    output reg [7:0] dout
);
    // Registers
    reg [7:0] mem [MEM_DEPTH-1:0];

    reg [ADDR_SIZE-1:0] wr_addr;
    reg [ADDR_SIZE-1:0] rd_addr;

    // Start of the Cycle
    always @(posedge clk or negedge rst) begin
        // Reset Check
        if (!rst) begin
            dout <= 6'd0;
            tx_valid <= 1'b0;
            wr_addr <= {ADDR_SIZE{1'b0}};
            rd_addr <= {ADDR_SIZE{1'b0}};
        end

        // Data Write or Read
        else begin
            tx_valid <= 1'b0;

            if (rx_valid) begin
                case (din[9:8])
                    2'b00 : wr_addr <= din[ADDR_SIZE-1 :0];
                    2'b01 : mem[wr_addr] <= din[ADDR_SIZE-1 : 0];
                    2'b10 : rd_addr <= din[ADDR_SIZE-1 : 0];
                    2'b11 : begin
                        dout <= mem[rd_addr];
                        tx_valid <= 1'b1;
                    end
                endcase
            end
        end
    end

endmodule