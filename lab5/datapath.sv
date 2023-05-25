module datapath 	( 	input Clk, Reset,
							input LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
							input GateMDR, GateALU, GatePC, GateMARMUX,
							input SR2MUX, ADDR1MUX, MARMUX,
							input MIO_EN, DRMUX, SR1MUX,
							input [1:0] PCMUX, ADDR2MUX, ALUK,
							input [15:0] MDR_In,
							output logic [15:0] MAR, MDR, IR,
							output logic BEN,
							output logic [9:0] LED);

	logic [3:0] Gate_Sel;
	logic [15:0] BusData;
	assign Gate_Sel = {GateMDR, GateALU, GatePC, GateMARMUX};
	
	logic [15:0] ALU, PC, Decoder;
	logic [15:0] SR1_Data, SR2_Data;
	logic [2:0] SR2;
	
	always_comb begin
		unique case (Gate_Sel)
			4'b1000	:	BusData = MDR;
			4'b0100	:	BusData = ALU;
			4'b0010	:	BusData = PC;
			4'b0001	:	BusData = Decoder;
			default	: 	BusData = 16'hX;
		endcase
	end
	
	PCU pc (.*, .Sel_PC(PCMUX), .Bus_In(BusData), .Addr_In(Decoder), .PC_Out(PC));
	MDRU mdr (.*, .Bus_In(BusData), .MEM_In(MDR_In), .MDR_Out(MDR));
	MARU mar (.*, .MAR_In(BusData), .MAR_Out(MAR));
	ir_unit ir (.*, .IR_In(BusData), .IR_Out(IR));
	Alu alu (.*, .IR_In(IR), .SR1_In(SR1_Data), .SR2_In(SR2_Data), .ALU_Out(ALU));
	Decoder decoder (.*, .IR_In(IR), .PC_In(PC), .SR1_In(SR1_Data), .Decoder_Out(Decoder));
	reg_file regfile (.*, .IR_in(IR), .Data_in(BusData), .SR1_out(SR1_Data), .SR2_out(SR2_Data));
	b_unit ben (.*, .Bus_In(BusData), .BEN_Out(BEN));
   ledu led (.*);
	
endmodule