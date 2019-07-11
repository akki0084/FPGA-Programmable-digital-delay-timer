class generator;

rand packet pkt;
int repeat_count;

mailbox m_box1;

event ended;

 //constructor
  function new(mailbox m_box1);
    //getting the mailbox handle from env, in order to share the transaction packet between the generator and driver, the same mailbox is shared between both.
    this.m_box1 = m_box1;
  endfunction
  
  //main task, generates(create and randomizes) the repeat_count number of transaction packets and puts into mailbox
  task main();
    repeat(repeat_count) begin
    pkt = new();
    pkt.randomize(); //$fatal("Gen:: trans randomization failed");
      pkt.display("[ Generator ]");
      m_box1.put(pkt);
    end
    -> ended; //triggering indicatesthe end of generation
  endtask
  
endclass
