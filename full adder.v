module half_adder(A,B,S,C);
input A,B;
output reg S,C;
always @ (*)
begin
S=A^B;
C=A&B;
end
endmodule 
module full_adder(
