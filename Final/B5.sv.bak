module B5_rom (
input clk,
input [11:0] addr,
output logic [7:0] q
)

logic [7:0] rom [3898];
always_ff @(posedge clk) begin
	q <= rom[addr];
end
initial begin $readmemh("B5.txt", rom); end
endmodule