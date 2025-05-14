module D_FF
  #(parameter ff_width = 32 )
  (
  input wire                     clk , rst,
  input wire                     ff_en,
  input wire  [ff_width - 1 : 0] ff_in,
  output reg  [ff_width - 1 : 0] ff_out
  );

always @(posedge clk, negedge rst)
  begin
    if(!rst)
      ff_out = 'b0;
    else if(ff_en)
      ff_out = ff_in;
  end
    
endmodule



