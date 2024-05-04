module ARITHMETIC_UNIT #(parameter width = 32)
  (
  input wire [width-17:0] a, b ,
  input wire [3:0] alu_fun ,
  input wire clk , arith_enable , rst ,
  output reg [width-1:0] arith_out ,
  output reg arith_flag , carry_out
  );
  always @ (posedge clk or negedge rst )
  if (!rst)
    begin
    arith_out <=1'b0;
    carry_out <= 1'b0;
    arith_flag <=1'b0;
    end
  else
    begin
      if (arith_enable)
        begin
        casex (alu_fun)
        4'bxx00 : 
        begin
        {carry_out , arith_out } <= a + b ;
        arith_flag <= 1'b1;
        end
        4'bxx01: 
        begin
        {carry_out , arith_out } <= a - b ;
        arith_flag <= 1'b1;
        end
        4'bxx10 : 
        begin
        {carry_out , arith_out } <= a * b ;
        arith_flag <= 1'b1;
        end
        4'bxx11 : 
        begin
        {carry_out , arith_out } <= a / b ;
        arith_flag <= 1'b1;
        end
        default :
        begin 
          arith_out <= 1'b0;
          arith_flag <= 1'b0;
          carry_out<= 1'b0;
        end
      endcase
    end
    else
      begin
      arith_flag <= 1'b0;
      arith_out <='b0;
      carry_out <= 1'b0;
    end
  end 
  endmodule
