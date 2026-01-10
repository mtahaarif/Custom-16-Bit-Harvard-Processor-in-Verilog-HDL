module Control (clk,rst,data_in,PC,pc,Instr,Rd,sr);

input clk,rst;
input [7:0] data_in;
reg [7:0] R;
reg [15:0] ROM [0:16];
output [15:0] sr,Rd;
output [7:0]pc;
output reg [7:0] PC;
output reg [15:0] Instr;

Datapath D1 (Instr,PC,Rd,sr,pc);

initial begin
#100
R=data_in;
PC=data_in;
end

always@(posedge clk, posedge rst ,negedge rst)

begin

if (rst==1)
begin
R=0;
end

else if (rst==0)
begin
R=R+1;
end

if (clk==1)
begin
PC=R;
end 

else if (clk==0)
begin
PC=R;

end
end

always @ (PC)
begin

ROM[0]=16'b0000100000000110; //saves 2 in register [0];
ROM[1]=16'b0000110000010110; //saves 3 in register [1];
ROM[2]=16'b0000000010100000; //register[2]= register [1] +register [0];
ROM[3]=16'b0100000010110001; //register[3]= sll register[1], 2 ;
ROM[4]=16'b0100000011000010; //register[4]= srl register[1], 2 ;
ROM[5]=16'b0000000011011010; //multiple=  register [1] * register [0];
ROM[6]=16'b0000000011011011; //register[5]= lo ;
ROM[7]=16'b0000000011111100; //register[7]= hi ;
ROM[8]=16'b0000000010100011; //register[2]= register [1] OR register [0];
ROM[9]=16'b0000000010100100; //register[2]= register [1] AND register [0];
ROM[10]=16'b0000110010100101; //register[2]= register[1] + 3 ;
ROM[11]=16'b0000110001100110; //register[6]= 3;
ROM[12]=16'b0000110011011000; //memory[register[1]+3] = register [5];
ROM[13]=16'b0000000010101110; //register[2]= register [3] +register [4] if register[1]<register[0];
ROM[14]=16'b0000110010000111; //register[0]=memory[register[1]+3];
ROM[15]=16'b0000000100011101; // EXIT if register[0]=54;
ROM[16]=16'b0000000000111001; // PC=address(3);

Instr=ROM[PC];

if (R==17)
begin
R=pc;
PC=pc;
Instr=ROM[pc];
end

if (pc==17)
begin
R=pc;
PC=pc;
Instr=ROM[pc];
end

end
endmodule

module Datapath (Instr,PC,Rd,sr,pc);

input [15:0] Instr;
input [7:0] PC;
reg [3:0] opcode;
reg [2:0] rd,rs,rt,shift;
reg [5:0] constant;
reg [8:0] address;
reg [15:0] hi,lo;
reg [31:0] multiple;
reg [15:0] memory[0:7];
reg [15:0] register [0:7];
output reg [15:0] Rd,sr;
output reg [7:0] pc;

always @ (Instr)
begin
opcode=Instr[3:0];
rd=Instr[6:4];
rs=Instr[9:7];
rt=Instr[12:10];
shift=Instr[15:13];
constant=Instr[15:10];
address=Instr[12:4];
sr=16'b0000000000000000;

if (opcode==4'b0000)
begin
register[rd]=register[rs]+register[rt];
Rd=register[rd];
pc=PC;

if (register[rs]==register[rt])
begin
sr=sr|8;
end

else if (register[rs]<register[rt])
begin
sr=sr|4;
end

if (register[rd]==16'b1111111111111111)
begin
sr=sr|1;
end
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
multiple=register[rs]*register[rt];
lo=multiple[15:0];
hi=multiple[31:16];
Rd=lo;
pc=PC;

if (register[rs]==register[rt])
begin
sr=sr|8;
end

if (register[rs]<register[rt])
begin
sr=sr|4;
end

if (multiple==32'b11111111111111111111111111111111)
begin
sr=sr|1;
end
end

else if (opcode==4'b1011)
begin
register[rd]=lo;
Rd=register[rd];
pc=PC;

if (register[rd]==16'b1111111111111111)
begin
sr=sr|1;
end
end

else if (opcode==4'b1100)
begin
register[rd]=hi;
Rd=register[rd];
pc=PC;

if (register[rd]==16'b1111111111111111)
begin
sr=sr|1;
end
end

else if (opcode==4'b0011)
begin
register[rd]=register[rs]|register[rt];
Rd=register[rd];
pc=PC;

if (register[rs]==register[rt])
begin
sr=sr|8;
end

if (register[rs]<register[rt])
begin
sr=sr|4;
end

if (register[rd]==16'b1111111111111111)
begin
sr=sr|1;
end
end

else if (opcode==4'b0100)
begin
register[rd]=register[rs]&register[rt];
Rd=register[rd];
pc=PC;

if (register[rs]==register[rt])
begin
sr=sr|8;
end

if (register[rs]<register[rt])
begin
sr=sr|4;
end

if (register[rd]==16'b1111111111111111)
begin
sr=sr|1;
end
end

else if (opcode==4'b0101)
begin
register[rd]=register[rs]+constant;
Rd=register[rd];
pc=PC;

if (register[rd]==16'b1111111111111111)
begin
sr=sr|1;
end
end

else if (opcode==4'b0110)
begin
register[rd]=constant;
Rd=register[rd];
pc=PC;

if (register[rd]==16'b1111111111111111)
begin
sr=sr|1;
end
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
pc=address;
Rd=address;
end

else if (opcode==4'b1101) 
begin
if (register[0]==16'b0000000000110110)
begin
pc=address;
Rd=address;
end

else
begin
pc=PC;
Rd=register[0];
end
end

else if (opcode==4'b1110)
begin

if (register[rs]<register[rt])
begin
sr=sr|4;
end

if (sr==16'b0000000000000100)
begin
register[rd]= register [3] +register[4];
Rd=register[rd];
pc=PC;
end

else
begin
Rd=register[rd];
pc=PC;
end
end
end 
endmodule 
