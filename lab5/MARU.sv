module MARU (	input Clk, LD_MAR, Reset,
					input [15:0] MAR_In,
					output [15:0] MAR_Out);
	
	reg_16 mar_ur	(.*, .Load(LD_MAR), .Data_in(MAR_In), .Data_out(MAR_Out));
	
endmodule
module b_unit	(	input [15:0] Bus_In, IR,
							input Clk, Reset, LD_CC, LD_BEN,
							output logic BEN_Out);
	
	logic [2:0] n_z_p, nzp_out;
	logic	b;
	
	ff	NZPff[2:0] (.*, .Load(LD_CC), .Data_in(n_z_p), .Data_out(nzp_out));
	ff bff (.*, .Load(LD_BEN), .Data_in(b), .Data_out(BEN_Out));
	
	always_comb begin
		if (Bus_In[15] == 1'b1)
			n_z_p = 3'b100;
		else if (Bus_In == 16'h0000)
			n_z_p = 3'b010;
		else
			n_z_p = 3'b001;
			
		b = (nzp_out[0]&IR[9])|(nzp_out[1]&IR[10])|(nzp_out[2]&IR[11]);
		
	end
endmodule
