module Control_Unit_MIPS
#(parameter opcode_width    = 6 ,
            function_width  = 6 ,
            alu_con_width   = 3 ,
            alu_op_width    = 2
            )
(
  input wire                            zero_flag,
  input wire [opcode_width - 1 : 0]     opcode,
  input wire [function_width - 1 : 0]   funct,
  output reg [alu_con_width - 1 : 0]    alu_con,
  output reg                            pc_src,
  output reg                            mem_to_reg,
  output reg                            mem_wr,
  output reg                            alu_src,
  output reg                            reg_dst,
  output reg                            reg_wr,
  output reg                            jump
  );
  
reg [alu_op_width - 1 : 0] alu_op ;
reg                        branch ;

always @*
  begin
  alu_op     = 'b00;
  mem_to_reg = 1'b0;
  mem_wr     = 1'b0;               
  branch     = 1'b0;
  alu_src    = 1'b0;
  reg_dst    = 1'b0;
  reg_wr     = 1'b0;
  jump       = 1'b0;

    case (opcode)
      'b00_0000 : 
                  begin
                    alu_op     = 'b10;
                    reg_dst    = 1'b1;
                    reg_wr     = 1'b1;
                  end
      'b10_0011 :  
                  begin
                    reg_wr     = 1'b1;
                    mem_to_reg = 1'b1;
                    alu_src    = 1'b1;
                  end
      'b10_1011 :  
                  begin
                    alu_src    = 1'b1;
                    mem_wr     = 1'b1;
                  end
      'b00_0100 :  
                  begin
                    alu_op     = 'b01;
                    branch     = 1'b1;  
                  end
      'b00_1000 :  
                  begin
                    alu_src    = 1'b1;
                    reg_wr     = 1'b1;
                  end
      'b00_0010 :  
                  begin
                    jump       = 1'b1; 
                  end
      default :  
                  begin
                    alu_op     = 'b00;
                    mem_to_reg = 1'b0;
                    mem_wr     = 1'b0;               
                    branch     = 1'b0;
                    alu_src    = 1'b0;
                    reg_dst    = 1'b0;
                    reg_wr     = 1'b0;
                    jump       = 1'b0;
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
      pc_src = zero_flag & branch ;
    end
    
endmodule