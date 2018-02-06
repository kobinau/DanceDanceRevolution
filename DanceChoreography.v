

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

