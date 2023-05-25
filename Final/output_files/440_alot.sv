module 440_alot_rom (
input clk,
input [13:0] addr,
output logic [7:0] q
)

logic [7:0] rom [8824];
always_ff @(posedge clk) begin
	q <= rom[addr];
end
initial begin $readmemh("440_alot.txt", rom); end
endmodule