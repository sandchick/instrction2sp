module spcounter #(parameter  N = 31,
parameter width = 32)(
    clk, rst_n, wlord, sp_out
);
   input clk;
   input rst_n;
   input [width-1:0] wlord ;
   output [N-1:0] sp_out;

wire [31:0]hign_count_out[width-1:0];
wire [31:0]low_count_out[width-1:0];
wire [N-1:0]sp_out_single[width-1:0];

generate 
    genvar i;
    for(i = 0;i < width; i = i + 1)begin:high_level_counter 
    level_counter high_level_counter(
        .rst_n (rst_n)
        ,.clk  (clk)
        ,.en  (wlord[i])
        ,.sign (hign_count_out[i])
    );end
endgenerate

generate
    genvar j;
    for(j = 0;j< width; j = j + 1)begin:low_level_counter 
    level_counter low_level_counter(
        .rst_n (rst_n)
        ,.clk  (clk)
        ,.en  (~wlord[j])
        ,.sign (low_count_out[j])
    );end
endgenerate

generate
    genvar k;
    for(k = 0;k < width; k = k + 1)begin:divider
    divider udivider(
        .a (hign_count_out[k])
        ,.b (low_count_out[k])
        ,.yshang (sp_out_single[k])
    );
    end
    
endgenerate









endmodule
