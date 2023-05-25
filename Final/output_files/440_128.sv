module 440_128_rom (
input clk,
input [6:0] addr,
output logic [7:0] q
)

logic [7:0] rom [128];
always_ff @(posedge clk) begin
	q <= rom[addr];
end
initial begin $readmemh("440_128.txt", rom); end
endmodule