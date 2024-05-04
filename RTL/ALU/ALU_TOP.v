module ALU_TOP #(parameter width = 32)
  (
  input wire [width-17:0] A ,B,
  input wire [3:0] ALU_FUN,
  input wire CLK,
  input wire RST,
  output wire [width-1:0] ARITH_OUT , 
  output wire [width-17:0] LOGIC_OUT ,CMP_OUT ,SHIFT_OUT ,
  output wire CMP_FLAG ,CARRY_OUT ,LOGIC_FLAG ,SHIFT_FLAG , ARITH_FLAG
  );
  
  // internal connections 
  wire ARITH_ENABLE , CMP_ENABLE , SHIFT_ENABLE ,LOGIC_ENABLE ;
  
      DECOODER  U_decoder(
      .alu_fun(ALU_FUN),
      .arith_enable(ARITH_ENABLE),
      .cmp_enable(CMP_ENABLE),
      .shift_enable(SHIFT_ENABLE),
      .logic_enable(LOGIC_ENABLE)
      );
      
  //#######################################
       ARITHMETIC_UNIT U_arithmetic (
       .a(A),
       .b(B),
       .rst(RST),
       .clk(CLK),
       .alu_fun(ALU_FUN),
       .arith_enable(ARITH_ENABLE),
       .arith_out(ARITH_OUT),
       .carry_out(CARRY_OUT),
       .arith_flag(ARITH_FLAG)
       );
//########################################
       LOGIC_UNIT U_logic (
       .a(A),
       .b(B),
       .clk(CLK),
       .rst(RST),
       .alu_fun(ALU_FUN),
       .logic_flag(LOGIC_FLAG),
       .logic_out(LOGIC_OUT),
       .logic_enable(LOGIC_ENABLE)
       );
//######################################
       CMP_UNIT U_cmp (
       .a(A),
       .b(B),
       .rst(RST),
       .clk(CLK),
       .alu_fun(ALU_FUN),
       .cmp_enable(CMP_ENABLE),
       .cmp_flag(CMP_FLAG),
       .cmp_out(CMP_OUT)
       );
//##########################################
       SHIFT_UNIT U_shift (
       .a(A),
       .b(B),
       .rst(RST),
       .clk(CLK),
       .alu_fun(ALU_FUN),
       .shift_enable(SHIFT_ENABLE),
       .shift_flag(SHIFT_FLAG),
       .shift_out(SHIFT_OUT)
       );
     endmodule