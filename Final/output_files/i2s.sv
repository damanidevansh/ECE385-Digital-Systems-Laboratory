module I2S
(
	input SCLK, LD,
	input [31:0] Din,
	output s);
	
logic [31:0] register;
always_ff @(posedge SCLK)
begin
if(LD)
begin
	register <= Din;
end
else
begin
	register <= {register[30:0], 1'b0};
end
end

assign s = register[31];
endmodule

//module I2S
//(
//	input SCLK, LRCLK,
//	input [31:0]Din,
//	output Dout
//);
//
//logic [31:0] rightreg;
//logic [31:0] leftreg;
////logic ARDUINO_IO;
//logic [5:0] ctr = 6'b000000;
////logic [31:0] looper = 32'b00000000000000000000000000000000;
////assign ctr = 0;
//
//always_ff @ (posedge SCLK)
//begin
//	if (LRCLK)
//	begin
//		leftreg <= Din;
//		Dout <= leftreg[ctr];
//		//ARDUINO_IO <= Dout;
//		//rightreg[31:1] <= rightreg[30:0];
////		if (looper < 4096)
////		begin
//		if (ctr < 32)
//		begin
////			rightreg[ctr+1] <= rightreg[ctr];
////		end
////		looper++;
////		end
////		if (ctr < 31)
////		begin
//		//rightreg = {rightreg[30:0],  1'b0};
//		ctr <= ctr+1;
//		end
//		if (ctr == 32)
//		begin
//		ctr <= 0;
//		end
//		//rightreg[0] <= 1'b0;
//	end
//	else
//		begin
//		//ARDUINO_IO <= Dout;
//		rightreg <= Din;
//		Dout <= rightreg[ctr];
//		if (ctr < 32)
//		begin
//		ctr <= ctr + 1;
//		end
//		if (ctr == 32)
//		begin
//		ctr <= 0;
//		end
//		//leftreg = {leftreg[30:0],  1'b0};
//		//leftreg[31:1] <= leftreg[30:0];
////		if (looper < 4096)
////		begin
////		if (ctr < 31)
////		begin
////			leftreg[ctr+1] <= leftreg[ctr];
////			ctr++;
////		end
////		looper++;
////		end
////		leftreg[0] <= 1'b0;
//	end
//	end
//endmodule