module controlSong(setdelayFreq, settimeSound, delayCounter, timeCounter, clock, reset, selectSound);

//counters for time interval between sound 
input [29:0]timeCounter;
input [18:0]delayCounter;
input clock, reset; 
output reg selectSound; //chooses whether or not to send sound
output reg [18:0]setdelayFreq;
output reg [29:0]settimeSound;

reg [8:0] current_state, next_state; 


localparam  note1   = 9'd0,
            note2   = 9'd1,
            note3   = 9'd2,
            note4   = 9'd3,
            note5   = 9'd4,
            note6   = 9'd5,
            note7   = 9'd6,
            note8   = 9'd7,
            note9   = 9'd8,    
				wait1 = 9'd9,
				wait2 = 9'd10,
				wait3 = 9'd11,
				wait4 = 9'd12,
				wait5 = 9'd13,
				note10   = 9'd14,
            note11   = 9'd15,
            note12   = 9'd16,
            note13  = 9'd17,
            note14   = 9'd18,
            note15   = 9'd19,
            note16  = 9'd20,
            note17  = 9'd21,
            note18   = 9'd22,
				note19   = 9'd23,
            note20   = 9'd24,
            note21   = 9'd25,
            note22   = 9'd26,
            note23   = 9'd27,
            note24   = 9'd28,
            note25   = 9'd29,
            note26   = 9'd30,
            note27   = 9'd31,
				note28   = 9'd32,
				note29   = 9'd33,
				note30   = 9'd34,
				note31   = 9'd35,
				note32   = 9'd36,
				note33   = 9'd37,
				note34   = 9'd38,
				note35   = 9'd39,
				note36   = 9'd40,
				note37   = 9'd41,
				note38   = 9'd42,
				note39   = 9'd43,
				
				
				note40   = 9'd44,
				note41   = 9'd45,
				note42   = 9'd46,
				note43   = 9'd47,
				note44   = 9'd48,
				note45   = 9'd49,
				note46   = 9'd50,
				note47   = 9'd51,
				note48   = 9'd52,
				note49   = 9'd53,
				
				note50   = 9'd54,
				note51   = 9'd55,
				note52   = 9'd56,
				note53   = 9'd57,
				note54   = 9'd58,
				note55   = 9'd59,
				note56   = 9'd60,
				note57   = 9'd61,
				note58   = 9'd62,
				note59   = 9'd63;
				
				
				
				
always@(*)
    begin 
            case (current_state) //will fill in the rest of the states later
				
				note1: next_state = (timeCounter == settimeSound) ? wait1 : note1; 
				wait1: next_state = (timeCounter == settimeSound) ? note2 : wait1;
				note2: next_state = (timeCounter == settimeSound) ? wait2 : note2;
				wait2: next_state = (timeCounter == settimeSound) ? note3 : wait2;
				note3: next_state = (timeCounter == settimeSound) ? wait3 : note3;
				wait3: next_state = (timeCounter == settimeSound) ? note4 : wait3;
				note4: next_state = (timeCounter == settimeSound) ? note5 : note4;			
				note5: next_state = (timeCounter == settimeSound) ? wait4 : note5;
				wait4: next_state = (timeCounter == settimeSound) ? note6 : wait4;
				note6: next_state = (timeCounter == settimeSound) ? note7 : note6;				
				note7: next_state = (timeCounter == settimeSound) ? note8 : note7;
				note8: next_state = (timeCounter == settimeSound) ? wait5 : note8;
				wait5: next_state = (timeCounter == settimeSound) ? note9 : wait5;
				note9: next_state = (timeCounter == settimeSound) ? note10 : note9;
				note10:next_state = (timeCounter == settimeSound) ? note11 : note10;
            note11:next_state = (timeCounter == settimeSound) ? note12 : note11;
            note12:next_state = (timeCounter == settimeSound) ? note13 : note12;
            note13:next_state = (timeCounter == settimeSound) ? note14 : note13;
            note14:next_state = (timeCounter == settimeSound) ? note15 : note14;
            note15:next_state = (timeCounter == settimeSound) ? note16 : note15;
            note16:next_state = (timeCounter == settimeSound) ? note17 : note16;
            note17:next_state = (timeCounter == settimeSound) ? note18 : note17;
            note18: next_state = (timeCounter == settimeSound) ? note19 : note18;
				note19: next_state = (timeCounter == settimeSound) ? note20 : note19;
            note20: next_state = (timeCounter == settimeSound) ? note21 : note20;
            note21:  next_state = (timeCounter == settimeSound) ? note22 : note21;
            note22:  next_state = (timeCounter == settimeSound) ? note23 : note22;
            note23:  next_state = (timeCounter == settimeSound) ? note24 : note23;
            
				
				//implement these later
				note24:   next_state = (timeCounter == settimeSound) ? note25 : note24;
            note25:   next_state = (timeCounter == settimeSound) ? note26 : note25;
            note26:   next_state = (timeCounter == settimeSound) ? note27 : note26;
            note27:   next_state = (timeCounter == settimeSound) ? note28 : note27;
				note28:	 next_state = (timeCounter == settimeSound) ? note29 : note28;
				note29:   next_state = (timeCounter == settimeSound) ? note30 : note29;
				note30:   next_state = (timeCounter == settimeSound) ? note31 : note30;
				note31:   next_state = (timeCounter == settimeSound) ? note32 : note31;
				
				//next set
				note32:   next_state = (timeCounter == settimeSound) ? note33 : note32;
            note33:   next_state = (timeCounter == settimeSound) ? note34 : note33;
            note34:   next_state = (timeCounter == settimeSound) ? note35 : note34;
            note35:   next_state = (timeCounter == settimeSound) ? note36 : note35;
				note36:	 next_state = (timeCounter == settimeSound) ? note37 : note36;
				note37:   next_state = (timeCounter == settimeSound) ? note38 : note37;
				note38:   next_state = (timeCounter == settimeSound) ? note39 : note38;
				note39:   next_state = (timeCounter == settimeSound) ? note40 : note39;
				
				//next set				
				note40:   next_state = (timeCounter == settimeSound) ? note41 : note40;
            note41:   next_state = (timeCounter == settimeSound) ? note42 : note41;
            note42:   next_state = (timeCounter == settimeSound) ? note43 : note42;
            note43:   next_state = (timeCounter == settimeSound) ? note44 : note43;
				note44:	 next_state = (timeCounter == settimeSound) ? note45 : note44;
				note45:   next_state = (timeCounter == settimeSound) ? note46 : note45;
				note46:   next_state = (timeCounter == settimeSound) ? note47 : note46;
				note47:   next_state = (timeCounter == settimeSound) ? note48 : note47;
				note48:	next_state = (timeCounter == settimeSound) ? note49 : note48;
				note49:	next_state = (timeCounter == settimeSound) ? note50: note49;
				
				
				//next set				
				note50:   next_state = (timeCounter == settimeSound) ? note51 : note50;
            note51:   next_state = (timeCounter == settimeSound) ? note52 : note51;
            note52:   next_state = (timeCounter == settimeSound) ? note53 : note52;
            note53:   next_state = (timeCounter == settimeSound) ? note54 : note53;
				note54:	 next_state = (timeCounter == settimeSound) ? note55 : note54;
				note55:   next_state = (timeCounter == settimeSound) ? note56 : note55;
				note56:   next_state = (timeCounter == settimeSound) ? note57 : note56;
				note57:   next_state = (timeCounter == settimeSound) ? note58 : note57;
				note58:	next_state = (timeCounter == settimeSound) ? note59 : note58;
				note59:	next_state = (timeCounter == settimeSound) ? note1: note59;


				default: next_state = note1;
				endcase
		end
		
//enabling signals		
always @(*)
    begin //doubling the times
			case (current_state)
					note1: begin
								selectSound = 1'b1;
								settimeSound = 30'd31999999;  //a#
								setdelayFreq = 19'd212992;
							end
							
							
					note2: begin
								selectSound = 1'b1;
								settimeSound = 30'd21999999;  //a#
								setdelayFreq = 19'd212992;
							end
							
							 //might need waiting phases
					
					note3: begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //a#
									setdelayFreq = 19'd212992;
								end
					note4: begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //a#
									setdelayFreq = 19'd212992;
								end
								
					note5: begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = 19'd140672;  
								end
					note6: begin
									selectSound = 1'b1;
									settimeSound = 30'd11999999;  //f
									setdelayFreq = 19'd140672;
								end
				   note7: begin
									selectSound = 1'b1;
									settimeSound = 30'd11999999;  //c#
									setdelayFreq = 19'd88704;
								end
								
					note8: begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = 19'd140672;
								end
					note9: begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = 19'd140672;
								end
								
					wait1: begin
										selectSound = 1'b0;
										settimeSound = 30'd7999999;  
										setdelayFreq = 19'd26;
								  end
					wait2: begin
										selectSound = 1'b0;
										settimeSound = 30'd3999999;  
										setdelayFreq = 19'd26;
								  end
				   wait3: begin
										selectSound = 1'b0;
										settimeSound = 30'd3999999;  
										setdelayFreq = 19'd26;
								  end
					wait4: begin
										selectSound = 1'b0;
										settimeSound = 30'd3999999;  
										setdelayFreq = 19'd26;
								  end
					wait5: begin
										selectSound = 1'b0;
										settimeSound = 30'd3999999;  
										setdelayFreq = 19'd26;
								  end
								  
					note10: begin
								selectSound = 1'b1;
								settimeSound = 30'd21999999;  //a#
								setdelayFreq = {4'b1100, 15'd3000};
							end
							
							
					note11: begin
								selectSound = 1'b1;
								settimeSound = 30'd11999999;  //a#
								setdelayFreq = {4'b1000, 15'd3000};
							end
							
							 //might need waiting phases
					
					note12: begin
									selectSound = 1'b1;
									settimeSound = 30'd11999999;  //a#
									setdelayFreq = {4'b1100, 15'd3000};
								end
					note13: begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //a#
									setdelayFreq = {4'b1000, 15'd3000};
								end
								
					note14: begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = {4'b1010, 15'd3000};  
								end
					note15: begin
									selectSound = 1'b1;
									settimeSound = 30'd11999999;  //f
									setdelayFreq = {4'b1000, 15'd3000};
								end
				   note16: begin
									selectSound = 1'b1;
									settimeSound = 30'd11999999;  //c#
									setdelayFreq = {4'b1010, 15'd3000};
								end
								
					note17: begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = {4'b1000, 15'd3000};
								end
					note18: begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = {4'b1001, 15'd3000};
								end
								
					note19: begin
								selectSound = 1'b1;
								settimeSound = 30'd11999999;  //a#
								setdelayFreq = {4'b1011, 15'd3000};
							end
							
							
					note20: begin
								selectSound = 1'b1;
								settimeSound = 30'd11999999;  //a#
								setdelayFreq = {4'b1001, 15'd3000};
							end
							
							 //might need waiting phases
					
					note21: begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //a#
									setdelayFreq = {4'b1000, 15'd3000};;
								end
					note22: begin
									selectSound = 1'b1;
									settimeSound = 30'd11999999;  //a#
									setdelayFreq = {4'b1001, 15'd3000};
								end
								
					note23: begin
									selectSound = 1'b1;
									settimeSound = 30'd11999999;  //f
									setdelayFreq = {4'b1000, 15'd3000};  
								end
					note24: begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = {4'b0110, 15'd3000};
								end
				   note25: begin
									selectSound = 1'b1;
									settimeSound = 30'd11999999;  //c#
									setdelayFreq = {4'b0100, 15'd3000};  //initially 10999999
								end
								
					note26: begin
									selectSound = 1'b1;
									settimeSound = 30'd11999999;  //f
									setdelayFreq = {4'b0110, 15'd3000};
								end
								
								
					note27: begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = {4'b0100, 15'd3000};
								end
								
					note28: begin
									selectSound = 1'b1;
									settimeSound = 30'd11999999;  //f
									setdelayFreq = {4'b0110, 15'd3000};
								end
					note29:begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = {4'b0100, 15'd3000};
								end
					note30:begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = {4'b0110, 15'd3000};
								end
					note31: begin
									selectSound = 1'b1;
									settimeSound = 30'd11999999;  //f
									setdelayFreq = {4'b0100, 15'd3000};
								end
								
								
								
								
					note32: begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = {4'b0101, 15'd3000};
								end
				   note33: begin
									selectSound = 1'b1;
									settimeSound = 30'd11999999;  //c#
									setdelayFreq = {4'b0100, 15'd3000};  //initially 10999999
								end
								
					note34: begin
									selectSound = 1'b1;
									settimeSound = 30'd11999999;  //f
									setdelayFreq = {4'b0101, 15'd3000};
								end
								
								
					note35: begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = {4'b0100, 15'd3000};
								end
								
					note36: begin
									selectSound = 1'b1;
									settimeSound = 30'd11999999;  //f
									setdelayFreq = {4'b0101, 15'd3000};
								end
					note37:begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = {4'b0100, 15'd3000};
								end
					note38:begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = {4'b0101, 15'd3000};
								end
					note39: begin
									selectSound = 1'b1;
									settimeSound = 30'd11999999;  //f
									setdelayFreq = {4'b0100, 15'd3000};
								end
								
								
								//new set
								
					note40:begin
									selectSound = 1'b1;
									settimeSound = 30'd12999999;  //f
									setdelayFreq = {4'b1000, 15'd3000};
								end
					note41: begin
									selectSound = 1'b1;
									settimeSound = 30'd6999999;  //f
									setdelayFreq = {4'b1100, 15'd3000};
								end
								
								
								
						//test here		//changing to one second here
					note42: begin
									selectSound = 1'b1;
									settimeSound = 30'd49999999;  //f
									setdelayFreq = {4'b1110, 15'd3000};
								end
				   note43: begin
									selectSound = 1'b1;
									settimeSound = 30'd10999999;  //c#
									setdelayFreq = {4'b1010, 15'd3000};  //initially 10999999
								end
								
					note44: begin
									selectSound = 1'b1;
									settimeSound = 30'd49999999;  //f
									setdelayFreq = {4'b1000, 15'd3000};
								end
								
								
					note45: begin
									selectSound = 1'b1;
									settimeSound = 30'd10999999;  //f
									setdelayFreq = {4'b1010, 15'd3000};
								end
								
					note46: begin
									selectSound = 1'b1;
									settimeSound = 30'd49999999;  //f
									setdelayFreq = {4'b1110, 15'd3000};
								end
					note47:begin
									selectSound = 1'b1;
									settimeSound = 30'd10999999;  //f
									setdelayFreq = {4'b1100, 15'd3000};
								end
					note48:begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = {4'b1000, 15'd3000};
								end
					note49: begin
									selectSound = 1'b1;
									settimeSound = 30'd10999999;  //f
									setdelayFreq = {4'b1001, 15'd3000};
								end
								
								
								
					//set			
								
								
					note50:begin
									selectSound = 1'b1;
									settimeSound = 30'd12999999;  //f
									setdelayFreq = {4'b1100, 15'd3000};
								end
					note51: begin
									selectSound = 1'b1;
									settimeSound = 30'd6999999;  //f
									setdelayFreq = {4'b1010, 15'd3000};
								end
								
								
								
						
					note52: begin
									selectSound = 1'b1;
									settimeSound = 30'd49999999;  //f
									setdelayFreq = {4'b1100, 15'd3000};
								end
				   note53: begin
									selectSound = 1'b1;
									settimeSound = 30'd12999999;  //c#
									setdelayFreq = {4'b1010, 15'd3000};  //initially 10999999
								end
								
					note54: begin
									selectSound = 1'b1;
									settimeSound = 30'd12999999;  //f
									setdelayFreq = {4'b1100, 15'd3000};
								end
								
								
					note55: begin
									selectSound = 1'b1;
									settimeSound = 30'd49999999;  //f
									setdelayFreq = {4'b1010, 15'd3000};
								end
								
					note56: begin
									selectSound = 1'b1;
									settimeSound = 30'd10999999;  //f
									setdelayFreq = {4'b1100, 15'd3000};
								end
					note57:begin
									selectSound = 1'b1;
									settimeSound = 30'd49999999;  //f
									setdelayFreq = {4'b1010, 15'd3000};
								end
					note58:begin
									selectSound = 1'b1;
									settimeSound = 30'd21999999;  //f
									setdelayFreq = {4'b1100, 15'd3000};
								end
					note59: begin
									selectSound = 1'b1;
									settimeSound = 30'd10999999;  //f
									setdelayFreq = {4'b1010, 15'd3000};
								end
								
					
					
					
					
					
					
								
					
								
								
				
			endcase
		end
		
	
    // current_state registers
    always@(posedge clock)
		begin
        if(reset)
            current_state <= note1;
        else
            current_state <= next_state;
    end 



endmodule

