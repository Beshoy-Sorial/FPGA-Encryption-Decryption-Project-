module DRound(input [127:0]in,input [127:0]key,output [127:0]out);



wire [127:0]out1;
wire [127:0]out2;
wire [127:0]out3;
wire [127:0]out4;

  InvShiftRows isr(in,out1);
  InvsubBytes isb(out1,out2);
  addRoundKey ar(out2,key,out3);
  InvMixColumns imx(out3,out4);



assign out = out4;




endmodule
