module HexDriver (	input				[3:0] In0,
							output logic	[6:0] Out0);
							
		always_comb
		begin
				unique case(In0)
						4'b0000	:	Out0 = 7'b1000000;
						4'b0001	:	Out0 = 7'b1111001;
						4'b0010	:	Out0 = 7'b0100100;
						4'b0011	:	Out0 = 7'b0110000;
						4'b0100	:	Out0 = 7'b0011001;
						4'b0101	:	Out0 = 7'b0010010;
						4'b0110	:	Out0 = 7'b0000010;
						4'b0111	:	Out0 = 7'b1111000;
						4'b1000	:	Out0 = 7'b0000000;
						4'b1001	:	Out0 = 7'b0010000; 
						4'b1010	:	Out0 = 7'b0001000; 
						4'b1011	:	Out0 = 7'b0000011;
						4'b1100	:	Out0 = 7'b1000110;
						4'b1101	:	Out0 = 7'b0100001;
						4'b1110	:	Out0 = 7'b0000110;
						4'b1111	:	Out0 = 7'b0001110;
						default   : Out0 = 7'bX;
				endcase
		end
endmodule