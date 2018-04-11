`timescale 1s / 1s
module trafficlighttb;

wire [1:0] ml,sl;
reg ms,ss;
trafficlight tl(ml,sl,ms,ss);

initial begin
	ms = 0;
	ss = 0;
	#200 ms = 1; //GR
	#10 ms = 0; //GR->YR->RG
	    ss = 1;
	#30 ss = 0; //RG->RY->GR
	    ms = 1;
	#180 ms = 0; //GR->YR->RG
	     ss = 1;
	#130 ss = 1; //RG->RY->GR
	#200 $stop;
end

initial
	$monitor($stime,ml,sl,ms,ss);
endmodule
