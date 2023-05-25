module Gb4_rom (
input clk,
input [14:0] addr,
output logic [7:0] q
)

logic [7:0] rom [22476];
always_ff @(posedge clk) begin
	q <= rom[addr];
end
initial begin $readmemh("Gb4.txt", rom); end
endmodule