module TOP_UART (
  input  wire [7:0] P_DATA,
  input  wire DATA_VALID,
  input  wire PAR_TYP,
  input  wire CLK , RST,
  input  wire PAR_EN,
  output wire TX_OUT,
  output wire BUSY
  );
  
  // internal wire
  
  wire SER_EN , SER_DONE , SER_DATA ;             
  wire [1:0] MUX_SEL ;                                  
  wire PAR_BIT , PAR_EN_INOUT ;                          
  wire STOP_BIT , START_BIT ;
  SERIALIZER_UART U0_SERIALIZER(
  .p_data(P_DATA),                                // data input to serializer
  .ser_en(SER_EN),                                // conections between serializer and fsm
  .ser_done(SER_DONE),                            // conections between serializer and fsm
  .ser_data(SER_DATA),                            // conections between serializer and mux
  .clk(CLK),
  .rst(RST)
  
);
  
  PARITY_CALC_YART U0_PARITY_CALC(
  .rst(RST),
  .p_data(P_DATA),                               // input to parity calc
  .data_valid(DATA_VALID),                        // input to parity calc
  .par_typ(PAR_TYP),                              // input to parity calc
  .par_bit(PAR_BIT), 
  .clk(CLK),                             // conections between parity calc and mux
  .par_en_in(PAR_EN_INOUT)                        // conections between parity calc and fsm
  );
  
  FSM_UART U0_FSM(
  .stop_bit_out(STOP_BIT) ,
  .start_bit_out(START_BIT),
  .data_valid(DATA_VALID),                        // input to fsm
  .par_en(PAR_EN),                                // input to fsm
  .clk(CLK),                                      // input to fsm
  .rst(RST),                                      // input to fsm
  .busy(BUSY),                                    // output of fsm
  .ser_en(SER_EN),                                // conections between serializer and fsm
  .ser_done(SER_DONE),                            // conections between serializer and fsm
  .mux_sel(MUX_SEL),                              // conections between mux and fsm
  .par_en_out(PAR_EN_INOUT)                       // conections between parity calc and fsm
  );
  
  MUX_UART U0_MUX(
  .stop_bit(STOP_BIT) ,
  .start_bit(START_BIT),
  .clk(CLK)        ,
  .rst(RST)        ,
  .tx_out(TX_OUT)  ,
  .mux_sel(MUX_SEL),                               // conections between mux and fsm 
  .par_bit(PAR_BIT),                               // conections between parity calc and mux 
  .ser_data(SER_DATA)                              // conections between serializer and mux
  );
  
endmodule
