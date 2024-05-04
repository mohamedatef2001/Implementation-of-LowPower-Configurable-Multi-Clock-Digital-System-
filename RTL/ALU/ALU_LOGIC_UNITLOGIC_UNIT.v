module LOGIC_UNIT #(parameter width = 16)
  (
  input wire [width-1:0] a, b ,
  input wire [3:0] alu_fun ,
  input wire clk , logic_enable , rst ,
  output reg [width-1:0] logic_out ,
  output reg logic_flag
  );
  
  always @ (posedge clk or negedge rst )
  if (!rst)
    begin
    logic_out <='b0;
    logic_flag <=1'b0;
    end
    else
    begin
      if (logic_enable)
        begin
        casex (alu_fun)
        'bxx00 : 
        begin
        logic_out <= a & b ;
        logic_flag <=1'b1;
        end
        'bxx01 : 
        begin
        logic_out <= a | b ;
        logic_flag <=1'b1;
        end
        'bxx10 : 
        begin
        logic_out <= ~(a & b) ;
        logic_flag <=1'b1;
        end
        'bxx11 : 
        begin
        logic_out <= ~(a | b) ;
        logic_flag <=1'b1;
        end
        default :
        begin 
          logic_out <= 'b0;
          logic_flag <= 1'b0;
        end
      endcase
    end
    else
      begin
      logic_out <='b0;
      logic_flag<= 1'b0;
    end
  end 
  endmodule
