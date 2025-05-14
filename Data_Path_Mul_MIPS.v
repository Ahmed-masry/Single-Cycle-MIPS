module Data_Path_Mul_MIPS
#(parameter alu_con_width      = 3  ,
            alu_width          = 32 ,
            pc_width           = 32 ,
            mem_width          = 32 ,
            reg_add_width      = 5  , 
            reg_width          = 32 ,
            reg_depth          = 32 
            
            )
            (
  input wire                            clk,rst,
  input wire [mem_width - 1 : 0]        mem_out,
  input wire [alu_con_width - 1 : 0]    alu_con,
  input wire [1:0]                      pc_src,
  input wire                            mem_to_reg,
  input wire                            alu_srca,
  input wire [1:0]                      alu_srcb,
  input wire                            reg_dst,
  input wire                            reg_wr,
  input wire                            io_rd,
  input wire                            ir_wr,
  input wire                            pc_en,
  output wire                           zero_flag,
  output wire [mem_width - 1 : 0]       instr ,
  output wire [pc_width - 1 : 0]        adr,
  output wire [reg_width - 1 : 0]       rd2_ff_out 
  );
  
  
  wire [pc_width - 1 : 0]              pc_src_mux_out ;
  wire [pc_width - 1 : 0]              pc ;
  wire [pc_width - 1 : 0]              pc_branch; 
  wire [pc_width - 1 : 0]              sl_jump_out; 
  wire [mem_width - 1 : 0]             signlmm ;
  wire [alu_width - 1 : 0]             alu_out ;
  wire [alu_width - 1 : 0]             alu_res ;
  wire [mem_width - 1 : 0]             data ;
  wire [reg_add_width - 1 : 0]         reg_dst_mux_out ;
  wire [mem_width - 1 : 0]             mem_to_reg_mux_out ; 
  wire [reg_width - 1 : 0]             rd2 ;
  wire [reg_width - 1 : 0]             rd1 ;  
  wire [reg_width - 1 : 0]             rd1_ff_out ;
  wire [mem_width - 1 : 0]             srca ; 
  wire [mem_width - 1 : 0]             srcb ;  
  
  
  D_FF #(.ff_width( pc_width )) pc_block(
  .clk(clk),
  .rst(rst),
  .ff_en(pc_en),
  .ff_in(pc_src_mux_out),
  .ff_out(pc)
  );
  
  MUX_MIPS #(.mux_width(pc_width)) io_rd_mux(
  .sel(io_rd),
  .mux_in1(pc),
  .mux_in2(alu_out),
  .mux_out(adr)
  
  );
  
  D_FF #(.ff_width( mem_width )) instr_ff(
  .clk(clk),
  .rst(rst),
  .ff_en(ir_wr),
  .ff_in(mem_out),
  .ff_out(instr)
  );
  
  D_FF #(.ff_width( mem_width )) data_ff(
  .clk(clk),
  .rst(rst),
  .ff_en(1'b1),
  .ff_in(mem_out),
  .ff_out(data)
  );
  
  MUX_MIPS #(.mux_width(reg_add_width)) reg_dst_mux(
  .sel(reg_dst),
  .mux_in1(instr[20:16]),
  .mux_in2(instr[15:11]),
  .mux_out(reg_dst_mux_out)
  
  );
  
  MUX_MIPS #(.mux_width(mem_width)) mem_to_reg_mux(
  .sel(mem_to_reg),
  .mux_in1(alu_out),
  .mux_in2(data),
  .mux_out(mem_to_reg_mux_out)
  
  );
  
  Register_File_MIPS #(.reg_add_width(reg_add_width),
                      .reg_width(reg_width),
                      .reg_depth(reg_depth)) rf(
  .clk(clk),
  .rst(rst),
  .wr_en_rf(reg_wr),
  .rd_add_rf1(instr[25:21]),
  .rd_add_rf2(instr[20:16]),
  .wr_add_rf(reg_dst_mux_out),
  .wrd_rf(mem_to_reg_mux_out),
  .rdd1_rf(rd1),
  .rdd2_rf(rd2)
  );
  
  D_FF #(.ff_width( reg_width )) rd1_ff(
  .clk(clk),
  .rst(rst),
  .ff_en(1'b1),
  .ff_in(rd1),
  .ff_out(rd1_ff_out)
  );
  
  D_FF #(.ff_width( reg_width )) rd2_ff(
  .clk(clk),
  .rst(rst),
  .ff_en(1'b1),
  .ff_in(rd2),
  .ff_out(rd2_ff_out)
  );
  
   Sign_extend #(.sign_ex_width_out( pc_width))Sign_ex(
  .sign_ex_in( instr[15:0]),
  .sign_ex_out(signlmm)
  );
  
  Shift_Left2_MIPS #(.shifting_width(pc_width)) sl2_pc_branch(
  .shift_in(signlmm),
  .shift_out(pc_branch)
  );
  
  MUX_MIPS #(.mux_width(reg_width))srca_mux(
  .sel(alu_srca),
  .mux_in1(pc),
  .mux_in2(rd1_ff_out),
  .mux_out(srca)
  
  );
  
  MUX4_1 #(.mux_width(reg_width))srcb_mux (
  .sel(alu_srcb),
  .mux_in1(rd2_ff_out),
  .mux_in2('b100),
  .mux_in3(signlmm),
  .mux_in4(pc_branch),
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
  
  D_FF #(.ff_width( alu_width )) alu_ff(
  .clk(clk),
  .rst(rst),
  .ff_en(1'b1),
  .ff_in(alu_res),
  .ff_out(alu_out)
  );
  
  Shift_Left2_MIPS #(.shifting_width(pc_width)) sl2_jump(
  .shift_in(instr[25:0]),
  .shift_out(sl_jump_out)
  );
  
   MUX4_1 #(.mux_width(reg_width))pcsrc_mux (
  .sel(pc_src),
  .mux_in1(alu_res),
  .mux_in2(alu_out),
  .mux_in3({pc[31:28],sl_jump_out[27:0]}),
  .mux_in4('b0),
  .mux_out(pc_src_mux_out)

  );
  

  endmodule

















