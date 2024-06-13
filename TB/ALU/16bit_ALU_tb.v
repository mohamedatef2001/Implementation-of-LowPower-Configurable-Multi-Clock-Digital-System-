module ALU_tb ();
  reg [15:0] A_tb , B_tb;
  reg  [3:0] ALU_FUN_tb;
  reg clk_tb;
  wire Arith_Flag_tb , Logic_Flag_tb , CMP_Flag_tb , Shift_Flag_tb;
  wire [15:0] ALU_OUT_tb ;
  
  ALU DUT (
  .A(A_tb),
  .B(B_tb),
  .ALU_FUN(ALU_FUN_tb),
  .clk(clk_tb),
  .Arith_Flag(Arith_Flag_tb),
  .Logic_Flag(Logic_Flag_tb),
  .CMP_Flag(CMP_Flag_tb),
  .Shift_Flag(Shift_Flag_tb),
  .ALU_OUT(ALU_OUT_tb)
  );
  
  always @ (posedge clk_tb)
  ALU_FUN_tb <= ALU_FUN_tb + 4'd1;
  
  /*at first posedge (after 5ns) ALU_FUN will be = don't care , so after 6 ns puts ALU_FUN =0 [Addition case] 
   ,at second posegde ALU_FUN will be = 1 [Subtraction case] and so on
  */
  always #5000 clk_tb=!clk_tb;
  
  initial 
    begin 
     $dumpfile("ALU_tb.vcd");
     $dumpvars;
     clk_tb = 1'd0;
     A_tb = 16'b1;
     B_tb = 16'b1;
     //###################################
     $display ("test 1");                 // Addition , Arith_Flag = 1
     #6000         
     ALU_FUN_tb = 4'd0;                   
     #4000
     if (ALU_OUT_tb == 16'd2 && Arith_Flag_tb )
       $display ("test 1 pass ");
     else 
       $display ("test 1 filed");
     //###################################
     $display ("test 2");                 // Subtraction , Arith_Flag = 1  
     #10000                              
     if(ALU_OUT_tb== 16'd0 && Arith_Flag_tb)
       $display ("test pass");
     else
       $display ("test filed");
    #10000
    //##################################
    $display ("test 3");                // Multiplication , Arith_Flag = 1 
    if(ALU_OUT_tb== 16'd1 && Arith_Flag_tb )
      $display ("test  pass ");
    else
      $display ("test filed");
    #10000
    //#################################
    $display ("test 4");               // Division   , Arith_Flag = 1 
    if(ALU_OUT_tb== 16'd1 && Arith_Flag_tb)
       $display ("test pass ");
     else
       $display ("test filed");
      #10000
     //###############################
     $display ("test 5");             // AND , Logic_Flag = 1
      if(ALU_OUT_tb== 16'd1 && Logic_Flag_tb )
        $display ("test  pass ");
      else
        $display ("test filed");
      #10000
      //##############################
      $display ("test 6");            // OR , Logic_Flag = 1
      if(ALU_OUT_tb== 16'd1 && Logic_Flag_tb )
        $display ("test  pass ");
      else
        $display ("test filed");
      #10000
      //#############################
      $display ("test 7");           // NAND , Logic_Flag = 1
      if(ALU_OUT_tb== 16'b1111111111111110 && Logic_Flag_tb )
        $display ("test  pass ");
     else
       $display ("test filed");
      #10000
      //############################
      $display ("test 8");          // NOR , Logic_Flag = 1
      if(ALU_OUT_tb== 16'b1111111111111110 && Logic_Flag_tb )
        $display ("test  pass ");
      else
        $display ("test filed");
      #10000
      //############################
      $display ("test 9");          // XOR , Logic_Flag = 1
      if(ALU_OUT_tb== 16'd0 && Logic_Flag_tb)
         $display ("test  pass ");
       else
          $display ("test filed");
      #10000
      //############################
      $display ("test 10");         // XNOR , Logic_Flag = 1
      if(ALU_OUT_tb== 16'b1111111111111111 && Logic_Flag_tb )
        $display ("test  pass ");
      else
        $display ("test filed");
      #10000
      //############################
      $display ("test 11");          // A==B , CMP_Flag = 1
      if(ALU_OUT_tb== 16'd1 && CMP_Flag_tb)
        $display ("test  pass ");
      else
        $display ("test filed");
      #10000
      //#############################
      $display ("test 12");          // A>B , CMP_Flag = 1
      if(ALU_OUT_tb== 16'd0 && CMP_Flag_tb )  
        $display ("test  pass ");
      else
        $display ("test filed");
      #10000
      //#############################
      $display ("test 13");          // A<B , CMP_Flag = 1
      if(ALU_OUT_tb== 16'd0 && CMP_Flag_tb )  
        $display ("test  pass ");
      else
        $display ("test filed");
      #10000
      //#############################
      $display ("test 14");          // A>>1 , Shift_Flag = 1
      if(ALU_OUT_tb== 16'd0 && Shift_Flag_tb )
        $display ("test  pass ");
      else
        $display ("test filed");
      #10000
      //#E##########################
      $display ("test 15");          // A<<1 , Shift_Flag = 1
      if(ALU_OUT_tb== 16'd2 && Shift_Flag_tb  )     
        $display ("test  pass ");
      else
        $display ("test filed");
      $finish;
      end
      endmodule