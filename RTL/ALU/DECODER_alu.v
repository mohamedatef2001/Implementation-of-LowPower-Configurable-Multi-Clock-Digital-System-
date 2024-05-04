module DECOODER 
  (
  input wire [3:0] alu_fun ,
  output reg arith_enable , logic_enable , shift_enable , cmp_enable 
  );
  
  
always @ (*)
      begin
          casex (alu_fun)
            4'b00xx :     /*arith_en=1*/
            begin
              arith_enable =1'b1;
              logic_enable =1'b0;
              shift_enable =1'b0;
              cmp_enable =1'b0;
            end
//##########################################
            4'b01xx :   /*logic_en=1*/
            begin
              arith_enable =1'b0;
              logic_enable =1'b1;
              shift_enable =1'b0;
              cmp_enable =1'b0;
            end
 //##########################################           
            4'b10xx:    /*cmp_en=1*/
            begin
              arith_enable =1'b0;
              logic_enable =1'b0;
              shift_enable =1'b0;
              cmp_enable =1'b1;
            end
//#########################################
             4'b11xx:     /*shift_en=1*/
            begin
              arith_enable =1'b0;
              logic_enable =1'b0;
              shift_enable =1'b1;
              cmp_enable =1'b0;
            end
           default :
                begin
                  arith_enable =1'b0;
                  logic_enable =1'b0;
                  shift_enable =1'b0;
                  cmp_enable =1'b0;
                end
          endcase
        end
      endmodule          