
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
	
				
				
				
				
				
				
				
				
				
				
					
				
				
				
				
				
				
				
				
					