`timescale 1ns/1ps;
module SYS_TB ();

reg                           RST_N         ;
reg                           UART_CLK      ;
reg                           REF_CLK       ;
reg                           UART_RX_IN    ;
wire                          UART_TX_O     ;
wire                          parity_error  ;
wire                          framing_error ;
 
   
                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 ////////////  PARAMETERS ///////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/

parameter CLK_P_REF        = 10               ,                   // 100 MHz      RE CLOCK
          CLK_P_UART       = 271.267          ,                   // 3.6864 MHz   RX CLOCK
          CLK_P_UART_TX    = 8680.555         ,                   // 115.2KHz     TX CLOCK 
          
          I_RX_IN_AA_F1    = 11'b10101010100  ,
          I_RX_IN_AA_F2    = 11'b11000000010  ,
          I_RX_IN_AA_F3    = 11'b11000000100  ,
          
          I_RX_IN_BB_F1    = 11'b10101110110  ,
          I_RX_IN_BB_F2    = 11'b11000000100  ,
          
          I_RX_IN_CC_F1    = 11'b10110011000  ,
          I_RX_IN_CC_F2    = 11'b10011001100  ,
          I_RX_IN_CC_F3    = 11'b10000001010  ,
          I_RX_IN_CC_F4    = 11'b11000000010  ,
          
          I_RX_IN_DD_F1    = 11'b10110111010  ,
          I_RX_IN_DD_F2    = 11'b11000000010  ;
          
          
          

                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 /////////////// CLOCK //////////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/
                 
                 
 always  #(CLK_P_REF/2.0) REF_CLK   = ~ REF_CLK     ;

 always  #(CLK_P_UART/2.0) UART_CLK = ~ UART_CLK    ;
 
           
                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 ////////////  TOP MODULE ///////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/
                 
 SYS_TOP DUT (
 .RST_N(RST_N)                   ,
 .UART_CLK(UART_CLK)             ,
 .REF_CLK(REF_CLK)               ,
 .UART_RX_IN(UART_RX_IN)         ,
 .UART_TX_O(UART_TX_O)           ,
 .parity_error(parity_error)     ,
 .framing_error(framing_error)      
 );
  
                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 //////////// INITIAL BLOCK /////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/
                 
                 
initial
begin
      $dumpfile("SYS_TB.vcd");
      $dumpvars;
      initialize();
      do_operation(I_RX_IN_AA_F1 , I_RX_IN_AA_F2 , I_RX_IN_AA_F3 , I_RX_IN_BB_F1 , I_RX_IN_BB_F2 ,
                                                                                   I_RX_IN_CC_F1 ,
                                                                                   I_RX_IN_CC_F2 ,
                                                                                   I_RX_IN_CC_F3 ,
                                                                                   I_RX_IN_CC_F4 ,
                                                                                   I_RX_IN_DD_F1 ,
                                                                                   I_RX_IN_DD_F2);
      #500
      $finish;
end




 
                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 //////////////// TASKS /////////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/
                 
      
 task initialize ;                                      // IDEAL STATE
  begin
        UART_CLK = 'b0;
        REF_CLK  = 'b0;
        RST_N    = 'b0;
        #(CLK_P_UART)
        RST_N    = 'b1;
  end
endtask     
        
         
task do_operation ;
  input [10:0] I_RX_IN_AA_F1 ,
               I_RX_IN_AA_F2 ,
               I_RX_IN_AA_F3 ,
               I_RX_IN_BB_F1 ,
               I_RX_IN_BB_F2 ,
               I_RX_IN_CC_F1 ,
               I_RX_IN_CC_F2 ,
               I_RX_IN_CC_F3 ,
               I_RX_IN_CC_F4 ,
               I_RX_IN_DD_F1 ,
               I_RX_IN_DD_F2 ;
  integer i                  ;           
  
  begin
        if (RST_N)
           begin
                
              for (i=0 ; i<=10 ; i=i+1)
                 begin
                 UART_RX_IN   = I_RX_IN_AA_F1 [i] ;
                 #(CLK_P_UART_TX);
                 end
                 
              #(CLK_P_UART_TX);
              
              
              for (i=0 ; i<=10 ; i=i+1)
                 begin
                 UART_RX_IN   = I_RX_IN_AA_F2 [i] ;
                 #(CLK_P_UART_TX);
                 end
                 
                
              #(CLK_P_UART_TX);
              
              
              for (i=0 ; i<=10 ; i=i+1)
                 begin
                 UART_RX_IN   = I_RX_IN_AA_F3 [i] ;
                 #(CLK_P_UART_TX);
                 end
                 
                
              #(CLK_P_UART_TX);
              
              
              for (i=0 ; i<=10 ; i=i+1)
                 begin
                 UART_RX_IN   = I_RX_IN_BB_F1 [i] ;
                 #(CLK_P_UART_TX);
                 end
                 
             #(CLK_P_UART_TX);
              
              
              for (i=0 ; i<=10 ; i=i+1)
                 begin
                 UART_RX_IN   = I_RX_IN_BB_F2 [i] ;
                 #(CLK_P_UART_TX);
                 end
              //#(50*CLK_P_UART_TX);
              
              
            #(CLK_P_UART_TX);
              
              
              for (i=0 ; i<=10 ; i=i+1)
                 begin
                 UART_RX_IN   = I_RX_IN_CC_F1 [i] ;
                 #(CLK_P_UART_TX);
                 end
                 
                 
            #(CLK_P_UART_TX);
              
              
              for (i=0 ; i<=10 ; i=i+1)
                 begin
                 UART_RX_IN   = I_RX_IN_CC_F2 [i] ;
                 #(CLK_P_UART_TX);
                 end  
                 
            #(CLK_P_UART_TX);
              
              
              for (i=0 ; i<=10 ; i=i+1)
                 begin
                 UART_RX_IN   = I_RX_IN_CC_F3 [i] ;
                 #(CLK_P_UART_TX);
                 end  
            #(CLK_P_UART_TX);
              
              
              for (i=0 ; i<=10 ; i=i+1)
                 begin
                 UART_RX_IN   = I_RX_IN_CC_F4 [i] ;
                 #(CLK_P_UART_TX);
                 end       
            //#(50*CLK_P_UART_TX);
            
            #(CLK_P_UART_TX);
              
              
              for (i=0 ; i<=10 ; i=i+1)
                 begin
                 UART_RX_IN   = I_RX_IN_DD_F1 [i] ;
                 #(CLK_P_UART_TX);
                 end     
                 
             #(CLK_P_UART_TX);
              
              
              for (i=0 ; i<=10 ; i=i+1)
                 begin
                 UART_RX_IN   = I_RX_IN_DD_F2 [i] ;
                 #(CLK_P_UART_TX);
                 end         
             #(50*CLK_P_UART_TX);
           end
            
                 
 end
endtask
 
endmodule          