module Decoder (	input	[15:0] IR_In, PC_In, SR1_In,
						input [1:0] ADDR2MUX,
						input ADDR1MUX,
						output logic [15:0] Decoder_Out);

	logic [15:0] Adder1, Adder2;
	
	always_comb begin
		unique case	(ADDR2MUX)
			2'b00		:	Adder1 = 16'h0000;
			2'b01		:	Adder1 = {{10{IR_In[5]}}, IR_In[5:0]};
			2'b10		:	Adder1 = {{7{IR_In[8]}}, IR_In[8:0]};
			2'b11		:	Adder1 = {{5{IR_In[10]}}, IR_In[10:0]};
		endcase
		
		unique case (ADDR1MUX)
			1'b0		: 	Adder2 = PC_In;
			1'b1		:	Adder2 = SR1_In;
		endcase
		
		Decoder_Out = Adder1 + Adder2;
	end
endmodule