module MUX_UART (
  input  wire start_bit , stop_bit ,
  input  wire clk , rst           ,
  input  wire [1:0] mux_sel       ,
  input  wire ser_data            ,
  input  wire par_bit             ,
  output reg tx_out 
  );
  
  
  
always @(posedge clk or negedge rst)
  begin
    if (!rst)
      tx_out <= 'b1;
    else 
       case(mux_sel)
          2'b00 : begin    
                       tx_out <=  start_bit ;
                  end
          
          2'b01 : begin
                        tx_out <= stop_bit ;
                  end
          
          2'b10 : begin
                       tx_out <= ser_data ; 
                  end
          
          2'b11 : begin 
                       tx_out <= par_bit ;
                  end
          
          default :    tx_out <= ser_data ;
        endcase
  end
endmodule