`timescale 1s / 1s
module trafficlight(ml,sl,ms,ss);
import states::*;
output [1:0] ml,sl;
input ms,ss;
reg [1:0] ml,sl;
reg [1:0] state,nextstate;
reg ctrl,en;
initial begin
	ml = G;
	sl = R;
	ctrl = 0;
	state = GR;
	nextstate = GR;
	en = 0;
end

always @(ctrl) begin
	wait(en == 1'b1)
	case(state)
	GR: begin nextstate = YR; ml = Y; sl = R; end
	YR: begin nextstate = RG; ml = R; sl = G; end
	RG: begin nextstate = RY; ml = R; sl = Y; end
	RY: begin nextstate = GR; ml = G; sl = R; end
	endcase
	state = nextstate;
	en = 0;
end

always begin
	wait(en == 1'b0);
	case(state)
	GR: #180 begin
		wait(ms == 1'b0 && ss == 1'b1);
		ctrl = ~ctrl;
	end
	YR: #10 ctrl = ~ctrl;
	RG: 
	fork: rgfork
		#120 begin
		ctrl = ~ctrl;
		disable rgfork;
		end
		begin
		wait(ss == 1'b0);
		ctrl = ~ctrl;
		disable rgfork;
		end
	join
	RY: #10 ctrl = ~ctrl;
	endcase
	en = 1;
end

endmodule
