module FSM_UART (
  input wire data_valid ,par_en , ser_done ,
  input wire clk , rst ,
  output reg busy , ser_en , par_en_out , start_bit_out , stop_bit_out ,
  output reg [1:0] mux_sel 
  );
  
// internal signal 
                                     
reg [2:0] curent_state , next_state;                //FSM INTERNAL SIGNAL
reg [3:0] count ;                                   // counter 8 clock cycle

// PARAMETERS
localparam 
            ideal     = 3'b000,
            start_bit = 3'b001,
            ser_data  = 3'b011,
            par_bit   = 3'b010,
            stop_bit  = 3'b110;
            
//state transition            
always @(posedge clk or negedge rst)
begin 
     if(!rst)
             curent_state <= ideal;
     else
             curent_state <= next_state;
end

// next_state_logic 
always @(*)
begin 
     case(curent_state)
      ideal :          begin
                             if(!data_valid)
                                     next_state = ideal;
                             else
                                     next_state = start_bit; 
                       end
                        
                        
                             
      start_bit :       begin 
                                    next_state = ser_data;
                        end
                              
                   
      ser_data :        begin
                              if(count !=4'b1000)
                                      next_state = ser_data;
                              else if (par_en)        
                                      next_state = par_bit;
                              else
                                      next_state = ideal ;
                        end
                        
                        
      par_bit :         begin 
                              if(count ==4'b1010)
                                      next_state = par_bit ;
                              else
                                      next_state = stop_bit;
                        end
                        
                        
      stop_bit :        begin 
                              if (data_valid && ser_done)
                                      next_state = start_bit ;
                              else
                                      next_state = ideal ;
                        end
                        
                        
      default :         begin
                              next_state = ideal;
                        end                
    endcase
end

// output_logic

always @(*)
begin
  busy       = 1'b0;
  ser_en     = 1'b0;
  par_en_out = 1'b0;
  mux_sel    = 2'b01;
  start_bit_out  = 'b0;
  stop_bit_out   = 'b1;
  
     case(curent_state)
       ideal :          begin
                              busy        = 1'b0;
                              ser_en      = 1'b0;
                              par_en_out  = 1'b0;
                              mux_sel     = 2'b01;
                        end 
                        
                      
       start_bit :      begin 
                              busy       = 1'b1;
                              ser_en     = 1'b1;
                              par_en_out = 1'b1;
                              mux_sel = 2'b00;
                        end
                        
                      
       ser_data :       begin
                              busy    = 1'b1;
                              mux_sel = 2'b10;
                        end   
                        
                        
       par_bit :       begin 
                                busy    = 1'b1;
                                mux_sel = 2'b11;
                       end            
                       
                       
                       
       stop_bit :      begin 
                                busy    = 1'b0;   
                                mux_sel = 2'b01;
                       end           
                       
                       
       default :       begin
                               busy    = 1'b0;
                               ser_en  = 1'b0;
                               par_en_out = 1'b0;
                               mux_sel = 2'b10;   
                              //* ser_done = 1'b0; 
                       end           
 endcase
end

always @(posedge clk or negedge rst)
begin
      if(!rst)
          count <= 4'b0000;
      else if (busy)
          count <= count + 1'b1;
      else 
          count <= 4'b0000;
end

endmodule