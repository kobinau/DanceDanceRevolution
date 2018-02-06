

// Etch-and-sketch

module DanceDanceRev
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,							//	Push Button[3:0]
		SW,								//	DPDT Switch[17:0]
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4,
		HEX5,
		GPIO_0,
		AUD_ADCDAT,

	// Bidirectionals
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,

	FPGA_I2C_SDAT,

	// Outputs
	AUD_XCK,
	AUD_DACDAT,

	FPGA_I2C_SCLK,
	);
	
	input				AUD_ADCDAT;

// Bidirectionals
inout				AUD_BCLK;
inout				AUD_ADCLRCK;
inout				AUD_DACLRCK;

inout				FPGA_I2C_SDAT;

// Outputs
output				AUD_XCK;
output				AUD_DACDAT;

output				FPGA_I2C_SCLK;


	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;					//	Button[3:0]
	input	[9:0]	SW;						//	Switches[0:0]
	input [6:0]GPIO_0;
	
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	output [6:0]HEX0, HEX1,HEX2,HEX3,HEX4,HEX5;
	wire resetn;
	
	wire [3:0]HEXCOUNTER1;
	wire [3:0]HEXCOUNTER2;
	wire [3:0]HEXCOUNTER3;
	wire [3:0]HEXCOUNTER4;
	wire [7:0]scoring;
	
	
	wire [2:0] color;
	wire [7:0] x;
	wire [7:0] wir_x;
	wire [7:0] wir_y;
	wire [7:0] y;
	wire plot;
	wire [3:0]enableCount;
	wire [3:0]pressEnable;
	assign resetn = SW[0];

	
	
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	
	
	
	
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(color),
			.x(wir_x),
			.y(wir_y),
			.plot(plot),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK),
			.VGA_SYNC(VGA_SYNC),
			.VGA_CLK(VGA_CLK));
			
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "backgroundimg.mif";
		
		//sends signals to drop blocks
dancechoreography d0(CLOCK_50,~SW[0],enableCount[3:0]);

		//uses FSM to drop blocks
FSM simulatechoreography(CLOCK_50, resetn,SW[7:0],wir_x,wir_y,color,plot,enableCount[3:0],pressEnable[3:0],scoring[7:0]);	

	// increments score depending on when pads are pressed
reactiontime test(pressEnable[0], pressEnable[1], pressEnable[2], pressEnable[3], scoring,  ~KEY[0], ~KEY[1], ~KEY[2], ~KEY[3],
			CLOCK_50, ~SW[0],HEXCOUNTER1,HEXCOUNTER2,HEXCOUNTER3,HEXCOUNTER4, ~GPIO_0[0], ~GPIO_0[2], ~GPIO_0[4], ~GPIO_0[6],SW[2]);
			
	hex_decoder  hex0(scoring[3:0], HEX0);
	hex_decoder  hex1(scoring[7:4], HEX1);
	hex_decoder  hex3(HEXCOUNTER1, HEX2);
	hex_decoder  hex4(HEXCOUNTER2, HEX3);
	hex_decoder  hex5(HEXCOUNTER3, HEX4);
	hex_decoder  hex6(HEXCOUNTER4, HEX5);
	
	
	
	//song instantiation
	audioTry DDRsong (
	// Inputs
	.CLOCK_50(CLOCK_50),
	.reset(SW[9]),

	.AUD_ADCDAT(AUD_ADCDAT),

	// Bidirectionals
	.AUD_BCLK(AUD_BCLK),
	.AUD_ADCLRCK(AUD_ADCLRCK),
	.AUD_DACLRCK(AUD_DACLRCK),

	.FPGA_I2C_SDAT(FPGA_I2C_SDAT),

	// Outputs
	.AUD_XCK(AUD_XCK),
	.AUD_DACDAT(AUD_DACDAT),

	.FPGA_I2C_SCLK(FPGA_I2C_SCLK),
	//LEDR
);
		endmodule

