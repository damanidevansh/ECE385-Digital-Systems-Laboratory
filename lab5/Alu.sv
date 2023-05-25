module Alu(input [15:0] IR_In, SR2_In, SR1_In,
							input [1:0]	ALUK,
							input SR2MUX,
							output logic [15:0] ALU_Out);
			
	logic [15:0] bin;
	
	always_comb begin
		if (SR2MUX)
			bin = {{11{IR_In[4]}}, IR_In[4:0]};
		else
			bin = SR2_In;
		unique case	(ALUK)
			2'b00		:	ALU_Out = SR1_In + bin;
			2'b01		:	ALU_Out = SR1_In & bin;
			2'b10		:	ALU_Out = ~SR1_In;
			2'b11		:	ALU_Out = SR1_In;
		endcase
	end
endmodule
module ir_unit (	input Clk, LD_IR, Reset,
				input [15:0] IR_In,
				output [15:0] IR_Out);
	reg_16 irr	(.*, .Load(LD_IR), .Data_in(IR_In), .Data_out(IR_Out));
endmodule
