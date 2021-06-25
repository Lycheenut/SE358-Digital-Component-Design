`timescale 1ps/1ps

module pl_computer_sim;
	reg            resetn_sim;
   reg            clock_sim;
	reg            mem_clock_sim;
	reg    [31:0]  in_port0_sim;
	reg    [31:0]  in_port1_sim;
 
	wire   [31:0]  pc_sim,inst_sim,ealu_sim,malu_sim,walu_sim;
   wire   [31:0]  out_port0_sim,out_port1_sim,out_port2_sim;
   wire   [31:0]  mem_dataout_sim;            // to check data_mem output
   wire   [31:0]  io_read_data_sim;

   wire           wmem_sim;   // connect the cpu and dmem. 

	pipeline_computer_main pl_computer(resetn_sim,clock_sim,mem_clock_sim, pc_sim,inst_sim,ealu_sim,malu_sim,walu_sim,
	out_port0_sim,out_port1_sim,out_port2_sim,in_port0_sim,in_port1_sim,mem_dataout_sim,io_read_data_sim);
	
	initial
      begin
			clock_sim = 1;
         while (1)
            #2  clock_sim = ~clock_sim;
      end

	initial
      begin
         mem_clock_sim = 1;
         while (1)
            #1  mem_clock_sim = ~ mem_clock_sim;
      end

	initial
      begin
         resetn_sim = 0;            // 低电平持续10个时间单位，后一直为1。
         while (1)
            #5 resetn_sim = 1;
      end
	 
	initial
	   begin
		   in_port0_sim = 0;
			in_port1_sim = 0;
		end

   initial
      begin
		   $display($time,"resetn=%b clock_50M=%b  mem_clk =%b", resetn_sim, clock_sim, mem_clock_sim);
			# 125000 $display($time,"out_port0 = %b  out_port1 = %b  out_port2 = %b ", out_port0_sim,out_port1_sim,out_port2_sim);
      end

endmodule
