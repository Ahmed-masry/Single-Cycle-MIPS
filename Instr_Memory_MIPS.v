module Instr_Memory_MIPS 
#(parameter Ins_mem_width = 32 ,
            Ins_mem_depth = 256 )(
 
  input wire [Ins_mem_width - 1 : 0]   rd_add_ins,
  output reg [Ins_mem_width - 1 : 0]   instr_out

);

reg [Ins_mem_width-1:0] instr_mem [Ins_mem_depth-1:0];

always @*
  begin
    instr_out = instr_mem[rd_add_ins];
  end
  
  initial
    begin
      instr_mem['h0]  = 'h20020005;
      instr_mem['h4]  = 'h2003000c;
      instr_mem['h8]  = 'h2067fff7;
      instr_mem['hc]  = 'h00e22025;
      instr_mem['h10] = 'h00642824;
      instr_mem['h14] = 'h00a42820;
      instr_mem['h18] = 'h10a7000a;
      instr_mem['h1c] = 'h0064202a;
      instr_mem['h20] = 'h10800001;
      instr_mem['h24] = 'h20050000;
      instr_mem['h28] = 'h00e2202a;
      instr_mem['h2c] = 'h00853820;
      instr_mem['h30] = 'h00e23822;
      instr_mem['h34] = 'hac670044;
      instr_mem['h38] = 'h8c020050;
      instr_mem['h3c] = 'h08000011;
      instr_mem['h40] = 'h20020001;
      instr_mem['h44] = 'hac020054;
end
endmodule 
