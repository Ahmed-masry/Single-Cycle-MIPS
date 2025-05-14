module MIPS_TOP
#(parameter 
            opcode_width       = 6 ,
            function_width     = 6 ,
            alu_op_width       = 2 ,
            alu_con_width      = 3  ,
            alu_width          = 32 ,
            pc_width           = 32 ,
            Ins_mem_width      = 32 ,
            Ins_mem_depth      = 256,
            mem_add_width      = 32 , 
            mem_width          = 32 ,
            mem_depth          = 256,
            mux_width          = 32 ,
            reg_add_width      = 5  , 
            reg_width          = 32 ,
            reg_depth          = 32 
            
            )
            (
   input wire                      clk,rst,
   output wire [mem_width - 1 : 0] test_value
  );
  
  
   wire [Ins_mem_width - 1 : 0]    instr;
   wire [mem_width - 1 : 0]        rdd_mem;
   wire [alu_con_width - 1 : 0]    alu_con;
   wire [opcode_width - 1 : 0]     opcode;
   wire [function_width - 1 : 0]   funct;
   wire                            pc_src;
   wire                            wr_en_mem;
   wire                            mem_to_reg;
   wire                            alu_src;
   wire                            reg_dst;
   wire                            reg_wr;
   wire                            jump;
   wire                            zero_flag;
   wire [pc_width - 1 : 0]         pc;
   wire [alu_width - 1 : 0]        alu_res;
   wire [mem_width - 1 : 0]        wrd_mem;

  
  Control_Unit_MIPS #(.alu_op_width(alu_op_width),
                      .function_width(function_width),
                      .opcode_width(opcode_width),
                      .alu_con_width(alu_con_width)) con_unit(
  
  .zero_flag(zero_flag),
  .opcode(instr[31:26]),
  .funct(instr[5:0]),
  .alu_con(alu_con),
  .pc_src(pc_src),
  .mem_to_reg(mem_to_reg),
  .mem_wr(wr_en_mem),
  .alu_src(alu_src),
  .reg_dst(reg_dst),
  .reg_wr(reg_wr),
  .jump(jump)                                  
   ); 
                     
  Data_Memeory_MIPS #(.mem_add_width(mem_add_width),
                      .mem_width(mem_width),
                      .mem_depth(mem_depth))dm(
  .clk(clk),
  .rst(rst),
  .wr_en_mem(wr_en_mem),
  .add_mem(alu_res),
  .wrd_mem(wrd_mem),
  .rdd_mem(rdd_mem),
  .test_value(test_value)
                     
  );
  
  Instr_Memory_MIPS #(.Ins_mem_width(Ins_mem_width),
                      .Ins_mem_depth(Ins_mem_depth))ins_m_block(
  .rd_add_ins(pc),
  .instr_out(instr)
  );  
  
  
  Data_Path_MIPS #(.alu_con_width ( alu_con_width ),
                   .alu_width(alu_width),
                   .Ins_mem_width(Ins_mem_width),
                   .pc_width(pc_width),
                   .mem_width(mem_width),
                   .mux_width(mux_width),
                   .reg_add_width(reg_add_width),
                   .reg_width(reg_width),
                   .reg_depth(reg_depth)) DP_block(
.clk(clk),                   
.rst(rst),
.instr(instr),
.rdd_mem(rdd_mem),                   
.alu_con(alu_con),                   
.pc_src(pc_src),
.mem_to_reg(mem_to_reg),                   
.alu_src(alu_src),                   
.reg_dst(reg_dst),
.reg_wr(reg_wr),                   
.jump(jump),                   
.zero_flag(zero_flag),
.pc(pc),                   
.alu_res(alu_res),                   
.wrd_mem(wrd_mem)    
              
);
  
  
  
  
endmodule