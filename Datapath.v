//Muhammad Taha , Furqan Ahmed Fareed , Muhammad Junaid CE-44 SYN B. We are currently figuring out how to make module datapath more efficient we have integrated both Register file and ALU in Datapath.
module Datapath (Instr,Rd,PC,pc);
input [15:0] Instr;
reg [2:0] rs,rt,rd;
reg [15:0] register [0:7] ;
reg [2:0] shift;
reg [3:0] opcode;
output reg [15:0] Rd;
reg [15:0] memory[0:7];
reg [5:0] constant;
reg [8:0] address;
input [7:0] PC;
output reg [7:0] pc;
reg [15:0] hi,lo,sr;
always @ (Instr)
begin
opcode=Instr[3:0];
rd=Instr[6:4];
rs=Instr[9:7];
rt=Instr[12:10];
shift=Instr[15:13];
constant=Instr[15:10];
address=Instr[12:4];

if (opcode==4'b0000)
begin
register[rd]=register[rs]+register[rt];
Rd=register[rd];
pc=PC;
end
else if (opcode==4'b0001)
begin
register[rd]=register[rs]<<shift;
Rd=register[rd];
pc=PC;
end
else if (opcode==4'b0010)
begin
register[rd]=register[rs]>>shift;
Rd=register[rd];
pc=PC;
end
else if (opcode==4'b1010)
begin
register[rd]=register[rs]*register[rt];
Rd=register[rd];
pc=PC;
end
else if (opcode==4'b1011)
begin
register[rd]=lo;
Rd=register[rd];
pc=PC;
end
else if (opcode==4'b1100)
begin
register[rd]=hi;
Rd=register[rd];
pc=PC;
end
else if (opcode==4'b0011)
begin
register[rd]=register[rs]|register[rt];
Rd=register[rd];
pc=PC;
end
else if (opcode==4'b0100)
begin
register[rd]=register[rs]&register[rt];
Rd=register[rd];
pc=PC;
end
else if (opcode==4'b0101)
begin
register[rd]=register[rs]+constant;
Rd=register[rd];
pc=PC;
end
else if (opcode==4'b0110)
begin
register[rd]=constant;
Rd=register[rd];
pc=PC;
end
else if (opcode==4'b0111)
begin
register[rd]=memory[register[rs]+constant];
Rd=register[rd];
pc=PC;
end
else if (opcode==4'b1000)
begin
memory[register[rs]+constant]=register[rd];
Rd=register[rd];
pc=PC;
end
else if (opcode==4'b1001)
begin
pc=PC-address;
end
end 
endmodule 