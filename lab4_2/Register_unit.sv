module reg_8 (input  logic Clk, Reset, Shift_In, Load, Shift_En,
              input  logic [7:0]  D_in,
              output logic Shift_Out,
              output logic [7:0]  D_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset)
			  D_Out <= 8'h0;
		 else if (Load)
			  D_Out <= D_in;
		 else if (Shift_En)
		 begin
			  D_Out <= { Shift_In, D_Out[7:1] }; 
	    end
    end
	
    assign Shift_Out = D_Out[0];

endmodule


module reg_1 (input logic Clk, Reset, D_in, Load,
					output logic D_out);
					
					always_ff @ (posedge Clk)
					begin
						if (Reset)
							D_out <= 1'b0;
						else if (Load)
							D_out <= D_in;
						end
endmodule
