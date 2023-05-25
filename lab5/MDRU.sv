module MDRU (	input Clk, LD_MDR, Reset,
					input MIO_EN,
					input [15:0] Bus_In, MEM_In,
					output logic [15:0] MDR_Out);
					
	logic [15:0] mdin;
	
	reg_16 mdru (.*, .Load(LD_MDR), .Data_in(mdin), .Data_out(MDR_Out));
	
	always_comb begin
		if (MIO_EN)
			mdin = MEM_In;
		else
			mdin = Bus_In;
	end
endmodule