module select_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);

    /* TODO
     *
     * Insert code here to implement a CSA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  logic c0, c1, c2;
	  ADDER4 a4(.A(A[3:0]), .B(B[3:0]), .cin(cin), .S(S[3:0]), .cout(c0));
     selectAdder sa1(.a(A[7:4]), .b(B[7:4]), .cin(c0), .S(S[7:4]), .cout(c1));
	  selectAdder sa2(.a(A[11:8]), .b(B[11:8]), .cin(c1), .S(S[11:8]), .cout(c2));
	  selectAdder sa3(.a(A[15:12]), .b(B[15:12]), .cin(c2), .S(S[15:12]), .cout(cout));
endmodule

module selectAdder(input logic [3:0] a, b,
				input logic cin,
				output logic [3:0]S, 
				output logic cout);
	/** logic [3:0] s0, s1;
	logic c0, c1;
	full_adder FA0(.x(a), .y(b), .z(1'b0), .s(s0), .c(c0));
	full_adder FA1(.x(a), .y(b), .z(1'b1), .s(s1), .c(c1));
	mux_21 m0(.d0(s0[0]), .d1(s1[0]), .sel(cin), .out(S[0]));
	mux_21 m1(.d0(s0[1]), .d1(s1[1]), .sel(c1), .out(S[1]));
	mux_21 m2(.d0(s0[2]), .d1(s1[2]), .sel(cin), .out(S[2]));
	mux_21 m3(.d0(s0[3]), .d1(s1[3]), .sel(cin), .out(S[3]));
	mux_21 m4(.d0(c0), .d1(c1), .sel(cin), .out(cout)); **/
	
	logic cout1, cout2;
	logic [3:0] s0, s1;
	logic c_temp;
	
	ADDER4 a10(.A(a[3:0]), .B(b[3:0]), .cin(1'b0), .S(s0), .cout(cout1));
	ADDER4 a11(.A(a[3:0]), .B(b[3:0]), .cin(1'b1), .S(s1), .cout(cout2));
	
	mux_21 mux1(.d0(s0), .d1(s1), .sel(cin), .out(S[3:0]));
	
	assign c_temp = (cin & cout2);
	assign cout = (c_temp | cout1);
	
endmodule 

module mux_21(input logic [3:0] d0,d1, 
				input logic sel,
				output logic [3:0] out);
	always_comb
	begin
		if (sel == 1'b1)
			out = d1;
		else
			out = d0;
	end
endmodule 

/**module ADDER4 (input [3:0] A, B,
 input c_in,
 output logic [3:0] S,
 output logic c_out);**/

// Internal carries in the 4-bit adder
//logic c0, c1, c2;
/*============================================*/
// Netlists with named (explicit) port connection
// Syntax: <module> <name>(.<parameter_name> (<connection_name>), …)
/**full_adder FA0 (.x (A[0]), .y (B[0]), .z (c_in), .s (S[0]), .c (c0));
full_adder FA1 (.x (A[1]), .y (B[1]), .z (c0), .s (S[1]), .c (c1));
full_adder FA2 (.x (A[2]), .y (B[2]), .z (c1), .s (S[2]), .c (c2));
full_adder FA3 (.x (A[3]), .y (B[3]), .z (c2), .s (S[3]), .c (c_out));
endmodule

module full_adder (input x, y, z,
 output logic s, c);
assign s = x^y^z;
assign c = (x&y)|(y&z)|(x&z);
endmodule **/

