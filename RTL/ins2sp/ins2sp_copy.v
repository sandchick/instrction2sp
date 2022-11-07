`include "e203_defines.v"
module ins2sp_copy (
  input  [`E203_INSTR_SIZE-1:0] i_ir,
  input  [`E203_PC_SIZE-1:0] i_pc,
  input  i_prdt_taken, 
  input  i_misalgn,              // The fetch misalign
  input  i_buserr,               // The fetch bus error
  input  i_muldiv_b2b,           // The back2back case for mul/div
  input  [`E203_XLEN-1:0] rf_wbck_wdat;
  input  [`E203_RFIDX_WIDTH-1:0] rf_wbck_rdidx;  
  input  [`E203_RFIDX_WIDTH-1:0] i_rs1idx,   // The RS1 index
  input  [`E203_RFIDX_WIDTH-1:0] i_rs2idx,   // The RS2 index
  input  rf_wbck_ena;

  
  output [`sp_count_copy+10 :0] sp_out,

  input clk,
  input rst_n
);
    
  e203_exu_regfile u_e203_exu_regfile(
    .read_src1_idx (i_rs1idx ),
    .read_src2_idx (i_rs2idx ),
    .read_src1_dat (rf_rs1),
    .read_src2_dat (rf_rs2),
    
                   
    .wbck_dest_wen (rf_wbck_ena),
    .wbck_dest_idx (rf_wbck_rdidx),
    .wbck_dest_dat (rf_wbck_wdat),
                                 
    .test_mode     (test_mode),
    .clk           (clk          ),
    .rst_n         (rst_n        ) 
  );

  wire dec_rs1en;
  wire dec_rs2en;


  
  //////////////////////////////////////////////////////////////
  // Instantiate the Decode
  wire [`E203_DECINFO_WIDTH-1:0]  dec_info;
  wire [`E203_XLEN-1:0] dec_imm;
  wire [`E203_PC_SIZE-1:0] dec_pc;
  wire dec_rs1x0;
  wire dec_rs2x0;
  wire dec_rdwen;
  wire [`E203_RFIDX_WIDTH-1:0] dec_rdidx;
  wire dec_misalgn;
  wire dec_buserr;
  wire dec_ilegl;

  `ifdef E203_HAS_NICE//{
  wire nice_cmt_off_ilgl;
  wire nice_xs_off;
  `endif//}

  //////////////////////////////////////////////////////////////
  // The Decoded Info-Bus
  e203_exu_decode u_e203_exu_decode (
    .dbg_mode     (dbg_mode),

    .i_instr      (i_ir    ),
    .i_pc         (i_pc    ),
    .i_misalgn    (i_misalgn),
    .i_buserr     (i_buserr ),
    .i_prdt_taken (i_prdt_taken), 
    .i_muldiv_b2b (i_muldiv_b2b), 
      
    .dec_rv32  (),
    .dec_bjp   (),
    .dec_jal   (),
    .dec_jalr  (),
    .dec_bxx   (),
    .dec_jalr_rs1idx(),
    .dec_bjp_imm(),

  `ifdef E203_HAS_NICE//{
    .dec_nice   (),
    .nice_xs_off(nice_xs_off),  
    .nice_cmt_off_ilgl_o(nice_cmt_off_ilgl),      
  `endif//}

    .dec_mulhsu  (dec2ifu_mulhsu),
    .dec_mul     (),
    .dec_div     (dec2ifu_div   ),
    .dec_rem     (dec2ifu_rem   ),
    .dec_divu    (dec2ifu_divu  ),
    .dec_remu    (dec2ifu_remu  ),


    .dec_info  (dec_info ),
    .dec_rs1x0 (dec_rs1x0),
    .dec_rs2x0 (dec_rs2x0),
    .dec_rs1en (dec_rs1en),
    .dec_rs2en (dec_rs2en),
    .dec_rdwen (dec_rdwen),
    .dec_rs1idx(),
    .dec_rs2idx(),
    .dec_misalgn(dec_misalgn),
    .dec_buserr (dec_buserr ),
    .dec_ilegl  (dec_ilegl),
    .dec_rdidx (dec_rdidx),
    .dec_pc    (dec_pc),
    .dec_imm   (dec_imm)
  );

  //////////////////////////////////////////////////////////////
  // Instantiate the Dispatch
  wire disp_alu_valid; 
  wire disp_alu_ready; 
  wire disp_alu_longpipe;
  wire [`E203_ITAG_WIDTH-1:0] disp_alu_itag;
  wire [`E203_XLEN-1:0] disp_alu_rs1;
  wire [`E203_XLEN-1:0] disp_alu_rs2;
  wire [`E203_XLEN-1:0] disp_alu_imm;
  wire [`E203_DECINFO_WIDTH-1:0]  disp_alu_info;  
  wire [`E203_PC_SIZE-1:0] disp_alu_pc;
  wire [`E203_RFIDX_WIDTH-1:0] disp_alu_rdidx;
  wire disp_alu_rdwen;
  wire disp_alu_ilegl;
  wire disp_alu_misalgn;
  wire disp_alu_buserr;



  wire wfi_halt_exu_req;
  wire wfi_halt_exu_ack;

  wire amo_wait;

  e203_exu_disp u_e203_exu_disp(
    .wfi_halt_exu_req    (wfi_halt_exu_req),
    .wfi_halt_exu_ack    (wfi_halt_exu_ack),
    .oitf_empty          (oitf_empty),

    .amo_wait            (amo_wait),

    .disp_i_valid        (i_valid         ),
    .disp_i_ready        (i_ready         ),
                                       
    .disp_i_rs1x0        (dec_rs1x0       ),
    .disp_i_rs2x0        (dec_rs2x0       ),
    .disp_i_rs1en        (dec_rs1en       ),
    .disp_i_rs2en        (dec_rs2en       ),
    .disp_i_rs1idx       (i_rs1idx      ),
    .disp_i_rs2idx       (i_rs2idx      ),
    .disp_i_rdwen        (dec_rdwen       ),
    .disp_i_rdidx        (dec_rdidx       ),
    .disp_i_info         (dec_info        ),
    .disp_i_rs1          (rf_rs1          ),
    .disp_i_rs2          (rf_rs2          ),
    .disp_i_imm          (dec_imm        ),
    .disp_i_pc           (dec_pc         ),
    .disp_i_misalgn      (dec_misalgn    ),
    .disp_i_buserr       (dec_buserr     ),
    .disp_i_ilegl        (dec_ilegl      ),

    .disp_o_alu_longpipe (disp_alu_longpipe),
    .disp_o_alu_itag     (disp_alu_itag    ),
    .disp_o_alu_rs1      (disp_alu_rs1     ),
    .disp_o_alu_rs2      (disp_alu_rs2     ),
    .disp_o_alu_rdwen    (disp_alu_rdwen    ),
    .disp_o_alu_rdidx    (disp_alu_rdidx   ),
    .disp_o_alu_info     (disp_alu_info    ),
    .disp_o_alu_pc       (disp_alu_pc      ),
    .disp_o_alu_imm      (disp_alu_imm     ),
    .disp_o_alu_misalgn  (disp_alu_misalgn    ),
    .disp_o_alu_buserr   (disp_alu_buserr     ),
    .disp_o_alu_ilegl    (disp_alu_ilegl      ),

   

  
    
    .clk                 (clk  ),
    .rst_n               (rst_n) 
  );

    ins2sp  # (
      .width_rs (`E203_XLEN)
     ,.width_rdidx (`E203_RFIDX_WIDTH) 
     ,.width_info (`E203_DECINFO_WIDTH)
     ,.width_pc (`E203_PC_SIZE)
     ,.width_imm (`E203_XLEN)
     ,.N (`sp_count_copy)
    )uins2sp(
      .clk (clk)
      ,.rst_n (rst_n)
      ,.i_rs1               (disp_alu_rs1     )
      ,.i_rs2               (disp_alu_rs2     )
      ,.i_rdidx             (disp_alu_rdidx   )
      ,.i_info              (disp_alu_info    )
      ,.i_pc                (i_pc    )
      ,.i_imm               (disp_alu_imm)
      ,.sp_out              (sp_out)
    );
  `endif //}





endmodule