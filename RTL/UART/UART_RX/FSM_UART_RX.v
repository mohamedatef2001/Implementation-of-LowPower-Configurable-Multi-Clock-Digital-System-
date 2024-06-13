module FSM_UART_RX (
  input clk , rst           ,
  input wire par_en         ,
  input wire rx_in          ,
  input wire par_err        ,                    // PARITY CHECK BLOCK
  input wire start_glitch   ,                    // START  CHECK BLOCK
  input wire stop_err       ,                    // STOP   CHECK BLOCK
  input wire [3:0] bit_count,                    // EDGE   BIT COUNTER
  input wire [5:0] edge_count,                   // EDGE   BIT COUNTER
  output reg par_check_en   ,                    // PARITY CHECK BLOCK
  output reg start_check_en ,                    // START  CHECK BLOCK
  output reg stop_check_en  ,                    // STOP   CHECK BLOCK
  output reg data_valid     ,                    // EQUAL 1 IN CORRECT CASE FOR ONE CLOCK CYCLE
  output reg deser_en       ,                    // DESERIALIZER BLOCK 
  output reg enable         ,                    // EDGE BIT COUNTER
  output reg dat_samp_en                         // DATA_SAMPLING BLOCK
  ); 
  
  
  
// INTERNAL SIGNAL
  reg [2:0] curent_state , next_state ;          // FSM SIGNALS
  
  
  
// PARAMETERS
 localparam     ideal           = 3'b000,
                start_bit_check = 3'b001,
                deser_out       = 3'b011,
                par_bit_check   = 3'b010,
                stop_bit_check  = 3'b110,
                out_data        = 3'b111;         // AFTER CHECK STOP ERR , PAR ERR = 0
             
                
                
// STATE TRANZITION            
always @(posedge clk or negedge rst)
begin 
     if(!rst)
             curent_state <= ideal;
     else
             curent_state <= next_state;
end


// NEXT STATE LOGIC 
always @(*)
begin
      case (curent_state)
        ideal             : begin 
                                  if (rx_in)
                                     next_state = ideal             ;
                                  else
                                     next_state = start_bit_check   ;
                            end


        start_bit_check   : begin
                                  if (edge_count != 'd14)
                                     next_state = start_bit_check   ;
                                   else if (!start_glitch)
                                     next_state = deser_out         ;
                                   else
                                     next_state = ideal             ;
                            end
                            
                            
        deser_out         : begin
                                  if (bit_count != 'd10 )
                                     next_state = deser_out         ;
                                   else if (par_en)
                                      next_state = par_bit_check    ;
                                   else
                                      next_state = ideal            ;
                            end
                      
    
        par_bit_check     : begin 
                                  if (edge_count != 'd9 )
                                     next_state = par_bit_check    ; 
                                   else if (par_err)
                                     next_state = ideal            ;
                                   else
                                     next_state = stop_bit_check   ;
                            end                    
                      
        stop_bit_check    : begin  
                                  if (bit_count != 'd11 && edge_count != 'd9)
                                      next_state = stop_bit_check  ;
                                  else if (stop_err)
                                     next_state = ideal            ; 
                                  else 
                                     next_state = out_data         ; 
                            end        
                            
                            
        out_data          : begin
                                   if (!rx_in )
                                     next_state = start_bit_check  ; 
                                  else
                                    next_state = ideal             ; 
                            end
                            
                            
        default           : begin
                                     next_state = ideal            ; 
                            end  
                                     
    endcase
end
  
// OUTPUT LOGIC

always @(*)
begin
par_check_en   = 'b0;
start_check_en = 'b0;  
stop_check_en  = 'b0;
data_valid     = 'b0;
deser_en       = 'b0;
enable         = 'b1;
dat_samp_en    = 'b1;
  
      case (curent_state)
         ideal            : begin
                                   par_check_en   = 'b0;
                                   start_check_en = 'b0;  
                                   stop_check_en  = 'b0;
                                   data_valid     = 'b1;
                                   deser_en       = 'b0;
                                   enable         = 'b0;
                                   dat_samp_en    = 'b1;
                            end
                            
                                            
        start_bit_check   : begin 
                                   start_check_en = 'b1;
                            end
                            
                            
        deser_out         : begin 
                                   deser_en       = 'b1;
                            end
                                  
                                  
        par_bit_check     : begin 
                                   par_check_en   = 'b1;                           
                            end 
                            
        stop_bit_check    : begin 
                                   stop_check_en  = 'b1;
                            end     
                            
        out_data          : begin
                                   data_valid       = 'b1;
                                   deser_en         = 'b1; 
                            end
                                      
        default           : begin
                                   par_check_en   = 'b0;
                                   start_check_en = 'b0;  
                                   stop_check_en  = 'b0;
                                   data_valid     = 'b0;
                                   deser_en       = 'b0;
                                   enable         = 'b1;
                                   dat_samp_en    = 'b0;             
                            end
      endcase
end
endmodule  