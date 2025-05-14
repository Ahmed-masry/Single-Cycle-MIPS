module Register_File_MIPS
#(parameter reg_add_width  = 5 , 
            reg_width      = 32 ,
            reg_depth      = 32
  )
 (
  input wire                              clk,rst,
  input wire                              wr_en_rf,
  input wire  [reg_add_width - 1 : 0]     rd_add_rf1,rd_add_rf2,wr_add_rf,
  input wire  [reg_width - 1 : 0]         wrd_rf,
  output wire [reg_width - 1 : 0]         rdd1_rf,
  output wire [reg_width - 1 : 0]         rdd2_rf
);

reg [reg_width - 1 : 0 ] reg_file [reg_depth -  1 : 0];
integer i;

always @(posedge clk,negedge rst)
  begin
    
    if(!rst)
      begin
        for (i=0; i<reg_depth; i=i+1)
          begin
            reg_file[i] <= 'b0;
          end
      end
      
    else if (wr_en_rf)
      begin
        reg_file[wr_add_rf] <= wrd_rf;
      end
      
  end
  
assign rdd1_rf = (rd_add_rf1 != 0)? reg_file[rd_add_rf1] : 'b0;
assign rdd2_rf = (rd_add_rf2 != 0)? reg_file[rd_add_rf2] : 'b0;
  
endmodule 
