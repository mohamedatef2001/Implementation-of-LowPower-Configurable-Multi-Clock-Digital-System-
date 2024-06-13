module TOP_UART_RX (
  input  wire CLK , RST           ,
  input  wire RX_IN               ,
  input  wire PAR_EN              ,
  input  wire PAR_TYP             ,
  input  wire [5:0] PRESCALE      ,
  output wire [7:0] P_DATA        ,
  output wire DATA_VALID    
  );
  
// INTERNAL SIGNAL
wire START_CHECK_EN_TOP;                        // CONECTED BETWEEN FSM AND START CHECK BLOCK
wire SAMPLED_BIT_TOP         ;                  // CONECTED BETWEEN DATA SAMPLING BLOCK , START CHECK BLOCK , STOP CHECK BLOCK , DESERIALIZER BLOCK
wire START_GLITCH_TOP        ;                  // CONECTED BETWEEN FSM AND START CHECK BLOCK
wire STOP_CHECK_EN_TOP       ;                  // CONECTED BETWEEN FSM AND STOP CHECK BLOCK
wire STOP_ERR_TOP            ;                  // CONECTED BETWEEN FSM AND STOP CHECK BLOCK
wire [5:0] EDGE_COUNT_TOP    ;                  // CONECTED BETWEEN FSM AND DATA SAMPLING AND EDGE BIT COUNTER
wire DAT_SAMP_EN_TOP         ;                  // CONECTED BETWEEN FSM AND DATA SAMPLING 
wire DESERIALIZER_EN_TOP     ;                  // CONECTED BETWEEN FSM AND DESERIALIZER
wire [3:0] BIT_COUNT_TOP     ;                  // CONECTED BETWEEN DESERIALIZER AND EDGE BIT COUNTER
wire PARITY_CHECK_EN_TOP     ;                  // CONECTWD BETWEEN FSM AND PARITY CHECK
wire PARITY_CHECK_ERR_TOP    ;                  // CONECTED BETWEEN FSM AND PARITY CHECK
wire [7:0] PARITY_CHECK      ;                  // CONECTED BETWEEN DESERIALIZER AND PARITY CHECK
wire ENABLE_TOP              ;                  // CONECTED BETWEEN FSM AND EDGE BIT COUNTER
// INST
  START_CHECK_UART_RX U_START (
  .clk(CLK)                          ,
  .rst(RST)                          ,
  .start_check_en(START_CHECK_EN_TOP),          // CONECTED TO FSM
  .sampled_bit(SAMPLED_BIT_TOP)      ,          // CONECTED TO DATA SAMPLING
  .start_glitch(START_GLITCH_TOP)               // CONECTED TO FSM
  );
  
  STOP_CHECK_UAR_RX U_STOP (
  .clk(CLK)                          ,
  .rst(RST)                          ,
  .stop_check_en(STOP_CHECK_EN_TOP)  ,          // CONECTED TO FSM
  .sampled_bit(SAMPLED_BIT_TOP)      ,          // CONECTED TO DATA SAMPLING
  .stop_err(STOP_ERR_TOP)                       // CONECTED TO FSM
  );
  
  DATA_SAMPLING_UART_RX U_DATA_SAMPLING (
  .clk(CLK)                          ,
  .rst(RST)                          ,
  .prescale(PRESCALE)                ,
  .edge_count(EDGE_COUNT_TOP)        ,          // CNECTED TO FSM 
  .dat_samp_en(DAT_SAMP_EN_TOP)      ,          // CNECTED TO FSM
  .rx_in(RX_IN)                      ,
  .samplid_bit(SAMPLED_BIT_TOP)                 // CONECTED TO DESERIALIZER
  );
  
  DESERIALIZER_UAT_RX U_DESERIALIZER (
  .clk(CLK)                          ,
  .rst(RST)                          ,
  .deser_en(DESERIALIZER_EN_TOP)     ,          // CNECTED TO FSM 
  .bit_count(BIT_COUNT_TOP)          ,          // CONECTED TO EDGE BIT COUNTER
  .samplid_bit(SAMPLED_BIT_TOP)      ,          // CONECTED TO DATA SAMPLING
  .p_data(P_DATA)                    ,
  .parity_out_check(PARITY_CHECK)               // CONECTED TO PARITY CHECK BLOCK
  );
  
  PARITY_CHECK_UART_RX U_PARITY (
  .clk(CLK)                          ,
  .rst(RST)                          ,
  .parity_check_en(PARITY_CHECK_EN_TOP),        // CONECTED TO FSM
  .sampled_bit(SAMPLED_BIT_TOP)      ,          // CONECTED TO DATA SAMPLING
  .par_typ(PAR_TYP)                  ,
  .par_err(PARITY_CHECK_ERR_TOP)     ,          // CONECTED TO FSM
  .parity_in_check(PARITY_CHECK)                // CONECTED TO DESERIALIZER 
  );
  
  EDGE_BIT_COUNTER_UART_RX U_EDGE_BIT (
  .clk(CLK)                          ,
  .rst(RST)                          ,
  .enable(ENABLE_TOP)                ,          // CONECTED TO FSM
  .edge_count(EDGE_COUNT_TOP)        ,          // CONECTED TO FSM
  .prescale(PRESCALE)                ,
  .bit_count(BIT_COUNT_TOP)                     // CONECTED TO FSM
  );
  
  
  FSM_UART_RX U_FSM (
  .clk(CLK)                          ,
  .rst(RST)                          ,
  .par_en(PAR_EN)                    ,      
  .rx_in(RX_IN)                      ,
  .par_err(PARITY_CHECK_ERR_TOP)     ,          // CONECTED TO PARITY CHECK
  .start_glitch(START_GLITCH_TOP)    ,          // CONECTED TO START CHECK
  .stop_check_en(STOP_CHECK_EN_TOP)  ,          // CONECTED TO STOP CHECK
  .bit_count(BIT_COUNT_TOP)          ,          // CONECTED TO EDGE BIT COUNTER
  .edge_count(EDGE_COUNT_TOP)        ,          // CONECTED TO EDGE BIT COUNTER
  .par_check_en(PARITY_CHECK_EN_TOP) ,           // CONECTED TO PARITY CHECK
  .start_check_en(START_CHECK_EN_TOP),          // CONECTED TO START CHECK
  .stop_err(STOP_ERR_TOP)            ,          // CONECTED TO STOP CHECK
  .data_valid(DATA_VALID)            ,         
  .deser_en(DESERIALIZER_EN_TOP)     ,          // CNECTED TO DESERIALIZER
  .enable(ENABLE_TOP)                ,          // CONECTED TO EDGE BIT COUNTER
  .dat_samp_en(DAT_SAMP_EN_TOP)                 // CNECTED TO DATA SAMPLING EN
  );
  
endmodule  


  
  
  
  
  