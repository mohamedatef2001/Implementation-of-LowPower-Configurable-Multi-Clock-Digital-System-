module FIFO_RD #(parameter P_WIDTH = 4 ) (
  
  input  wire               r_inc     ,  // CONTROL SIGNAL
  input  wire               r_clk     , 
  input  wire [P_WIDTH-1:0] sync_wptr ,  // WRITE POINTER IN GRAY CODE FROM FIFO WR
  input  wire               rrst_n    ,  
  output wire               r_empty   ,  // EMPTY FLAG
  output wire [P_WIDTH-2:0] r_addr    ,  // READ ADDRESS
  output reg  [P_WIDTH-1:0] r_ptr_gray   // READ POINTER IN GRAY CODE
  );  


// INTERNAL SIGNL 

reg [P_WIDTH-1:0] rd_pointer ;

always @(posedge r_clk or negedge rrst_n)
begin
  
if (!rrst_n)
  begin
        rd_pointer <= 0;
  end
  
else if (!r_empty && r_inc )
  begin
        rd_pointer <= rd_pointer + 1'b1 ;
  end
  
end

always @(posedge r_clk or negedge rrst_n)
begin
 if(!rrst_n)
   begin
    r_ptr_gray <= 0 ;
   end
 else 
  begin
   case (rd_pointer)
   4'b0000: r_ptr_gray <= 4'b0000 ;
   4'b0001: r_ptr_gray <= 4'b0001 ;
   4'b0010: r_ptr_gray <= 4'b0011 ;
   4'b0011: r_ptr_gray <= 4'b0010 ;
   4'b0100: r_ptr_gray <= 4'b0110 ;
   4'b0101: r_ptr_gray <= 4'b0111 ;
   4'b0110: r_ptr_gray <= 4'b0101 ;
   4'b0111: r_ptr_gray <= 4'b0100 ;
   4'b1000: r_ptr_gray <= 4'b1100 ;
   4'b1001: r_ptr_gray <= 4'b1101 ;
   4'b1010: r_ptr_gray <= 4'b1111 ;
   4'b1011: r_ptr_gray <= 4'b1110 ;
   4'b1100: r_ptr_gray <= 4'b1010 ;
   4'b1101: r_ptr_gray <= 4'b1011 ;
   4'b1110: r_ptr_gray <= 4'b1001 ;
   4'b1111: r_ptr_gray <= 4'b1000 ;
   endcase
  end
 end
 
assign r_empty = (r_ptr_gray == sync_wptr );
assign r_addr  = rd_pointer [P_WIDTH-2:0]  ;

endmodule