module Sign_extend
  #(parameter sign_ex_width_out = 32 ,
              sign_ex_width_in  = sign_ex_width_out/2  )
  (
  
  input wire  [sign_ex_width_in - 1 : 0]      sign_ex_in,
  output wire [sign_ex_width_out - 1 : 0]     sign_ex_out
  
  );

assign sign_ex_out = {{16{sign_ex_in[sign_ex_width_in-1]}},sign_ex_in};

endmodule
