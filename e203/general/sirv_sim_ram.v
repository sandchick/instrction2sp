 /*                                                                      
 Copyright 2018-2020 Nuclei System Technology, Inc.                
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
  Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */                                                                      
                                                                         
                                                                         
                                                                         
//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  The simulation model of SRAM
//
// ====================================================================
module sirv_sim_ram 
#(parameter DP = 8192,
  parameter FORCE_X2ZERO = 0,
  parameter DW = 64,
  parameter MW = 8,
  parameter AW = 13 
)
(
  input             clk, 
  input  [DW-1  :0] din, 
  input  [AW-1  :0] addr,
  input             cs,
  input             we,
  input  [MW-1:0]   wem,
  output [DW-1:0]   dout
);
 
  wire cs1;
  wire cs2;



  wire [DW-1:0] dout_pre;
  assign addr14 = AW;
  begin
    generate
      for (genvar i = 0; i < MW; i = i+1) begin :mem1
     sram usram1(
     .A (addr)
     ,.D (din[8*i+7:8*i])
     ,.WEN (we)
     ,.CEN (cs)
     ,.Q (dout_pre[8*i+7:8*i])
     );
      end
    endgenerate

// assign cs1 = cs & addr[AW-1];
// assign cs2 = cs & (~addr[AW-1]);
  //  generate
  //    for (genvar j = 0; j < MW; j = j+1) begin :mem2
  //   sram usram2(
  //   .A (addr[AW-2:0])
  //   ,.D (din[8*j+7:8*j])
  //   ,.WEN (we)
  //   ,.CEN (cs2)
  //   ,.Q (dout_pre[8*j+7:8*j])
  //   );
  //    end
  //  endgenerate

       assign dout = dout_pre;

 
endmodule
