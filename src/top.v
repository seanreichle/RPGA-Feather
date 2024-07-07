`include "pwm.v"
`include "sp_mem.v"
`include "hx8kdemo.v"
`include "picosoc.v"
`include "picorv32.v"
`include "spimemio.v"
`include "spiflash.v"
`include "simpleuart.v"

module top( output [2:0] RGB );
    
    // RPGA RGP Hoolpa TOP!!!
    reg [6:0] counter;
    reg [7:0] val_pwm0; //only make it go to 128 (half brightness)
    reg [7:0] val_pwm1; //only make it go to 128 (half brightness)
    reg [7:0] val_pwm2; //only make it go to 128 (half brightness)

    wire pwm_en_bit;
    wire clk;

    reg [2:0] leds;
    reg [7:0] leds2;
    reg [7:0] val_in0;
    reg [7:0] val_in1;
    reg [7:0] val_in2;

    SB_LFOSC SB_LFOSC_inst(
      .CLKLFEN(1),
      .CLKLFPU(1),
      .CLKLF(clk)
    );

    pwm pwm_init(.clk(clk),
                 .en(pwm_en_bit),
                 .value_input0(val_in0),
                 .value_input1(val_in1),
                 .value_input2(val_in2),
                 .out(leds));

    assign RGB = ~leds;

    // Init Some Block Ram
    //SCR Let's add some memory.  16k
    reg mem_reset;
    reg [15:0] mem_data_io;
    reg [9:0] mem_address;
    reg mem_w_en;
    reg mem_r;
    single_port_mem mem_init( 
        .clk(clk), 
        .reset(mem_reset), 
        .data_io(mem_data_io), 
        .address(mem_address), 
        .wr_en(mem_w_en), 
        .rd(mem_r)
        );

    // Init RISC-V 32bit PicoSOC
    hx8kdemo j8_init(
	    .clk(clk),
        .ser_tx(P48),
	    .ser_rx(P47),
        .leds(leds2),
        .flash_csb(flash_csb),
        .flash_clk(flash_clk),
        .flash_io0(flash_io0),
        .flash_io1(flash_io1),
        .flash_io2(flash_io2),
        .flash_io3(flash_io3),
        .debug_ser_tx(P48),
        .debug_ser_rx(P47),
        .debug_flash_csb(debug_flash_csb),
        .debug_flash_clk(debug_flash_clk),
        .debug_flash_io0(debug_flash_io0),
        .debug_flash_io1(debug_flash_io1),
        .debug_flash_io2(debug_flash_io2),
        .debug_flash_io3(debug_flash_io3)
        );


    // Init TOP RGB Cycle
    initial begin
        counter = 0;
        pwm_en_bit = 1;
        val_pwm0 = 255;
        val_pwm1 = 0;
        val_pwm2 = 0;
    end

    always @(posedge clk) begin
        pwm_en_bit = 0;
        counter <= counter + 1;
        if (counter==0) begin
            if (val_pwm0 > 0 && val_pwm1 < 255 && val_pwm2 == 0) begin
                val_pwm0 <= val_pwm0 - 1; //increase the width of pwm
                val_pwm1 <= val_pwm1 + 1;
            end
            if (val_pwm0 == 0 && val_pwm1 > 0 && val_pwm2 < 255) begin
                val_pwm1 <= val_pwm1 - 1; //increase the width of pwm
                val_pwm2 <= val_pwm2 + 1;
            end
            if (val_pwm0 < 255 && val_pwm1 == 0 && val_pwm2 > 0) begin
                val_pwm2 <= val_pwm2 - 1; //increase the width of pwm
                val_pwm0 <= val_pwm0 + 1;
            end

            pwm_en_bit = 1;
            val_in0 <= val_pwm0;
            val_in1 <= val_pwm1;
            val_in2 <= val_pwm2;        
        end

        if (counter > ((255*255*255)-1)) begin
            counter <= 0;
        end

    end
endmodule
