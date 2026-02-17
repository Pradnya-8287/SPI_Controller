module SPI (
    input wire clk,
    input wire rst,
    input wire [2:0] addr,
    input wire we,
    input wire [31:0] write_data,
    input wire re,
    output reg [31:0] read_data
);

    localparam ENABLE   = 3'b000;
    localparam COMMAND  = 3'b001;
    localparam ADDRESS  = 3'b010;
    localparam DATA_IN  = 3'b011;
    localparam DATA_OUT = 3'b100;

    reg enable;
    reg [7:0] command;
    reg [23:0] address;
    reg [31:0] data_in;
    wire [31:0] data_out;

    // ✅ Synchronous register interface
    always @(posedge clk) begin
        if (rst) begin
            enable <= 0;
            command <= 0;
            address <= 0;
            data_in <= 0;
            read_data <= 0;
        end else begin
            case (addr)
                ENABLE:   if (we) enable <= write_data[0];
                COMMAND:  if (we) command <= write_data[7:0];
                ADDRESS:  if (we) address <= write_data[23:0];
                DATA_IN:  if (we) data_in <= write_data;
                DATA_OUT: if (re) read_data <= data_out;
            endcase
        end
    end

    wire cs, sck, mosi, miso;

    SPI_master master (
        .clk(clk),
        .rst(rst),
        .en(enable),
        .cs(cs),
        .sck(sck),
        .ext_command_in(command),
        .ext_address_in(address),
        .ext_data_in(data_in),
        .mosi(mosi),
        .miso(miso),
        .ext_data_out(data_out)
    );

    SPI_slave slave (
        .clk(clk),
        .rst(rst),
        .cs(cs),
        .sck(sck),
        .mosi(mosi),
        .miso(miso)
    );

endmodule
