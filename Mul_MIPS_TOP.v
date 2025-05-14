module Mul_MIPS_TOP
#(parameter opcode_width       = 6 ,
            function_width     = 6 ,
            alu_op_width       = 2 ,
            alu_con_width      = 3  ,
            alu_width          = 32 ,
            pc_width           = 32 ,
            mem_add_width      = 32 , 
            mem_width          = 32 ,
            mem_depth          = 256,
            reg_add_width      = 5  , 
            reg_width          = 32 ,
            reg_depth          = 32 
            
            )
            (
   input wire                      clk,rst,
   output wire [mem_width - 1 : 0] test_value
  );
  
   wire [mem_width - 1 : 0]        instr ;
   wire [pc_width - 1 : 0]         adr;
   wire [mem_width - 1 : 0]        mem_out;
   wire [alu_con_width - 1 : 0]    alu_con;
   wire [opcode_width - 1 : 0]     opcode;
   wire [function_width - 1 : 0]   funct;
   wire [1:0]                      pc_src;
   wire                            wr_en_mem;
   wire                            mem_to_reg;
   wire                            alu_srca;
   wire [1:0]                      alu_srcb;
   wire                            reg_dst;
   wire                            reg_wr;
   wire                            jump;
   wire                            zero_flag;
   wire                            io_rd,pc_en,ir_wr;
   wire [pc_width - 1 : 0]         pc;
   wire [alu_width - 1 : 0]        alu_res;
   wire [mem_width - 1 : 0]        wrd_mem;
   wire [reg_width - 1 : 0]        rd2_ff_out ;
  
  
  
  
  Control_Unit_Mul_MIPS #(.alu_op_width(alu_op_width),
                      .function_width(function_width),
                      .opcode_width(opcode_width),
                      .alu_con_width(alu_con_width)) con_unit(
  .clk(clk),
  .rst(rst),
  .zero_flag(zero_flag),
  .opcode(instr[31:26]),
  .funct(instr[5:0]),
  .alu_con(alu_con),
  .pc_src(pc_src),
  .mem_to_reg(mem_to_reg),
  .mem_wr(wr_en_mem),
  .alu_srca(alu_srca),
  .alu_srcb(alu_srcb),
  .reg_dst(reg_dst),
  .reg_wr(reg_wr),
  .io_rd(io_rd),
  .ir_wr(ir_wr),
  .pc_en(pc_en)                                 
   ); 
     
     
                     
  Data_Memeory_MIPS #(.mem_add_width(mem_add_width),
                      .mem_width(mem_width),
                      .mem_depth(mem_depth))dm(
  .clk(clk),
  .rst(rst),
  .wr_en_mem(wr_en_mem),
  .add_mem(adr),
  .wrd_mem( rd2_ff_out ),
  .rdd_mem(mem_out),
  .test_value(test_value)
                     
  );
  
  
  
  Data_Path_Mul_MIPS #(.alu_con_width ( alu_con_width ),
                   .alu_width(alu_width),
                   .pc_width(pc_width),
                   .mem_width(mem_width),
                   .reg_add_width(reg_add_width),
                   .reg_width(reg_width),
                   .reg_depth(reg_depth)) DP_block(
.clk(clk) ,                   
.rst(rst) ,
.mem_out(mem_out) ,                
.alu_con(alu_con) ,                   
.pc_src(pc_src) ,
.mem_to_reg(mem_to_reg) ,                 
.alu_srca(alu_srca) ,
.alu_srcb(alu_srcb) ,                   
.reg_dst(reg_dst) ,
.reg_wr(reg_wr) ,                                     
.zero_flag(zero_flag) ,
.pc_en(pc_en) ,
.io_rd(io_rd) ,
.ir_wr(ir_wr) ,        
.adr(adr),     
.instr(instr),           
.rd2_ff_out(rd2_ff_out)    
              
);
  
  
  
  
endmodule
