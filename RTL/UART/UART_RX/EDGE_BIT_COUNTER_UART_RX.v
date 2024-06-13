module EDGE_BIT_COUNTER_UART_RX (
  input wire clk , rst                            ,
  input wire enable                               ,     // FROM FSM BLOCK
  input wire [5:0] prescale                       ,     // FROM TOP MODULE
  output reg [3:0] bit_count , [5:0] edge_count     
  );
  
  
always @(posedge clk or negedge rst)
begin
      if (!rst)
        begin
                bit_count  <= 'b0;
                edge_count <= 'b0;
        end
      
      else 
         begin
              if (enable)
               case(prescale)
                
                'd8          : begin 
                                     if ( edge_count == 'd7)
                                       bit_count  <= bit_count + 1'b1 ;
                                     else
                                       edge_count <= edge_count + 1'b1;
                               end
                               
                
                'd16          : begin 
                                     if ( edge_count == 'd15 )
                                       bit_count  <= bit_count + 1'b1 ;
                                     else
                                       edge_count <= edge_count + 1'b1;
                               end
                
                
                'd32          : begin 
                                     if ( edge_count == 'd31)
                                       bit_count  <= bit_count + 1'b1 ;
                                     else
                                       edge_count <= edge_count + 1'b1;
                               end
                               
                               
                default      : begin 
                                      if ( edge_count == 'd15 )                 // IF PRESCALE WAS ANY NUMBER OTHER 32 , 16 , 8 
                                       bit_count  <= bit_count + 1'b1 ;
                                     else
                                       edge_count <= edge_count + 1'b1;
                               end
                   
               endcase
               
              else             begin 
                                      bit_count  <= 'b0;
                                      edge_count <= 'b0;
                                end     
        end
end


always @(posedge clk or negedge rst)
begin 
  if(!rst)
     edge_count <= 'b0;
   else if ( edge_count == 'd15 )
               edge_count <= 'b0;
end
               
endmodule
            
             