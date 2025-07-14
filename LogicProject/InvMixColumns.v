module InvMixColumns(input [0:127]state,output [0:127] out);
function[7:0] multiply(input [7:0]x,input integer n);
integer i;
begin
	for(i=0;i<n;i=i+1)begin
		if(x[7] == 1) x = ((x << 1) ^ 8'h1b);
		else x = x << 1; 
	end
	multiply=x;
end

endfunction

function [7:0] MBe; 
input [7:0] x;
begin
	MBe=multiply(x,3) ^ multiply(x,2)^ multiply(x,1);
end
endfunction

function [7:0] MBd; 
input [7:0] x;
begin
	MBd=multiply(x,3) ^ multiply(x,2)^ x;
end
endfunction

function [7:0] MBb;
input [7:0] x;
begin
	MBb=multiply(x,3) ^ multiply(x,1)^ x;
end
endfunction

function [7:0] MB9; 
input [7:0] x;
begin
	MB9=multiply(x,3) ^  x;
end
endfunction

reg [0:127]temp;



always @(*) begin
//s 0,c
temp[0:7] =    { MBe(state[0:7]) ^ MBb(state[8:15]) ^ MBd(state[16:23]) ^ MB9(state[24:31]) };
temp[32:39] =  { MBe(state[32:39]) ^ MBb(state[40:47]) ^ MBd(state[48:55]) ^ MB9(state[56:63]) };
temp[64:71] =  { MBe(state[64:71]) ^ MBb(state[72:79]) ^ MBd(state[80:87]) ^ MB9(state[88:95]) };
temp[96:103] = { MBe(state[96:103]) ^ MBb(state[104:111]) ^ MBd(state[112:119]) ^ MB9(state[120:127]) };

//s 1,c
temp[8:15] =  { MB9(state[0:7]) ^ MBe(state[8:15]) ^ MBb(state[16:23]) ^ MBd(state[24:31]) };
temp[40:47] = { MB9(state[32:39]) ^ MBe(state[40:47]) ^ MBb(state[48:55]) ^ MBd(state[56:63]) };
temp[72:79] =  { MB9(state[64:71]) ^ MBe(state[72:79]) ^ MBb(state[80:87]) ^ MBd(state[88:95]) };
temp[104:111] =  { MB9(state[96:103]) ^ MBe(state[104:111]) ^ MBb(state[112:119]) ^ MBd(state[120:127]) };

//s 2,c
temp[16:23] = { MBd(state[0:7]) ^ MB9(state[8:15]) ^ MBe(state[16:23]) ^ MBb(state[24:31]) };
temp[48:55] = { MBd(state[32:39]) ^ MB9(state[40:47]) ^ MBe(state[48:55]) ^ MBb(state[56:63]) };
temp[80:87] = { MBd(state[64:71]) ^ MB9(state[72:79]) ^ MBe(state[80:87]) ^ MBb(state[88:95]) };
temp[112:119] = { MBd(state[96:103]) ^ MB9(state[104:111]) ^ MBe(state[112:119]) ^ MBb(state[120:127]) };

//s 3,c
temp[24:31] =  { MBb(state[0:7]) ^ MBd(state[8:15]) ^ MB9(state[16:23]) ^ MBe(state[24:31]) };
temp[56:63] =  { MBb(state[32:39]) ^ MBd(state[40:47]) ^ MB9(state[48:55]) ^ MBe(state[56:63]) };
temp[88:95] =  { MBb(state[64:71]) ^ MBd(state[72:79]) ^ MB9(state[80:87]) ^ MBe(state[88:95]) };
temp[120:127] = { MBb(state[96:103]) ^ MBd(state[104:111]) ^ MB9(state[112:119]) ^ MBe(state[120:127]) };

end

assign out = temp;


endmodule
