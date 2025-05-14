module PC_MIPS 
#(parameter pc_width = 32)(
  input wire                  clk,rst,
  input wire [pc_width-1:0]   pc_in,
  output reg [pc_width-1:0]   pc_out

);
         

always @(posedge clk,negedge rst)
  begin
    if(!rst)
      begin
        pc_out <= 'b0;
      end
    else 
      begin
        pc_out <= pc_in;
      end
  end
  initial
    begin
      pc_out = 'b0;
      end
endmodule 