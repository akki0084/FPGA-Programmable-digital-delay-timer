
`include "packet.sv"
`include "generator.sv"
`include "driver.sv"
class environment;
  
  //generator and driver instance
  generator gen;
  driver    driv;
  
  //mailbox handle's
  mailbox m_box1;
  
  //virtual interface
  virtual intf vif;
  
  //constructor
  function new(virtual intf vif);
    //get the interface from test
    this.vif = vif;
    
    //creating the mailbox (Same handle will be shared across generator and driver)
    m_box1 = new();
    
    //creating generator and driver
    gen  = new(m_box1);
    driv = new(vif,m_box1);
  endfunction
  
  //
  task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork 
    gen.main();
    driv.main();
    join_any
  endtask
  
  task post_test();
    wait(gen.ended.triggered);
    wait(gen.repeat_count == driv.no_packets);
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask
  
endclass