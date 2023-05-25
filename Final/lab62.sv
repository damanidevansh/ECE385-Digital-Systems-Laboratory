//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------

module lab62 (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 
		
//		input        i2c_0_i2c_serial_sda_in,        //        i2c_0_i2c_serial.sda_in
//		input        i2c_0_i2c_serial_scl_in,        //                        .scl_in
//		output       i2c_0_i2c_serial_sda_oe,        //                        .sda_oe
//		output       i2c_0_i2c_serial_scl_oe        //                        .scl_oe

);




logic Reset_h, vssig, blank, sync, VGA_CLK;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig;
	logic [3:0] Red, Blue, Green;
	logic [7:0] keycode;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red;
	assign VGA_B = Blue;
	assign VGA_G = Green;
	
logic [1:0]aud_mclk_ctr;
logic i2c_serial_scl_in;
logic i2c_serial_sda_in;
logic i2c_serial_scl_oe;
logic i2c_serial_adc_oe;

	
	
	lab62soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode),
		
		//I2C Peripherals
		.i2c_0_i2c_serial_sda_in(i2c_serial_sda_in),        //        i2c_0_i2c_serial.sda_in
		.i2c_0_i2c_serial_scl_in(i2c_serial_scl_in),
		.i2c_0_i2c_serial_sda_oe(i2c_serial_adc_oe),        //                        .sda_oe
		.i2c_0_i2c_serial_scl_oe(i2c_serial_scl_oe)
	 );
	 

assign ARDUINO_IO[3] = aud_mclk_ctr[1]; //generate 12.5MHz CODEC MCLK, code provided by Professor Chen in Lecture 24
always_ff @(posedge MAX10_CLK1_50)
begin
    aud_mclk_ctr <= aud_mclk_ctr + 1;
end

//assign ARDUINO_IO[2] = ARDUINO_IO[1]; // Audio Interface Ports, code provided by Professor Chen in Lecture 24
//assign ARDUINO_IO[1] = 1'bz;


assign i2c_serial_scl_in = ARDUINO_IO[15]; // 12C Serial Interface Connections, code provided by Professor Chen in Lecture 24
assign ARDUINO_IO[15] = i2c_serial_scl_oe ? 1'b0:1'bz;
assign i2c_serial_sda_in = ARDUINO_IO[14];
assign ARDUINO_IO[14] = i2c_serial_adc_oe ? 1'b0:1'bz;
//assign data_out = 1'b0;
//assign counter = 1'b10;

logic [31:0]I2S_Din;
logic I2S_Dout;
logic I2S_Dout1;
logic I2S_Dout2;

// I2S Pin Placements:
assign SCLK = ARDUINO_IO[5]; //(LRCLK * 64)
assign LRCLK = ARDUINO_IO[4]; //(44.1kHz, generated by SGTL5000)
//assign ARDUINO_IO[3] = MCLK; //(12.2MHz)
//assign I2S_Din = ARDUINO_IO[2];
//assign ARDUINO_IO[1] = I2S_Dout;
assign ARDUINO_IO[2] = I2S_Dout;
//assign ARDUINO_IO[1] = I2S_Dout;

logic [31:0] C4counter;
logic [31:0] Db4counter;
logic [31:0] D4counter;
logic [31:0] Eb4counter;
logic [31:0] E4counter;
logic [31:0] F4counter;
logic [31:0] Gb4counter;
logic [31:0] G4counter;
logic [31:0] Ab4counter;
logic [13:0] A4counter;
logic [31:0] Bb4counter;
logic [31:0] B4counter;
logic [7:0] c4_out;
logic [7:0] db4_out;
logic [7:0] d4_out;
logic [7:0] eb4_out;
logic [7:0] e4_out;
logic [7:0] f4_out;
logic [7:0] gb4_out;
logic [7:0] g4_out;
logic [7:0] ab4_out;
logic [7:0] a4_out;
logic [7:0] bb4_out;
logic [7:0] b4_out;
logic [31:0] C5counter;
logic [31:0] Db5counter;
logic [31:0] D5counter;
logic [31:0] Eb5counter;
logic [31:0] E5counter;
logic [31:0] F5counter;
logic [31:0] Gb5counter;
logic [31:0] G5counter;
logic [31:0] Ab5counter;
logic [13:0] A5counter;
logic [31:0] Bb5counter;
logic [31:0] B5counter;
logic [7:0] c5_out;
logic [7:0] db5_out;
logic [7:0] d5_out;
logic [7:0] eb5_out;
logic [7:0] e5_out;
logic [7:0] f5_out;
logic [7:0] gb5_out;
logic [7:0] g5_out;
logic [7:0] ab5_out;
logic [7:0] a5_out;
logic [7:0] bb5_out;
logic [7:0] b5_out;

//Counter Block
//using SCLK to increment the counter

always_ff @(posedge ARDUINO_IO[4])
begin
if (C4counter == 167)
begin
C4counter <= 0;
end
else
C4counter <= C4counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (Db4counter == 159)
begin
Db4counter <= 0;
end
else
Db4counter <= Db4counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (D4counter == 150)
begin
D4counter <= 0;
end
else
D4counter <= D4counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (Eb4counter == 142)
begin
Eb4counter <= 0;
end
else
Eb4counter <= Eb4counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (E4counter == 134)
begin
E4counter <= 0;
end
else
E4counter <= E4counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (F4counter == 126)
begin
F4counter <= 0;
end
else
F4counter <= F4counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (Gb4counter == 119)
begin
Gb4counter <= 0;
end
else
Gb4counter <= Gb4counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (G4counter == 113)
begin
G4counter <= 0;
end
else
G4counter <= G4counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (Ab4counter == 106)
begin
Ab4counter <= 0;
end
else
Ab4counter <= Ab4counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (A4counter == 100)
begin
A4counter <= 0;
end
else
A4counter <= A4counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (Bb4counter == 95)
begin
Bb4counter <= 0;
end
else
Bb4counter <= Bb4counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (B4counter == 89)
begin
B4counter <= 0;
end
else
B4counter <= B4counter + 1;
end

// higher
always_ff @(posedge ARDUINO_IO[4])
begin
if (C5counter == 84)
begin
C5counter <= 0;
end
else
C5counter <= C5counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (Db5counter == 80)
begin
Db5counter <= 0;
end
else
Db5counter <= Db5counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (D5counter == 75)
begin
D5counter <= 0;
end
else
D5counter <= D5counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (Eb5counter == 71)
begin
Eb5counter <= 0;
end
else
Eb5counter <= Eb5counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (E5counter == 67)
begin
E5counter <= 0;
end
else
E5counter <= E5counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (F5counter == 63)
begin
F5counter <= 0;
end
else
F5counter <= F5counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (Gb5counter == 60)
begin
Gb5counter <= 0;
end
else
Gb5counter <= Gb5counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (G5counter == 56)
begin
G5counter <= 0;
end
else
G5counter <= G5counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (Ab5counter == 53)
begin
Ab5counter <= 0;
end
else
Ab5counter <= Ab5counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (A5counter == 50)
begin
A5counter <= 0;
end
else
A5counter <= A5counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (Bb5counter == 47)
begin
Bb5counter <= 0;
end
else
Bb5counter <= Bb5counter + 1;
end

always_ff @(posedge ARDUINO_IO[4])
begin
if (B5counter == 45)
begin
B5counter <= 0;
end
else
B5counter <= B5counter + 1;
end

logic [23:0] freqout;
logic [7:0] sample;
logic [31:0] sampleconc;

assign sampleconc = {1'b0, {2{sample[7]}}, sample[7:0], 21'b0};

// Unit Test Block / Initial Module Instantiations
C4_rom c4(.clk(MAX10_CLK1_50), .addr(C4counter), .q(c4_out));
Db4_rom db4(.clk(MAX10_CLK1_50), .addr(Db4counter), .q(db4_out));
D4_rom d4(.clk(MAX10_CLK1_50), .addr(D4counter), .q(d4_out));
Eb4_rom eb4(.clk(MAX10_CLK1_50), .addr(Eb4counter), .q(eb4_out));
E4_rom e4(.clk(MAX10_CLK1_50), .addr(E4counter), .q(e4_out));
F4_rom f4(.clk(MAX10_CLK1_50), .addr(F4counter), .q(f4_out));
Gb4_rom gb4(.clk(MAX10_CLK1_50), .addr(Gb4counter), .q(gb4_out));
G4_rom g4(.clk(MAX10_CLK1_50), .addr(G4counter), .q(g4_out));
Ab4_rom ab4(.clk(MAX10_CLK1_50), .addr(Ab4counter), .q(ab4_out));
A4_rom a4(.clk(MAX10_CLK1_50), .addr(A4counter), .q(a4_out));
Bb4_rom bb4(.clk(MAX10_CLK1_50), .addr(Bb4counter), .q(bb4_out));
B4_rom b4(.clk(MAX10_CLK1_50), .addr(B4counter), .q(b4_out));

C5_rom c5(.clk(MAX10_CLK1_50), .addr(C5counter), .q(c5_out));
Db5_rom db5(.clk(MAX10_CLK1_50), .addr(Db5counter), .q(db5_out));
D5_rom d5(.clk(MAX10_CLK1_50), .addr(D5counter), .q(d5_out));
Eb5_rom eb5(.clk(MAX10_CLK1_50), .addr(Eb5counter), .q(eb5_out));
E5_rom e5(.clk(MAX10_CLK1_50), .addr(E5counter), .q(e5_out));
F5_rom f5(.clk(MAX10_CLK1_50), .addr(F5counter), .q(f5_out));
Gb5_rom gb5(.clk(MAX10_CLK1_50), .addr(Gb5counter), .q(gb5_out));
G5_rom g5(.clk(MAX10_CLK1_50), .addr(G5counter), .q(g5_out));
Ab5_rom ab5(.clk(MAX10_CLK1_50), .addr(Ab5counter), .q(ab5_out));
A5_rom a5(.clk(MAX10_CLK1_50), .addr(A5counter), .q(a5_out));
Bb5_rom bb5(.clk(MAX10_CLK1_50), .addr(Bb5counter), .q(bb5_out));
B5_rom b5(.clk(MAX10_CLK1_50), .addr(B5counter), .q(b5_out));

I2S i2s1(.SCLK(ARDUINO_IO[5]), .LD(ARDUINO_IO[4]), .Din(sampleconc), .s(I2S_Dout1));
I2S i2s2(.SCLK(ARDUINO_IO[5]), .LD(~(ARDUINO_IO[4])), .Din(sampleconc), .s(I2S_Dout2));

//frameRAM bg(.data_In(), .write_address(), .read_address(), .we(1), .Clk(MAX10_CLK1_50));

		//output logic [4:0] data_Out);

always_ff @(posedge ARDUINO_IO[5])
begin
	if (SW[0])
	begin
	case (keycode)
	8'h04: begin  // A
		sample <= c5_out;
		end
	8'h16: begin // S
		sample <= d5_out;
		end
	8'h07: begin // D
		sample <= e5_out;
		end
	8'h09: begin // F
		sample <= f5_out;
		end
	8'h0A: begin // G
		sample <= g5_out;
		end
	8'h0B: begin // H
		sample <= a5_out;
		end
	8'h0D: begin // J
		sample <= b5_out;
		end
	8'h1A: begin // W
		sample <= db5_out;
		end
	8'h08: begin // E
		sample <= eb5_out;
		end
	8'h17: begin // T
		sample <= gb5_out;
		end
	8'h1C: begin // Y
		sample <= ab5_out;
		end
	8'h18: begin // U
		sample <= bb5_out;
		end
		endcase
	end
	else
	begin
	case (keycode)
	8'h04: begin  // A
		sample <= c4_out;
		end
	8'h16: begin // S
		sample <= d4_out;
		end
	8'h07: begin // D
		sample <= e4_out;
		end
	8'h09: begin // F
		sample <= f4_out;
		end
	8'h0A: begin // G
		sample <= g4_out;
		end
	8'h0B: begin // H
		sample <= a4_out;
		end
	8'h0D: begin // J
		sample <= b4_out;
		end
	8'h1A: begin // W
		sample <= db4_out;
		end
	8'h08: begin // E
		sample <= eb4_out;
		end
	8'h17: begin // T
		sample <= gb4_out;
		end
	8'h1C: begin // Y
		sample <= ab4_out;
		end
	8'h18: begin // U
		sample <= bb4_out;
		end
		endcase
		end
end

//I2S Dual Output Mux
always_comb
//always_ff @(posedge ARDUINO_IO[4])
begin
	if (ARDUINO_IO[4])
	begin
		I2S_Dout = I2S_Dout2;
	end
	else
	begin
		I2S_Dout = I2S_Dout1;
	end
end

image_mapper background(.DrawX(drawxsig), .DrawY(drawysig), .vga_clk(VGA_CLK), .blank(blank), .red(Red), .green(Green), .blue(Blue));

//freq frequency(.LRCLK(ARDUINO_IO[4]), .Freq(freqout)); //.freq_desired(9'b110111000)
//sine_rom sine(.clk(MAX10_CLK1_50), .addr(freqout[23:12]), .q(sample));


//I2S i2smodule(.SCLK(ARDUINO_IO[5]), .LRCLK(ARDUINO_IO[4]), .Din(sampleconc), .Dout(I2S_Dout));
//calling FrameRam with counter
//frameRAM ram(.data_In(ARDUINO_IO[2]), .write_address(), .read_address(counter), .we(1), .Clk(SCLK), .data_Out(ARDUINO_IO[2]));

//instantiate a vga_controller, ball, and color_mapper here with the ports.

vga_controller vgacontrol(.Reset(Reset_h), .Clk(MAX10_CLK1_50), .hs(VGA_HS), .vs(VGA_VS), .pixel_clk(VGA_CLK), .blank(blank), .sync(sync), .DrawX(drawxsig), .DrawY(drawysig));

/*
color_mapper colormap(.BallX(ballxsig), .BallY(ballysig), .Ball_size(ballsizesig), .DrawX(drawxsig), .DrawY(drawysig), .Red(Red), .Green(Green), .Blue(Blue));

ball ballcall (.Reset(Reset_h), .frame_clk(VGA_VS), .keycode(keycode), .BallX(ballxsig), .BallY(ballysig), .BallS(ballsizesig));
**/

endmodule