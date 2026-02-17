module SPI_master (
    input wire clk,
    input wire rst,
    input wire en,
    output reg cs,
    output reg sck,
    input wire [7:0] ext_command_in,
    input wire [23:0] ext_address_in,
    input wire [31:0] ext_data_in,
    output reg mosi,
    input wire miso,
    output wire [31:0] ext_data_out
);

    localparam IDLE = 2'b00;
    localparam ENABLE = 2'b01;
    localparam DATA = 2'b10;

    reg [1:0] current_state, next_state;
    reg clock_toggle;

    // Clock toggle
    always @(posedge clk) begin
        if (rst) clock_toggle <= 0;
        else clock_toggle <= ~clock_toggle;
    end

    reg [63:0] shift_reg;
    reg [5:0] bit_count;
    reg [31:0] data_in;

    assign ext_data_out = data_in;

    // FSM state register
    always @(posedge clk) begin
        if (rst) current_state <= IDLE;
        else current_state <= next_state;
    end

    // FSM next state
    always @(*) begin
        next_state = current_state;

        case (current_state)
            IDLE:   if (en) next_state = ENABLE;
            ENABLE: next_state = DATA;
            DATA:   if (bit_count == 63) next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (rst) begin
            cs <= 1;
            sck <= 1;
            mosi <= 0;
            shift_reg <= 0;
            bit_count <= 0;
            data_in <= 0;
        end else begin
            case (current_state)

                IDLE: begin
                    cs <= 1;
                    sck <= 1;
                    bit_count <= 0;
                    shift_reg <= {ext_command_in, ext_address_in, ext_data_in};
                end

                ENABLE: begin
                    cs <= 0;
                    sck <= clock_toggle;
                end

                DATA: begin
                    cs <= 0;
                    sck <= clock_toggle;
                    mosi <= shift_reg[63];
                    shift_reg <= {shift_reg[62:0],1'b0};
                    bit_count <= bit_count + 1;

                    if (bit_count >= 32)
                        data_in <= {data_in[30:0], miso};
                end

            endcase
        end
    end

endmodule
