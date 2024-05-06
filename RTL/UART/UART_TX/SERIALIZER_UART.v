module SERIALIZER_UART (
input wire [7:0] p_data ,
input wire ser_en ,
input wire clk, rst ,
output reg ser_done ,
output wire ser_data
);

// internal signal 
reg [7:0] serilaizer_save ;

always @(posedge clk or negedge rst)
begin  
      if (!rst)
        begin
              serilaizer_save <= 'b0 ;
              ser_done <= 1'b0;
        end
        
      else if (ser_en)
        begin
              ser_done <= 1'b1;
              serilaizer_save[7:0] <= p_data ;
        end
        
      else if (!ser_en)
        begin
              
              serilaizer_save <= serilaizer_save >> 1 ;
               /*
               serilaizer_save <=  serilaizer_save >> 1;
               ser_data <=  serilaizer_save[0];
               */
        end
        
      else
        begin
              ser_done <= 1'b0;
              serilaizer_save <= 'b0 ;
        end
end


assign ser_data = serilaizer_save[0];


endmodule
