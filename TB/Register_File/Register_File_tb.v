`timescale 1us/1ns;
module Register_File_tb #(parameter width = 16, parameter depth = 8, parameter address = 3 )();
  
reg [width-1:0] WrData_tb ;
reg [address-1:0] Address_tb;
reg WrEn_tb;
reg RdEn_tb;
reg CLK_tb;
reg RST_tb;
wire [width-1:0] RdData_tb; 
Regiser_File DUT (
.WrData(WrData_tb),
.Address(Address_tb),
.WrEn(WrEn_tb),
.RdEn(RdEn_tb),
.CLK(CLK_tb),
.RST(RST_tb),
.RdData(RdData_tb)
);

always @ (posedge CLK_tb)
begin
WrData_tb <= WrData_tb +16'b1;
Address_tb <=Address_tb +3'b1;
end

always #5 CLK_tb=!CLK_tb;

initial 
begin
$dumpfile("Register_File_tb.vcd");
$dumpvars;
WrData_tb = 16'b0;
CLK_tb = 1'b0;
WrEn_tb = 1'b1;
RdEn_tb = 1'b0 ;
RST_tb = 1'b1 ;
//####################################
$display ("test 1");
#6
Address_tb = 3'b0;
#4
if (WrData_tb == 16'b1)
  $display ("test 1 pass ");
else
  $display ("test 1 filed ");
//###################################
$display ("test 2");
#10
if (WrData_tb == 16'd2)
  $display ("test 2 pass ");
else
  $display ("test 2 filed ");
#70
WrEn_tb = 1'b0;
RdEn_tb = 1'b1 ;
//###################################
$display ("test 3");
#10
if (RdData_tb == 16'd1)
  $display ("test 3 pass ");
else
  $display ("test 3 filed ");
//###################################
$display ("test 4");
#50
if (RdData_tb == 16'd6)
  $display ("test 4 pass ");
else
  $display ("test 4 filed ");
//###################################
$display ("test 5");
#10
RST_tb = 1'b0 ;
#10
if (RdData_tb == 16'd0)
  $display ("test 5 pass ");
else
  $display ("test 5 filed ");
$finish;
end
endmodule