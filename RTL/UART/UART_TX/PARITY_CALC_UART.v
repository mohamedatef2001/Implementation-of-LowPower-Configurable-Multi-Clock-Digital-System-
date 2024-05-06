module PARITY_CALC_YART (
  input wire par_en_in ,
  input wire [7:0] p_data ,
  input wire data_valid ,
  input wire par_typ ,
  input clk , rst    ,
  output reg par_bit 
  );
  
  // internal signal
  reg  parity_calc ;
  always @(posedge clk or negedge rst)
  begin
    if (!rst)
      par_bit <= 'b0;
    else
        if (par_en_in)                           // note must be high for one clock cycle
           begin 
                 par_bit <= parity_calc ;
           end
  end
  
  always @(*)
  begin
       case(par_typ)
        1'b1:          begin        
                             parity_calc = ~^p_data ;
                       end
                       
                       
         1'b0:        begin                                       // REGISTER TO SAVE VALUE IF DATA_VALID = 0
                             parity_calc = ^p_data ;
                      end
                       
        endcase                     
  end
endmodule