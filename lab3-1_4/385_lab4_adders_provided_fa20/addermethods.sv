module full_adder (input x, y, z,
 output logic s, c);
assign s = x^y^z;
assign c = (x&y)|(y&z)|(x&z);
endmodule

module ADDER4 (input [3:0] A, B,
 input cin,
 output logic [3:0] S,
output logic cout);
logic c0, c1, c2;
full_adder FA0 (.x (A[0]), .y (B[0]), .z (cin), .s (S[0]), .c (c0));
full_adder FA1 (.x (A[1]), .y (B[1]), .z (c0), .s (S[1]), .c (c1));
full_adder FA2 (.x (A[2]), .y (B[2]), .z (c1), .s (S[2]), .c (c2));
full_adder FA3 (.x (A[3]), .y (B[3]), .z (c2), .s (S[3]), .c (cout));

endmodule