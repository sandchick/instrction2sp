module ins2sp #(
    parameter width_rs = 32,
    parameter width_rdidx = 5,
    parameter width_info = 10,
    parameter width_imm = 32,
    parameter width_pc = 16,
    parameter N = 21
) (
    input clk,
    input rst_n,
    input  [width_rs-1:0] i_rs1,
    input  [width_rs-1:0] i_rs2,
    input  [width_rdidx-1:0] i_rdidx,
    input  [width_imm-1:0] i_imm,
    input  [width_info-1:0]  i_info,  
    input  [width_pc-1:0] i_pc,
    output [N+10:0] sp_out
);

wire [N-1:0] sp_out_rs1;   
wire [N-1:0] sp_out_rs2;
wire [N-1:0] sp_out_rdidx;
wire [N-1:0] sp_out_imm;
wire [N-1:0] sp_out_info;
wire [N-1:0] sp_out_pc;


    spcounter  #(
        .width (width_rs)
        )u_rs1_spcounter(
        .clk (clk)
        ,.rst_n (rst_n)
        ,.wlord (i_rs1)
        ,.sp_out (sp_out_rs1)
    );

    spcounter  #(
        .width (width_rs)
        )u_rs2_spcounter(
        .clk (clk)
        ,.rst_n (rst_n)
        ,.wlord (i_rs2)
        ,.sp_out (sp_out_rs2)
    );

    spcounter  #(
        .width (width_rdidx)
        )u_rdidx_spcounter(
        .clk (clk)
        ,.rst_n (rst_n)
        ,.wlord (i_rdidx)
        ,.sp_out (sp_out_rdidx)
    );
    
    spcounter  #(
        .width (width_imm)
        )u_imm_spcounter(
        .clk (clk)
        ,.rst_n (rst_n)
        ,.wlord (i_imm)
        ,.sp_out (sp_out_imm)
    );

    spcounter  #(
        .width (width_info)
        )u_info_spcounter(
        .clk (clk)
        ,.rst_n (rst_n)
        ,.wlord (i_info)
        ,.sp_out (sp_out_info)
    );

    spcounter  #(
        .width (width_pc)
        )u_pc_spcounter(
        .clk (clk)
        ,.rst_n (rst_n)
        ,.wlord (i_pc)
        ,.sp_out (sp_out_pc)
    );

assign sp_out = sp_out_rs1 + sp_out_rs2 + sp_out_rdidx + sp_out_imm + sp_out_info + sp_out_pc;



endmodule
