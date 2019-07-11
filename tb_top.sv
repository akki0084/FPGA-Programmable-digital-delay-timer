`include "interface.sv"

//-------------------------[NOTE]---------------------------------
//Particular testcase can be run by uncommenting, and commenting the rest
`include "test.sv"
//`include "directed_test.sv"
//----------------------------------------------------------------

module tb_top;
  
  //clock and reset signal declaration
  bit clk;
  bit reset;
  bit trigger;

  //clock ang trigger generation
  always #5 clk = ~clk;
  always #20 trigger = ~trigger;

  //reset Generation
  initial begin
    reset = 1;
    #5 reset =0;
  end
 
  //creatinng instance of interface, inorder to connect DUT and testcase
  intf i_intf(clk,reset, trigger);
  
  //Testcase instance, interface handle is passed to test as an argument
  test t1(i_intf);
  
  //DUT instance, interface signals are connected to the DUT ports
  delay_timer DUT (
    .clk(i_intf.clk),
    .reset(i_intf.reset),
    .Wb(i_intf.Wb),
    .mode_a(i_intf.mode_a),
     .mode_b(i_intf.mode_b),
    .trigger(i_intf.trigger),
    .delay_out(i_intf.delay_out)
   );
  
  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
