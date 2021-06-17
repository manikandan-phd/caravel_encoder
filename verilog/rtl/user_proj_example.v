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

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 * Multipurpose encoder integrated with caravel
 * Receives input from LA and outputs either to LA and directed to 
 * GPIO
 * Test bench la_test1 can be used to test the encoding process
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    wire clk;
    wire rst;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire [31:0] rdata; 
    wire [31:0] wdata;
    wire [BITS-1:0] CODE;

    wire valid;
    wire [3:0] wstrb;
    wire [31:0] la_write;

    // WB MI A
    assign valid = wbs_cyc_i && wbs_stb_i; 
    assign wstrb = wbs_sel_i & {4{wbs_we_i}};
    assign wbs_dat_o = rdata;
    assign wdata = wbs_dat_i;

    // IO
    assign io_out = CODE;
    assign io_oeb = {(`MPRJ_IO_PADS-1){rst}};

    // IRQ
    assign irq = 3'b000;	// Unused
	
    // LA
    assign la_data_out = {{(127-BITS){1'b0}}, CODE};
	
    // Assuming LA probes [127:32] are for controlling the CODE register  
    
    assign la_write = ~((la_oenb[127:96] | la_oenb[95:64] )| la_oenb[63:32]);
	
    // controlling the CODE clk & reset  
    assign clk = wb_clk_i;
    assign rst = wb_rst_i;
	
    multi_encoder #(
        .BITS(BITS)
    ) multi_encoder(
        .clk(clk),
        .rst(rst),
      //.ready(wbs_ack_o),
      //.valid(valid),
      //.rdata(rdata),
      //.wdata(wbs_dat_i),
      //.wstrb(wstrb),
        .la_write(la_write),
        .RM(la_data_in[127:96]),
		.RT(la_data_in[95:64]),
		.KEY(la_data_in[63:32]),
        .CODE(CODE)
    );

endmodule

module multi_encoder #(
    parameter BITS = 32
)(
    input clk,
    input rst,
  //input valid,
  //input [3:0] wstrb,
  //input [BITS-1:0] wdata,
    input [BITS-1:0] la_write,
    input [BITS-1:0] RM,
    input [BITS-1:0] RT,
    input [BITS-1:0] KEY,
    output ready,
  //output [BITS-1:0] rdata,
    output [BITS-1:0] CODE
);
   //reg ready;
    reg [BITS-1:0] CODE,T_TEMP,R_TEMP,SKEY,PDT,PDR;
  //reg [BITS-1:0] rdata;
    wire [BITS-1:0]PT,PM;
    Per_32B pt(PT,RT,KEY, clk,rst);
    Per_32B pm(PM,RM,KEY, clk,rst);

    always @(posedge clk) begin
        if (rst) begin
	        PDT[31:0]<= 32'h0000000; 
		PDR[31:0]<= 32'h0000000;
		CODE[31:0] <= 32'h0000000;
        end
	else if (|la_write) begin
                SKEY[31:0]<={KEY[30:0],1'b0};
		T_TEMP[31:0]<= KEY[31:0]^PT[31:0];
		R_TEMP[31:0]<= KEY[31:0]^PM[31:0];
		PDT[31:0]<= T_TEMP[31:0]^SKEY[31:0]; 
		PDR[31:0]<= R_TEMP[31:0]^SKEY[31:0];
		CODE[31:0] <= PDR[31:0] ^ PDT[31:0];
				
        end
       
    end

endmodule
`default_nettype wire



