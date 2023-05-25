/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x0257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

IVn = Draw inverse glyph
CODEn = Glyph code from IBM codepage 437

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]

VSYNC signal = bit which flips on every Vsync (time for new frame), used to synchronize software
BKG_R/G/B = Background color, flipped with foreground when IVn bit is set
FGD_R/G/B = Foreground color, flipped with background when Inv bit is set

************************************************************************/
`define NUM_REGS 601 //80*30 characters / 4 characters per register
`define CTRL_REG 600 //index of control register

module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [11:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

logic [31:0] VRAM_out;
logic [31:0] Palette	[8];
	logic pixel_clk, blank, sync;
	logic [9:0] DrawX, DrawY;
	logic [7:0] c;
	logic [11:0]a;
	logic [10:0]fa;
	logic [7:0]data;
	logic on;
	logic [3:0] FGD_R, FGD_G, FGD_B, BKG_R, BKG_G, BKG_B;
	logic twochar;
	logic IV;
	logic [6:0]CODE;
	logic [3:0] FGD_IDX;
	logic [3:0] BKG_IDX;

//Declare submodules..e.g. VGA controller, ROMS, etc
	font_rom fontrom(.addr(fa), .data(data));  
	vga_controller v(.Clk(CLK), .Reset(RESET), .hs(hs), .vs(vs), .pixel_clk(pixel_clk), .blank(blank), .sync(sync), .DrawX(DrawX), .DrawY(DrawY));
   VRAM onchip	(
		.clock(CLK), 
		.address_a(AVL_ADDR),
		.byteena_a(AVL_BYTE_EN), 
		.data_a(AVL_WRITEDATA),
		.rden_a(AVL_READ & AVL_CS), 
		.wren_a(AVL_WRITE & AVL_CS),
		.q_a(AVL_READDATA),
		.address_b(ac[11:1]), 
		.byteena_b(), 
		.data_b(), 
		.rden_b(1'b1), 
		.wren_b(1'b0), 
		.q_b(VRAM_out)
	);

always_ff @(posedge CLK) begin
if( AVL_CS & AVL_WRITE & AVL_ADDR[11])
	begin
		Palette[AVL_ADDR[2:0]] <= AVL_WRITEDATA;
	end

end

always_comb begin
	twochar = a[0];
	if (twochar == 1)
		begin
		IV = VRAM_out[31];
		CODE = VRAM_out[30:24];
		FGD_IDX = VRAM_out[23:20];
		BKG_IDX = VRAM_out[19:16];
		end
	else
		begin
		IV =  VRAM_out[15];
		CODE = VRAM_out[14:8];
		FGD_IDX = VRAM_out[7:4];
		BKG_IDX = VRAM_out[3:0];
		end


	if (FGD_IDX[0]==0)
		begin
		FGD_B = Palette[FGD_IDX[3:1]][4:1];
		FGD_G = Palette[FGD_IDX[3:1]][8:5];
		FGD_R = Palette[FGD_IDX/2][12:9];
		end
	else
		begin
		FGD_B = Palette[FGD_IDX/2][16:13];
		FGD_G = Palette[FGD_IDX/2][20:17];
		FGD_R = Palette[FGD_IDX/2][24:21];
		end

	if(BKG_IDX[0]==0)
		begin
		BKG_B = Palette[BKG_IDX/2][4:1];
		BKG_G = Palette[BKG_IDX/2][8:5];
		BKG_R = Palette[BKG_IDX/2][12:9];
		end
	else
		begin
		BKG_B = Palette[BKG_IDX/2][16:13];
		BKG_G = Palette[BKG_IDX/2][20:17];
		BKG_R = Palette[BKG_IDX/2][24:21];
		end

a = ((DrawX[9:3])) + ((DrawY[9:4])*80);

fa = ((CODE[6:0]*16) + DrawY[3:0]);
on = data[7-DrawX[2:0]];
end

always_ff @(posedge pixel_clk)
begin
	if(~blank)
		begin
			red <= 4'b0;
			blue <= 4'b0;
			green <= 4'b0;
		end
	else if(on ^ IV)
		begin
			red <= FGD_R;
			green <= FGD_G;
			blue <= FGD_B;
		end
	else
		begin
			red <= BKG_R;
			green <= BKG_G;
			blue <= BKG_B;
		end

end
endmodule