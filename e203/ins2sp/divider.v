module divider #(parameter N = 21)(
    clk, rst_n, a, b, yshang, yyushu,en,done
);
input clk;
input rst_n;
input en;
input [N-1:0] a;
input [N-1:0] b;
output reg [N-1:0] yshang;
output reg [N-1:0] yyushu;
output reg done;

parameter S=N<<1; 
reg[N-1:0] tempa;
reg[N-1:0] tempb;
reg[S-1:0] temp_a;
reg[S-1:0] temp_b; 
reg [5:0] status;
parameter s_idle = 6'b000000;
parameter s_init = 6'b000001;
parameter s_calc1 = 6'b000010;
parameter s_calc2 = 6'b000100;
parameter s_done = 6'b001000;
 
reg [N-1:0] i;
 
always @(posedge clk)
begin
    if(!rst_n)
        begin
            i <= 21'h0;
            tempa <= 21'h1;
            tempb <= 21'h1;
            yshang <= 21'h1;
            yyushu <= 21'h1;
            done <= 1'b0;
            status <= s_idle;
        end
    else
        begin
            case (status)
            s_idle:
                begin
                    if(en)
                        begin
                            tempa <= a;
                            tempb <= b;
                            status <= s_init;
                        end
                    else
                        begin
                            i <= 21'h0;
                            tempa <= 21'h1;
                            tempb <= 21'h1;
                            yshang <= 21'h1;
                            yyushu <= 21'h1;
                            done <= 1'b0;
                            status <= s_idle;
                        end
                end
                
            s_init:
                begin
                    temp_a <= {21'h00000000,tempa};
                    temp_b <= {tempb,21'h00000000};
                    status <= s_calc1;
                end
                
            s_calc1:
                begin
                    if(i < N)
                        begin
                            temp_a <= {temp_a[S-2:0],1'b0};
                            status <= s_calc2;
                        end
                    else
                        begin
                            status <= s_done;
                        end
                    
                end
                
            s_calc2:
                begin
                    if(temp_a[S-1:N] >= tempb)
                        begin
                            temp_a <= temp_a - temp_b + 1'b1;
                        end
                    else
                        begin
                            temp_a <= temp_a;
                        end
                    i <= i + 1'b1;    
                    status <= s_calc1;
                end
            
            s_done:
                begin
                    yshang <= temp_a[N-1:0];
                    yyushu <= temp_a[S-1:N];
                    done <= 1'b1;
                    
                    status <= s_idle;
                end
            
            default:
                begin
                    status <= s_idle;
                end
            endcase
        end
   
end


    
endmodule