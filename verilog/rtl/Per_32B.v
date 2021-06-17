// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0


module Per_32B(P,X, Y, clk, rst);

output reg [31:0]P;
input [31:0]X,Y;
input clk,rst;
reg [31:0]Per;
integer i,j=31,k=0;

always@(posedge clk)
begin
	if (!rst)
	begin
		for (i=31;i>=0;i=i-1)
		begin              
        
		    if(Y[i])
			begin
			        Per[j] <= X[i];
			        j=j-1;
		  
			end
	 
		     else 
			begin
				  Per[k] <= X[i];
				  k=k+1;
			end
		end
	j=31;
	k=0;
	end 
	else 
	begin
		Per <= 32'h00000000;
	end

P <= Per;
end

endmodule 
