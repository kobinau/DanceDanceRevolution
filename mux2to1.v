

module mux2to1(input black,  output reg[2:0]color);//black or white?
			always@(*)

			begin
			if(black)
				color = 3'b000;
			else
				color = 3'b111;
				end
		endmodule					
				
				
				
				
				
				
				
				
				
				
				
				
				
					
				
				
				
				
				
				
				
				
					