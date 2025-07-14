module  Encrypt#(parameter Nk,parameter Nr)(input clk,reset,input [127:0]in,input [32*Nk-1:0]key,output reg[127:0]state,input s1,s2);


wire [(128*(Nr+1))-1 :0] word;
reg[127:0]a1;
wire[127:0]a2;
wire[127:0]a3;
reg[127:0]a4;

wire[127:0]b1;
wire[127:0]b2;
wire[127:0]b3;

integer i = 0;

always @(posedge clk or posedge reset) begin
 if (reset) begin
    i = 0;
    state<=in;
    a1 <= 128'h0;
    a4 <= 128'h0;
 end      
 else begin
  if (i==0) begin
    a1 <= a3;
    state<=a3;  i = i + 1;
  end 
  else if (i>0 && i<Nr-1) begin
    a1 <= a2; 
    state<=a2; 
    i = i + 1; 
  end
  else if(i==Nr-1)  begin
    a4<=a2;
    state<=a2;
    i = i + 1;					   
  end
  else  if(i >= Nr) begin
	state<=b3;
  end 
 end
end


always @(s1,s2) begin
    i = 0;
    state<=128'h0;
    a1 <= 128'h0;
    a4 <= 128'h0;
end


KeyExpansion #(Nk,Nr)ke(key,word);
addRoundKey ar (in,word[128*(Nr)+:128],a3);
ERound er(a1,word[128*(Nr-i)+:128],a2);
subBytes sb(a4,b1);
ShiftRows sr(b1,b2);
addRoundKey addrk(b2,word[128* 0+:128],b3);







endmodule