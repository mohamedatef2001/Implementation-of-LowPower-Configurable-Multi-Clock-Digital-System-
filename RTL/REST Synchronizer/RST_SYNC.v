module RST_SYNC # (parameter NUM_STG = 2)(	
input    wire     rst,
input    wire     clk,
output   reg      sync_rst
);

//INTERNAL SIGNALS
		
reg   [NUM_STG-1:0]    sync_reg;
		
always @(posedge clk or negedge rst)
 begin
  if(!rst)      
   begin
    sync_reg <= 'b0 ;
    sync_rst <= 'b0 ;
   end
  else
   begin
    sync_reg <= {sync_reg[NUM_STG-2:0], 1'b1}    ;
    sync_rst <= sync_reg[NUM_STG-1]             ;   // ONE CLOCK CYCLE DELAY 
   end  
 end
 
 
//assign  SYNC_RST = sync_reg[NUM_STAGES-1] ;

endmodule
