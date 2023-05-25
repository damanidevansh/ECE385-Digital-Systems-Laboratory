module lookahead_adder (
	input logic [15:0] A, B,
	input logic        cin,
	output logic [15:0] S,
	output logic       cout
);

/**logic c0, c1, c2;
logic [3:0] P;
logic [3:0] G;

lookahead la0(.a,.b,c[0],s,p,g) 
always_comb
begin
c0 = (0&P[0]) | G[0] 
 input c_in,
c1 = (0&P[0} & P[1] | G[0] & G[1]) //
end **/

/**module lookahead (input [3:0] A, B, 
 input c_in,
 output logic [3:0] S,
 output logic p, g);

endmodule

module full_adder (input x, y, z,
 output logic s, c);
assign s = x^y^z;
assign c = (x&y)|(y&z)|(x&z);
endmodule**/

//	  logic c1out, c2out, c3out;
		logic [3:0] pg;
		logic [3:0] gg;
		logic cout1, cout2, cout3;
		
	  loadadder la0(.A(A[3:0]), .B(B[3:0]), .cin(cin), .s(S[3:0]), .pg(pg[0]), .gg(gg[0]));
	  loadadder la1 (.A(A[7:4]), .B(B[7:4]), .cin(cout1), .s(S[7:4]), .pg(pg[1]), .gg(gg[1]));
	  loadadder la2(.A(A[11:8]), .B(B[11:8]), .cin(cout2), .s(S[11:8]),.pg(pg[2]), .gg(gg[2]));
	  loadadder la3(.A(A[15:12]), .B(B[15:12]), .cin(cout3), .s(S[15:12]), .pg(pg[3]), .gg(gg[3]));
	  
	  assign cout1 = (gg[0] | cin & pg[0]);
	  assign cout2 = gg[1] | gg[0] & pg[1] | cin & pg[0] & pg[1];
	  assign cout3 = gg[2] | gg[1] & pg[2] | gg[0] & pg[2] &pg[1] | cin & pg[2] & pg[1] & pg[0];
	  
	  assign cout = gg[3] | gg[2] & pg[3] | gg[1] & pg[2] & pg[3] | gg[0] & pg[3] & pg[2] & pg[1] | cin & pg[3] & pg[2] & pg[1] & pg[0];
	  

endmodule
module loadadder(input logic [3:0]A,B,
					input logic cin,
					output logic [3:0] s,
					output logic pg, gg);
					
		logic [3:0] p;
		logic [3:0] g;
		logic 		c0,c1,c2,c3;


super_lookahead SL0(.x(A[0]), .y(B[0]), .z(c0), .s(s[0]), .g(g[0]), .p(p[0]));  
super_lookahead SL1(.x(A[1]), .y(B[1]), .z(c1), .s(s[1]), .g(g[1]), .p(p[1]));  
super_lookahead SL2(.x(A[2]), .y(B[2]), .z(c2), .s(s[2]), .g(g[2]), .p(p[2]));  
super_lookahead SL3(.x(A[3]), .y(B[3]), .z(c3), .s(s[3]), .g(g[3]), .p(p[3]));  

		assign c0 = cin;
		assign c1 = cin & p[0] | g[0];
		assign c2 = cin & p[0] & p[1] | g[0] & p[1] | g[1];
	   assign c3 = cin & p[0] & p[1] & p[2] | g[0] & p[1] & p[2] | g[1] & p[2] | g[2];
	  //cout1 = gg[0] + c[0] & pg[0];
	  
	 assign pg = ( p[0] & p[1] & p[2] & p[3]);
	 assign gg = g[3] | (g[2] & p[3] | g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]);


endmodule
module super_lookahead	 (input logic x, y, z,
						  output logic s, p, g);
		assign s = (x^y^z);
		assign g = (x & y);
		assign p = (x ^ y);

endmodule