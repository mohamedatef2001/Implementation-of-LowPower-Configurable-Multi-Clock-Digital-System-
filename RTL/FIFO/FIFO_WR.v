module FIFO_WR #(parameter P_WIDTH = 4 ) (
  
  input  wire               w_inc     ,  // CONTROL SIGNAL
  input  wire               w_clk     , 
  input  wire [P_WIDTH-1:0] sync_rptr ,  // READ POINTER IN GRAY CODE FROM FIFO RD
  input  wire               wrst_n    ,  
  output wire               full      ,  // FULL FLAG
  output wire [P_WIDTH-2:0] w_addr    ,  // READ ADDRESS
  output reg  [P_WIDTH-1:0] w_ptr_gray   // WRITE POINTER IN GRAY CODE
  );  


// INTERNAL SIGNL 

reg [P_WIDTH-1:0] wr_pointer ;

always @(posedge w_clk or negedge wrst_n)
begin
  
if (!wrst_n)
  begin
        wr_pointer <= 0;
  end
  
else if (!full && w_inc )
  begin
        wr_pointer <= wr_pointer + 1'b1 ;
  end
  
end

always @(posedge w_clk or negedge wrst_n)
begin
 if(!wrst_n)
   begin
    w_ptr_gray <= 0 ;
   end
 else 
  begin
   case (wr_pointer)
   4'b0000: w_ptr_gray <= 4'b0000 ;
   4'b0001: w_ptr_gray <= 4'b0001 ;
   4'b0010: w_ptr_gray <= 4'b0011 ;
   4'b0011: w_ptr_gray <= 4'b0010 ;
   4'b0100: w_ptr_gray <= 4'b0110 ;
   4'b0101: w_ptr_gray <= 4'b0111 ;
   4'b0110: w_ptr_gray <= 4'b0101 ;
   4'b0111: w_ptr_gray <= 4'b0100 ;
   4'b1000: w_ptr_gray <= 4'b1100 ;
   4'b1001: w_ptr_gray <= 4'b1101 ;
   4'b1010: w_ptr_gray <= 4'b1111 ;
   4'b1011: w_ptr_gray <= 4'b1110 ;
   4'b1100: w_ptr_gray <= 4'b1010 ;
   4'b1101: w_ptr_gray <= 4'b1011 ;
   4'b1110: w_ptr_gray <= 4'b1001 ;
   4'b1111: w_ptr_gray <= 4'b1000 ;
   endcase
  end
 end
 
assign full = (w_ptr_gray[P_WIDTH-1]!= sync_rptr[P_WIDTH-1] && sync_rptr[P_WIDTH-2]!= w_ptr_gray[P_WIDTH-2] && w_ptr_gray[P_WIDTH-3:0] == sync_rptr[P_WIDTH-3:0]) ;
assign w_addr = wr_pointer[P_WIDTH-2:0] ;
endmodule
