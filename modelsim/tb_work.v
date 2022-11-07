`timescale 1ns/1ps

module tb_work();

reg clk;
reg rst_n;
reg [31:0]wlord;
wire [31:0]sp_out;
initial begin
    clk = 0 ;
    #10
    rst_n = 0;
    #20
    rst_n = 1;
//    wlord = $random()%100;
//    #1000 $stop;
    wlord = 32'h0002;
    #1000
    wlord = 32'h0003;
    #1000
    wlord = 32'd0004;
    #1000
    wlord = 32'd0005;
end

always # 5 clk = ~clk;
//always #100 wlord = wlord + 10;

spcounter uspcounter(
    .clk (clk)
    ,.rst_n (rst_n)
    ,.wlord (wlord)
    ,.sp_out (sp_out)
);

endmodule