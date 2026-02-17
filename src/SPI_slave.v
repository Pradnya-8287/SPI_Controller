module SPI_slave (
    input wire clk,
    input wire rst,
    input wire cs,
    input wire sck,
    input wire mosi,
    output reg miso
);

    localparam IDLE = 2'b00;
    localparam DATA = 2'b01;

    reg [1:0] state;
    reg [5:0] bit_count;
    reg [63:0] shift_reg;

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            miso <= 0;
        end else begin
            case (state)

                IDLE: begin
                    miso <= 0;
                    if (!cs) state <= DATA;
                end

                DATA: begin
                    if (cs) state <= IDLE;
                    else begin
                        if (sck) begin
                            shift_reg <= {shift_reg[62:0], mosi};
                            bit_count <= bit_count + 1;
                        end

                        if (bit_count >= 32)
                            miso <= shift_reg[63];
                        else
                            miso <= 0;
                    end
                end

            endcase
        end
    end

endmodule
