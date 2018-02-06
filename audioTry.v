
module audioTry (
	// Inputs
	CLOCK_50,
	reset,

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
	//LEDR
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input				CLOCK_50;
input 			reset;
//input		[3:0]	KEY;
//output [3:0]LEDR;

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

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire				audio_in_available;
wire		[31:0]	left_channel_audio_in;
wire		[31:0]	right_channel_audio_in;
wire				read_audio_in;

wire				audio_out_allowed;
wire		[31:0]	left_channel_audio_out;
wire		[31:0]	right_channel_audio_out;
wire				write_audio_out;

// Internal Registers

reg [18:0] delay_cnt;
wire [18:0] delay;
reg [29:0]timeBetweenSound;
wire [29:0]maxTimeCount;
reg snd;
wire selectingSound;

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(posedge CLOCK_50)
	begin
	timeBetweenSound <= timeBetweenSound + 1;
	delay_cnt <= delay_cnt + 1;
	if (reset)
		begin
		snd <= 1'b1;
		delay_cnt <= 0;
		
		timeBetweenSound <= 30'd0;
		end
	
	if(delay_cnt == delay) begin
		delay_cnt <= 0;
		snd <= !snd;		
	end
	if (timeBetweenSound == maxTimeCount)
		begin
		timeBetweenSound <= 0;
		end
	end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

 //instantiate delay within a module
//assign delay = {selectFreq[3:0], 15'd3000};

controlSong controlSong(delay, maxTimeCount, delay_cnt, timeBetweenSound, CLOCK_50, reset, selectingSound);

wire [31:0] sound = selectingSound ? ( snd ? 32'd10000000 : -32'd10000000) : 0;


assign read_audio_in			= 1'b0;

assign left_channel_audio_out	= /*left_channel_audio_in*/sound;
assign right_channel_audio_out	= /*right_channel_audio_in*/sound; //--tried taking off the audio in part
assign write_audio_out			= 1'b1;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

Audio_Controller Audio_Controller (
	// Inputs
	.CLOCK_50						(CLOCK_50),
	.reset						(reset),

	.clear_audio_in_memory		(),
	.read_audio_in				(read_audio_in),
	
	.clear_audio_out_memory		(),
	.left_channel_audio_out		(left_channel_audio_out),
	.right_channel_audio_out	(right_channel_audio_out),
	.write_audio_out			(write_audio_out),

	.AUD_ADCDAT					(AUD_ADCDAT),

	// Bidirectionals
	.AUD_BCLK					(AUD_BCLK),
	.AUD_ADCLRCK				(AUD_ADCLRCK),
	.AUD_DACLRCK				(AUD_DACLRCK),


	// Outputs
	.audio_in_available			(audio_in_available),
	.left_channel_audio_in		(left_channel_audio_in),
	.right_channel_audio_in		(right_channel_audio_in),

	.audio_out_allowed			(audio_out_allowed),

	.AUD_XCK					(AUD_XCK),
	.AUD_DACDAT					(AUD_DACDAT)

);

avconf #(.USE_MIC_INPUT(1)) avc (
	.FPGA_I2C_SCLK					(FPGA_I2C_SCLK),
	.FPGA_I2C_SDAT					(FPGA_I2C_SDAT),
	.CLOCK_50					(CLOCK_50),
	.reset						(reset)
);

endmodule

