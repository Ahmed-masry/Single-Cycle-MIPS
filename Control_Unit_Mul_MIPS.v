module Control_Unit_Mul_MIPS
#(parameter opcode_width    = 6 ,
            function_width  = 6 ,
            alu_con_width   = 3 ,
            alu_op_width    = 2
            )
(
                              
  input wire                            clk,rst,
  input wire                            zero_flag, 
  input wire [opcode_width - 1 : 0]     opcode,
  input wire [function_width - 1 : 0]   funct,
  output reg [alu_con_width - 1 : 0]    alu_con,
  output reg [1:0]                      pc_src,
  output reg                            mem_to_reg,
  output reg                            mem_wr,
  output reg                            alu_srca,
  output reg [1:0]                      alu_srcb,
  output reg                            reg_dst,
  output reg                            reg_wr,
  output reg                            io_rd,
  output reg                            ir_wr,
  output reg                            pc_en

  
  );
  
reg [alu_op_width - 1 : 0]     alu_op ;
reg                            pc_wr;
reg                            branch;


localparam [3:0]fetch      = 4'b0000,
                decode     = 4'b0001,
                mem_adr    = 4'b0010,
                mem_read   = 4'b0011,
                mem_wrb    = 4'b0100,
                mem_write  = 4'b0101,
                execute    = 4'b0110,
                alu_wrb    = 4'b0111,
                branch_s   = 4'b1000,
                addi_ex    = 4'b1001,
                addi_wrb   = 4'b1010,
                jump_s     = 4'b1011;
            
reg [3:0] current_state,next_state;

always @(posedge clk , negedge rst)
  begin
    if(!rst)
      begin
        current_state <= fetch ;
      end
    else
      begin
        current_state <= next_state ;
      end
    end
    
always @*
  begin
  alu_op     = 'b00 ;
  mem_to_reg = 1'b0 ;
  mem_wr     = 1'b0 ;                
  branch     = 1'b0 ;
  reg_dst    = 1'b0 ;
  reg_wr     = 1'b0 ;
  io_rd      = 1'b0 ;
  alu_srca   = 1'b0 ;
  alu_srcb   = 2'b00; 
  pc_src     = 2'b00; 
  ir_wr      = 1'b0 ;
  pc_wr      = 1'b0 ;
  
    case (current_state)
      fetch : 
                  begin
                    io_rd     = 1'b0 ;
                    alu_srca  = 1'b0 ;
                    alu_srcb  = 2'b01;
                    alu_op    = 2'b00; 
                    pc_src    = 2'b00; 
                    ir_wr     = 1'b1 ;
                    pc_wr     = 1'b1 ;
                    
                    next_state = decode ;
                  end
      decode :  
                  begin
                    alu_srca  = 1'b0 ;
                    alu_srcb  = 2'b11;
                    alu_op    = 2'b00; 
                    
                    if (opcode == 6'b100011 || opcode == 6'b101011)
                      next_state = mem_adr ;
                    else if ( opcode == 6'b000000)
                      next_state = execute ;
                    else if ( opcode == 6'b000100)
                      next_state = branch_s ;
                    else if  (opcode == 6'b001000)
                      next_state = addi_ex ;
                    else if ( opcode == 6'b000010)
                      next_state = jump_s ;
                    else
                      next_state = fetch ;
                  end
      mem_adr :  
                  begin
                    alu_srca  = 1'b1 ;
                    alu_srcb  = 2'b10;
                    alu_op    = 2'b00;
                    if  (opcode == 6'b100011)
                      next_state = mem_read ;
                    else if ( opcode == 6'b101011)
                      next_state = mem_write ;
                    else
                      next_state = fetch ; 
                  end
      mem_read :  
                  begin
                   io_rd = 1'b1; 
                   
                   next_state = mem_wrb ; 
                  end
      mem_wrb:  
                  begin
                    reg_dst    = 1'b0;
                    mem_to_reg = 1'b1;
                    reg_wr    = 1'b1;
                    
                    next_state = fetch ; 
                  end
      mem_write :  
                  begin
                   io_rd  = 1'b1; 
                   mem_wr = 1'b1;
                   
                   next_state = fetch ; 
                  end
      execute :  
                  begin
                    alu_srca  = 1'b1 ;
                    alu_srcb  = 2'b00;
                    alu_op    = 2'b10;
                    
                    next_state = alu_wrb ; 
                  end
      alu_wrb:  
                  begin
                    reg_dst    = 1'b1; 
                    mem_to_reg = 1'b0;
                    reg_wr    = 1'b1;
                    
                    next_state = fetch ; 
                  end   
      branch_s :  
                  begin
                    alu_srca  = 1'b1 ;
                    alu_srcb  = 2'b00;
                    alu_op    = 2'b01;
                    pc_src    = 2'b01;
                    branch    = 1'b1 ;
                    
                    next_state = fetch ; 
                  end                 
      addi_ex :  
                  begin
                    alu_srca  = 1'b1 ;
                    alu_srcb  = 2'b10;
                    alu_op    = 2'b00;
                    
                    next_state = addi_wrb ; 
                  end 
      addi_wrb:  
                  begin
                    reg_dst    = 1'b0;
                    mem_to_reg = 1'b0;
                    reg_wr     = 1'b1;
                    
                    next_state = fetch ; 
                  end 
      jump_s  :  
                  begin
                    pc_src     = 2'b10;
                    pc_wr      = 1'b1 ;
                    
                    next_state = fetch ; 
                  end                                
 
      default :  
                  begin
                    alu_op     = 'b00 ;
                    mem_to_reg = 1'b0 ;
                    mem_wr     = 1'b0 ;                
                    branch     = 1'b0 ;
                    reg_dst    = 1'b0 ;
                    reg_wr     = 1'b0 ;
                    io_rd      = 1'b0 ;
                    alu_srca   = 1'b0 ;
                    alu_srcb   = 2'b00; 
                    pc_src     = 2'b00; 
                    ir_wr      = 1'b1 ;
                    pc_wr      = 1'b1 ;
                    
                    next_state = fetch ;
                  end
   endcase
 end

 always @*
    begin 
      case (alu_op)
        'b00 :
           begin
             alu_con = 'b010 ;
           end
        'b01 :
           begin
             alu_con = 'b110 ;
           end
        'b10 :
           begin
             case (funct)
               'b10_0000 : 
                  begin
                     alu_con = 'b010 ;
                  end
                'b10_0010 : 
                  begin
                     alu_con = 'b110 ;
                  end
                'b10_0100 : 
                  begin
                     alu_con = 'b000 ;
                  end
                'b10_0101 : 
                  begin
                     alu_con = 'b001 ;
                  end
                'b10_1010 : 
                  begin
                     alu_con = 'b111 ;
                  end
                default : 
                  begin
                     alu_con = 'b010 ;
                  end
                endcase
              end
        default : 
          begin
            alu_con = 'b010;         
          end
      endcase
    end
 always @*
    begin
      pc_en = (zero_flag & branch) | pc_wr ;
    end
endmodule

