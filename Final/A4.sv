module A4_rom (
input clk,
input [13:0] addr,
output logic [7:0] q
);

// N = 8824 > 2^13
logic [7:0] rom [1000]; // rom [4096];
always_ff @(posedge clk) begin
	q <= rom[addr];
end
initial begin $readmemh("A4.txt", rom); end
endmodule