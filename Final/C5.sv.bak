module C5_rom (
input clk,
input [11:0] addr,
output logic [7:0] q
)

logic [7:0] rom [2497];
always_ff @(posedge clk) begin
	q <= rom[addr];
end
initial begin $readmemh("C5.txt", rom); end
endmodule