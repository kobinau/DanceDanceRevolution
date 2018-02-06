

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
part3 simulatechoreography(CLOCK_50, resetn,SW[7:0],wir_x,wir_y,color,plot,enableCount[3:0],pressEnable[3:0],scoring[7:0]);	

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







module dancechoreography(clock,resetn,enablecount);
input clock;
input resetn;
output reg [3:0]enablecount;//enablecount 1 2 3 4 

reg [29:0]counterbetweenpulses;//counts between pulses
reg [29:0]upcounter;
reg [1:0]analysetimebetweensteps;
reg [200:0]choreography;
reg [200:0]timing;
reg [20:0]timingcounter;
reg [1:0]analysewhichsteptopress;
reg [1:0]storeChorBits; //used to shift the bits that have been bit shifted

always@(posedge clock)

begin
case(analysetimebetweensteps)//adjust numbers below to mark time between block drops

2'd0:begin
	counterbetweenpulses<=30'd9999999;//
	end
2'd1:begin
	counterbetweenpulses<=30'd5999999;
	end
2'd2:begin
	counterbetweenpulses<=30'd19999999;
	end
3'd3:begin
	counterbetweenpulses<=30'd8999999;
	end
endcase

end


always@(posedge clock)
begin
	case(analysewhichsteptopress)//encoder for which block to fall
	2'd0:begin
		enablecount<=4'b0001;
	end
	2'd1:begin
		enablecount<=4'b0010;
	end
	2'd2:begin
		enablecount<=4'b0100;
	end
	3'd3:begin
		enablecount<=4'b1000;
	end
	endcase
end

always@(posedge clock)
begin
if(resetn)
	begin
	//string of 200 bits to tell order of steps of blocks falling, and time between falling blocks
	choreography<= 201'b010101000001011100000011011000000100011001000011000000111001001110010011110011100111110011000101101011101010101101101100001010001101010001001010010100101101000110000010111001111111011001010001010100000;
	//choreography[200:193]<=8'b11011000;
	//choreography[192:0]<=193'b0;
	timing <= 201'b110011100010011100111100001101001000110011000000010100101100011010101111000001100101110010101100010100000000101100011011110010101001000001110011110101011111100011100101110000010110010000010011011101100; 
	//timing[200:193]<=8'b11001001;
	//timing[192:0]<=193'b0;
	analysewhichsteptopress<=2'b11;
	analysetimebetweensteps<=2'b11;
	storeChorBits<=2'b11;
	upcounter<=0;
	end
else
	begin 
	if(upcounter>=counterbetweenpulses)
		begin
		timing<=timing<<2;
		storeChorBits <= choreography[200:199];
		choreography<=choreography<<2;
		//resetting the choreography
		choreography[1:0] <= storeChorBits;
		timing[1:0]<=analysewhichsteptopress;
		analysewhichsteptopress<=choreography[200:199];
		analysetimebetweensteps<=timing[200:199];
		upcounter <= 30'd0;
		end
	else if(upcounter<counterbetweenpulses)
		begin
		upcounter<=upcounter+1;
		end

	//added portion here to reset

	end
end
endmodule 


module reactiontime(enableCount1, enableCount2, enableCount3, enableCount4, overallScore, press1, press2, press3, press4, clk, reset,HEXCOUNTER1,HEXCOUNTER2,HEXCOUNTER3,HEXCOUNTER4,pad1, pad2, pad3, pad4,resetscore);
	
	//enable signals for the counters
	input enableCount1, enableCount2, enableCount3, enableCount4, clk, reset;
	reg startCount1, startCount2, startCount3, startCount4;
	reg enablescore;
	reg [25:0]countbeforeincrement;	
	//inputs of user pressing the keys
	input press1, press2, press3, press4, pad1, pad2, pad3, pad4;
	input resetscore;
	
	//counters, which will determine keep track of how much time user has to press the buttons
	reg [30:0] count1, count2, count3, count4;

	//will display score on the screen, can display these on hexes as well
	output reg [7:0]overallScore; 
	output reg [3:0]HEXCOUNTER1;
	output reg [3:0]HEXCOUNTER2;
	output reg [3:0]HEXCOUNTER3;
	output reg [3:0]HEXCOUNTER4;
	
	

	
	always@(posedge clk)
		begin
			if(resetscore)begin
			overallScore<=8'b0;end
			if(reset) begin  //down counter for each block reaction time window
				count1=31'd50000000;
				count2=31'd50000000;
				count3=31'd50000000;
				count4=31'd50000000;
				countbeforeincrement<=0;
				overallScore<=8'b0;
				
				end
			else begin
			if(enableCount1)
				startCount1<=1'b1;
			if(enableCount2)
				startCount2<=1'b1;
			if(enableCount3)
				startCount3<=1'b1;
			if(enableCount4)
				startCount4<=1'b1;
			if(enablescore==1'b1)
				begin//counter to ensure score increments by 1 when reaction occurs
					if(countbeforeincrement<26'd5000000)
					countbeforeincrement<=countbeforeincrement+1;
					else if(countbeforeincrement>=26'd5000000)
						begin
						overallScore<=overallScore+1;
						enablescore<=1'b0;
						countbeforeincrement<=0;
						end
				end
			
			if(startCount1)begin
			
				if(count1 > 31'd90000000)//some parts are residual code from older milestons
					begin
					HEXCOUNTER1<=4'd3;
					count1<=count1-1;
					end
				else if(count1<=31'd90000000 && count1>31'd50000001)
					begin
					HEXCOUNTER1 <= 4'd2;
					count1<=count1-1;
					if(press1 || pad1)
						begin
						enablescore<=1'b1;
						startCount1 <= 1'b0;
						count1 <= 31'd0;
						HEXCOUNTER1 <= 3'd0;
						end
					end
				else if(count1<=31'd50000001 && count1>31'd5000000)//countdown begins here for block1. 
					begin
					HEXCOUNTER1<=4'd1;
					count1<=count1-1;
					if(press1 || pad1)//pressing enables score to increment and count to reset, same goes for the following blocks
						begin
						enablescore<=1'b1;
						startCount1<=1'b0;
						count1<=31'd0;
						HEXCOUNTER1<=3'd0;
						end
					end
				else if(count1<=31'd5000000&&count1>31'd0)
					begin
					HEXCOUNTER1<=4'd0;
					count1<=count1-1;
					if(press1 || pad1)
						begin
						enablescore<=1'b1;
						startCount1<=1'b0;
						count1<=31'd0;
						HEXCOUNTER1<=3'd0;
						end
					end
				else if(count1==31'd0)
					begin
					count1<=31'd50000000;
					startCount1<=1'b0;
					end
				end
			if(startCount2)begin
			
				if(count2>31'd90000000)
					begin
					HEXCOUNTER2<=4'd3;
					count2<=count2-1;
					end
				else if(count2<=31'd90000000&&count2>31'd50000001)
					begin
					HEXCOUNTER2<=4'd2;
					count2<=count2-1;
					if(press2 || pad2)
						begin
						enablescore<=1'b1;
						startCount2<=1'b0;
						count2<=31'd0;
						HEXCOUNTER2<=3'd0;
						end
					end
				else if(count2<=31'd50000001&&count2>31'd5000000)
					begin
					HEXCOUNTER2<=4'd1;
					count2<=count2-1;
					if(press2 || pad2)
						begin
						enablescore<=1'b1;
						startCount2<=1'b0;
						count2<=31'd0;
						HEXCOUNTER2<=3'd0;
						end
					end
				else if(count2<=31'd5000000&&count2>31'd0)
					begin
					HEXCOUNTER2<=4'd0;
					count2<=count2-1;
					if(press2 || pad2)
						begin
						enablescore<=1'b1;
						startCount2<=1'b0;
						count2<=31'd0;
						HEXCOUNTER2<=3'd0;
						end
					end
				else if(count2==31'd0)
					begin
					count2<=31'd50000000;
					startCount2 <= 1'b0;
					end
				end
			if(startCount3)begin
			
				if(count3>31'd90000000)
					begin
					HEXCOUNTER3<=4'd3;
					count3<=count3-1;
					end
				else if(count3<=31'd90000000&&count3>31'd50000001)
					begin
					HEXCOUNTER3<=4'd2;
					count3<=count3-1;
					if(press3 || pad3)
						begin
						enablescore<=1'b1;
						startCount3<=1'b0;
						count3<=31'd0;
						HEXCOUNTER3<=3'd0;
						end
					end
				else if(count3<=31'd50000001&&count3>31'd5000000)
					begin
					HEXCOUNTER3<=4'd1;
					count3<=count3-1;
					if(press3 || pad3)
						begin
						enablescore<=1'b1;
						startCount3 <= 1'b0;
						count3 <= 31'd0;
						HEXCOUNTER3<=3'd0;
						end
					end
				else if(count3<=31'd5000000&&count3>31'd0)
					begin
					HEXCOUNTER3<=4'd0;
					count3<=count3-1;
					if(press3 || pad3)
						begin
						enablescore<=1'b1;
						startCount3<=1'b0;
						count3<=31'd0;
						HEXCOUNTER3<=3'd0;
						end
					end
				else if(count3==31'd0)
					begin
					count3<=31'd50000000;
					startCount3<=1'b0;
					end
				end
			if(startCount4)begin
			
				if(count4>31'd90000000)
					begin
					HEXCOUNTER4<=4'd3;
					count4<=count4-1;
					end
				else if(count4<=31'd90000000&&count4>31'd50000001)
					begin
					HEXCOUNTER4<=4'd2;
					count4<=count4-1;
					if(press4 || pad4)
						begin
						enablescore<=1'b1;
						startCount4<=1'b0;
						count4<=31'd0;
						HEXCOUNTER4<=3'd0;
						end
					end
				else if(count4<=31'd50000001&&count4>31'd5000000)
					begin
					HEXCOUNTER4<=4'd1;
					count4<=count4-1;
					if(press4 || pad4)
						begin
						enablescore<=1'b1;
						startCount4<=1'b0;
						count4<=31'd0;
						HEXCOUNTER4<=3'd0;
						end
					end
				else if(count4<=31'd5000000&&count4>31'd0)
					begin
					HEXCOUNTER4<=4'd0;
					count4<=count4-1;
					if(press4 || pad4)
						begin
						enablescore<=1'b1;
						startCount4<=1'b0;
						count4<=31'd0;
						HEXCOUNTER4<=3'd0;
						end
					end
				else if(count4==31'd0)
					begin
					count4<=31'd50000000;
					startCount4<=1'b0;
					end
				end
				
			end
		end
		
	
	

		
				
				
				
	endmodule

	module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule

				









		
module part3(clock, resetn,inputs,wir_x,wir_y,colour,plot,enablecount,pressEnable,score);
input clock,resetn;
input [7:0]score;
output plot;
output [3:0]pressEnable;
input [7:0]inputs;
input [3:0]enablecount;
wire [10:0]state;
wire [7:0]x;
wire [7:0]y;
wire [7:0]x1;
wire [7:0]y1;
wire [7:0]x2;
wire [7:0]y2;
wire [7:0]x3;
wire [7:0]y3;
wire [7:0]y4;
wire [7:0]x4;
wire [7:0]y5;
wire [7:0]x5;

assign y4=8'd30;
assign x4=8'd110;
assign y5=8'd30;
assign x5=8'd103;
wire black,moveup,movedown,moveleft,moveright;
wire [5:0]draw;
output [7:0] wir_x;
output [7:0] wir_y;
output [2:0] colour;
reg [7:0]finalx;
reg [7:0]finaly;
wire [7:0]wir_x1;
wire [7:0]wir_x2;
wire [7:0]wir_y1;
wire [7:0]wir_y2;
reg [3:0]inputscore;
//control tells datapath to either draw change position or destroy blocks
control C0(clock,resetn,inputs,state);
//datapath does that
datapath D0(clock,resetn,state,x,y,x1,y1,x2,y2,x3,y3,inputs,black,movedown,plot,draw,enablecount,pressEnable);
always@(*)
begin
if(draw==6'b100000)
	inputscore<=score[7:4];
else if (draw==6'b010000)
	inputscore<=score[3:0];
end
always@(posedge clock)//coordinates of blocks change, we use an (x,y) pair for each column and must store that into the VGA at appropriate time
begin
case(draw)
5'b00001:begin
	finalx<=x;
	finaly<=y;
	
	end	
5'b00010:begin
	finalx<=x1;
	finaly<=y1;

	end	
5'b00100:begin
	finalx<=x2;
	finaly<=y2;
	
	end	
5'b01000:begin
	finalx<=x3;
	finaly<=y3;
	
	end
5'b10000: begin
	finalx<=x4;
	finaly<=y4;
	end
6'b100000:begin
	finalx<=x5;
	finaly<=y5;
	end	
endcase
end
square S0(finalx,finaly, clock, wir_x,  wir_y,black,resetn,draw[5:0],plot,colour,inputscore);//draws square and score blocks


endmodule

module control(clock,resetn,inputs,state);
input clock;
input [7:0]inputs;
input resetn;


output reg [10:0]state;
reg [27:0]counter;
reg [10:0]drawcount;
always@(posedge clock)
	begin
	if(~resetn)
	begin
	state<=0;
	counter<=0;
	drawcount<=0;
	end
	else 
		begin
			case(state)
			25'd0://find the places x0 x1 x2 and x3 are falling (only check the block points if y is at 0 or )
				begin
				if(drawcount<=4)
					drawcount<=drawcount+1;
				else if(drawcount>4)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd1:begin//draw block 1
				if(drawcount<=17)
					drawcount<=drawcount+1;
				else if(drawcount>17)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd2: state<=state+1;
			25'd3:
			begin
				if(drawcount<=4)
					drawcount<=drawcount+1;
				else if(drawcount>4)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd4://draw block 2
				begin
				if(drawcount<=17)
					drawcount<=drawcount+1;
				else if(drawcount>17)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd5: state<=state+1;
			25'd6:begin
				if(drawcount<=4)
					drawcount<=drawcount+1;
				else if(drawcount>4)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd7:begin//draw block 3
				if(drawcount<=17)
					drawcount<=drawcount+1;
				else if(drawcount>17)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd8: state<=state+1;
			25'd9:begin
				if(drawcount<=4)
					drawcount<=drawcount+1;
				else if(drawcount>4)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd10:begin//draw block 4
				if(drawcount<=17)
					drawcount<=drawcount+1;
				else if(drawcount>17)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end

			25'd11:begin//counter
					if(counter<=28'd833333)
					counter<=counter+1;
					else
						begin
						counter<=0;
						state<=state+1;
						end
					end
			25'd12: state<=state+1;
			25'd13:begin
				if(drawcount<=4)
					drawcount<=drawcount+1;
				else if(drawcount>4)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end	
			25'd14:begin//delete to black1
					if(drawcount<=17)
					drawcount<=drawcount+1;
				else if(drawcount>17)
						begin
						drawcount<=0;
						state<=state+1;
						end
					end
			25'd15: state<=state+1;
			25'd16:
			begin
				if(drawcount<=4)
					drawcount<=drawcount+1;
				else if(drawcount>4)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd17:begin//deletetoblack 2
				if(drawcount<=17)
					drawcount<=drawcount+1;
				else if(drawcount>17)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd18: state<=state+1;
			25'd19:
			begin
				if(drawcount<=4)
					drawcount<=drawcount+1;
				else if(drawcount>4)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd20:begin//deleteto black 3
					if(drawcount<=17)
					drawcount<=drawcount+1;
				else if(drawcount>17)
						begin
						drawcount<=0;
						state<=state+1;
							end
					end
			25'd21:state<=state+1;
			25'd22:begin
				if(drawcount<=4)
					drawcount<=drawcount+1;
				else if(drawcount>4)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd23:begin//deletetoblack 4
				if(drawcount<=17)
					drawcount<=drawcount+1;
				else if(drawcount>17)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd24:state<=state+1;
			25'd25:state<=state+1;
			25'd26:begin
				if(drawcount<=4)
					drawcount<=drawcount+1;
				else if(drawcount>4)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd27:begin
				if(drawcount<=100)//draw ones score in hexadecimal
					drawcount<=drawcount+1;
				else if(drawcount>100)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd28:state<=state+1;
			25'd29:state<=state+1;
			25'd30:begin
				if(drawcount<=4)
					drawcount<=drawcount+1;
				else if(drawcount>4)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd31:begin
				if(drawcount<=100)//draw tens score in hexadecimal
					drawcount<=drawcount+1;
				else if(drawcount>100)
					begin
					drawcount<=0;
					state<=state+1;
					end
				end
			25'd32:state<=state+1;
			25'd33:begin
				if(drawcount<=4)
					drawcount<=drawcount+1;
				else if(drawcount>4)
					begin
					drawcount<=0;
					state<=0;
					end
				end
					
			default: ;

			endcase
		end
	end



endmodule

module datapath(clock,resetn,state,x,y,x1,y1,x2,y2,x3,y3,inputs,black,movedown,plot,draw,enablecount,pressEnable);
input clock;
input [7:0]inputs;
input resetn;
input [10:0] state;
input [3:0]enablecount;
output reg [3:0]pressEnable;
output reg [7:0]x;
output reg [7:0]y;
output reg [7:0]x1;
output reg [7:0]y1;
output reg [7:0]x2;
output reg [7:0]y2;
output reg [7:0]x3;
output reg [7:0]y3;
output reg plot;
output reg movedown;
output reg black;
output reg [5:0]draw;
reg [3:0]rundown;

always@(posedge clock)
begin
if(~resetn) begin
	plot<=0;
	draw<=0;
	black<=0;
	movedown<=0;
	x<=8'd20;
	y<=8'd20;
	x1<=8'd40;
	y1<=8'd20;
	x2<=8'd60;
	y2<=8'd20;
	x3<=8'd80;
	y3<=8'd20;
	pressEnable<=4'd0;
	rundown<=4'b0;
	end 
	else if(resetn)  begin
	if(enablecount[0]==1&&y==20)//first take in signals to know if blocks should start falling
				begin
					rundown[0]<=1;
					x<= 8'd20;
					y<=8'd20;
				end
				if(enablecount[1]==1&&y1==20)
				begin
					rundown[1]<=1;
					x1<=8'd40;
					y1<=8'd20;
				end
				if(enablecount[2]==1&&y2==20)
				begin
					rundown[2]<=1;
					x2<=8'd60;
						y2<=8'd20;
				end
				if(enablecount[3]==1&&y3==20)
				begin
					rundown[3]<=1;
					x3<=8'd80;
					y3<=8'd20;
				end
		case(state)		
				
		25'd0:begin
		plot<=0;
		draw<=4'b0001;
		end
		25'd1:begin//draw block 1
		if(rundown[0])
			begin
			plot<=1;
			draw<=4'b0001;
			end

		end
		25'd2: draw<=0;
		25'd3: begin
		plot<=0;
		draw<=4'b0010;
		end
		25'd4:
		begin
		if(rundown[1])//draw block 2
			begin
			plot<=1;
			draw<=4'b0010;
			end
		end
		25'd5: draw<=0;
		25'd6:begin
		plot<=0;
		draw<=4'b0100;
		end
		25'd7:begin
		if(rundown[2])//draw block 3
			begin
			plot<=1;
			draw<=4'b0100;
			end
		end
		25'd8: draw<=0;
		25'd9:begin
		plot<=0;
		draw<=4'b1000;
		end
		25'd10:begin//draw block 4
		if(rundown[3])
			begin
			plot<=1;//output changes to square
			draw<=4'b1000;//run through squares changes
			end
		end
		25'd11:;//firstcounter
		25'd12: draw<=0;
		25'd13:begin
		plot<=0;
		draw<=4'b0001;
		end
		25'd14:begin//deletetoblack block 0
		if(rundown[0])
			begin
			plot<=1;
			black<=1;
			draw<=4'b0001;
			end
		end
		25'd15: draw<=0;
		25'd16:begin
		plot<=0;
		draw<=4'b0010;
		end
		25'd17:begin//drawblack on current x values block 1
		if(rundown[1])
			begin
			plot<=1;
			black<=1;
			draw<=4'b0010;
			end
		end
		25'd18: draw<=0;
		25'd19:begin
		plot<=0;
		draw<=4'b0100;
		end
		25'd20:begin//drawblack on current x values block 2
		if(rundown[2])
			begin
			plot<=1;
			black<=1;
			draw<=4'b0100;
			end
		end
		25'd21: draw<=0;
		25'd22:begin
		plot<=0;
		draw<=4'b1000;
		end
		25'd23:begin 
		if(rundown[3])//draw black on current x values block 3
		begin
			black<=1;
			draw<=4'b1000;
			plot<=1;
			end
		end

		25'd24:begin //shift y coordinate down 1 pixel for each falling block
		black<=0;
		draw<=0;
		plot<=0;

		if(rundown[0])
			begin
			if(y>75)
			pressEnable[0]<=1;
			if(y<90)
			y<=y+1;
				else begin
				y<=20;
				rundown[0]<=0;
				pressEnable[0]<=0;
				end
			end

		if(rundown[1])
			begin
			if(y1>75)
			pressEnable[1]<=1;
			if(y1<90)
			y1<=y1+1;
				else begin
				y1<=20;
				rundown[1]<=0;
				pressEnable[1]<=0;
				end
			end
		if(rundown[2])
			begin
			if(y2>75)
			pressEnable[2]<=1;
			if(y2<90)
			y2<=y2+1;
				else begin
				y2<=20;
				rundown[2]<=0;
				pressEnable[2]<=0;
				end
			end
		if(rundown[3])
			begin
			if(y3>75)
			pressEnable[3]<=1;
			if(y3<90)
			y3<=y3+1;
				else begin
				y3<=20;
				rundown[3]<=0;
				pressEnable[3]<=0;
				end
			end
		end
		25'd25:begin
		draw<=0;
		end
		25'd26:begin
		plot<=0;
		draw<=5'b10000;
		end
		25'd27:plot<=1;//draw 1's score in hexadecimal
		25'd28:begin
		draw<=0;
		plot<=0;
		end
		25'd29:begin
		draw<=0;
		end
		25'd30:begin
		plot<=0;
		draw<=6'b100000;
		end
		25'd31:plot<=1;//draw 10's score in hexadecimal
		25'd32:begin
		draw<=0;
		plot<=0;
		end
		25'd33:
		begin
		plot<=0;
		draw<=4'b0001;
		end
		default: ;//hold
		endcase
	end
end


endmodule 
//draws both squares and scores
	module square (input [7:0]x,input [7:0]y, input clock, output [7:0] wir_x, output [7:0] wir_y,input black,input resetn,input [5:0]draw,input plot,output [2:0]colour,input [3:0]score);
		
		
		reg [2:0] countx = 3'b000; 
		reg [2:0] county = 3'b000;  
		reg go;
		reg [24:0]bits;
		reg [2:0] counter;
		reg assignblack;
		reg black2;
		 assign wir_x = x + countx;
		 assign wir_y = y + county;
		 
		 mux2to1 M0(assignblack, colour);
		always@(*)
			begin
			if(draw==5'b1||draw==5'd2||draw==5'd4||draw==5'd8)
			assignblack<=black;//for drawing over entirely in black or for drawing over entirely in white
			else if(draw==6'd16||6'd32)
			assignblack<=black2;//drawing scores have some squares black and some white
			end
			
		always@ (posedge clock)//draws squares
			if(~resetn||draw[5:0]==6'b0)
				begin
				countx<=3'b000;
				county<=3'b000;
				go<=1;//must control a different way
				counter<=0;
				end
			
			else if(plot)
					begin if(draw[3]==1'b1||draw[2]==1'b1||draw[1]==1'b1||draw[0]==1'b1)
						case(countx)
						3'd0: countx<=countx+1;
						3'd1: countx<=countx+1;
						3'd2:	countx<=countx+1;
						3'd3:	begin
						
								countx<=3'b0;
								if(county<=2)
									county<=county+1'b1;
								else if(county==3)
									begin
									county<=county;
									countx<=countx;
									end
								end
						endcase
					else if(draw[4]==1'b1||draw[5]==1'b1)
					begin
						case(score)
						//25 bits to draw score in hexadecimal
						4'd0: begin if(go) bits=25'b0111010001100011000101110;go<=0;end
						4'd1: begin if(go) bits=25'b0010000100001000010000100;go<=0;end
						4'd2: begin if(go) bits=25'b1111100001111111000011111;go<=0;end
						4'd3: begin if(go) bits=25'b1111100001111110000111111;go<=0;end
						4'd4: begin if(go) bits=25'b1000110001111110000100001;go<=0;end
						4'd5: begin if(go) bits=25'b1111110000111110000111111;go<=0;end
						4'd6: begin if(go) bits=25'b1111110000111111000111111;go<=0;end
						4'd7: begin if(go) bits=25'b1111100001000010000100001;go<=0;end
						4'd8: begin if(go) bits=25'b1111110001111111000111111;go<=0;end
						4'd9: begin if(go) bits=25'b1111110001111110000100001;go<=0;end
						4'hA: begin if(go) bits=25'b0111010001111111000110001;go<=0;end
						4'hB: begin if(go) bits=25'b1000010000111111000101110;go<=0;end
						4'hC: begin if(go) bits=25'b0111110000100001000001111;go<=0;end
						4'hD: begin if(go) bits=25'b0000100001111111000101110;go<=0;end
						4'hE: begin if(go) bits=25'b1111110000111111000011111;go<=0;end
						4'hF: begin if(go) bits=25'b1111110000111111000010000;go<=0;end
						default: bits=bits;
						endcase
						case(countx)//draws scores, bit shifts for each bit and analyzes if should be black or white to have 5x5 pixel shape resembling 1-F 
						3'd0: begin if(counter<2)
							begin
							counter<=counter+1;
							if(bits[24]==0)
							black2<=1'b1;//
							else if (bits[24]==1)
							black2<=1'b0;//
							end
						if(counter>=2)
							begin
							counter<=0;
							countx<=countx+1;
							bits<=bits<<1;
							end
						end
						3'd1: begin if(counter<2)
							begin
							counter<=counter+1;
							if(bits[24]==0)
							black2<=1'b1;//
							else if (bits[24]==1)
							black2<=1'b0;//
							end
						if(counter>=2)
							begin
							counter<=0;
							countx<=countx+1;
							bits<=bits<<1;
							end
						end
						3'd2: begin	if(counter<2)
							begin
							counter<=counter+1;
							if(bits[24]==0)
							black2<=1'b1;//
							else if (bits[24]==1)
							black2<=1'b0;//
							end
						if(counter>=2)
							begin
							counter<=0;
							countx<=countx+1;
							bits<=bits<<1;
							end
						end
						3'd3: begin if(counter<2)
							begin
							counter<=counter+1;
							if(bits[24]==0)
							black2<=1'b1;//
							else if (bits[24]==1)
							black2<=1'b0;//
							end
						if(counter>=2)
							begin
							counter<=0;
							countx<=countx+1;
							bits<=bits<<1;
							end
						end
						3'd4:	begin
						
							if(counter<2)
							begin
							counter<=counter+1;
							if(bits[24]==0)
							black2<=1'b1;//
							else if (bits[24]==1)
							black2<=1'b0;//
							end
						if(counter>=2)
							begin
							counter<=0;
							
							bits<=bits<<1;
							countx<=3'b0;
							if(county<=3)
								county<=county+1'b1;
							else if(county==4)
									begin
									county<=county;
									countx<=countx;
									end
							end
						end
						endcase
					end
				end
			endmodule

module mux2to1(input black,  output reg[2:0]color);//black or white?
			always@(*)

			begin
			if(black)
				color = 3'b000;
			else
				color = 3'b111;
				end
		endmodule					
				
				
				
				
				
				
				
				
				
				
				
				
				
					
				
				
				
				
				
				
				
				
					