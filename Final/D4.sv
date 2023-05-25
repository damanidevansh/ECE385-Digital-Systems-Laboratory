module D4_rom (
input clk,
input [14:0] addr,
output logic [7:0] q
);

logic [7:0] rom [1000];
always_ff @(posedge clk) begin
	q <= rom[addr];
end
initial begin $readmemh("D4.txt", rom); end
endmodule