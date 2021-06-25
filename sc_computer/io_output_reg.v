module io_output(addr,datain,write_io_enable,io_clk,out_port);
	input 	[31:0] 	addr,datain;
	input 			write_io_enable,io_clk;
	output 	[31:0]	out_port;
	
	reg 	[31:0]	out_port;
	
	always @ (posedge io_clk)
	begin
		if (write_io_enable == 1)
			case (addr[7:2])
				6'b100000: out_port = datain;
				6'b100001: out_port = datain;
				6'b100010: out_port = datain;
			endcase
	end
endmodule
