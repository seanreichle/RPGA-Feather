// Single Port Memory 
// Sean C. Reichle
// Blaine C. Readler 

module single_port_mem( clk, reset, data_io, address, wr_en, rd);
    input clk;
    input reset;
    inout [15:0] data_io;
    input [9:0] address;
    input wr_en;
    input rd;

    reg [15:0] memory[0:1023];
    reg [15:0] dat_out;
    reg rd_d1;

    always @( posedge clk )
        begin
            if (wr_en)
                memory[address] <= data_io;
            data_out <= memory[address];
            rd_d1 <= rd;
        end
    assign data_io = rd_d1 ? data_out : 16'bz;
endmodule