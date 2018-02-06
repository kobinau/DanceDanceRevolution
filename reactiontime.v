

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

				
					
				
				
				
				
				
				
				
				
					