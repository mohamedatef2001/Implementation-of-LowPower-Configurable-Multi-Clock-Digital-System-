module Regiser_File 
#(parameter depth = 8,
  parameter width = 16,
  parameter address = 3 )
  //################################
(
input wire [width-1:0] WrData ,
input wire [address-1:0] Address,
input wire WrEn,
input wire RdEn,
input wire CLK,
input wire RST,
output reg [width-1:0] RdData
);
//##################################
reg [width-1:0] MEM [depth-1:0];
integer i = 0;
always @(posedge CLK or negedge RST)
begin 
  if(!RST)
    begin
      for (i=0;i<8;i=i+1)
      RdData[i]<='d0;
    end
  else
    begin
      if (WrEn && !RdEn)
        begin
          RdData <=16'b0;
          MEM[Address]<=WrData;
        end
      else if (!WrEn && RdEn)
        begin
        RdData <= MEM[Address];
        end
      else
        MEM[Address] <= 16'b0;
      end
    end
    endmodule
        