module STOP_CHECK_UAR_RX (
  input wire clk , rst     ,
  input wire stop_check_en ,
  input wire sampled_bit   ,
  output reg stop_err       
  );
  
  always @(posedge clk or negedge rst)
   begin
     if(!rst)
                      stop_err <= 'b0         ;
     else
        if (stop_check_en)
           begin
                 if (sampled_bit == 'b1)
                   
                      stop_err <=   'b0;
                 else
                      stop_err <=   'b1;
            end
        else
                      stop_err <= 'b0         ;
end
endmodule