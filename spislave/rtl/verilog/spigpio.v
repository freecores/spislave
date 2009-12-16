// RTL program for SPI GPIO -- shift 8 bit register

`define		P0_P9_OP	8'b10101010 //0xAA
`define		P0_P3_OP	8'b11111111 //0xFF
`define		P4_P7_OP	8'b11111110 //0xFE
 
module spigpio(clk, cs, sr_in, gpioout, sr_out);
  
	input clk, cs;
	input sr_in;
	output sr_out;
	output [7:0] gpioout;

	reg [7:0] gpioout;
	reg sr_out;
	
	wire rw;
	reg [7:0] sr;

	assign rw = sr[7];	
	
	always@(posedge clk )
	begin
		if (cs == 1'b0)
		begin 
			sr_out <= sr[7];
			sr[7:1] <= sr[6:0];
			sr[0] <= sr_in;
		end 		
		
		if (cs == 1'b1)
		begin 
		
			if (rw == 1'b1)
			begin 
			
				case (sr)
				`P0_P9_OP : gpioout[7:0] <= { sr[0], sr[1], sr[2], sr[3],
							      sr[4], sr[5], sr[6], sr[7]};
				`P0_P3_OP : gpioout[3:0] <= {sr[0], sr[1], sr[2], sr[3]};
				`P4_P7_OP : gpioout[7:4] <= { sr[4], sr[5], sr[6], sr[7]};
				default   : gpioout[0] <= sr[0];
				endcase	
			end
	 	end
	end
endmodule
