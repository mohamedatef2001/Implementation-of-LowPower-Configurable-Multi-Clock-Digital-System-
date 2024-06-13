module DATA_SAMPLING_UART_RX (
  input wire clk , rst                  ,
  input wire rx_in                      ,
  input wire [5:0] prescale             ,     
  input wire [5:0] edge_count           ,       // FROM EDGE_COUNTER_BIT BLOCK
  input wire dat_samp_en                ,       // FROM FSM BLOCK
  output reg samplid_bit  
  );


// INTERNAL SIGNAL
  wire correct ;
  reg sample_7 ;
  reg sample_8 ;
  reg sample_9 ;
  
  always @ (posedge clk or negedge rst)
  begin
    if (!rst)
     begin
      samplid_bit <= 'b0;
      sample_7    <= 'b0;
      sample_8    <= 'b0;
      sample_9    <= 'b0;
     end
    else if (dat_samp_en)                           // if it's working don't forget to edit it for prescale 8 , 32
          begin
                if(edge_count == 'd7 )
                  sample_7 <= rx_in ;
                else if (edge_count == 'd8)
                  sample_8 <= rx_in ; 
                else if (edge_count == 'd9 )
                  sample_9 <= rx_in ;  
           end
 end
  
  
  always @(posedge clk or negedge rst)
  begin
    if (!rst)
     begin
      samplid_bit <= 'b0;
      sample_7    <= 'b0;
      sample_8    <= 'b0;
      sample_9    <= 'b0;
     end
    else if(edge_count == 'd9)
        begin
             if (sample_7 == correct )
                samplid_bit <= sample_7;
             else
                samplid_bit <= sample_8;
        end     
 end
  
  
  
assign correct  = (sample_7 == sample_8 || sample_7 == sample_9);

endmodule

