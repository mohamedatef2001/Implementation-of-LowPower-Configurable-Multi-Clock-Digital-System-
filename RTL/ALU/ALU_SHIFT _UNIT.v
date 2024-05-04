module SHIFT_UNIT #(parameter width = 16)
  (
  input wire [width-1:0] a, b ,
  input wire [3:0] alu_fun ,
  input wire clk , shift_enable , rst ,
  output reg [width-1:0] shift_out ,
  output reg shift_flag
  );
  
  //#################################
  always @ (posedge clk or negedge rst )
  if (!rst)
    begin
    shift_out <='b0;
    shift_flag <=1'b0;
    end
    else
    begin
      if (shift_enable)
        begin
          casex (alu_fun)
            'bxx00 :     /*shift A>>1*/
            begin
              shift_out <=  a>>1;
              shift_flag <= 1'b1;
            end 
//########################################            
            'bxx01 :   /*shift A<<1*/
            begin
              shift_out <=  a<<1;
              shift_flag <= 1'b1;
            end
                
//###############################################                                
            'bxx10:    /*shift B>>1*/
            begin
              shift_out <=  b>>1;
              shift_flag <= 1'b1;
            end
//################################################
            'bxx11:     /*shift B<<1*/
            begin
              shift_out <=  b<<1;
              shift_flag <= 1'b1;
            end
          endcase
        end
      else
        begin
          shift_out <=  'b0;
          shift_flag <= 1'b0;
        end
      end
      endmodule          
  
