module ripple_adder
(
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
	  logic c0, c1, c2;
	  ADDER4 a0(.A(A[3:0]), .B(B[3:0]), .cin(0), .S(S[3:0]), .cout(c0));
	  ADDER4 a1(.A(A[7:4]), .B(B[7:4]), .cin(c0), .S(S[7:4]), .cout(c1));
	  ADDER4 a2(.A(A[11:8]), .B(B[11:8]), .cin(c1), .S(S[11:8]), .cout(c2));
	  ADDER4 a3(.A(A[15:12]), .B(B[15:12]), .cin(c2), .S(S[15:12]), .cout(cout));

endmodule

/** module full_adder (input x, y, z,
 output logic s, c);
assign s = x^y^z;
assign c = (x&y)|(y&z)|(x&z);
endmodule **/

/** module ADDER4 (input [3:0] A, B,
 input c_in,
 output logic [3:0] S,
 output logic c_out);
endmodule **/

// Internal carries in the 4-bit adder
/** logic c0, c1, c2;
/*============================================*/
// Netlists with named (explicit) port connection
// Syntax: <module> <name>(.<parameter_name> (<connection_name>), …)
/** full_adder FA0(.x (A[0]), .y (B[0]), .z (c_in), .s (S[0]), .c (c0));
full_adder FA1(.x (A[1]), .y (B[1]), .z (c0), .s (S[1]), .c (c1));
full_adder FA2(.x (A[2]), .y (B[2]), .z (c1), .s (S[2]), .c (c2));
full_adder FA3(.x (A[3]), .y (B[3]), .z (c2), .s (S[3]), .c (cout));
// endmodule **/


    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
		
