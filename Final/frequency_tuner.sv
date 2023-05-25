module freq (
	//input [11:0] Din,
	//input [10:0] freq_desired,
	input LRCLK,
	output [23:0] Freq);

always_ff @(posedge LRCLK)
begin
	Freq[23:0] <= Freq[23:0] + 167200; //freq_desired*380;
end
endmodule