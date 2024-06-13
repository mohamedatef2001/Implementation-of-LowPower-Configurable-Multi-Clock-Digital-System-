module FIFO_TB #(parameter  WR_DATA_WIDTH = 16 ) ();
  
   reg                           I_W_CLK_TB   ;      // SOURCE DOMAIN CLOCK        
   reg                           I_W_RST_TB   ;      // SOURCE DOMAIN ASYNC RST       
   reg                           I_W_INC_TB   ;      // WRITE OPERATION ENABLE          
   reg                           I_R_CLK_TB   ;      // DESTINATION DOMAIN CLOCK         
   reg                           I_R_RST_TB   ;      // DESTINATION DOMAIN ASYNC RST         
   reg                           I_R_INC_TB   ;      // READ OPERATION ENABLE
   reg   [WR_DATA_WIDTH-1:0]     I_W_DATA_TB  ;      // WRITE DATA BUS
   wire                          O_FULL_TB    ;      // FULL FLAG
   wire  [WR_DATA_WIDTH-1:0]     O_RD_DATA_TB ;      // READ DATA BUS         
   wire                          O_EMPTY_TB   ;      // READ DATA BUS


  
                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 ////////////  PARAMETERS ///////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/

parameter CLK_P_WR     = 12.5   ,
          CLK_P_RD     = 20     ;
          
          
                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 ////////////  TOP MODULE ///////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/
                 
 FIFO_TOP DUT (
 .I_W_CLK(I_W_CLK_TB)    ,
 .I_W_RST(I_W_RST_TB)    ,
 .I_W_INC(I_W_INC_TB)    ,
 .I_R_CLK(I_R_CLK_TB)    ,
 .I_R_RST(I_R_RST_TB)    ,
 .I_R_INC(I_R_INC_TB)    ,
 .I_W_DATA(I_W_DATA_TB)  ,
 .O_FULL(O_FULL_TB)      ,
 .O_RD_DATA(O_RD_DATA_TB),
 .O_EMPTY(O_EMPTY_TB)
 );
 
 
                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 /////////////// CLOCK //////////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/
                 
                 
 
   always #(CLK_P_WR/2)  I_W_CLK_TB = ~I_W_CLK_TB ;     // 12.5 ns period (80 MHz clock frequency) 
   
   always #(CLK_P_RD/2)  I_R_CLK_TB = ~I_R_CLK_TB ;     // 20 ns period (50 MHz clock frequency) 
 
 
 
                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 //////////// INITIAL BLOCK /////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/
                 
                 
initial
begin
      $dumpfile("FIFO_TB.vcd");
      $dumpvars;
      initialize();
      /*
      @(posedge I_W_CLK_TB)
      if (!O_FULL_TB)
      I_W_DATA_TB = 'b1111000011110000;
      */
      I_W_DATA_TB = 'b1111000011110000;
      #(CLK_P_WR);
      I_W_DATA_TB = 'b1111000011111111;
      #(CLK_P_WR);
      I_W_DATA_TB = 'b0000000011111111;
      #400
      
      $finish;
end


                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 //////////////// TASKS /////////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/
                 
      
 task initialize ;                                      // IDEAL STATE
  begin
        I_W_CLK_TB = 'b0;
        I_R_CLK_TB = 'b0;
        I_W_RST_TB = 'b0;
        I_R_RST_TB = 'b0;
        
        #(CLK_P_RD);
        
        I_W_RST_TB = 'b1;
        I_R_RST_TB = 'b1;
        I_W_INC_TB  = 'b1;
        I_R_INC_TB  = 'b1;
      
  end
endtask     

endmodule