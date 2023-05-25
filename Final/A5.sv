module A5_rom (
input clk,
input [11:0] addr,
output logic [7:0] q
);

logic [7:0] rom [3594];
always_ff @(posedge clk) begin
	q <= rom[addr];
end
initial begin $readmemh("A5.txt", rom); end
endmodule