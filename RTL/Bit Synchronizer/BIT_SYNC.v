module BIT_SYNC #(parameter NUM_STG = 2 , DEPTH   = 2 )(
  input wire [DEPTH-1:0] async ,
  input wire clk , rst         ,
  output reg [DEPTH-1:0] sync  
  );
  
// INTERNAL SIGNAL
integer i ;

reg [NUM_STG-1:0] sync_shift [DEPTH-1:0];
  always @(posedge clk or negedge rst)
  begin
  if (!rst)
            begin
              for(i=0;i<DEPTH;i=i+1)
                begin
                  sync_shift[i] <= 'b0;
                  sync          <= 'b0;
                end
            end
  else
            begin
              for(i=0;i<DEPTH;i=i+1)
               begin
                sync_shift[i] <= {sync_shift[i][NUM_STG-2:0] , async[i]};
                sync[i]       <=  sync_shift[i][NUM_STG-1]              ;  // ONE CLOCK CYCLE DELAY         
               end
            end
  end
       
/*               
always @(*)
 begin
  for (i=0; i<DEPTH; i=i+1)
    sync[i] = sync_shift[i][NUM_STG-1] ; 
 end
*/ 
endmodule                        
