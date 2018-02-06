		
module FSM(clock, resetn,inputs,wir_x,wir_y,colour,plot,enablecount,pressEnable,score);
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

