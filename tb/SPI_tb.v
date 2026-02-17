`timescale 1ns/1ns

module SPI_tb;

    reg clk = 0;
    reg rst = 0;
    reg [2:0] addr = 0;
    reg we = 0;
    reg re = 0;
    reg [31:0] write_data = 0;
    wire [31:0] read_data;

    SPI uut (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .we(we),
        .write_data(write_data),
        .re(re),
        .read_data(read_data)
    );

    always #10 clk = ~clk;

    initial begin
        rst = 1;
        #40 rst = 0;

        // Write registers
        addr=1; we=1; write_data=8'hA5; #20;
        addr=2; write_data=24'h123456; #20;
        addr=3; write_data=32'h789ABCDE; #20;

        // Enable transfer
        addr=0; write_data=1; #20;
        addr=0; write_data=0; #1000;

        // Read output
        addr=4; re=1; #40;

        $finish;
    end

    initial begin
        $dumpfile("SPI.vcd");
        $dumpvars(0, uut);
    end

endmodule
