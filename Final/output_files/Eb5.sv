module Eb5_rom (
input clk,
input [11:0] addr,
output logic [7:0] q
)

logic [7:0] rom [3411];
always_ff @(posedge clk) begin
	q <= rom[addr];
end
initial begin $readmemh("Eb5.txt", rom); end
endmodule