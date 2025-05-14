module Adder_MIPS
  #(parameter adder_width = 32 )
  (
  input wire  [adder_width - 1 : 0] adder_in1,adder_in2,
  output wire [adder_width - 1 : 0] adder_out
  );

assign adder_out = adder_in1 + adder_in2 ;

endmodule