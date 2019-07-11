class driver;
  
  //used to count the number of transactions
  int no_packets;
  
  //creating virtual interface handle
  virtual intf vif;
  
  //creating mailbox handle
  mailbox m_box1;
  
  //constructor
  function new(virtual intf vif,mailbox m_box1);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
    this.m_box1 = m_box1;
  endfunction
  
  //Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait(vif.reset);
    $display("[ DRIVER ] ----- Reset Started -----");
    vif.Wb <= 0;
    vif.mode_a <= 0;
vif.mode_b <= 0;
        wait(!vif.reset);
    $display("[ DRIVER ] ----- Reset Ended   -----");
  endtask
  
  //drivers the transaction items to interface signals
  task main;
    forever begin
      packet pkt;
      m_box1.get(pkt);
      @(posedge vif.clk);
      vif.Wb     <= pkt.Wb;
      vif.mode_a     <= pkt.mode_a;
      vif.mode_b     <= pkt.mode_b;
      @(posedge vif.clk);
      
      pkt.delay_out   = vif.delay_out;
      @(posedge vif.clk);
      pkt.display("[ Driver ]");
      no_packets++;
    end
  endtask
  
endclass
