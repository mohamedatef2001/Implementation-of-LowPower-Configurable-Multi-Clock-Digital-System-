`timescale 1ns/1ps;    
module ClkDiv_tb ();
  reg I_REF_CLK_tb;
  reg I_RST_N_tb;
  reg I_CLK_EN_tb;
  reg [2:0] I_DIV_RATIO_tb;
  wire O_DIV_CLK_tb;
  
/*
/////////////////////////////////// 
//////////// PARAMETER ////////////
///////////////////////////////////
*/

  parameter CLK_P     = 10 ;
  parameter DIV_RATIO = 'b011 ;
  parameter CLK_EN    = 1'b1;
  
/*
//////////////////////////////////
/////////// INSTATIATION /////////
//////////////////////////////////
*/ 

  ClkDiv  DUT (
  .i_ref_clk(I_REF_CLK_tb),
  .i_rst_n(I_RST_N_tb),
  .i_clk_en(I_CLK_EN_tb),
  .i_div_ratio(I_DIV_RATIO_tb),
  .o_div_clk(O_DIV_CLK_tb)
  );
  

/* 
/////////////////////////////////
///////////// CLOCK /////////////
/////////////////////////////////
*/ 
  always #(CLK_P/2) I_REF_CLK_tb = !I_REF_CLK_tb;
  
  
/*
///////////////////////////////////////
//////////// INITIAL BLOCK ////////////
///////////////////////////////////////
*/

initial 
begin
      $dumpfile("ClkDiv_tb.vcd");
      $dumpvars;
      initialize();
      do_operation (CLK_EN , DIV_RATIO );
      $finish;
end


/*
///////////////////////////////////
//////////// TASKS ////////////////
///////////////////////////////////
*/

task initialize ;                                    
  begin
        I_REF_CLK_tb = 'b0;
        I_RST_N_tb   = 'b0;
        #(CLK_P/2);
        I_RST_N_tb   = 'b1;
  end
endtask


task do_operation ;
  input  T_CLK_EN_tb ;
  input  [2:0] T_DIV_RATIO_tb ;
  begin
      I_CLK_EN_tb = T_CLK_EN_tb ;
      I_DIV_RATIO_tb = T_DIV_RATIO_tb ;
      #(30*CLK_P);
  end
endtask

endmodule              // ############   CHECK THE WAVEFORM  ############