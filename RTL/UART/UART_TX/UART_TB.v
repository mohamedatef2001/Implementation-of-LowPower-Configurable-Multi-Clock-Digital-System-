`timescale 1ns/1ps;
module UART_TB ();
  
  reg  [7:0] P_DATA_tb ;
  reg  DATA_VALID_tb;
  reg  PAR_TYP_tb;
  reg  CLK_tb , RST_tb;
  reg  PAR_EN_tb;
  wire TX_OUT_tb;
  wire BUSY_tb;
  integer i =0 ;

  
/*
###################################################
############## ///PARAMETER//// ###################
###################################################
*/

parameter CLK_P      = 5 ;
parameter P_DATA     = 8'b10101010;
parameter PAR_TYP    = 1'b0;
parameter PAR_EN     = 1'b1;
parameter DATA_VALID = 1'b1;
parameter CLK        = 1'b1;
parameter VALID      = 1'b1;
parameter RST        = 1'b1;
//#################################################

  TOP_UART DUT (
  .P_DATA(P_DATA_tb),
  .DATA_VALID(DATA_VALID_tb),
  .PAR_TYP(PAR_TYP_tb),
  .CLK(CLK_tb),
  .RST(RST_tb),
  .PAR_EN(PAR_EN_tb),
  .TX_OUT(TX_OUT_tb),
  .BUSY(BUSY_tb)
  );
  
/*
############################################### 
############## ////CLOCK///// #################
###############################################
*/

always  #(CLK_P/2.0) CLK_tb = ~ CLK_tb;

//#############################################

initial
begin
      $dumpfile("UART_TB.vcd");
      $dumpvars;
      initialize();
      //test_fsm(1,1,1);
      do_operation(P_DATA , PAR_EN , PAR_TYP , CLK , VALID ,RST);
      $finish;
end



/*
#########################################
########## ////TASKS///// ###############
#########################################
*/

task initialize ;                                      // IDEAL STATE
  begin
        CLK_tb        = 'b0;
        RST_tb        = 'b0;
        PAR_TYP_tb    = 'b1;
        P_DATA_tb     = 0;
        DATA_VALID_tb = 0;
        PAR_EN_tb     = 0;
        #(CLK_P);
  end
endtask

//######################################

/*

task test_fsm ;                                        // CHECK  TX_OUT , BUSY
  input I_CLK, I_DATA_VALID ;
  input I_RST ;
  
  begin
        CLK_tb        = I_CLK ;
        DATA_VALID_tb = I_DATA_VALID ;
        RST_tb        = I_RST;
        #(CLK_P);
        if (BUSY_tb && TX_OUT_tb )
               $display (" test 1 pass ");
          else
               $display ("test 1 not pass");
 end
 endtask
 
 */
 
//######################################

task do_operation ;                                    // CHECK OPERATION OF OUTPUT
  input [7:0] I_P_DATA ;
  input I_PAR_EN , I_PAR_TYP ;
  input I_CLK, I_DATA_VALID ;
  input I_RST ;
  reg [10:0] save ;
  begin  
        CLK_tb        = I_CLK ;
        P_DATA_tb     = I_P_DATA ;
        DATA_VALID_tb = I_DATA_VALID ;
        RST_tb        = I_RST ;
        PAR_EN_tb     = I_PAR_EN ;
        PAR_TYP_tb    = I_PAR_TYP ;
        #(CLK_P)
       for (i=0 ; i<=10 ; i=i+1)
        begin
        @(posedge CLK_tb)
        begin
              #(CLK_P)
              save[i] = TX_OUT_tb ;
        end
        end
        #(11*CLK_P);
        if (save==11'b10101010100)
          $display (" test 1 pass ");                // note : two fram connected 
        else
          $display (" test 1 not pass ");
        
        #(5*CLK_P);                                  // CHECK FUNCTIONALITY OF TX IF THER IS ONTHER DATA
 end
endtask
        
endmodule
                
          
        
        

