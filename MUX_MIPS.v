module MUX_MIPS
  #(parameter mux_width = 32 )
  (
  input wire                      sel,
  input wire  [mux_width - 1 : 0] mux_in1,mux_in2,
  output wire [mux_width - 1 : 0] mux_out
  );

assign mux_out = (sel) ? mux_in2 : mux_in1 ;

endmodule

