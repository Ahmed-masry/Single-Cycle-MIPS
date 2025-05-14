`timescale 1ns/1ps
module MIPS_TOP_tb ();
parameter   clk_per            = 10 ;
parameter   opcode_width       = 6  ,
            function_width     = 6  ,
            alu_op_width       = 2  ,
            alu_con_width      = 3  ,
            alu_width          = 32 ,
            pc_width           = 32 ,
            mem_add_width      = 32 , 
            mem_width          = 32 ,
            mem_depth          = 256,
            reg_add_width      = 5  , 
            reg_width          = 32 ,
            reg_depth          = 32 ;
            
reg clk_tb,rst_tb;
wire [mem_width - 1 : 0] test_value_tb;

Mul_MIPS_TOP #(.opcode_width(opcode_width),
           .function_width(function_width),
           .alu_op_width(alu_op_width),
           .alu_con_width(alu_con_width ),
           .alu_width(alu_width),
           .pc_width(pc_width),
           .mem_width(mem_width),
           .mem_depth(mem_depth),
           .mem_add_width(mem_add_width),
           .reg_add_width(reg_add_width),
           .reg_width(reg_width),
           .reg_depth(reg_depth)) DUT(
.clk(clk_tb),                   
.rst(rst_tb),
.test_value(test_value_tb)
);


always#(clk_per) clk_tb = ~clk_tb;

initial 
  begin
    clk_tb = 1'b0;
    reset();
      force DUT.dm.mem['h0]  = 'h20020005;
      force DUT.dm.mem['h0]  = 'h20020005;
      force DUT.dm.mem['h4]  = 'h2003000c;
      force DUT.dm.mem['h8]  = 'h2067fff7;
      force DUT.dm.mem['hc]  = 'h00e22025;
      force DUT.dm.mem['h10] = 'h00642824;
      force DUT.dm.mem['h14] = 'h00a42820;
      force DUT.dm.mem['h18] = 'h10a7000a;
      force DUT.dm.mem['h1c] = 'h0064202a;
      force DUT.dm.mem['h20] = 'h10800004;
      force DUT.dm.mem['h24]  = 'h00e22025;
      force DUT.dm.mem['h28] = 'h00642824;
      force DUT.dm.mem['h2c] = 'h00a42820;
      force DUT.dm.mem['h30] = 'h20050000;
      force DUT.dm.mem['h34] = 'h00e2202a;
      /*force DUT.dm.mem['h2c] = 'h00853820;
      force DUT.dm.mem['h30] = 'h00e23822;
      force DUT.dm.mem['h34] = 'hac670044;
      force DUT.dm.mem['h38] = 'h8c020050;
      force DUT.dm.mem['h3c] = 'h08000011;
      force DUT.dm.mem['h40] = 'h20020001;
      force DUT.dm.mem['h44] = 'hac020054;
*/
  end

task reset;
  begin
    rst_tb = 1'b1;
    #(clk_per)
    rst_tb = 1'b0;
    #(clk_per/2)
    rst_tb = 1'b1;
  end
endtask







endmodule