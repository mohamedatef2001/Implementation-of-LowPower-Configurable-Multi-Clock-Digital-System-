module CMP_UNIT #(parameter width = 16)
  (
  input wire [width-1:0] a, b ,
  input wire [3:0] alu_fun ,
  input wire clk , cmp_enable , rst ,
  output reg [width-1:0] cmp_out ,
  output reg cmp_flag
  );
  
  //########################################
  always @ (posedge clk or negedge rst )
  if (!rst)
    begin
    cmp_out <='b0;
    cmp_flag <=1'b0;
    end
    else
    begin
      if (cmp_enable)
        begin
          casex (alu_fun)
            'bxx00 :     /*NOPE*/
            begin
              cmp_out <= 'b0;
              cmp_flag <= 1'b1;
            end 
//#####################################################            
             'bxx01 :   /*CMP A=B*/
              begin
                if (a==b)
                  begin
                    cmp_out <= 'b1;
                    cmp_flag <= 1'b1;
                  end
                else
                  begin
                    cmp_out <= 'b0;
                    cmp_flag <= 1'b0;
                  end
                end
//#######################################################                
              'bxx10 : /*CMP A>B*/
              begin
                if(a>b)
                  begin
                    cmp_out <= 'b1;
                    cmp_flag <= 1'b1;
                  end
                else
                  begin
                    cmp_out <= 'b0;
                    cmp_flag <= 1'b0;
                  end
                end
//#######################################################                
                'bxx11 : /*CMP A<B*/
                begin
                  if(a<b)
                    begin
                      cmp_out <= 'b1;
                      cmp_flag <= 1'b1;
                    end
                  else
                    begin
                      cmp_out <= 'b0;
                      cmp_flag <= 1'b0;
                    end
                  end
//#######################################################                  
                default :
                begin
                  cmp_out <= 'b0;
                  cmp_flag <= 1'b0;
                end
              endcase
            end
          else
            begin
              cmp_flag <= 1'b0;
              cmp_out <='b0;
            end
          end
          endmodule
                    
                    
                