module level_counter #(parameter  width= 32)(
    rst_n,en,clk,sign,over
);
input rst_n;
input clk;
input en;
output reg [width-1 :0]sign;
output wire over;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)begin
        sign <= 1'd0;
    end
    else begin 
        if (en) sign <= sign + 1'b1;
    end
end
    assign over = & sign;
    
endmodule
