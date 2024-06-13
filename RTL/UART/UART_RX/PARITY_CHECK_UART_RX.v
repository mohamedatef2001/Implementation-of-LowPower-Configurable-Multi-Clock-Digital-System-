module PARITY_CHECK_UART_RX (
  input wire clk , rst                ,                      // RX CLOCK
  input wire parity_check_en          ,                      // FROM FSM BLOCK
  input wire sampled_bit              ,                      // FROM DATA SAMPLING BLOCK
  input wire par_typ                  ,
  input wire [7:0] parity_in_check    ,                      // FROM DESERIALIZER BLOCK
  output reg par_err                                    
  );
  
  // internal signal
  reg  parity_calc ;
  
  always @ (posedge clk or negedge rst)                               // EN FF TO AVOIDE TIMING VIOLATION
  begin
        if(!rst)
          begin
           par_err     <= 'b0;
           parity_calc <= 'b0;
          end
          
        else
      
         if (parity_check_en)                                          // NOTE MUST BE HIGH FOR ONE CLOCK CYCLE
            begin
                 case(par_typ)
                 1'b1:   begin        
                            parity_calc <= ~^parity_in_check ;
                            if (parity_calc == sampled_bit)
                               par_err  <= 'b0               ;
                             else
                               par_err  <= 'b1               ;
                               
                         end
                       
                       
                 1'b0:   begin                                        // REGISTER TO SAVE VALUE IF DATA_VALID = 0
                             parity_calc <= ^parity_in_check ;
                             if (parity_calc == sampled_bit)
                               par_err   <= 'b0              ;
                             else
                               par_err   <= 'b1              ;
                         end
                 endcase 
            end      
        else     
                         begin  
                               par_err     <= 'b0;
                               parity_calc <= 'b0;         
                         end                     
  end
endmodule