module FIFO_TOP #(parameter WR_DATA_WIDTH = 16 , WR_ADDR_WIDTH = 8 , P_WIDTH = 4 )
 (
   input                           I_W_CLK   ,      // SOURCE DOMAIN CLOCK        
   input                           I_W_RST   ,      // SOURCE DOMAIN ASYNC RST       
   input                           I_W_INC   ,      // WRITE OPERATION ENABLE          
   input                           I_R_CLK   ,      // DESTINATION DOMAIN CLOCK         
   input                           I_R_RST   ,      // DESTINATION DOMAIN ASYNC RST         
   input                           I_R_INC   ,      // READ OPERATION ENABLE
   input   [WR_DATA_WIDTH-1:0]     I_W_DATA  ,      // WRITE DATA BUS
   output                          O_FULL    ,      // FULL FLAG
   output  [WR_DATA_WIDTH-1:0]     O_RD_DATA ,      // READ DATA BUS         
   output                          O_EMPTY          // READ DATA BUS

);

// INTERNAL SIGNAL 


wire [P_WIDTH-2:0] W_ADD_TOP ;                      // CONECTION BETWEEN FIFO MEM AND FIFO WR
wire [P_WIDTH-2:0] R_ADD_TOP ;                      // CONECTION BETWEEN FIFO MEM AND FIFO RD
wire [P_WIDTH-1:0] W_PTR_TOP ;                      // CONECTION BETWEEN FIFO WR  AND SUNC BIT WR
wire [P_WIDTH-1:0] R_PTR_TOP ;                      // CONECTION BETWEEN FIFO RD  AND SUNC BIT RD
wire [P_WIDTH-1:0] WQ2_RPTR  ;                      // CONECTION BETWEEN FIFO WR  AND SUNC BIT RD
wire [P_WIDTH-1:0] RQ2_RPTR  ;                      // CONECTION BETWEEN FIFO RD  AND SUNC BIT WR

 
  


FIFO_MEM U0_MEM (
.w_inc(I_W_INC)   ,
.w_full(O_FULL)   ,
.w_addr(W_ADD_TOP),
.r_addr(R_ADD_TOP),
.w_clk(I_W_CLK)   ,
.w_rst(I_R_RST)   ,
.w_data(I_W_DATA) ,
.r_data(O_RD_DATA)
);


FIFO_WR U0_WR (
.w_inc(I_W_INC)      ,
.w_clk(I_W_CLK)      ,
.sync_rptr(WQ2_RPTR) ,
.wrst_n(I_W_RST)     ,
.full(O_FULL)        ,
.w_addr(W_ADD_TOP)   ,
.w_ptr_gray(W_PTR_TOP)
);



FIFO_RD U0_RD (
.r_inc(I_R_INC)      ,
.r_clk(I_R_CLK)      ,
.sync_wptr(RQ2_RPTR) ,
.rrst_n(I_R_RST)     ,
.r_empty(O_EMPTY)    ,
.r_addr(R_ADD_TOP)   ,
.r_ptr_gray(R_PTR_TOP)
);



BIT_SYNC UO_SYNC_WR (
.clk(I_W_CLK)        ,
.rst(I_W_RST)        ,
.async(W_PTR_TOP)   ,
.sync(RQ2_RPTR)
);



BIT_SYNC UO_SYNC_RD (
.clk(I_R_CLK)        ,
.rst(I_R_RST)        ,
.async(R_PTR_TOP)    ,
.sync(WQ2_RPTR)
);

endmodule

