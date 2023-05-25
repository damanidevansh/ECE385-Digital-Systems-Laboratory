//module image_rom (
//	input logic clock,
//	input logic [16:0] address,
//	output logic [3:0] q
//);
//
//logic [3:0] memory [0:76799] /* synthesis ram_init_file = "C:\\Users\\zacha\\Downloads\\Palettizer-main\\Palettizer-main\\image\\image.mif" */;
//
//always_ff @ (posedge clock) begin
//	q <= memory[address];
//end
//
//endmodule


module image_rom (
	input logic clock,
	input logic [17:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:201239] /* synthesis ram_init_file = "C:\\Users\\zacha\\Downloads\\Palettizer-main\\Palettizer-main\\image\\image.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
