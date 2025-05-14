module Shift_Left2_MIPS
  #(parameter shifting_width = 32 )
  (
  
  input wire  [shifting_width - 1 : 0]    shift_in,
  output wire [shifting_width - 1 : 0]    shift_out
  
  );

assign shift_out = (shift_in << 2);

endmodule

