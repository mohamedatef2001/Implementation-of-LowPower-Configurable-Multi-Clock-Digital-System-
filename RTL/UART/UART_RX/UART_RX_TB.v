`timescale 1ns/1ps;
module UART_RX_TB ();
  reg CLK_TB , RST_TB      ;
  reg  RX_IN_TB            ;
  reg [5:0] PRESCALE_TB    ;
  reg PAR_EN_TB            ;
  reg PAR_TYP_TB           ;
  wire DATA_VALID_TB       ;
  wire [7:0] P_DATA_TB     ;
  
  
                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 ////////////  PARAMETERS ///////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/

parameter CLK_P     = 10   ,
          RX_IN     = 11'b10101010100,
          PRESCALE  = 'd16 ,
          PAR_EN    = 1'b1 ,
          PAR_TYP   = 1'b0 ;
          
          
                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 ////////////  TOP MODULE ///////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/
                 
 TOP_UART_RX DUT (
 .CLK(CLK_TB)            ,
 .RST(RST_TB)            ,
 .RX_IN(RX_IN_TB)        ,
 .PAR_EN(PAR_EN_TB)      ,
 .PAR_TYP(PAR_TYP_TB)    ,
 .PRESCALE(PRESCALE_TB)  ,
 .P_DATA(P_DATA_TB)      ,
 .DATA_VALID(DATA_VALID_TB)
 );
 

                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 /////////////// CLOCK //////////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/
                 
                 
 always  #(CLK_P/2.0) CLK_TB = ~ CLK_TB; 
 
 
 
                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 //////////// INITIAL BLOCK /////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/
                 
                 
initial
begin
      $dumpfile("UART_RX_TB.vcd");
      $dumpvars;
      initialize();
      do_operation(PRESCALE , PAR_EN , PAR_TYP , RX_IN) ;
      $finish;
end
      
      
 
                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 //////////////// TASKS /////////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/
                 
      
 task initialize ;                                      // IDEAL STATE
  begin
        #(CLK_P);
        CLK_TB = 'b0;
        RST_TB = 'b0;
        #(CLK_P);
        RST_TB = 'b1;
        //#(CLK_P);
  end
endtask     
        
         

                  /*################################*/
                  
task do_operation ;
  input [5:0] I_PRESCALE   ;
  input I_PAR_EN           ;
  input I_PAR_TYP          ;
  input [10:0] I_RX_IN     ;
  reg   [10:0] SAVE        ;
  integer i                ;
  
  begin
        PRESCALE_TB =  I_PRESCALE ;
        PAR_EN_TB   =  I_PAR_EN   ;
        PAR_TYP_TB  =  I_PAR_TYP  ;
        
              for (i=0 ; i<=10 ; i=i+1)
                 begin
                 RX_IN_TB   = I_RX_IN [i] ;
                 #(16*CLK_P);
                 end
                 
                 #(25*CLK_P);
                 
                 for (i=0 ; i<=10 ; i=i+1)
                 begin
                 RX_IN_TB   = I_RX_IN [i] ;
                 #(16*CLK_P);
                 end
                 #(50*CLK_P);       /* CHECK WAVEFORM  */
 end
endtask
                  
endmodule     

            