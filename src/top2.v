`include "sp_mem.v"
//`include "clock_buffer.v"


    //SB_LFOSC SB_LFOSC_inst(
    //  .CLKLFEN(1),
    //  .CLKLFPU(1),
    //  .CLKLF(lf_clk)
    //);

module top( );
    //SCR Let's add some memory.  16k
    reg [1:0] mem_reset;
    reg [15:0] mem_data_io;
    reg [9:0] mem_address;
    reg [1:0] mem_w_en;
    reg [1:0] mem_r;
    single_port_mem mem_init( .clk(clk), .reset(mem_reset), .data_io(mem_data_io), .address(mem_address), .wr_en(mem_w_en), .rd(mem_r));
endmodule
