module Processor ( input Clk, Reset, Run, ClrALDB,
					input [7:0] S,
					output logic [7:0] Aval, Bval,
				output logic [6:0] HEX0, 
										 HEX1, 
										 HEX2, 
										 HEX3,
					output logic X);
	logic ResetOut, Run_H;
		logic Shift_Enable, addsub,clearXandA, clearB, loadA, loadB,loadX;
		logic [7:0] A, B;
		logic [8:0] Sum;
		logic [7:0] SW;
		logic load;
		
		data d (.Din(Sum[8]),
							.Clk(Clk),
							.reset(clearXandA),
							.Dout(X));
							
		ADDER9 adder( .A(A),
							  .B(SW),
							  .cin(addsub),
							  .S(Sum),
							  .cout(x));
							  
module ADDER9 (input [8:0] A, B,
 input cin,
 output logic [8:0] S,
output logic cout);

reg_8 reg_One (.Clk(Clk),
						.Reset(clearXandA),
						.Load(loadA),
						.Shift_En(Shift_Enable),
						.Shift_In(X),
						.out( load),
						.Data_Out(A));
						
		reg_8 reg_Two (.Clk(Clk),
						.Reset(clearB),
						.load(loadB),
						.Shift_En(Shift_Enable),
						.Shift_In(load),
						.Data_Out(B));	
					
		reg_1 reg_x (.Ckl(Clk),
							.Reset(clearXandA),
							.D_in(X),
							
				
		control cu (.Run(Run_H),
									.Reset(Reset),
									.Clk(Clk),
									.M(B[0]),
									.Shift_En(Shift_Enable),
									.Sub(addsub),
									.ClearXandA(clearXandA),
									.LoadB(loadB),
									.LoadA(loadA),
									.ResetOut(clearB));
											  
		HexDriver		AHex0 (
								.In0(A[3:0]),
								.Out0(HEX0) );
								
		HexDriver		AHex1 (
								.In0(B[3:0]),
								.Out0(HEX1) );
								
		HexDriver		BHex0 (
								.In0(A[7:4]),
								.Out0(HEX2) );
								
		HexDriver		BHex1 (
								.In0(B[7:4]),
								.Out0(HEX3) );
		
		HexDriver		BHex2 (
								.In0(Out[11:8]),
								.Out0(HEX4) );
								
		HexDriver		BHex3 (
								.In0(Out[15:12]),
								.Out0(HEX5) );
								
	sync syncOne[2:0] (Clk, {ResetOut,Run_H}, {ResetOut, Run_H});
	sync syncTwo[7:0] (Clk, S, SW);

		
endmodule

module data(
				input logic Din,
				input logic Clk, reset, load,
				output logic Dout);
				
				always_ff @ (posedge Clk)
				
				begin
					if(reset)
						Dout <= 0;
					else if (load)
						Dout <= Din;
				end
	
	endmodule