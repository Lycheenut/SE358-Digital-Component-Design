module alu (a,b,aluc,s,z);
   input  [31:0] a,b;
   input  [3:0]  aluc;
   output [31:0] s;
   output        z;
   reg    [31:0] s;
   reg           z;
	wire   [31:0] d;
	assign        d = a ^ b;
   always @ (a or b or aluc) 
      begin                                   // event
         casex (aluc)
             4'bx000: s = a + b;              //x000 ADD
				 4'bx100: s = a - b;              //x100 SUB
             4'bx001: s = a & b;					 //x001 AND
             4'bx101: s = a | b;              //x101 OR
             4'bx010: s = a ^ b;              //x010 XOR
             4'bx110: s = b << 16;		       //x110 LUI: imm << 16bit             
             4'b0011: s = $unsigned(b) << a;  //0011 SLL: rd <- (rt << sa)
             4'b0111: s = $unsigned(b) >> a;  //0111 SRL: rd <- (rt >> sa) (logical)
             4'b1111: s = $signed(b) >>> a;   //1111 SRA: rd <- (rt >> sa) (arithmetic)
				 4'b1011: begin				 //1011 HAMDIS: rd <- count(1, rt ^ rs)
				          s = d[0] + d[1] + d[2] + d[3] + d[4] + d[5] + d[6] + d[7];
				          end
             default: s = 0;
         endcase
         if (s == 0 )  z = 1;
            else z = 0;         
      end      
endmodule
