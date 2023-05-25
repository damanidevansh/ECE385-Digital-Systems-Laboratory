module control (input logic Clk, Reset, Run, M,
						output logic Shift_En, Add, Sub, ClearXandA, LoadB, LoadA, LoadX, ResetOut);
	enum logic [4:0] {Start, Load, AddZero, ShiftZero,
							AddOne, ShiftOne,
							AddTwo, ShiftTwo,
							AddThree, ShiftThree,
							AddFour, ShiftFour,
							AddFive, ShiftFive,
							AddSix, ShiftSix,
							AddSeven, ShiftSeven, STOP, defaults, begine
							} curr_state, next_state; // Internal

		always_ff @ (posedge Clk ) // Sequential logic
		begin
		if (Reset)
			curr_state <= Start;
			//curr_state = Start; // alternatively use the enum method
		else 
			curr_state <= next_state;
		end

	always_comb 
	begin
		next_state = curr_state; //Default state

		unique case (curr_state)
			Start 	: 	next_state = Load;
							
			Load		: if(Run)
							next_state <= AddOne;
							else
							next_state <=Load;
							
		
			AddZero	: 	next_state <= ShiftZero;
			ShiftZero 	: 	next_state <= AddOne;

			
			AddOne	: 	next_state <= ShiftOne;
			ShiftOne 	: 	next_state <= AddTwo;
			
			
			AddTwo	: 	next_state <= ShiftTwo;
			ShiftTwo 	: 	next_state <= AddThree;
			
			
			AddThree	: 	next_state <= ShiftThree;
			ShiftThree 	: 	next_state <= AddFour;
			
			AddFour	: 	next_state <= ShiftFour;
			ShiftFour 	: 	next_state <= AddFive;
			
			AddFive	: 	next_state <= ShiftFive;
			ShiftFive 	: 	next_state <= AddSix;
			
			AddSix	: 	next_state <= ShiftSix;
			ShiftSix 	: 	next_state <= AddSeven;
			
			AddSeven	: 	next_state <= ShiftSeven;
			ShiftSeven 	: 	next_state <= STOP;
			
			
			STOP:   if(~Run)
						next_state <= begine;
						else next_state <= STOP;
						
			begine: if(Run)
						next_state <= defaults;
						
			defaults:if(Run)
				next_state <= AddZero;
				
		endcase
end
// Assign outputs based on ‘state’
always_comb 

begin case (curr_state)
	
begine:
	begin
	LoadA <= 1'b0;
	LoadB <= 1'b0;
	ClearXandA <= 1'b0;
	LoadX <= 1'b0;
	ResetOut <= 1'b0;
	Shift_En <= 1'b0;
	end

Start:
	begin
	Shift_En <= 1'b0;
	Sub <= 1'b0;
	ClearXandA <= 1'b1;
	LoadA <= 1'b0;
	LoadB <= 1'b0;
	LoadX <= 1'b0;
	ResetOut <= 1'b0;
	end
	
Load:
	begin
	Shift_En <= 1'b0;
	Sub <= 1'b0;
	ClearXandA <= 1'b1;
	LoadB <= 1'b0;
	LoadX <= 1'b0;
	ResetOut <= 1'b0;
   end
 
AddZero, AddOne, AddTwo, AddThree, AddFour, AddFive, AddSix, AddSeven:
	begin
	if ( M == 1'b0)
	Shift_En <= 1'b0;
	Sub <= 1'b0;
	ClearXandA <= 1'b0;
	LoadA <= 1'b1;
	LoadB <= 1'b1;
	LoadX <= 1'b1;
	ResetOut <= 1'b0;
	
else if(M)
	LoadA <= 1'b1;
	LoadX <= 1'b1;
else                                                                  
	LoadA <= 1'b0;
	LoadX <= 1'b0;
	end
end
ShiftZero, ShiftOne, ShiftTwo, ShiftThree, ShiftFour, ShiftFive, ShiftSix, ShiftSeven:
begin
Shift_En <= 1'b1;
Sub <= 1'b0;
ClearXandA <= 1'b0;
LoadB <= 1'b0;
LoadA <= 1'b0;
LoadX <= 1'b0;
ResetOut <= 1'b0;
end

 
endcase
end
endmodule