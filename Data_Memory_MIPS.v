module Data_Memeory_MIPS 
#(parameter mem_add_width  = 32 , 
            mem_width      = 32 ,
            mem_depth      = 256
  )
(  
  input wire                                 clk,rst,
  input wire                                 wr_en_mem,
  input wire  [mem_add_width - 1 : 0]        add_mem,
  input wire  [mem_width - 1 : 0]            wrd_mem,
  output wire [mem_width - 1 : 0]            rdd_mem,
  output wire [mem_width - 1 : 0]            test_value
);

reg [mem_width - 1 : 0] mem [mem_depth - 1 : 0];
integer i ;

always @(posedge clk,negedge rst)
  begin
    
    if(!rst)
      begin
        for (i = 0 ; i < mem_depth ; i = i + 1)
          begin
            mem[i] <= 'b0;
          end
      end
      
    else if (wr_en_mem)
      begin
        mem[add_mem] <= wrd_mem ;
      end
  end

assign rdd_mem    = mem [add_mem] ;
assign test_value = mem[0] ;
 
endmodule 

