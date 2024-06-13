module SYS_CTRL (
  input  wire        CLK             ,  // Clock Signal           Connected to   REF_CLK
  input  wire        ALU_OUT_VLD     ,  // ALU Result Valid       Connected to   ALU
  input  wire        RST             ,  // Active Low Reset       Connected to   RST_SYNC
  input  wire        FIFO_FULL       ,  // control signal Result  Connected to   FIFO
  input  wire [15:0] ALU_OUT         ,  // ALU Result             Connected to   ALU
  input  wire [7:0]  RF_RdData       ,  // Read Data Bus          Connected to   RegFile
  input  wire [7:0]  UART_RX_DATA    ,  // UART _RX Data          Connected to   UART_RX
  input  wire        RF_RdData_VLD   ,  // Read Data Valid        Connected to   RegFile
  input  wire        UART_RX_VLD     ,  // RX Data Valid          Connected to   UART_RX
  output reg [3:0]   ALU_FUN          ,  // ALU Function signal   Connected to   ALU
  output reg         ALU_EN           ,  // ALU Enable signal     Connected to   ALU
  output reg         CLKG_EN          ,  // Clock gate enable     Connected to   CLK_GATE 
  output reg [3:0]   RF_Address       ,  // Address bus           Connected to   RegFile 
  output reg         RF_WrEn          ,  // Write Enable          Connected to   RegFile 
  output reg         RF_RdEn          ,  // Read Enable           Connected to   RegFile
  output reg [7:0]   RF_WrData        ,  // Write Data Bus        Connected to   RegFile
  output reg [7:0]   UART_TX_DATA     ,  // UART _TX Data         Connected to   FIFO
  output reg         UART_TX_VLD      ,  // TX Data Valid         Connected to   FIFO
  output reg         CLKDIV_EN          // Clock divider enable   Connected to   CLKDiv
  );   
  
    

  
                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 ////////////  PARAMETERS ///////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/

parameter ideal                         =  'b0000  ,

          
          RF_Wr_Addr                    =  'b0001  ,
          RF_Wr_Data                    =  'b0011  ,
          
          
          RF_Rd_Addr                    =  'b0010  ,
          
          Operand_A                     =  'b0110  ,
          Operand_B                     =  'b0111  ,
          
          ALU_OPER_W_NOP_CMD            =  'b0101  ,
          ALU_FUN_S                     =  'b0100  ;
         
        
 
 
                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 /////////// INTERNAL SIGNAL ////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/
                                  
reg [3:0] curent_state , next_state ;
reg [3:0] save ;
  
                 /*//////////////////////////////////////
                 ////////////////////////////////////////
                 ////////////  ALWAYS BLOCK /////////////
                 ////////////////////////////////////////
                 //////////////////////////////////////*/        

        
always @(posedge CLK or negedge RST)
begin
  if(!RST)
    curent_state <= ideal      ;
  else
    curent_state <= next_state ;
    
end


always @(*)
begin
      case(curent_state)
        ideal            : begin
                                 if(UART_RX_VLD && UART_RX_DATA == 'hAA)
                                   next_state = RF_Wr_Addr          ;
                                   
                                 else if (UART_RX_VLD && UART_RX_DATA == 'hBB)
                                   next_state = RF_Rd_Addr          ;
                                   
                                 else if (UART_RX_VLD && UART_RX_DATA == 'hCC)
                                   next_state = Operand_A           ;
                                   
                                 else if (UART_RX_VLD && UART_RX_DATA == 'hDD)
                                   next_state = ALU_FUN_S           ;
                                   
                                 else
                                   next_state = ideal               ;
                           end
                           
                           
                           
                                   
        RF_Wr_Addr       : begin 
                                 if(UART_RX_VLD)
                                   next_state = RF_Wr_Data          ;
                                 else
                                   next_state = RF_Wr_Addr          ;
                            end
                            
                            
        RF_Wr_Data       : begin 
                                 if(UART_RX_VLD)
                                    next_state = ideal              ;
                                  else
                                    next_state = RF_Wr_Data         ;
                           end
                          
                            
                            
        RF_Rd_Addr       : begin
                                 if(RF_RdData_VLD)
                                   next_state = ideal               ;
                                 else
                                   next_state = RF_Rd_Addr          ;
                           end
                         
                        
        
        Operand_A        : begin
                                  if(UART_RX_VLD)
                                    next_state = Operand_B          ;
                                   else
                                    next_state = Operand_A          ;
                            end
                            
 
                            
        Operand_B         : begin
                                  if(UART_RX_VLD)
                                    next_state = ALU_FUN_S          ;
                                  else
                                    next_state = Operand_B          ;
                            end                           
                            
                            
        ALU_FUN_S         : begin
                                  if(ALU_OUT_VLD)
                                    next_state = ideal               ;           
                                 else
                                    next_state = ALU_FUN_S           ;
                            end     
                            
                                        

        default           : begin
                                    next_state = ideal               ;
                            end
                            
 endcase
end

always @(*)
begin
ALU_FUN      = 'b0;
ALU_EN       = 'b0;
CLKG_EN      = 'b0;
RF_Address   = 'b0;
RF_WrEn      = 'b0;
RF_RdEn      = 'b0;
RF_WrData    = 'b0;
UART_TX_DATA = 'b0;
UART_TX_VLD  = 'b0;
CLKDIV_EN    = 'b1;
save         = 'b0;

      case (curent_state)
         ideal            : begin
                                   ALU_FUN      = 'b0;
                                   ALU_EN       = 'b0;
                                   CLKG_EN      = 'b0;
                                   RF_Address   = 'b0;
                                   RF_WrEn      = 'b0;
                                   RF_RdEn      = 'b0;
                                   RF_WrData    = 'b0;
                                   UART_TX_DATA = 'b0;
                                   UART_TX_VLD  = 'b0;
                                   CLKDIV_EN    = 'b1;
                            end
                            
                                                        
         RF_Wr_Addr       : begin

                                 if(UART_RX_VLD)
                                   begin
                                   save   = UART_RX_DATA               ;
                                   end 
                
                            end                   
            
         RF_Wr_Data       : begin 
                                 if(UART_RX_VLD)
                                   begin
                                   RF_WrEn      = 'b1;
                                   RF_WrData    = UART_RX_DATA         ;
                                   RF_Address   = save                 ;

                                   end                                 

                           end

                            
         RF_Rd_Addr       : begin
                                 if(UART_RX_VLD)
                                   begin
                                   RF_Address          = save;
                                   RF_RdEn      = 'b1;
                                   
                                   end
                                   
                                 else if (RF_RdData_VLD)
                                   begin
                                   UART_TX_DATA  = RF_RdData            ;
                                   UART_TX_VLD   = 'b1;
                                   end
                                   
                                   
                           end                  
                           
                            
                            
        Operand_A         : begin
                                  if(UART_RX_VLD)
                                   begin
                                   RF_WrEn      = 'b1;
                                   RF_WrData    = UART_RX_DATA         ;
                                   RF_Address   = 'd0                  ;

                                   end      
                            end  
                        
                            
        Operand_B         : begin
                                  if(UART_RX_VLD)
                                   begin
                                   RF_WrEn      = 'b1;
                                   RF_WrData    = UART_RX_DATA         ;
                                   RF_Address   = 'd1                  ;
                                   
                                   end      
                            end  
                                              
                            
        ALU_FUN_S         : begin
                                  if(UART_RX_VLD)
                                    begin
                                    ALU_FUN      = UART_RX_DATA         ;
                                    CLKG_EN      = 'b1; 
                                    UART_TX_DATA  = ALU_OUT             ;
                                    ALU_EN       = 'b1;

                                    end

                                  else if (ALU_OUT_VLD)
                                   begin
                                   CLKG_EN      = 'b1; 
                                   UART_TX_DATA  = ALU_OUT              ;
                                   UART_TX_VLD   = 'b1;
                                   end
                            end     
endcase                                
end       
                                            
endmodule
