module PCU (	input Clk, LD_PC, Reset,
						input [1:0] Sel_PC,
						input [15:0] Bus_In, Addr_In,
						output logic [15:0] PC_Out);
						
	logic [15:0] pc_in;
						
	reg_16 pcr (.*, .Load(LD_PC), .Data_in(pc_in), .Data_out(PC_Out));
	
	always_comb begin
		unique case (Sel_PC)
			2'b00		:	pc_in = PC_Out + 1;
			2'b01		:	pc_in = Addr_In;
			2'b10		:	pc_in = Bus_In;
			default	:	pc_in = PC_Out;
		endcase
	end
endmodule