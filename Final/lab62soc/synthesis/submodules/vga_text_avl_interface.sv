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

//logic [31:0] LOCAL_REG [`NUM_REGS]; // Registers
//put other local variables here
logic pixel_clk, blank, sync;
logic [9:0] DrawX, DrawY, Col, Row, CURR_REG, CURR_CHAR;
logic [7:0] char, BITS;
logic [3:0] COLOR_REG;
logic [31:0] REG_DATA, COLOR_DATA;
logic [10:0] FONT_INPUT;
logic [2:0] pixel;

//week 2
logic [11:0] ADDR, COLOR_ADDR;

//Declare submodules..e.g. VGA controller, ROMS, etc
//module  vga_controller ( input        Clk,       // 50 MHz clock
//                                      Reset,     // reset signal
//                         output logic hs,        // Horizontal sync pulse.  Active low
//								              vs,        // Vertical sync pulse.  Active low
//												  pixel_clk, // 25 MHz pixel clock output
//												  blank,     // Blanking interval indicator.  Active low.
//												  sync,      // Composite Sync signal.  Active low.  We don't use it in this lab,
//												             //   but the video DAC on the DE2 board requires an input for it.
//								 output [9:0] DrawX,     // horizontal coordinate
//								              DrawY );   // vertical coordinate
												  
vga_controller vga_controller(.Clk(CLK), .Reset(RESET), .hs(hs), .vs(vs), .pixel_clk(pixel_clk), .blank(blank), .sync(sync),
					.DrawX(DrawX), .DrawY(DrawY));
					
byte_enabled_simple_dual_port_ram memBlock(.waddr(AVL_ADDR), .raddr(ADDR), .raddr2(COLOR_ADDR), .be(AVL_BYTE_EN), .wdata(AVL_WRITEDATA), .we(AVL_WRITE), 
			.clk(CLK), .q(AVL_READDATA), .q2(COLOR_DATA));
//module font_rom ( input [10:0]	addr,
//						output [7:0]	data
//					 );
//font_rom font_row(.addr(FONT_INPUT), .data(BITS));
   
// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
//always_ff @(posedge CLK) begin
//if(AVL_CS==1'b1)
//begin
//	if(AVL_WRITE==1'b1)
//	begin
//		case(AVL_BYTE_EN)
//			4'b0001:
//				LOCAL_REG[AVL_ADDR][7:0]=AVL_WRITEDATA[7:0];
//			4'b0010:
//				LOCAL_REG[AVL_ADDR][15:8]=AVL_WRITEDATA[15:8];
//			4'b0100:
//				LOCAL_REG[AVL_ADDR][23:16]=AVL_WRITEDATA[23:16];
//			4'b1000:
//				LOCAL_REG[AVL_ADDR][31:24]=AVL_WRITEDATA[31:24];
//			4'b0011:
//				LOCAL_REG[AVL_ADDR][15:0]=AVL_WRITEDATA[15:0];
//			4'b1100:
//				LOCAL_REG[AVL_ADDR][31:16]=AVL_WRITEDATA[31:16];
//			4'b1111:
//				LOCAL_REG[AVL_ADDR]=AVL_WRITEDATA;
//			default: LOCAL_REG[AVL_ADDR]=LOCAL_REG[AVL_ADDR];
//		endcase
//	end
//	else if(AVL_READ==1'b1)
//	begin
//		AVL_READDATA=LOCAL_REG[AVL_ADDR];
//	end
//  if(RESET==1'b1)
//	begin
//		int i;
//		for(i=0;i<601;i++)
//		begin
//			LOCAL_REG[i]=32'h0;
//		end
//	end
//end  //end the Chip select
//end //end the always_ff


//handle drawing (may either be combinational or sequential - or both).
always_comb
begin
	 Col=DrawX[9:3]; //col=drawx/8
	 Row=DrawY[9:4];  //row=drawy/16
	
	// CURR_REG=(Col+Row*80)/4; //=AVL_ADDR
	 ADDR=(Col+Row*80)/2;
	
	 CURR_CHAR=(Col+Row*80);  //80 char per row
//end	
//	 //REG_DATA=LOCAL_REG[CURR_REG];
//always_ff @(posedge CLK)
//begin
		REG_DATA=AVL_READDATA;
//end
//
//always_comb
//begin
	case(CURR_CHAR[0])
		1'b0: char=REG_DATA[15:8];
		1'b1: char=REG_DATA[31:24];
		default: char=REG_DATA[15:8]; //wont get here
	endcase


	 FONT_INPUT=16*char[6:0] + DrawY[3:0];      				//should be char[6:0]
	//BITS has been updated 10010000
	 pixel= 7- DrawX[2:0];
	 
	 //COLOR_REG = LOCAL_REG[`CTRL_REG];
end

always_ff @(posedge pixel_clk)
begin
//	case(CURR_CHAR[0])
//		1'b0: COLOR_REG = AVL_READDATA[7:0];
//		1'b1: COLOR_REG = AVL_READDATA[23:16];
//	endcase
	
//	if(BITS[pixel] == 1'b1 ^ char[7])
//	begin
//		COLOR_ADDR = 3'h800 + COLOR_REG[7:4]
//	end

if(CURR_CHAR[0] == 1'b0)
begin
	if(BITS[pixel] == (1'b1 ^ char[7]))
	begin
	COLOR_REG = AVL_READDATA[7:4];
	end
	else
	begin
	COLOR_REG = AVL_READDATA[3:0];
	end
end
else
begin
	if(BITS[pixel] == (1'b1 ^ char[7]))
	begin
	COLOR_REG = AVL_READDATA[23:20];
	end
	else
	begin
	COLOR_REG = AVL_READDATA[19:16];
	end
end

COLOR_ADDR = 3'h800 + COLOR_REG;	
	
end

always_ff @(posedge pixel_clk)
begin
	 if(blank)
	 begin
		 if(BITS[pixel]==(1'b1 ^ char[7]))									//XOR char[7]
		 begin
			if(COLOR_REG % 2 == 0)
			begin
				red= COLOR_DATA[12:9];
				green=COLOR_DATA[8:5];
				blue=COLOR_DATA[4:1];
			end
			else
			begin
				red= COLOR_DATA[24:21];
				green=COLOR_DATA[20:17];
				blue=COLOR_DATA[16:13];
			end
		 end
		 else
		 begin
			if(COLOR_REG % 2 == 0)
			begin
				red= COLOR_DATA[12:9];
				green=COLOR_DATA[8:5];
				blue=COLOR_DATA[4:1];
			end
			else
			begin
				red= COLOR_DATA[24:21];
				green=COLOR_DATA[20:17];
				blue=COLOR_DATA[16:13];
			end
		 end
	end
	else
	begin
		red=0;
		green=0;
		blue=0;
	end
	 
end


endmodule
