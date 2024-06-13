module START_CHECK_UART_RX (
  input wire clk , rst          ,
  input wire start_check_en     ,           // FROM FSM BLOCK
  input wire sampled_bit        ,           // FROM DATA SAMPLING
  output reg start_glitch       
  );
  
  always @ (posedge clk or negedge rst )
  begin
    if(!rst)
                      start_glitch <= 'b0;
     else if (start_check_en)
           begin
                 if (sampled_bit == 'b0)
                   
                      start_glitch <= 'b0;
                 else
                      start_glitch <= 'b1;
            end
end
endmodule