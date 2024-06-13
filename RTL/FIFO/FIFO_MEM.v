module FIFO_MEM #(parameter WR_DATA_WIDTH = 16 , WR_ADDR_WIDTH = 8 , P_WIDTH = 4 ) // WR_ADDR_WIDTH MUST = 50 , P_WIDTH = 7
(                                                                                  // CUZ FIFO Buffer depth to overcome data
  
  input  wire                      w_inc   ,     // WRITE OPERATION ENABLE 
  input  wire                      w_full  ,     // FIFO BUFFER FULL FLAG
  input  wire [P_WIDTH-2:0]        w_addr  ,     // POINTER WRITE ADDRESS BUS
  input  wire [P_WIDTH-2:0]        r_addr  ,     // POINTER READ ADDRESS BUS
  input  wire                      w_clk   ,     
  input  wire                      w_rst   ,
  input  wire [WR_DATA_WIDTH-1:0]  w_data  ,     // WRITE DATA BUS
  output reg  [WR_DATA_WIDTH-1:0]  r_data        // READ  DATA BUS
  );
  
// INTERNAL SIGNAL
  reg [WR_DATA_WIDTH-1:0] FIFO_MEM_SAVE [WR_ADDR_WIDTH-1:0] ;
 integer i ;
  
  always @(posedge w_clk or negedge w_rst )
  begin
  if (!w_rst)
    begin
          //r_data <= 'b0 ;
          for(i=0;i<WR_ADDR_WIDTH;i=i+1)
          FIFO_MEM_SAVE[i] <= 0 ;
    end
    
  else if (!w_full && w_inc)
    begin
          FIFO_MEM_SAVE[w_addr] <= w_data                 ;
        //r_data                <= FIFO_MEM_SAVE [r_addr] ;
    end
/*  
  else
          r_data                <= FIFO_MEM_SAVE [r_addr] ;
*/  
assign r_data = FIFO_MEM_SAVE [r_addr] ;
end   
endmodule
  