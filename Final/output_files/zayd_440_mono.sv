module zayd_440_mono_rom (
input clk,
input [6:0] addr,
output logic [7:0] q
)

logic [7:0] rom [100];
always_ff @(posedge clk) begin
	q <= rom[addr];
end
initial begin $readmemh("zayd_440_mono.txt", rom); end
endmodule