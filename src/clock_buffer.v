// Clock Buffer
// Sean C. Reichle
// Blaine C. Readler 

module clock_buffer( reset, clk_in, dat_in, dat_out);
    input reset;
    input clk_in;
    input dat_in;
    output dat_out;

    wire clk;
    reg dat_out;
    
    BUFG clock_buffer_int( .I (clk_in ), .O ( clk ));

    always @( posedge clk or posedge reset )
        begin
            if (reset)
                dat_out <= 1'b0;
            else
                dat_out <= dat_in;
        end
        
endmodule