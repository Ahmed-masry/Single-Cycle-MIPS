module MUX4_1
  #(parameter mux_width = 32 )
  (
  input wire  [1 : 0]             sel,
  input wire  [mux_width - 1 : 0] mux_in1,mux_in2,mux_in3,mux_in4,
  output reg [mux_width - 1 : 0] mux_out
  );

always @*
  begin
    case (sel)
      'b00 : mux_out = mux_in1;
      'b01 : mux_out = mux_in2;
      'b10 : mux_out = mux_in3;
      'b11 : mux_out = mux_in4;
    endcase
  end
    
endmodule

