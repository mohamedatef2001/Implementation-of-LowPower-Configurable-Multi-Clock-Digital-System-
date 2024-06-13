module DESERIALIZER_UAT_RX (
  input wire clk , rst                              ,
  input wire deser_en                               , 
  input wire [3:0] bit_count                        ,    // FROM FSM BLOCK
  input wire samplid_bit                            ,    // FROM DATA SAMPLING BLOCK
  output reg [7:0] p_data                           , 
  output reg [7:0] parity_out_check
  );
  
  reg  [7:0] save            ;
  wire flag                  ;
  always @(posedge clk or rst )
  begin
        if(!rst)
          begin
                p_data           <= 'b0;
                save             <= 'b0;
                parity_out_check <= 'b0;
          end
        
         else if (bit_count != 'd1 && !flag)     // (bit_count != 'd1) TO IGNOR FIRST BIT "START BIT"
           
            begin
                 save[bit_count-1]             <= samplid_bit ;
                 parity_out_check[bit_count-1] <= samplid_bit ;
                 p_data                        <= 'b0         ;
            end
                 
         else if (deser_en)
           
             begin
                 p_data            <= save        ;
                 save              <= 'b0         ;
                 parity_out_check  <= 'b0         ;
              end
end


assign flag = (bit_count=='d11);                          



endmodule
                 
                    
  