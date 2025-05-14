module Data_Path_Piplined_MIPS
#(parameter alu_con_width      = 3  ,
            alu_width          = 32 ,
            Ins_mem_width      = 32 ,
            pc_width           = 32 ,
            mem_width          = 32 ,
            mux_width          = 32 ,
            reg_add_width      = 5  , 
            reg_width          = 32 ,
            reg_depth          = 32 
            
            )
            (
  input wire                            clk,rst,
  input wire [Ins_mem_width - 1 : 0]    instr,
  input wire [mem_width - 1 : 0]        rdd_mem,
  input wire [alu_con_width - 1 : 0]    alu_con,
  input wire                            pc_src,
  input wire                            mem_to_reg,
  input wire                            alu_src,
  input wire                            reg_dst,
  input wire                            reg_wr,
  input wire                            jump,
  output wire                           zero_flag,
  output wire [pc_width - 1 : 0]        pc,
  output wire [alu_width - 1 : 0]       alu_res,
  output wire [mem_width - 1 : 0]       wrd_mem
  );
  
  wire [pc_width - 1 : 0]              pcplus4 ;
  wire [pc_width - 1 : 0]              pcbranch ;
  wire [pc_width - 1 : 0]              first_mux_out ;
  wire [pc_width - 1 : 0]              sec_mux_out ;
  wire [Ins_mem_width - 1 : 0]         signlmm ;
  wire [pc_width - 1 : 0]              sl_jump_out ;
  wire [pc_width - 1 : 0]              pc_branch_in1 ;
  wire [reg_add_width - 1 : 0]         wrd_reg ;
  wire [reg_width - 1 : 0]             srca ; 
  wire [reg_width - 1 : 0]             srcb ;  
  wire [mem_width - 1 : 0]             res ; 
  
  
  MUX_MIPS #(.mux_width(mux_width)) first_pc_mux(
  .sel(pc_src),
  .mux_in1(pcplus4),
  .mux_in2(pcbranch),
  .mux_out(first_mux_out)
  
  );
  
  Shift_Left2_MIPS #(.shifting_width(pc_width)) sl2_jump(
  .shift_in(instr[25:0]),
  .shift_out(sl_jump_out)
  );
  
  
  MUX_MIPS #(.mux_width(mux_width)) sec_pc_mux(
  .sel(jump),
  .mux_in1(first_mux_out),
  .mux_in2({pcplus4 [31 : 28], sl_jump_out[27:0]}),
  .mux_out(sec_mux_out)
  
  );
  
  PC_MIPS #(.pc_width( pc_width )) pc_block(
  .clk(clk),
  .rst(rst),
  .pc_in(sec_mux_out),
  .pc_out(pc)
  );
  
  Adder_MIPS #(.adder_width( pc_width )) pcplus4_adder (
  .adder_in1(pc),
  .adder_in2('b100),
  .adder_out(pcplus4)
  );
  
  Sign_extend #(.sign_ex_width_out( pc_width))Sign_ex(
  .sign_ex_in( instr[15:0]),
  .sign_ex_out(signlmm)
  );
  
  Shift_Left2_MIPS #(.shifting_width(pc_width)) sl2_pc_branch(
  .shift_in(signlmm),
  .shift_out(pc_branch_in1)
  );

  Adder_MIPS #(.adder_width( pc_width )) pcbranch_adder (
  .adder_in1(pc_branch_in1),
  .adder_in2(pcplus4),
  .adder_out(pcbranch)
  );

  MUX_MIPS #(.mux_width(reg_add_width)) reg_dst_mux(
  .sel(reg_dst),
  .mux_in1(instr[20:16]),
  .mux_in2(instr[15:11]),
  .mux_out(wrd_reg)
  
  );
  
  Register_File_MIPS #(.reg_add_width(reg_add_width),
                      .reg_width(reg_width),
                      .reg_depth(reg_depth)) rf(
  .clk(clk),
  .rst(rst),
  .wr_en_rf(reg_wr),
  .rd_add_rf1(instr[25:21]),
  .rd_add_rf2(instr[20:16]),
  .wr_add_rf(wrd_reg),
  .wrd_rf(res),
  .rdd1_rf(srca),
  .rdd2_rf(wrd_mem)
  );
  
   MUX_MIPS #(.mux_width(reg_width)) srcb_alu(
  .sel(alu_src),
  .mux_in1(wrd_mem),
  .mux_in2(signlmm),
  .mux_out(srcb)
  
  );
  
  ALU_MIPS #(.alu_width(reg_width),
             .alu_con_width(alu_con_width)) alu_block(

  .srca(srca),
  .srcb(srcb),
  .alu_con(alu_con),
  .zero_flag(zero_flag),
 . alu_res(alu_res)
  );

 MUX_MIPS #(.mux_width(mem_width)) memreg_mux(
  .sel(mem_to_reg),
  .mux_in1(alu_res),
  .mux_in2(rdd_mem),
  .mux_out(res)
  
  );
  
  endmodule

















