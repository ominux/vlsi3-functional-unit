/* Verilog for cell 'uber_fu_1x8{sch}' from library 'chainedRRFc_reg_out' */
/* Created on Sun Oct 14, 2007 18:02:25 */
/* Last revised on Thu Apr 29, 2010 17:09:50 */
/* Written on Fri Apr 30, 2010 09:17:34 by Electric VLSI Design System, version 8.08a */

module primitives__structural_cpg_tap(in, out);
  /* user-specified Verilog parameters */
  parameter muxgrp = "none";
  parameter muxelem = 0;
  parameter configured=0;

  input [31:0] in;
  output [31:0] out;

  /* user-specified Verilog declarations */
  wire                              cmd;
  defparam ctrl.configured = configured;
  dpg_controller ctrl(.cmd(cmd));

  /* user-specified Verilog code */
  // Functionality for a structural tap is embedded in the hierarchically enclosing mux cell

  /* automatically generated Verilog */
endmodule   /* primitives__structural_cpg_tap */

module primitives__flipflop(D, clk_gate_, Q);
  /* user-specified Verilog parameters */
  parameter isIC=0;
  parameter isCore=0;
  parameter real JOULES_PER_BIT = 1.0;
  parameter real JOULES_PER_CLK = 1.0;
  parameter real JOULES_PER_INACTIVE_CLK = 1.0;
  parameter real STATIC_POWER = 1.0;
  parameter real DELAY = 1.0;
  parameter PWR_MODEL = "none";
  parameter debug = 0;
  parameter isMonitored = 0;
  localparam CPG_WIDTH=32;
  localparam PWR_DOMAIN = isIC ? `IC : isCore ? `CLUSTER : 0;
  localparam INIT_VAL=1'h0;

  input [31:0] D;
  input [31:0] clk_gate_;
  output [31:0] Q;

  /* user-specified Verilog declarations */
  reg [CPG_WIDTH-1:0] Q_int;
  wire                       clk;
  wire                       rst_n;
  reg [32-1:0] old_Q;
  reg [31:0] Q_tx_cnt, Q_bit_tx_cnt;
  `ifdef CLOCK_GATING
  reg [31:0] cycle_cnt;
  `endif

  /* user-specified Verilog code */
  // Hook up global signals
  `ifdef CLOCK_GATING
  // The clock_gate_ is an active low signal that disables the clock when 0
  // Make sure to pull to clock up in the first half of the period to avoid spurious positive edges
  assign                     clk = (clk_gate_ === 1'b0) ? 1'b1 : glbl.clk;
  `else // NO_CLOCK_GATING
  assign                     clk = glbl.clk;
  `endif
  assign                     rst_n = glbl.rst_n;
  assign #(DELAY) Q = Q_int;
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      Q_int <= INIT_VAL;
  `ifdef CLOCK_GATING
      cycle_cnt <= 0;
  `endif
    end else begin
      Q_int <= D;
      if(debug) begin
        $display("[@%5d]<%d> %m registered d=%x q=%x", $time, glbl.ctx, D, Q);
      end
  `ifdef CLOCK_GATING
      cycle_cnt <= cycle_cnt + 1;
  `endif
    end
  end
  `ifdef SELECTIVE_MONITORING
  initial begin
    if(isMonitored) begin
      $dumpvars(0, Q);
    end
  end
  `endif
  
  `ifdef POWER_SIM
  `include "monitor_cpg_signal.v"
  
  always @(Q, rst_n) begin
    if(rst_n && (isIC || isCore)) begin
      monitor_cpg_signal(Q, old_Q, Q_tx_cnt, Q_bit_tx_cnt);
  //    $display("[@%5d]<%d> %m Q=%x old_Q=%x Q_tx_cnt=%x Q_bit_tx_cnt=%x", $time, glbl.ctx, Q, old_Q, Q_tx_cnt, Q_bit_tx_cnt);
      old_Q = Q;
    end else begin
      Q_tx_cnt = 0;
      Q_bit_tx_cnt = 0;
      old_Q = 0;
    end
  end
  
  initial begin
    if(isIC || isCore) begin
    `ifdef CLOCK_GATING
      $cgra_hybrid_monitor(PWR_DOMAIN, PWR_MODEL, `PLI_MODE_IS_CLOCKED_WITH_GATING, cycle_cnt, Q_tx_cnt, Q_bit_tx_cnt); 
    `else
      $cgra_hybrid_monitor(PWR_DOMAIN, PWR_MODEL, `PLI_MODE_IS_CLOCKED, Q_tx_cnt, Q_bit_tx_cnt); 
    `endif
    end
  end
  `endif

  /* automatically generated Verilog */
endmodule   /* primitives__flipflop */

module cells_cpg__gatedFlipflop(D, Q);
  /* user-specified Verilog parameters */
  parameter debug=0;
  parameter isCore=0;
  // Power paramters for the registers
  parameter real JOULES_PER_BIT = 1.0;
  parameter real JOULES_PER_CLK = 1.0;
  parameter real JOULES_PER_INACTIVE_CLK = 1.0;
  parameter real STATIC_POWER = 1.0;
  parameter real DELAY = 1.0;
  parameter PWR_MODEL = "none";

  input [31:0] D;
  output [31:0] Q;

  trireg [31:0] clk_en0;
  trireg [31:0] reg0_data_signal;
  trireg [31:0] wr_0_shift_enable_signal;

  /* user-specified Verilog code */
  assign reg0_data_signal = D;
  assign clk_en0 = wr_tap_0.cmd;

  primitives__structural_cpg_tap dummy_wr_tap_0(.in(wr_0_shift_enable_signal[31:0]), 
      .out(reg0_data_signal[31:0]));
  primitives__structural_cpg_tap feedback_tap_0(.in(Q[31:0]), .out(reg0_data_signal[31:0]));
  /* begin Verilog_defparam for primitives:flipflop{sch} */
  defparam flipflop_0.JOULES_PER_BIT = JOULES_PER_BIT;
  defparam flipflop_0.JOULES_PER_CLK = JOULES_PER_CLK;
  defparam flipflop_0.JOULES_PER_INACTIVE_CLK = JOULES_PER_INACTIVE_CLK;
  defparam flipflop_0.STATIC_POWER = STATIC_POWER;
  defparam flipflop_0.DELAY = DELAY;
  defparam flipflop_0.PWR_MODEL = PWR_MODEL;
  defparam flipflop_0.isCore = isCore;
  // end Verilog_defparam
  primitives__flipflop flipflop_0(.D(reg0_data_signal[31:0]), .clk_gate_(clk_en0[31:0]), 
      .Q(Q[31:0]));
  primitives__structural_cpg_tap wr_tap_0(.in(D[31:0]), .out(wr_0_shift_enable_signal[31:0]));
endmodule   /* cells_cpg__gatedFlipflop */

module primitives__structural_tap(in, out);
  /* user-specified Verilog parameters */
  parameter muxgrp = "none";
  parameter muxelem = 0;
  parameter configured=0;

  input [31:0] in;
  output [31:0] out;

  /* user-specified Verilog declarations */
  wire                              cmd;
  defparam ctrl.configured = configured;
  dpg_controller ctrl(.cmd(cmd));

  /* user-specified Verilog code */
  // Functionality for a structural tap is embedded in the hierarchically enclosing mux cell

  /* automatically generated Verilog */
endmodule   /* primitives__structural_tap */

module primitives__pipe(D, clk_gate_, Q);
  /* user-specified Verilog parameters */
  parameter isIC=0;
  parameter isCore=0;
  parameter real JOULES_PER_BIT = 1.0;
  parameter real JOULES_PER_CLK = 1.0;
  parameter real JOULES_PER_INACTIVE_CLK = 1;
  parameter real STATIC_POWER = 1.0;
  parameter real DELAY = 1.0;
  parameter PWR_MODEL = "none";
  parameter debug = 0;
  parameter isMonitored = 0;
  localparam PWR_DOMAIN = isIC ? `IC : isCore ? `CLUSTER : 0;
  localparam INIT_VAL=32'h0;

  input [31:0] D;
  input [31:0] clk_gate_;
  output [31:0] Q;

  /* user-specified Verilog declarations */
  reg [32-1:0] Q_int;
  wire                       clk;
  wire                       rst_n;
  reg [32-1:0] old_Q;
  reg [31:0] Q_tx_cnt, Q_bit_tx_cnt;
  `ifdef CLOCK_GATING
  reg [31:0] cycle_cnt;
  `endif

  /* user-specified Verilog code */
  // Hook up global signals
  `ifdef CLOCK_GATING
  // The clock_gate_ is an active low signal that disables the clock when 0
  // Make sure to pull to clock up in the first half of the period to avoid spurious positive edges
  assign                     clk = (clk_gate_ === 1'b0) ? 1'b1 : glbl.clk;
  `else // NO_CLOCK_GATING
  assign                     clk = glbl.clk;
  `endif
  assign                     rst_n = glbl.rst_n;
  assign #(DELAY) Q = Q_int;
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      Q_int <= INIT_VAL;
  `ifdef CLOCK_GATING
      cycle_cnt <= 0;
  `endif
    end else begin
      Q_int <= D;
      if(debug) begin
        $display("[@%5d]<%d> %m registered d=%x q=%x", $time, glbl.ctx, D, Q);
      end
  `ifdef CLOCK_GATING
      cycle_cnt <= cycle_cnt + 1;
  `endif
    end
  end
  `ifdef SELECTIVE_MONITORING
  initial begin
    if(isMonitored) begin
      $dumpvars(0, Q);
    end
  end
  `endif
  
  `ifdef POWER_SIM
  `include "monitor_dpg_signal.v"
  
  always @(Q, rst_n) begin
    if(rst_n && (isIC || isCore)) begin
      monitor_dpg_signal(Q, old_Q, Q_tx_cnt, Q_bit_tx_cnt);
  //    $display("[@%5d]<%d> %m Q=%x old_Q=%x Q_tx_cnt=%x Q_bit_tx_cnt=%x", $time, glbl.ctx, Q, old_Q, Q_tx_cnt, Q_bit_tx_cnt);
      old_Q = Q;
    end else begin
      Q_tx_cnt = 0;
      Q_bit_tx_cnt = 0;
      old_Q = 0;
    end
  end
  
  initial begin
    if(isIC || isCore) begin
    `ifdef CLOCK_GATING
      $cgra_hybrid_monitor(PWR_DOMAIN, PWR_MODEL, `PLI_MODE_IS_CLOCKED_WITH_GATING, cycle_cnt, Q_tx_cnt, Q_bit_tx_cnt); 
    `else
      $cgra_hybrid_monitor(PWR_DOMAIN, PWR_MODEL, `PLI_MODE_IS_CLOCKED, Q_tx_cnt, Q_bit_tx_cnt); 
    `endif
    end
  end
  `endif

  /* automatically generated Verilog */
endmodule   /* primitives__pipe */

module cells__gatedRegister(D, Q);
  /* user-specified Verilog parameters */
  parameter debug=0;
  parameter isCore=0;
  // Power paramters for the registers
  parameter real JOULES_PER_BIT = 1.0;
  parameter real JOULES_PER_CLK = 1.0;
  parameter real JOULES_PER_INACTIVE_CLK = 1.0;
  parameter real STATIC_POWER = 1.0;
  parameter real DELAY = 1.0;
  parameter PWR_MODEL = "none";

  input [31:0] D;
  output [31:0] Q;

  trireg [31:0] clk_en0;
  trireg [31:0] reg0_data_signal;
  trireg [31:0] wr_0_shift_enable_signal;

  /* user-specified Verilog code */
  assign reg0_data_signal = D;
  assign clk_en0 = wr_tap_0.cmd;

  primitives__structural_tap dummy_wr_tap_0(.in(wr_0_shift_enable_signal[31:0]), 
      .out(reg0_data_signal[31:0]));
  primitives__structural_tap feedback_tap_0(.in(Q[31:0]), .out(reg0_data_signal[31:0]));
  /* begin Verilog_defparam for primitives:pipe{sch} */
  defparam pipe_0.JOULES_PER_BIT = JOULES_PER_BIT;
  defparam pipe_0.JOULES_PER_CLK = JOULES_PER_CLK;
  defparam pipe_0.JOULES_PER_INACTIVE_CLK = JOULES_PER_INACTIVE_CLK;
  defparam pipe_0.STATIC_POWER = STATIC_POWER;
  defparam pipe_0.DELAY = DELAY;
  defparam pipe_0.PWR_MODEL = PWR_MODEL;
  defparam pipe_0.isCore = isCore;
  // end Verilog_defparam
  primitives__pipe pipe_0(.D(reg0_data_signal[31:0]), .clk_gate_(clk_en0[31:0]), .Q(Q[31:0]));
  primitives__structural_tap wr_tap_0(.in(D[31:0]), .out(wr_0_shift_enable_signal[31:0]));
endmodule   /* cells__gatedRegister */

module cells__mux2(in00, in01, out);
  /* user-specified Verilog parameters */
  parameter configured=0;
  parameter isIC=0;
  parameter isCore=0;
  parameter real JOULES_PER_BIT = 1.0;
  parameter real JOULES_PER_CFG = 1.0;
  parameter real STATIC_POWER = 1.0;
  parameter real CFG_SRAM_POWER = 1.0;
  parameter real DELAY = 1.0;
  parameter PWR_MODEL = "none";
  localparam PWR_DOMAIN = isIC ? `IC : isCore ? `CLUSTER : 0;
  parameter debug = 0;
  localparam wordsize=32;
  parameter isMonitored = 0;
  localparam isActive = configured;
  localparam PLI_MODE = `PLI_MODE_DEVICE_CAN_BE_SCHEDULED | (isActive ? `PLI_MODE_DEFAULT : `PLI_MODE_DEVICE_IS_DISABLED);
  localparam MUX_SIZE = 2;

  input [31:0] in00;
  input [31:0] in01;
  output [31:0] out;

  /* user-specified Verilog declarations */
  wire [MUX_SIZE-1:0] cfg;
  wire                rdy;
  reg [wordsize-1:0]  old_out;
  reg [MUX_SIZE-1:0]  old_cfg;
  reg [31:0]  out_tx_cnt, out_bit_tx_cnt;
  reg [31:0]  cfg_tx_cnt, cfg_bit_tx_cnt;
  `ifdef SELECTIVE_MONITORING
  reg [clogb2(MUX_SIZE)-1:0] en_cfg;
  `endif

  /* user-specified Verilog code */
  assign     rdy = glbl.rdy;
  assign     cfg = {tap_1.cmd, tap_0.cmd};
  // If unconfigured drive in0 to out
  assign #(DELAY) out = cfg[1] ? in01 :
                        cfg[0] ? in00 : in00;
  
  `ifdef POWER_SIM
  `include "monitor_dpg_signal.v"
  `include "monitor_cfg_signal.v"
  
  always @(out, rdy) begin
    if(rdy && (isIC || isCore)) begin
      monitor_dpg_signal(out, old_out, out_tx_cnt, out_bit_tx_cnt);
      if(debug) begin
        $display("[@%5d]<%d> %m cfg=%x out=%x old_out=%x out_tx_cnt=%x out_bit_tx_cnt=%x", $time, glbl.ctx, cfg, out, old_out, out_tx_cnt, out_bit_tx_cnt);
      end
      old_out = out;
    end else begin
      out_tx_cnt = 0;
      out_bit_tx_cnt = 0;
      old_out = 0;
    end
  end
  
  always @(cfg, rdy) begin
    if(rdy && (isIC || isCore)) begin
      monitor_cfg_signal(cfg, old_cfg, cfg_tx_cnt, cfg_bit_tx_cnt);
      if(debug) begin
        $display("[@%5d]<%d> %m cfg=%x old_cfg=%x cfg_tx_cnt=%x cfg_bit_tx_cnt=%x", $time, glbl.ctx, cfg, old_cfg, cfg_tx_cnt, cfg_bit_tx_cnt);
      end
      old_cfg = cfg;
    end else begin
      cfg_tx_cnt = 0;
      cfg_bit_tx_cnt = 0;
      old_cfg = 0;
    end
  end
  
  initial begin
    if(isIC || isCore) begin
      $cgra_hybrid_monitor(PWR_DOMAIN, PWR_MODEL, PLI_MODE, cfg_tx_cnt, cfg_bit_tx_cnt, out_tx_cnt, out_bit_tx_cnt);
    end
  end
  `else
  always @(*) begin
    if(rdy && debug) begin
      $display("[@%5d]<%d> %m cfg=%x out=%x  in01=%x in00=%x", $time, glbl.ctx, cfg, out, in01, in00,);
    end
  end
  `endif
  
  `ifdef SELECTIVE_MONITORING
  `include "encode_mux_cfg.v"
  `include "clogb2.v"
  
  always @(cfg, rdy) begin
    if(rdy && (isIC || isCore)) begin
      encode_mux_cfg(cfg, en_cfg);
    end else begin
      en_cfg = 0;
    end
  end
  
  initial begin
    if(isIC || isCore) begin
      #0 $dumpvars(0, en_cfg);
    end
  end
  `endif

  /* automatically generated Verilog */
  primitives__structural_tap tap_0(.in(in00[31:0]), .out(out[31:0]));
  primitives__structural_tap tap_1(.in(in01[31:0]), .out(out[31:0]));
endmodule   /* cells__mux2 */

module cells_cpg__mux2_cpg(in00, in01, out);
  /* user-specified Verilog parameters */
  parameter configured=0;
  parameter isIC=0;
  parameter isCore=0;
  parameter real JOULES_PER_BIT = 1.0;
  parameter real JOULES_PER_CFG = 1.0;
  parameter real STATIC_POWER = 1.0;
  parameter real CFG_SRAM_POWER = 1.0;
  parameter real DELAY = 1.0;
  parameter PWR_MODEL = "none";
  localparam PWR_DOMAIN = isIC ? `IC : isCore ? `CLUSTER : 0;
  parameter debug = 0;
  localparam wordsize=32;
  parameter isMonitored = 0;
  localparam isActive = configured;
  localparam PLI_MODE = `PLI_MODE_DEVICE_CAN_BE_SCHEDULED | (isActive ? `PLI_MODE_DEFAULT : `PLI_MODE_DEVICE_IS_DISABLED);
  localparam MUX_SIZE = 2;

  input [31:0] in00;
  input [31:0] in01;
  output [31:0] out;

  /* user-specified Verilog declarations */
  wire [MUX_SIZE-1:0] cfg;
  wire                rdy;
  reg [wordsize-1:0]  old_out;
  reg [MUX_SIZE-1:0]  old_cfg;
  reg [31:0]  out_tx_cnt, out_bit_tx_cnt;
  reg [31:0]  cfg_tx_cnt, cfg_bit_tx_cnt;
  `ifdef SELECTIVE_MONITORING
  reg [clogb2(MUX_SIZE)-1:0] en_cfg;
  `endif

  /* user-specified Verilog code */
  assign     rdy = glbl.rdy;
  assign     cfg = {tap_1.cmd, tap_0.cmd};
  // If unconfigured drive in0 to out
  assign #(DELAY) out = cfg[1] ? in01 :
                        cfg[0] ? in00 : in00;
  
  `ifdef POWER_SIM
  `include "monitor_cpg_signal.v"
  `include "monitor_cfg_signal.v"
  
  always @(out, rdy) begin
    if(rdy && (isIC || isCore)) begin
      monitor_cpg_signal(out, old_out, out_tx_cnt, out_bit_tx_cnt);
      if(debug) begin
        $display("[@%5d]<%d> %m cfg=%x out=%x old_out=%x out_tx_cnt=%x out_bit_tx_cnt=%x", $time, glbl.ctx, cfg, out, old_out, out_tx_cnt, out_bit_tx_cnt);
      end
      old_out = out;
    end else begin
      out_tx_cnt = 0;
      out_bit_tx_cnt = 0;
      old_out = 0;
    end
  end
  
  always @(cfg, rdy) begin
    if(rdy && (isIC || isCore)) begin
      monitor_cfg_signal(cfg, old_cfg, cfg_tx_cnt, cfg_bit_tx_cnt);
      if(debug) begin
        $display("[@%5d]<%d> %m cfg=%x old_cfg=%x cfg_tx_cnt=%x cfg_bit_tx_cnt=%x", $time, glbl.ctx, cfg, old_cfg, cfg_tx_cnt, cfg_bit_tx_cnt);
      end
      old_cfg = cfg;
    end else begin
      cfg_tx_cnt = 0;
      cfg_bit_tx_cnt = 0;
      old_cfg = 0;
    end
  end
  
  initial begin
    if(isIC || isCore) begin
      $cgra_hybrid_monitor(PWR_DOMAIN, PWR_MODEL, PLI_MODE, cfg_tx_cnt, cfg_bit_tx_cnt, out_tx_cnt, out_bit_tx_cnt);
    end
  end
  `else
  always @(*) begin
    if(rdy && debug) begin
      $display("[@%5d]<%d> %m cfg=%x out=%x  in01=%x in00=%x", $time, glbl.ctx, cfg, out, in01, in00,);
    end
  end
  `endif
  
  `ifdef SELECTIVE_MONITORING
  `include "encode_mux_cfg.v"
  `include "clogb2.v"
  
  always @(cfg, rdy) begin
    if(rdy && (isIC || isCore)) begin
      encode_mux_cfg(cfg, en_cfg);
    end else begin
      en_cfg = 0;
    end
  end
  
  initial begin
    if(isIC || isCore) begin
      #0 $dumpvars(0, en_cfg);
    end
  end
  `endif

  /* automatically generated Verilog */
  primitives__structural_cpg_tap tap_0(.in(in00[31:0]), .out(out[31:0]));
  primitives__structural_cpg_tap tap_1(.in(in01[31:0]), .out(out[31:0]));
endmodule   /* cells_cpg__mux2_cpg */

module cells__mux4(in00, in01, in02, in03, out);
  /* user-specified Verilog parameters */
  parameter configured=0;
  parameter isIC=0;
  parameter isCore=0;
  parameter real JOULES_PER_BIT = 1.0;
  parameter real JOULES_PER_CFG = 1.0;
  parameter real STATIC_POWER = 1.0;
  parameter real CFG_SRAM_POWER = 1.0;
  parameter real DELAY = 1.0;
  parameter PWR_MODEL = "none";
  localparam PWR_DOMAIN = isIC ? `IC : isCore ? `CLUSTER : 0;
  parameter debug = 0;
  localparam wordsize=32;
  parameter isMonitored = 0;
  localparam isActive = configured;
  localparam PLI_MODE = `PLI_MODE_DEVICE_CAN_BE_SCHEDULED | (isActive ? `PLI_MODE_DEFAULT : `PLI_MODE_DEVICE_IS_DISABLED);
  localparam MUX_SIZE = 4;

  input [31:0] in00;
  input [31:0] in01;
  input [31:0] in02;
  input [31:0] in03;
  output [31:0] out;

  /* user-specified Verilog declarations */
  wire [MUX_SIZE-1:0] cfg;
  wire                rdy;
  reg [wordsize-1:0]  old_out;
  reg [MUX_SIZE-1:0]  old_cfg;
  reg [31:0]  out_tx_cnt, out_bit_tx_cnt;
  reg [31:0]  cfg_tx_cnt, cfg_bit_tx_cnt;
  `ifdef SELECTIVE_MONITORING
  reg [clogb2(MUX_SIZE)-1:0] en_cfg;
  `endif

  /* user-specified Verilog code */
  assign     rdy = glbl.rdy;
  assign     cfg = {tap_3.cmd, tap_2.cmd, tap_1.cmd, tap_0.cmd};
  // If unconfigured drive in0 to out
  assign #(DELAY) out = cfg[3] ? in03 :
                        cfg[2] ? in02 :
                        cfg[1] ? in01 :
                        cfg[0] ? in00 : in00;
  
  `ifdef POWER_SIM
  `include "monitor_dpg_signal.v"
  `include "monitor_cfg_signal.v"
  
  always @(out, rdy) begin
    if(rdy && (isIC || isCore)) begin
      monitor_dpg_signal(out, old_out, out_tx_cnt, out_bit_tx_cnt);
      if(debug) begin
        $display("[@%5d]<%d> %m cfg=%x out=%x old_out=%x out_tx_cnt=%x out_bit_tx_cnt=%x", $time, glbl.ctx, cfg, out, old_out, out_tx_cnt, out_bit_tx_cnt);
      end
      old_out = out;
    end else begin
      out_tx_cnt = 0;
      out_bit_tx_cnt = 0;
      old_out = 0;
    end
  end
  
  always @(cfg, rdy) begin
    if(rdy && (isIC || isCore)) begin
      monitor_cfg_signal(cfg, old_cfg, cfg_tx_cnt, cfg_bit_tx_cnt);
      if(debug) begin
        $display("[@%5d]<%d> %m cfg=%x old_cfg=%x cfg_tx_cnt=%x cfg_bit_tx_cnt=%x", $time, glbl.ctx, cfg, old_cfg, cfg_tx_cnt, cfg_bit_tx_cnt);
      end
      old_cfg = cfg;
    end else begin
      cfg_tx_cnt = 0;
      cfg_bit_tx_cnt = 0;
      old_cfg = 0;
    end
  end
  
  initial begin
    if(isIC || isCore) begin
      $cgra_hybrid_monitor(PWR_DOMAIN, PWR_MODEL, PLI_MODE, cfg_tx_cnt, cfg_bit_tx_cnt, out_tx_cnt, out_bit_tx_cnt);
    end
  end
  `else
  always @(*) begin
    if(rdy && debug) begin
      $display("[@%5d]<%d> %m cfg=%x out=%x  in03=%x in02=%x in01=%x in00=%x", $time, glbl.ctx, cfg, out, in03, in02, in01, in00,);
    end
  end
  `endif
  
  `ifdef SELECTIVE_MONITORING
  `include "encode_mux_cfg.v"
  `include "clogb2.v"
  
  always @(cfg, rdy) begin
    if(rdy && (isIC || isCore)) begin
      encode_mux_cfg(cfg, en_cfg);
    end else begin
      en_cfg = 0;
    end
  end
  
  initial begin
    if(isIC || isCore) begin
      #0 $dumpvars(0, en_cfg);
    end
  end
  `endif

  /* automatically generated Verilog */
  primitives__structural_tap tap_0(.in(in00[31:0]), .out(out[31:0]));
  primitives__structural_tap tap_1(.in(in01[31:0]), .out(out[31:0]));
  primitives__structural_tap tap_2(.in(in02[31:0]), .out(out[31:0]));
  primitives__structural_tap tap_3(.in(in03[31:0]), .out(out[31:0]));
endmodule   /* cells__mux4 */

module cells_cpg__mux4_cpg(in00, in01, in02, in03, out);
  /* user-specified Verilog parameters */
  parameter configured=0;
  parameter isIC=0;
  parameter isCore=0;
  parameter real JOULES_PER_BIT = 1.0;
  parameter real JOULES_PER_CFG = 1.0;
  parameter real STATIC_POWER = 1.0;
  parameter real CFG_SRAM_POWER = 1.0;
  parameter real DELAY = 1.0;
  parameter PWR_MODEL = "none";
  localparam PWR_DOMAIN = isIC ? `IC : isCore ? `CLUSTER : 0;
  parameter debug = 0;
  localparam wordsize=32;
  parameter isMonitored = 0;
  localparam isActive = configured;
  localparam PLI_MODE = `PLI_MODE_DEVICE_CAN_BE_SCHEDULED | (isActive ? `PLI_MODE_DEFAULT : `PLI_MODE_DEVICE_IS_DISABLED);
  localparam MUX_SIZE = 4;

  input [31:0] in00;
  input [31:0] in01;
  input [31:0] in02;
  input [31:0] in03;
  output [31:0] out;

  /* user-specified Verilog declarations */
  wire [MUX_SIZE-1:0] cfg;
  wire                rdy;
  reg [wordsize-1:0]  old_out;
  reg [MUX_SIZE-1:0]  old_cfg;
  reg [31:0]  out_tx_cnt, out_bit_tx_cnt;
  reg [31:0]  cfg_tx_cnt, cfg_bit_tx_cnt;
  `ifdef SELECTIVE_MONITORING
  reg [clogb2(MUX_SIZE)-1:0] en_cfg;
  `endif

  /* user-specified Verilog code */
  assign     rdy = glbl.rdy;
  assign     cfg = {tap_3.cmd, tap_2.cmd, tap_1.cmd, tap_0.cmd};
  // If unconfigured drive in0 to out
  assign #(DELAY) out = cfg[3] ? in03 :
                        cfg[2] ? in02 :
                        cfg[1] ? in01 :
                        cfg[0] ? in00 : in00;
  
  `ifdef POWER_SIM
  `include "monitor_cpg_signal.v"
  `include "monitor_cfg_signal.v"
  
  always @(out, rdy) begin
    if(rdy && (isIC || isCore)) begin
      monitor_cpg_signal(out, old_out, out_tx_cnt, out_bit_tx_cnt);
      if(debug) begin
        $display("[@%5d]<%d> %m cfg=%x out=%x old_out=%x out_tx_cnt=%x out_bit_tx_cnt=%x", $time, glbl.ctx, cfg, out, old_out, out_tx_cnt, out_bit_tx_cnt);
      end
      old_out = out;
    end else begin
      out_tx_cnt = 0;
      out_bit_tx_cnt = 0;
      old_out = 0;
    end
  end
  
  always @(cfg, rdy) begin
    if(rdy && (isIC || isCore)) begin
      monitor_cfg_signal(cfg, old_cfg, cfg_tx_cnt, cfg_bit_tx_cnt);
      if(debug) begin
        $display("[@%5d]<%d> %m cfg=%x old_cfg=%x cfg_tx_cnt=%x cfg_bit_tx_cnt=%x", $time, glbl.ctx, cfg, old_cfg, cfg_tx_cnt, cfg_bit_tx_cnt);
      end
      old_cfg = cfg;
    end else begin
      cfg_tx_cnt = 0;
      cfg_bit_tx_cnt = 0;
      old_cfg = 0;
    end
  end
  
  initial begin
    if(isIC || isCore) begin
      $cgra_hybrid_monitor(PWR_DOMAIN, PWR_MODEL, PLI_MODE, cfg_tx_cnt, cfg_bit_tx_cnt, out_tx_cnt, out_bit_tx_cnt);
    end
  end
  `else
  always @(*) begin
    if(rdy && debug) begin
      $display("[@%5d]<%d> %m cfg=%x out=%x  in03=%x in02=%x in01=%x in00=%x", $time, glbl.ctx, cfg, out, in03, in02, in01, in00,);
    end
  end
  `endif
  
  `ifdef SELECTIVE_MONITORING
  `include "encode_mux_cfg.v"
  `include "clogb2.v"
  
  always @(cfg, rdy) begin
    if(rdy && (isIC || isCore)) begin
      encode_mux_cfg(cfg, en_cfg);
    end else begin
      en_cfg = 0;
    end
  end
  
  initial begin
    if(isIC || isCore) begin
      #0 $dumpvars(0, en_cfg);
    end
  end
  `endif

  /* automatically generated Verilog */
  primitives__structural_cpg_tap tap_0(.in(in00[31:0]), .out(out[31:0]));
  primitives__structural_cpg_tap tap_1(.in(in01[31:0]), .out(out[31:0]));
  primitives__structural_cpg_tap tap_2(.in(in02[31:0]), .out(out[31:0]));
  primitives__structural_cpg_tap tap_3(.in(in03[31:0]), .out(out[31:0]));
endmodule   /* cells_cpg__mux4_cpg */
  /* user-specified Verilog external code */
  `define OP_CONST 1
  `define OP_KERNEL_CONST 2
  `define OP_RUNTIME_SYS 3
  `define SIG_INIT 1
  `ifndef CGRA_MAX_II
  `define CGRA_MAX_II 16
  `endif


module primitives__boolean_constant(c);
  /* user-specified Verilog parameters */
  localparam PLI_WIDTH=32;
  localparam NUM_CONFIG_WORDS=`CGRA_MAX_II;
  localparam CONFIG_IDX_SIZE=clogb2(NUM_CONFIG_WORDS);
  localparam DATA_WORD_SIZE=32;
  localparam wordsize = DATA_WORD_SIZE > PLI_WIDTH ? DATA_WORD_SIZE : PLI_WIDTH;
  localparam CONFIG_WORD_SIZE=2;
  parameter debug=0;
  parameter configured=0;
  parameter II=16;
  localparam INIT_VAL=1'h0;

  output [31:0] c;

  /* user-specified Verilog declarations */
  wire [DATA_WORD_SIZE-1:0] internal_const, sig_runtime;
  wire [wordsize-1:0] immediate;
  reg  [PLI_WIDTH-1:0] kernel_loadin[0:II-1];
  wire [CONFIG_IDX_SIZE-1:0] ctx;
  wire                             clk;
  wire                             rst_n;
  wire                             init;
  wire [CONFIG_WORD_SIZE-1:0] cmd;
  wire [31:0] sched_slot, cycle_cnt;
  defparam              ctrl.CONFIG_WORD_SIZE=CONFIG_WORD_SIZE;
  defparam              ctrl.configured = configured;
  dpg_controller ctrl(.cmd(cmd));
  defparam              const.CONFIG_WORD_SIZE=wordsize;
  defparam              const.configured = configured;
  dpg_controller const(.cmd(immediate));
  defparam              sched.CONFIG_WORD_SIZE=32;
  defparam              sched.configured = configured;
  dpg_controller sched(.cmd(sched_slot));
  wire [PLI_WIDTH-1:0] OBJ_ID;
  assign clk = configured == 1 ? glbl.clk : 0;
  assign rst_n = glbl.rst_n;
  assign ctx = configured == 1 ? glbl.ctx : 0;
  assign init = glbl.init;
  assign cycle_cnt = configured == 1 ? glbl.cycle_cnt : 0;

  /* user-specified Verilog code */
  // Either pull in a value from the kernel_loadin cache or from the configuration memory
  assign internal_const = (cmd == `OP_KERNEL_CONST) ? kernel_loadin[ctx] : (init && cycle_cnt >= sched_slot) || (glbl.rdy && !init) ? immediate : INIT_VAL;
  // If used as an the macah init signal, it needs to output a 1 and then 0's
  assign sig_runtime = immediate == `SIG_INIT && cycle_cnt == sched_slot ? {DATA_WORD_SIZE{1'b0}} | init : {DATA_WORD_SIZE{1'b0}};
  assign c = (cmd == `OP_RUNTIME_SYS) ? sig_runtime : internal_const;
  assign OBJ_ID = (cmd == `OP_KERNEL_CONST) ? immediate : {DATA_WORD_SIZE{1'bz}};
  
  always @(negedge clk or negedge rst_n) begin
    if(!rst_n) begin
      kernel_loadin[ctx] <= INIT_VAL;
    end else if(init && (cmd == `OP_KERNEL_CONST) && cycle_cnt == sched_slot) begin
      $macah_pli_get_idx(PLI_WIDTH, OBJ_ID, 0, kernel_loadin[ctx]);
      if(debug) begin
        $display("[@%5d] %m loaded %d[%d]=%d from the pli", $time, OBJ_ID, ctx, $signed(kernel_loadin[ctx]));
      end
    end
    if(debug && (cmd == `OP_KERNEL_CONST)) begin
      $display("[@%5d] %m load c=%d into the DPG on phase %d", $time, c, ctx);
    end
    if(debug && cmd == `OP_CONST) begin
      $display("[@%5d] %m load c=%d into the DPG on phase %d", $time, $signed(internal_const), ctx);
    end
    if(debug && cmd == `OP_RUNTIME_SYS) begin
      $display("[@%5d] %m wiring runtime signal c=%d into the DPG on phase %d", $time, c, ctx);
    end
  end
  `include "clogb2.v"

  /* automatically generated Verilog */
endmodule   /* primitives__boolean_constant */

module primitives__structural_flipflop(D, Q);
  input [31:0] D;
  output [31:0] Q;

endmodule   /* primitives__structural_flipflop */
  /* user-specified Verilog external code */
  `ifndef CGRA_MAX_II
  `define CGRA_MAX_II 16
  `endif


module cells_cpg__regfile8_r1_w1_cpg_cydra_c1(w0, r0);
  /* user-specified Verilog parameters */
  parameter configured=0;
  parameter debug=0;
  parameter numConstants=0;
  parameter isCore=0;
  localparam DPG_WIDTH=32;
  localparam wordsize=32;
  localparam isActive = configured;
  localparam NUM_REGISTERS = 8;
  localparam NUM_ADDR_BITS = clogb2(NUM_REGISTERS);
  localparam ONE_HOT_BUS_SIZE = NUM_REGISTERS;
  parameter MAX_II = `CGRA_MAX_II;
  localparam CONFIG_IDX_SIZE=clogb2(MAX_II);
  localparam INIT_VAL=1'h0;
  parameter real JOULES_PER_READ = 1.0;
  parameter real JOULES_PER_WRITE = 1.0;
  parameter real JOULES_PER_BIT_READ = 1.0;
  parameter real JOULES_PER_BIT_WRITE = 1.0;
  parameter real JOULES_PER_CLK = 1.0;
  parameter real JOULES_PER_INACTIVE_CLK = 1.0;
  parameter real STATIC_POWER = 1.0;
  parameter real CFG_SRAM_POWER = 1.0;
  parameter real DELAY = 1.0;
  parameter PWR_MODEL = "none";
  localparam PWR_DOMAIN = isCore ? `CLUSTER : 0;
  localparam PLI_MODE = `PLI_MODE_DEVICE_IS_READ_AND_WRITE | `PLI_MODE_IS_CLOCKED_WITH_GATING;
  localparam partitionLowMask = {NUM_REGISTERS{1'b1}} >> numConstants; // Setup the mask for the rotation split
  localparam partitionHighMask = ~partitionLowMask; // Setup the mask for the rotation split

  input [31:0] w0;
  output [31:0] r0;

  trireg [31:0] c0_src;
  trireg [31:0] net_126;
  trireg [31:0] net_157;
  trireg [31:0] net_188;
  trireg [31:0] net_219;
  trireg [31:0] net_229;
  trireg [31:0] net_238;
  trireg [31:0] net_33;
  trireg [31:0] net_64;
  trireg [31:0] net_95;
  trireg [31:0] reg0_const_line;
  trireg [31:0] reg0_data_signal;
  trireg [31:0] reg0_rd_dummy_signal;
  trireg [31:0] reg0_rd_phase_signal;
  trireg [31:0] reg0_rd_wave_partition_signal;
  trireg [31:0] reg0_rd_wave_signal;
  trireg [31:0] reg0_word_line;
  trireg [31:0] reg0_wr_phase_signal;
  trireg [31:0] reg0_wr_wave_partition_signal;
  trireg [31:0] reg0_wr_wave_signal;
  trireg [31:0] reg1_const_line;
  trireg [31:0] reg1_data_signal;
  trireg [31:0] reg1_rd_dummy_signal;
  trireg [31:0] reg1_rd_phase_signal;
  trireg [31:0] reg1_rd_wave_partition_signal;
  trireg [31:0] reg1_rd_wave_signal;
  trireg [31:0] reg1_word_line;
  trireg [31:0] reg1_wr_phase_signal;
  trireg [31:0] reg1_wr_wave_partition_signal;
  trireg [31:0] reg1_wr_wave_signal;
  trireg [31:0] reg2_const_line;
  trireg [31:0] reg2_data_signal;
  trireg [31:0] reg2_rd_dummy_signal;
  trireg [31:0] reg2_rd_phase_signal;
  trireg [31:0] reg2_rd_wave_partition_signal;
  trireg [31:0] reg2_rd_wave_signal;
  trireg [31:0] reg2_word_line;
  trireg [31:0] reg2_wr_phase_signal;
  trireg [31:0] reg2_wr_wave_partition_signal;
  trireg [31:0] reg2_wr_wave_signal;
  trireg [31:0] reg3_const_line;
  trireg [31:0] reg3_data_signal;
  trireg [31:0] reg3_rd_dummy_signal;
  trireg [31:0] reg3_rd_phase_signal;
  trireg [31:0] reg3_rd_wave_partition_signal;
  trireg [31:0] reg3_rd_wave_signal;
  trireg [31:0] reg3_word_line;
  trireg [31:0] reg3_wr_phase_signal;
  trireg [31:0] reg3_wr_wave_partition_signal;
  trireg [31:0] reg3_wr_wave_signal;
  trireg [31:0] reg4_const_line;
  trireg [31:0] reg4_data_signal;
  trireg [31:0] reg4_rd_dummy_signal;
  trireg [31:0] reg4_rd_phase_signal;
  trireg [31:0] reg4_rd_wave_partition_signal;
  trireg [31:0] reg4_rd_wave_signal;
  trireg [31:0] reg4_word_line;
  trireg [31:0] reg4_wr_phase_signal;
  trireg [31:0] reg4_wr_wave_partition_signal;
  trireg [31:0] reg4_wr_wave_signal;
  trireg [31:0] reg5_const_line;
  trireg [31:0] reg5_data_signal;
  trireg [31:0] reg5_rd_dummy_signal;
  trireg [31:0] reg5_rd_phase_signal;
  trireg [31:0] reg5_rd_wave_partition_signal;
  trireg [31:0] reg5_rd_wave_signal;
  trireg [31:0] reg5_word_line;
  trireg [31:0] reg5_wr_phase_signal;
  trireg [31:0] reg5_wr_wave_partition_signal;
  trireg [31:0] reg5_wr_wave_signal;
  trireg [31:0] reg6_const_line;
  trireg [31:0] reg6_data_signal;
  trireg [31:0] reg6_rd_dummy_signal;
  trireg [31:0] reg6_rd_phase_signal;
  trireg [31:0] reg6_rd_wave_partition_signal;
  trireg [31:0] reg6_rd_wave_signal;
  trireg [31:0] reg6_word_line;
  trireg [31:0] reg6_wr_phase_signal;
  trireg [31:0] reg6_wr_wave_partition_signal;
  trireg [31:0] reg6_wr_wave_signal;
  trireg [31:0] reg7_const_line;
  trireg [31:0] reg7_data_signal;
  trireg [31:0] reg7_rd_dummy_signal;
  trireg [31:0] reg7_rd_phase_signal;
  trireg [31:0] reg7_rd_wave_partition_signal;
  trireg [31:0] reg7_rd_wave_signal;
  trireg [31:0] reg7_word_line;
  trireg [31:0] reg7_wr_phase_signal;
  trireg [31:0] reg7_wr_wave_partition_signal;

  /* user-specified Verilog declarations */
  reg [NUM_ADDR_BITS-1:0] base;
  reg [DPG_WIDTH-1:0]      mem[0:NUM_REGISTERS-1];
  
  // Write Ports
  wire [NUM_REGISTERS-1:0] w0_cfg;
  wire [NUM_REGISTERS-1:0] w0_phase_cfg, w0_wave_cfg, w0_cfg_rot;
  wire [NUM_REGISTERS-1:0] w0_cfg_low_masked, w0_cfg_high_masked, w0_cfg_combined;
  reg  [NUM_ADDR_BITS-1:0] w0_addr;
  reg                      w0_valid;
  `ifdef POWER_SIM
  reg [31:0] w0_tx_cnt;
  reg [31:0] w0_bit_tx_cnt;
  reg [31:0] old_w0;
  `endif
  // Constant Generators
  wire [NUM_REGISTERS-1:0] c0_cfg;
  reg  [NUM_ADDR_BITS-1:0] c0_addr;
  reg                      c0_valid;
  // Read Ports
  wire [NUM_REGISTERS-1:0] r0_cfg;
  wire [NUM_REGISTERS-1:0] r0_cfg_rot;
  wire [NUM_REGISTERS-1:0] r0_cfg_low_masked, r0_cfg_high_masked, r0_cfg_combined;
  reg  [NUM_ADDR_BITS-1:0] r0_addr;
  reg                      r0_valid;
  `ifdef POWER_SIM
  reg [31:0] r0_tx_cnt;
  reg [31:0] r0_bit_tx_cnt;
  reg [31:0] old_r0;
  `endif
  
  wire clk, rst_n, init;
  wire [CONFIG_IDX_SIZE-1:0] ctx;
  integer i;
  `ifdef POWER_SIM
  reg [31:0]  read_tx_cnt, read_bit_tx_cnt;
  reg [31:0]  write_tx_cnt, write_bit_tx_cnt;
  reg [31:0] cycle_cnt;
  `endif

  /* user-specified Verilog code */
  assign clk = glbl.clk;
  assign ctx = glbl.ctx;
  assign rst_n = glbl.rst_n;
  assign init = glbl.init;
  
  `include "encode_one_hot_signal.v"
  `include "clogb2.v"
  
  assign w0_cfg = {w0_tap_7.cmd, w0_tap_6.cmd, w0_tap_5.cmd, w0_tap_4.cmd, 
                                            w0_tap_3.cmd, w0_tap_2.cmd, w0_tap_1.cmd, w0_tap_0.cmd};
                                            
  assign w0_cfg_low_masked = w0_cfg & partitionLowMask; // Mask off the values above the split point
  assign w0_cfg_high_masked = w0_cfg & partitionHighMask; // Mask off the values above the split point
  assign w0_cfg_rot = ((w0_cfg_low_masked << base) | (w0_cfg_low_masked >> (NUM_REGISTERS - numConstants - base))) & partitionLowMask; // Rotate and remask the result
  assign w0_cfg_combined = w0_cfg_high_masked | w0_cfg_rot;
  
  always @(w0_cfg_combined) begin
    encode_one_hot_signal(w0_cfg_combined, w0_addr, w0_valid);
    if(debug) begin
      $display("[@%5d] %m w0_addr=%b w0_cfg=%b w0_cfg_low_masked=%b w0_cfg_high_masked=%b w0_cfg_rot=%b w0_cfg_combined=%b partitionLow=%b partitionHigh=%b", $time,  w0_addr, w0_cfg, w0_cfg_low_masked, w0_cfg_high_masked, w0_cfg_rot, w0_cfg_combined, partitionLowMask, partitionHighMask);
    end
  end
  
  
  assign c0_cfg = {c0_tap_7.cmd, c0_tap_6.cmd, c0_tap_5.cmd, c0_tap_4.cmd, 
                                            c0_tap_3.cmd, c0_tap_2.cmd, c0_tap_1.cmd, c0_tap_0.cmd};
                                            
  always @(c0_cfg) begin
         encode_one_hot_signal(c0_cfg, c0_addr, c0_valid);
  end
  
  
  // Ignore the read wave and phase taps
  assign r0_cfg = {r0_tap_7.cmd, r0_tap_6.cmd, r0_tap_5.cmd, r0_tap_4.cmd, 
                           r0_tap_3.cmd, r0_tap_2.cmd, r0_tap_1.cmd, r0_tap_0.cmd};
                           
  assign r0_cfg_low_masked = r0_cfg & partitionLowMask; // Mask off the values above the split point
  assign r0_cfg_high_masked = r0_cfg & partitionHighMask; // Mask off the values above the split point
  assign r0_cfg_rot = ((r0_cfg_low_masked << base) | (r0_cfg_low_masked >> (NUM_REGISTERS - numConstants - base))) & partitionLowMask; // Rotate and remask the result
  assign r0_cfg_combined = r0_cfg_high_masked | r0_cfg_rot;
  
  always @(r0_cfg_combined) begin
    encode_one_hot_signal(r0_cfg_combined, r0_addr, r0_valid);
    if(debug) begin
      $display("[@%5d] %m r0_addr=%b r0_cfg=%b r0_cfg_low_masked=%b r0_cfg_high_masked=%b r0_cfg_rot=%b r0_cfg_combined=%b partitionLow=%b partitionHigh=%b", $time,  r0_addr, r0_cfg, r0_cfg_low_masked, r0_cfg_high_masked, r0_cfg_rot, r0_cfg_combined, partitionLowMask, partitionHighMask);
    end
  end
  
  assign #(DELAY) r0 = configured && r0_valid ? mem[r0_addr] : {DPG_WIDTH{1'bz}};
  
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      base <= 0;
      for(i = 0; i < NUM_REGISTERS; i = i+1) begin
        mem[i] <= INIT_VAL;
      end
    `ifdef POWER_SIM
      w0_tx_cnt <= 0;
      w0_bit_tx_cnt <= 0;
      old_w0 <= 0;
      // Active clock energy is currently accumulated with each write
      cycle_cnt <= 0;
    `endif
    end else if(configured) begin
      if(ctx == glbl.II-1) begin
        if(base == NUM_REGISTERS-numConstants-1) begin
          base <= 0;
        end else begin
          base <= base + 1;
        end
      end
      if(w0_valid) begin
        mem[w0_addr] <= w0;
      `ifdef POWER_SIM
        monitor_cpg_signal(w0, old_w0, w0_tx_cnt, w0_bit_tx_cnt);
        if(debug) begin
          $display("[@%5d]<%d> %m w0=%x old_w0=%x w0_tx_cnt=%x w0_bit_tx_cnt=%x", $time, glbl.ctx, w0, old_w0, w0_tx_cnt, w0_bit_tx_cnt);
        end
        old_w0 <= w0;
      `endif
        if(debug) begin
          $display("[@%5d]<%d><%d> %m  %d -> mem[%4d](%b,%b)", $time, ctx, base, w0, w0_addr, w0_cfg, w0_cfg_rot);
        end
      end
      if(c0_valid) begin
        mem[c0_addr] <= c0_src;
        if(debug) begin
          $display("[@%5d]<%d> %m  mem[%4d](%b) <- %d", $time, ctx, c0_addr, c0_cfg, c0_src);
        end
      end
    end
  end
  
  always @(*) begin
    if(configured && debug) begin
      if(r0_valid) begin
        $display("[@%5d]<%d><%d> %m  mem[%4d](%b,%b) -> %d", $time, ctx, base, r0_addr, r0_cfg, r0_cfg_rot, r0);
      end
    end
  end
  `ifdef POWER_SIM
  `include "monitor_cpg_signal.v"
  
  always @(*) begin
    if(glbl.rdy && isCore) begin
      if(r0_valid) begin
        monitor_cpg_signal(r0, old_r0, r0_tx_cnt, r0_bit_tx_cnt);
        if(debug) begin
          $display("[@%5d]<%d> %m r0=%x old_r0=%x r0_tx_cnt=%x r0_bit_tx_cnt=%x", $time, glbl.ctx, r0, old_r0, r0_tx_cnt, r0_bit_tx_cnt);
        end
        old_r0 = r0;
      end
    end else begin
      r0_tx_cnt = 0;
      r0_bit_tx_cnt = 0;
      old_r0 = 0;
    end // glbl.rdy && isCore
  end
  
  always @(*) begin
    if(glbl.rdy && isCore) begin
  read_tx_cnt = r0_tx_cnt;
  read_bit_tx_cnt = r0_bit_tx_cnt;
  write_tx_cnt = w0_tx_cnt;
  write_bit_tx_cnt = w0_bit_tx_cnt;
    end // glbl.rdy && isCore
  end
  
  initial begin
    if(isCore) begin
      $cgra_hybrid_monitor(PWR_DOMAIN, PWR_MODEL, PLI_MODE, read_tx_cnt, read_bit_tx_cnt, write_tx_cnt, write_bit_tx_cnt, cycle_cnt);
    end
  end
  `endif

  /* automatically generated Verilog */
  primitives__structural_cpg_tap c0_tap_0(.in(c0_src[31:0]), .out(reg0_const_line[31:0]));
  primitives__structural_cpg_tap c0_tap_1(.in(c0_src[31:0]), .out(reg1_const_line[31:0]));
  primitives__structural_cpg_tap c0_tap_2(.in(c0_src[31:0]), .out(reg2_const_line[31:0]));
  primitives__structural_cpg_tap c0_tap_3(.in(c0_src[31:0]), .out(reg3_const_line[31:0]));
  primitives__structural_cpg_tap c0_tap_4(.in(c0_src[31:0]), .out(reg4_const_line[31:0]));
  primitives__structural_cpg_tap c0_tap_5(.in(c0_src[31:0]), .out(reg5_const_line[31:0]));
  primitives__structural_cpg_tap c0_tap_6(.in(c0_src[31:0]), .out(reg6_const_line[31:0]));
  primitives__structural_cpg_tap c0_tap_7(.in(c0_src[31:0]), .out(reg7_const_line[31:0]));
  primitives__boolean_constant c_0(.c(c0_src[31:0]));
  primitives__structural_cpg_tap contant_dummy_tap_0(.in(reg0_const_line[31:0]), 
      .out(reg0_data_signal[31:0]));
  primitives__structural_cpg_tap contant_dummy_tap_1(.in(reg1_const_line[31:0]), 
      .out(reg1_data_signal[31:0]));
  primitives__structural_cpg_tap contant_dummy_tap_2(.in(reg2_const_line[31:0]), 
      .out(reg2_data_signal[31:0]));
  primitives__structural_cpg_tap contant_dummy_tap_3(.in(reg3_const_line[31:0]), 
      .out(reg3_data_signal[31:0]));
  primitives__structural_cpg_tap contant_dummy_tap_4(.in(reg4_const_line[31:0]), 
      .out(reg4_data_signal[31:0]));
  primitives__structural_cpg_tap contant_dummy_tap_5(.in(reg5_const_line[31:0]), 
      .out(reg5_data_signal[31:0]));
  primitives__structural_cpg_tap contant_dummy_tap_6(.in(reg6_const_line[31:0]), 
      .out(reg6_data_signal[31:0]));
  primitives__structural_cpg_tap contant_dummy_tap_7(.in(reg7_const_line[31:0]), 
      .out(reg7_data_signal[31:0]));
  primitives__structural_cpg_tap feedback_phase_tap_0(.in(net_229[31:0]), 
      .out(reg0_wr_phase_signal[31:0]));
  primitives__structural_cpg_tap feedback_phase_tap_1(.in(net_33[31:0]), 
      .out(reg1_wr_phase_signal[31:0]));
  primitives__structural_cpg_tap feedback_phase_tap_2(.in(net_64[31:0]), 
      .out(reg2_wr_phase_signal[31:0]));
  primitives__structural_cpg_tap feedback_phase_tap_3(.in(net_95[31:0]), 
      .out(reg3_wr_phase_signal[31:0]));
  primitives__structural_cpg_tap feedback_phase_tap_4(.in(net_126[31:0]), 
      .out(reg4_wr_phase_signal[31:0]));
  primitives__structural_cpg_tap feedback_phase_tap_5(.in(net_157[31:0]), 
      .out(reg5_wr_phase_signal[31:0]));
  primitives__structural_cpg_tap feedback_phase_tap_6(.in(net_188[31:0]), 
      .out(reg6_wr_phase_signal[31:0]));
  primitives__structural_cpg_tap feedback_phase_tap_7(.in(net_219[31:0]), 
      .out(reg7_wr_phase_signal[31:0]));
  primitives__structural_cpg_tap feedback_wave_tap_0(.in(net_229[31:0]), .out(net_238[31:0]));
  primitives__structural_cpg_tap feedback_wave_tap_1(.in(net_33[31:0]), 
      .out(reg0_wr_wave_signal[31:0]));
  primitives__structural_cpg_tap feedback_wave_tap_2(.in(net_64[31:0]), 
      .out(reg1_wr_wave_signal[31:0]));
  primitives__structural_cpg_tap feedback_wave_tap_3(.in(net_95[31:0]), 
      .out(reg2_wr_wave_signal[31:0]));
  primitives__structural_cpg_tap feedback_wave_tap_4(.in(net_126[31:0]), 
      .out(reg3_wr_wave_signal[31:0]));
  primitives__structural_cpg_tap feedback_wave_tap_5(.in(net_157[31:0]), 
      .out(reg4_wr_wave_signal[31:0]));
  primitives__structural_cpg_tap feedback_wave_tap_6(.in(net_188[31:0]), 
      .out(reg5_wr_wave_signal[31:0]));
  primitives__structural_cpg_tap feedback_wave_tap_7(.in(net_219[31:0]), 
      .out(reg6_wr_wave_signal[31:0]));
  primitives__structural_flipflop flipflop_0(.D(reg0_data_signal[31:0]), .Q(net_229[31:0]));
  primitives__structural_flipflop flipflop_1(.D(reg1_data_signal[31:0]), .Q(net_33[31:0]));
  primitives__structural_flipflop flipflop_2(.D(reg2_data_signal[31:0]), .Q(net_64[31:0]));
  primitives__structural_flipflop flipflop_3(.D(reg3_data_signal[31:0]), .Q(net_95[31:0]));
  primitives__structural_flipflop flipflop_4(.D(reg4_data_signal[31:0]), .Q(net_126[31:0]));
  primitives__structural_flipflop flipflop_5(.D(reg5_data_signal[31:0]), .Q(net_157[31:0]));
  primitives__structural_flipflop flipflop_6(.D(reg6_data_signal[31:0]), .Q(net_188[31:0]));
  primitives__structural_flipflop flipflop_7(.D(reg7_data_signal[31:0]), .Q(net_219[31:0]));
  primitives__structural_cpg_tap r0_tap_0(.in(reg0_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_cpg_tap r0_tap_1(.in(reg1_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_cpg_tap r0_tap_2(.in(reg2_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_cpg_tap r0_tap_3(.in(reg3_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_cpg_tap r0_tap_4(.in(reg4_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_cpg_tap r0_tap_5(.in(reg5_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_cpg_tap r0_tap_6(.in(reg6_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_cpg_tap r0_tap_7(.in(reg7_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_cpg_tap rd_dummy_partition_tap_0(.in(reg0_rd_wave_partition_signal[31:0]), 
      .out(reg0_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_partition_tap_1(.in(reg1_rd_wave_partition_signal[31:0]), 
      .out(reg1_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_partition_tap_2(.in(reg2_rd_wave_partition_signal[31:0]), 
      .out(reg2_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_partition_tap_3(.in(reg3_rd_wave_partition_signal[31:0]), 
      .out(reg3_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_partition_tap_4(.in(reg4_rd_wave_partition_signal[31:0]), 
      .out(reg4_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_partition_tap_5(.in(reg5_rd_wave_partition_signal[31:0]), 
      .out(reg5_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_partition_tap_6(.in(reg6_rd_wave_partition_signal[31:0]), 
      .out(reg6_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_phase_tap_0(.in(reg0_rd_phase_signal[31:0]), 
      .out(reg0_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_phase_tap_1(.in(reg1_rd_phase_signal[31:0]), 
      .out(reg1_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_phase_tap_2(.in(reg2_rd_phase_signal[31:0]), 
      .out(reg2_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_phase_tap_3(.in(reg3_rd_phase_signal[31:0]), 
      .out(reg3_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_phase_tap_4(.in(reg4_rd_phase_signal[31:0]), 
      .out(reg4_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_phase_tap_5(.in(reg5_rd_phase_signal[31:0]), 
      .out(reg5_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_phase_tap_6(.in(reg6_rd_phase_signal[31:0]), 
      .out(reg6_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_phase_tap_7(.in(reg7_rd_phase_signal[31:0]), 
      .out(reg7_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_wave_tap_0(.in(reg0_rd_wave_signal[31:0]), 
      .out(reg0_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_wave_tap_1(.in(reg1_rd_wave_signal[31:0]), 
      .out(reg1_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_wave_tap_2(.in(reg2_rd_wave_signal[31:0]), 
      .out(reg2_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_wave_tap_3(.in(reg3_rd_wave_signal[31:0]), 
      .out(reg3_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_wave_tap_4(.in(reg4_rd_wave_signal[31:0]), 
      .out(reg4_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_wave_tap_5(.in(reg5_rd_wave_signal[31:0]), 
      .out(reg5_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_wave_tap_6(.in(reg6_rd_wave_signal[31:0]), 
      .out(reg6_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_dummy_wave_tap_7(.in(reg7_rd_wave_signal[31:0]), 
      .out(reg7_rd_dummy_signal[31:0]));
  primitives__structural_cpg_tap rd_phase_tap_0(.in(net_229[31:0]), 
      .out(reg0_rd_phase_signal[31:0]));
  primitives__structural_cpg_tap rd_phase_tap_1(.in(net_33[31:0]), 
      .out(reg1_rd_phase_signal[31:0]));
  primitives__structural_cpg_tap rd_phase_tap_2(.in(net_64[31:0]), 
      .out(reg2_rd_phase_signal[31:0]));
  primitives__structural_cpg_tap rd_phase_tap_3(.in(net_95[31:0]), 
      .out(reg3_rd_phase_signal[31:0]));
  primitives__structural_cpg_tap rd_phase_tap_4(.in(net_126[31:0]), 
      .out(reg4_rd_phase_signal[31:0]));
  primitives__structural_cpg_tap rd_phase_tap_5(.in(net_157[31:0]), 
      .out(reg5_rd_phase_signal[31:0]));
  primitives__structural_cpg_tap rd_phase_tap_6(.in(net_188[31:0]), 
      .out(reg6_rd_phase_signal[31:0]));
  primitives__structural_cpg_tap rd_phase_tap_7(.in(net_219[31:0]), 
      .out(reg7_rd_phase_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_partition_tap_0(.in(net_229[31:0]), 
      .out(reg0_rd_wave_partition_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_partition_tap_1(.in(net_229[31:0]), 
      .out(reg1_rd_wave_partition_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_partition_tap_2(.in(net_229[31:0]), 
      .out(reg2_rd_wave_partition_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_partition_tap_3(.in(net_229[31:0]), 
      .out(reg3_rd_wave_partition_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_partition_tap_4(.in(net_229[31:0]), 
      .out(reg4_rd_wave_partition_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_partition_tap_5(.in(net_229[31:0]), 
      .out(reg5_rd_wave_partition_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_partition_tap_6(.in(net_229[31:0]), 
      .out(reg6_rd_wave_partition_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_partition_tap_7(.in(net_229[31:0]), 
      .out(reg7_rd_wave_partition_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_tap_0(.in(net_33[31:0]), 
      .out(reg0_rd_wave_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_tap_1(.in(net_64[31:0]), 
      .out(reg1_rd_wave_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_tap_2(.in(net_95[31:0]), 
      .out(reg2_rd_wave_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_tap_3(.in(net_126[31:0]), 
      .out(reg3_rd_wave_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_tap_4(.in(net_157[31:0]), 
      .out(reg4_rd_wave_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_tap_5(.in(net_188[31:0]), 
      .out(reg5_rd_wave_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_tap_6(.in(net_219[31:0]), 
      .out(reg6_rd_wave_signal[31:0]));
  primitives__structural_cpg_tap rd_wave_tap_7(.in(reg7_rd_wave_partition_signal[31:0]), 
      .out(reg7_rd_wave_signal[31:0]));
  primitives__structural_cpg_tap w0_tap_0(.in(w0[31:0]), .out(reg0_word_line[31:0]));
  primitives__structural_cpg_tap w0_tap_1(.in(w0[31:0]), .out(reg1_word_line[31:0]));
  primitives__structural_cpg_tap w0_tap_2(.in(w0[31:0]), .out(reg2_word_line[31:0]));
  primitives__structural_cpg_tap w0_tap_3(.in(w0[31:0]), .out(reg3_word_line[31:0]));
  primitives__structural_cpg_tap w0_tap_4(.in(w0[31:0]), .out(reg4_word_line[31:0]));
  primitives__structural_cpg_tap w0_tap_5(.in(w0[31:0]), .out(reg5_word_line[31:0]));
  primitives__structural_cpg_tap w0_tap_6(.in(w0[31:0]), .out(reg6_word_line[31:0]));
  primitives__structural_cpg_tap w0_tap_7(.in(w0[31:0]), .out(reg7_word_line[31:0]));
  primitives__structural_cpg_tap wr_dummy_partition_tap_0(.in(reg0_wr_wave_partition_signal[31:0]), 
      .out(reg0_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_partition_tap_1(.in(reg1_wr_wave_partition_signal[31:0]), 
      .out(reg1_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_partition_tap_2(.in(reg2_wr_wave_partition_signal[31:0]), 
      .out(reg2_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_partition_tap_3(.in(reg3_wr_wave_partition_signal[31:0]), 
      .out(reg3_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_partition_tap_4(.in(reg4_wr_wave_partition_signal[31:0]), 
      .out(reg4_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_partition_tap_5(.in(reg5_wr_wave_partition_signal[31:0]), 
      .out(reg5_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_partition_tap_6(.in(reg6_wr_wave_partition_signal[31:0]), 
      .out(reg6_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_phase_tap_0(.in(reg0_wr_phase_signal[31:0]), 
      .out(reg0_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_phase_tap_1(.in(reg1_wr_phase_signal[31:0]), 
      .out(reg1_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_phase_tap_2(.in(reg2_wr_phase_signal[31:0]), 
      .out(reg2_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_phase_tap_3(.in(reg3_wr_phase_signal[31:0]), 
      .out(reg3_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_phase_tap_4(.in(reg4_wr_phase_signal[31:0]), 
      .out(reg4_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_phase_tap_5(.in(reg5_wr_phase_signal[31:0]), 
      .out(reg5_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_phase_tap_6(.in(reg6_wr_phase_signal[31:0]), 
      .out(reg6_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_phase_tap_7(.in(reg7_wr_phase_signal[31:0]), 
      .out(reg7_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_tap_0(.in(reg0_word_line[31:0]), 
      .out(reg0_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_tap_1(.in(reg1_word_line[31:0]), 
      .out(reg1_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_tap_2(.in(reg2_word_line[31:0]), 
      .out(reg2_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_tap_3(.in(reg3_word_line[31:0]), 
      .out(reg3_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_tap_4(.in(reg4_word_line[31:0]), 
      .out(reg4_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_tap_5(.in(reg5_word_line[31:0]), 
      .out(reg5_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_tap_6(.in(reg6_word_line[31:0]), 
      .out(reg6_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_tap_7(.in(reg7_word_line[31:0]), 
      .out(reg7_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_wave_tap_0(.in(reg0_wr_wave_signal[31:0]), 
      .out(reg0_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_wave_tap_1(.in(reg1_wr_wave_signal[31:0]), 
      .out(reg1_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_wave_tap_2(.in(reg2_wr_wave_signal[31:0]), 
      .out(reg2_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_wave_tap_3(.in(reg3_wr_wave_signal[31:0]), 
      .out(reg3_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_wave_tap_4(.in(reg4_wr_wave_signal[31:0]), 
      .out(reg4_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_wave_tap_5(.in(reg5_wr_wave_signal[31:0]), 
      .out(reg5_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_wave_tap_6(.in(reg6_wr_wave_signal[31:0]), 
      .out(reg6_data_signal[31:0]));
  primitives__structural_cpg_tap wr_dummy_wave_tap_7(.in(reg7_wr_wave_partition_signal[31:0]), 
      .out(reg7_data_signal[31:0]));
  primitives__structural_cpg_tap wr_wave_partition_tap_0(.in(net_238[31:0]), 
      .out(reg0_wr_wave_partition_signal[31:0]));
  primitives__structural_cpg_tap wr_wave_partition_tap_1(.in(net_238[31:0]), 
      .out(reg1_wr_wave_partition_signal[31:0]));
  primitives__structural_cpg_tap wr_wave_partition_tap_2(.in(net_238[31:0]), 
      .out(reg2_wr_wave_partition_signal[31:0]));
  primitives__structural_cpg_tap wr_wave_partition_tap_3(.in(net_238[31:0]), 
      .out(reg3_wr_wave_partition_signal[31:0]));
  primitives__structural_cpg_tap wr_wave_partition_tap_4(.in(net_238[31:0]), 
      .out(reg4_wr_wave_partition_signal[31:0]));
  primitives__structural_cpg_tap wr_wave_partition_tap_5(.in(net_238[31:0]), 
      .out(reg5_wr_wave_partition_signal[31:0]));
  primitives__structural_cpg_tap wr_wave_partition_tap_6(.in(net_238[31:0]), 
      .out(reg6_wr_wave_partition_signal[31:0]));
  primitives__structural_cpg_tap wr_wave_partition_tap_7(.in(net_238[31:0]), 
      .out(reg7_wr_wave_partition_signal[31:0]));
endmodule   /* cells_cpg__regfile8_r1_w1_cpg_cydra_c1 */
  /* user-specified Verilog external code */
  `define OP_CONST 1
  `define OP_KERNEL_CONST 2
  `define OP_RUNTIME_SYS 3
  `define SIG_INIT 1
  `ifndef CGRA_MAX_II
  `define CGRA_MAX_II 16
  `endif


module primitives__constant(c);
  /* user-specified Verilog parameters */
  localparam PLI_WIDTH=32;
  localparam NUM_CONFIG_WORDS=`CGRA_MAX_II;
  localparam CONFIG_IDX_SIZE=clogb2(NUM_CONFIG_WORDS);
  localparam DATA_WORD_SIZE=32;
  localparam wordsize = DATA_WORD_SIZE > PLI_WIDTH ? DATA_WORD_SIZE : PLI_WIDTH;
  localparam CONFIG_WORD_SIZE=2;
  parameter debug=0;
  parameter configured=0;
  parameter II=16;
  localparam INIT_VAL=32'h0;

  output [31:0] c;

  /* user-specified Verilog declarations */
  wire [DATA_WORD_SIZE-1:0] internal_const, sig_runtime;
  wire [wordsize-1:0] immediate;
  reg  [PLI_WIDTH-1:0] kernel_loadin[0:II-1];
  wire [CONFIG_IDX_SIZE-1:0] ctx;
  wire                             clk;
  wire                             rst_n;
  wire                             init;
  wire [CONFIG_WORD_SIZE-1:0] cmd;
  wire [31:0] sched_slot, cycle_cnt;
  defparam              ctrl.CONFIG_WORD_SIZE=CONFIG_WORD_SIZE;
  defparam              ctrl.configured = configured;
  dpg_controller ctrl(.cmd(cmd));
  defparam              const.CONFIG_WORD_SIZE=wordsize;
  defparam              const.configured = configured;
  dpg_controller const(.cmd(immediate));
  defparam              sched.CONFIG_WORD_SIZE=32;
  defparam              sched.configured = configured;
  dpg_controller sched(.cmd(sched_slot));
  wire [PLI_WIDTH-1:0] OBJ_ID;
  assign clk = configured == 1 ? glbl.clk : 0;
  assign rst_n = glbl.rst_n;
  assign ctx = configured == 1 ? glbl.ctx : 0;
  assign init = glbl.init;
  assign cycle_cnt = configured == 1 ? glbl.cycle_cnt : 0;

  /* user-specified Verilog code */
  // Either pull in a value from the kernel_loadin cache or from the configuration memory
  assign internal_const = (cmd == `OP_KERNEL_CONST) ? kernel_loadin[ctx] : (init && cycle_cnt >= sched_slot) || (glbl.rdy && !init) ? immediate : INIT_VAL;
  // If used as an the macah init signal, it needs to output a 1 and then 0's
  assign sig_runtime = immediate == `SIG_INIT && cycle_cnt == sched_slot ? {DATA_WORD_SIZE{1'b0}} | init : {DATA_WORD_SIZE{1'b0}};
  assign c = (cmd == `OP_RUNTIME_SYS) ? sig_runtime : internal_const;
  assign OBJ_ID = (cmd == `OP_KERNEL_CONST) ? immediate : {DATA_WORD_SIZE{1'bz}};
  
  always @(negedge clk or negedge rst_n) begin
    if(!rst_n) begin
      kernel_loadin[ctx] <= INIT_VAL;
    end else if(init && (cmd == `OP_KERNEL_CONST) && cycle_cnt == sched_slot) begin
      $macah_pli_get_idx(PLI_WIDTH, OBJ_ID, 0, kernel_loadin[ctx]);
      if(debug) begin
        $display("[@%5d] %m loaded %d[%d]=%d from the pli", $time, OBJ_ID, ctx, $signed(kernel_loadin[ctx]));
      end
    end
    if(debug && (cmd == `OP_KERNEL_CONST)) begin
      $display("[@%5d] %m load c=%d into the DPG on phase %d", $time, c, ctx);
    end
    if(debug && cmd == `OP_CONST) begin
      $display("[@%5d] %m load c=%d into the DPG on phase %d", $time, $signed(internal_const), ctx);
    end
    if(debug && cmd == `OP_RUNTIME_SYS) begin
      $display("[@%5d] %m wiring runtime signal c=%d into the DPG on phase %d", $time, c, ctx);
    end
  end
  `include "clogb2.v"

  /* automatically generated Verilog */
endmodule   /* primitives__constant */

module primitives__structural_register(D, Q);
  input [31:0] D;
  output [31:0] Q;

endmodule   /* primitives__structural_register */
  /* user-specified Verilog external code */
  `ifndef CGRA_MAX_II
  `define CGRA_MAX_II 16
  `endif


module cells__regfile8_r4_w1_cydra_c1(w0, r0, r1, r2, r3);
  /* user-specified Verilog parameters */
  parameter configured=0;
  parameter debug=0;
  parameter numConstants=0;
  parameter isCore=0;
  localparam DPG_WIDTH=32;
  localparam wordsize=32;
  localparam isActive = configured;
  localparam NUM_REGISTERS = 8;
  localparam NUM_ADDR_BITS = clogb2(NUM_REGISTERS);
  localparam ONE_HOT_BUS_SIZE = NUM_REGISTERS;
  parameter MAX_II = `CGRA_MAX_II;
  localparam CONFIG_IDX_SIZE=clogb2(MAX_II);
  localparam INIT_VAL=32'h0;
  parameter real JOULES_PER_READ = 1.0;
  parameter real JOULES_PER_WRITE = 1.0;
  parameter real JOULES_PER_BIT_READ = 1.0;
  parameter real JOULES_PER_BIT_WRITE = 1.0;
  parameter real JOULES_PER_CLK = 1.0;
  parameter real JOULES_PER_INACTIVE_CLK = 1.0;
  parameter real STATIC_POWER = 1.0;
  parameter real CFG_SRAM_POWER = 1.0;
  parameter real DELAY = 1.0;
  parameter PWR_MODEL = "none";
  localparam PWR_DOMAIN = isCore ? `CLUSTER : 0;
  localparam PLI_MODE = `PLI_MODE_DEVICE_IS_READ_AND_WRITE | `PLI_MODE_IS_CLOCKED_WITH_GATING;
  localparam partitionLowMask = {NUM_REGISTERS{1'b1}} >> numConstants; // Setup the mask for the rotation split
  localparam partitionHighMask = ~partitionLowMask; // Setup the mask for the rotation split

  input [31:0] w0;
  output [31:0] r0;
  output [31:0] r1;
  output [31:0] r2;
  output [31:0] r3;

  trireg [31:0] c0_src;
  trireg [31:0] net_113;
  trireg [31:0] net_150;
  trireg [31:0] net_187;
  trireg [31:0] net_224;
  trireg [31:0] net_261;
  trireg [31:0] net_271;
  trireg [31:0] net_286;
  trireg [31:0] net_39;
  trireg [31:0] net_76;
  trireg [31:0] reg0_const_line;
  trireg [31:0] reg0_data_signal;
  trireg [31:0] reg0_rd_dummy_signal;
  trireg [31:0] reg0_rd_phase_signal;
  trireg [31:0] reg0_rd_wave_partition_signal;
  trireg [31:0] reg0_rd_wave_signal;
  trireg [31:0] reg0_word_line;
  trireg [31:0] reg0_wr_phase_signal;
  trireg [31:0] reg0_wr_wave_partition_signal;
  trireg [31:0] reg0_wr_wave_signal;
  trireg [31:0] reg1_const_line;
  trireg [31:0] reg1_data_signal;
  trireg [31:0] reg1_rd_dummy_signal;
  trireg [31:0] reg1_rd_phase_signal;
  trireg [31:0] reg1_rd_wave_partition_signal;
  trireg [31:0] reg1_rd_wave_signal;
  trireg [31:0] reg1_word_line;
  trireg [31:0] reg1_wr_phase_signal;
  trireg [31:0] reg1_wr_wave_partition_signal;
  trireg [31:0] reg1_wr_wave_signal;
  trireg [31:0] reg2_const_line;
  trireg [31:0] reg2_data_signal;
  trireg [31:0] reg2_rd_dummy_signal;
  trireg [31:0] reg2_rd_phase_signal;
  trireg [31:0] reg2_rd_wave_partition_signal;
  trireg [31:0] reg2_rd_wave_signal;
  trireg [31:0] reg2_word_line;
  trireg [31:0] reg2_wr_phase_signal;
  trireg [31:0] reg2_wr_wave_partition_signal;
  trireg [31:0] reg2_wr_wave_signal;
  trireg [31:0] reg3_const_line;
  trireg [31:0] reg3_data_signal;
  trireg [31:0] reg3_rd_dummy_signal;
  trireg [31:0] reg3_rd_phase_signal;
  trireg [31:0] reg3_rd_wave_partition_signal;
  trireg [31:0] reg3_rd_wave_signal;
  trireg [31:0] reg3_word_line;
  trireg [31:0] reg3_wr_phase_signal;
  trireg [31:0] reg3_wr_wave_partition_signal;
  trireg [31:0] reg3_wr_wave_signal;
  trireg [31:0] reg4_const_line;
  trireg [31:0] reg4_data_signal;
  trireg [31:0] reg4_rd_dummy_signal;
  trireg [31:0] reg4_rd_phase_signal;
  trireg [31:0] reg4_rd_wave_partition_signal;
  trireg [31:0] reg4_rd_wave_signal;
  trireg [31:0] reg4_word_line;
  trireg [31:0] reg4_wr_phase_signal;
  trireg [31:0] reg4_wr_wave_partition_signal;
  trireg [31:0] reg4_wr_wave_signal;
  trireg [31:0] reg5_const_line;
  trireg [31:0] reg5_data_signal;
  trireg [31:0] reg5_rd_dummy_signal;
  trireg [31:0] reg5_rd_phase_signal;
  trireg [31:0] reg5_rd_wave_partition_signal;
  trireg [31:0] reg5_rd_wave_signal;
  trireg [31:0] reg5_word_line;
  trireg [31:0] reg5_wr_phase_signal;
  trireg [31:0] reg5_wr_wave_partition_signal;
  trireg [31:0] reg5_wr_wave_signal;
  trireg [31:0] reg6_const_line;
  trireg [31:0] reg6_data_signal;
  trireg [31:0] reg6_rd_dummy_signal;
  trireg [31:0] reg6_rd_phase_signal;
  trireg [31:0] reg6_rd_wave_partition_signal;
  trireg [31:0] reg6_rd_wave_signal;
  trireg [31:0] reg6_word_line;
  trireg [31:0] reg6_wr_phase_signal;
  trireg [31:0] reg6_wr_wave_partition_signal;
  trireg [31:0] reg6_wr_wave_signal;
  trireg [31:0] reg7_const_line;
  trireg [31:0] reg7_data_signal;
  trireg [31:0] reg7_rd_dummy_signal;
  trireg [31:0] reg7_rd_phase_signal;
  trireg [31:0] reg7_rd_wave_partition_signal;
  trireg [31:0] reg7_rd_wave_signal;
  trireg [31:0] reg7_word_line;
  trireg [31:0] reg7_wr_phase_signal;
  trireg [31:0] reg7_wr_wave_partition_signal;

  /* user-specified Verilog declarations */
  reg [NUM_ADDR_BITS-1:0] base;
  reg [DPG_WIDTH-1:0]      mem[0:NUM_REGISTERS-1];
  
  // Write Ports
  wire [NUM_REGISTERS-1:0] w0_cfg;
  wire [NUM_REGISTERS-1:0] w0_phase_cfg, w0_wave_cfg, w0_cfg_rot;
  wire [NUM_REGISTERS-1:0] w0_cfg_low_masked, w0_cfg_high_masked, w0_cfg_combined;
  reg  [NUM_ADDR_BITS-1:0] w0_addr;
  reg                      w0_valid;
  `ifdef POWER_SIM
  reg [31:0] w0_tx_cnt;
  reg [31:0] w0_bit_tx_cnt;
  reg [31:0] old_w0;
  `endif
  // Constant Generators
  wire [NUM_REGISTERS-1:0] c0_cfg;
  reg  [NUM_ADDR_BITS-1:0] c0_addr;
  reg                      c0_valid;
  // Read Ports
  wire [NUM_REGISTERS-1:0] r0_cfg;
  wire [NUM_REGISTERS-1:0] r0_cfg_rot;
  wire [NUM_REGISTERS-1:0] r0_cfg_low_masked, r0_cfg_high_masked, r0_cfg_combined;
  reg  [NUM_ADDR_BITS-1:0] r0_addr;
  reg                      r0_valid;
  `ifdef POWER_SIM
  reg [31:0] r0_tx_cnt;
  reg [31:0] r0_bit_tx_cnt;
  reg [31:0] old_r0;
  `endif
  wire [NUM_REGISTERS-1:0] r1_cfg;
  wire [NUM_REGISTERS-1:0] r1_cfg_rot;
  wire [NUM_REGISTERS-1:0] r1_cfg_low_masked, r1_cfg_high_masked, r1_cfg_combined;
  reg  [NUM_ADDR_BITS-1:0] r1_addr;
  reg                      r1_valid;
  `ifdef POWER_SIM
  reg [31:0] r1_tx_cnt;
  reg [31:0] r1_bit_tx_cnt;
  reg [31:0] old_r1;
  `endif
  wire [NUM_REGISTERS-1:0] r2_cfg;
  wire [NUM_REGISTERS-1:0] r2_cfg_rot;
  wire [NUM_REGISTERS-1:0] r2_cfg_low_masked, r2_cfg_high_masked, r2_cfg_combined;
  reg  [NUM_ADDR_BITS-1:0] r2_addr;
  reg                      r2_valid;
  `ifdef POWER_SIM
  reg [31:0] r2_tx_cnt;
  reg [31:0] r2_bit_tx_cnt;
  reg [31:0] old_r2;
  `endif
  wire [NUM_REGISTERS-1:0] r3_cfg;
  wire [NUM_REGISTERS-1:0] r3_cfg_rot;
  wire [NUM_REGISTERS-1:0] r3_cfg_low_masked, r3_cfg_high_masked, r3_cfg_combined;
  reg  [NUM_ADDR_BITS-1:0] r3_addr;
  reg                      r3_valid;
  `ifdef POWER_SIM
  reg [31:0] r3_tx_cnt;
  reg [31:0] r3_bit_tx_cnt;
  reg [31:0] old_r3;
  `endif
  
  wire clk, rst_n, init;
  wire [CONFIG_IDX_SIZE-1:0] ctx;
  integer i;
  `ifdef POWER_SIM
  reg [31:0]  read_tx_cnt, read_bit_tx_cnt;
  reg [31:0]  write_tx_cnt, write_bit_tx_cnt;
  reg [31:0] cycle_cnt;
  `endif

  /* user-specified Verilog code */
  assign clk = glbl.clk;
  assign ctx = glbl.ctx;
  assign rst_n = glbl.rst_n;
  assign init = glbl.init;
  
  `include "encode_one_hot_signal.v"
  `include "clogb2.v"
  
  assign w0_cfg = {w0_tap_7.cmd, w0_tap_6.cmd, w0_tap_5.cmd, w0_tap_4.cmd, 
                                            w0_tap_3.cmd, w0_tap_2.cmd, w0_tap_1.cmd, w0_tap_0.cmd};
                                            
  assign w0_cfg_low_masked = w0_cfg & partitionLowMask; // Mask off the values above the split point
  assign w0_cfg_high_masked = w0_cfg & partitionHighMask; // Mask off the values above the split point
  assign w0_cfg_rot = ((w0_cfg_low_masked << base) | (w0_cfg_low_masked >> (NUM_REGISTERS - numConstants - base))) & partitionLowMask; // Rotate and remask the result
  assign w0_cfg_combined = w0_cfg_high_masked | w0_cfg_rot;
  
  always @(w0_cfg_combined) begin
    encode_one_hot_signal(w0_cfg_combined, w0_addr, w0_valid);
    if(debug) begin
      $display("[@%5d] %m w0_addr=%b w0_cfg=%b w0_cfg_low_masked=%b w0_cfg_high_masked=%b w0_cfg_rot=%b w0_cfg_combined=%b partitionLow=%b partitionHigh=%b", $time,  w0_addr, w0_cfg, w0_cfg_low_masked, w0_cfg_high_masked, w0_cfg_rot, w0_cfg_combined, partitionLowMask, partitionHighMask);
    end
  end
  
  
  assign c0_cfg = {c0_tap_7.cmd, c0_tap_6.cmd, c0_tap_5.cmd, c0_tap_4.cmd, 
                                            c0_tap_3.cmd, c0_tap_2.cmd, c0_tap_1.cmd, c0_tap_0.cmd};
                                            
  always @(c0_cfg) begin
         encode_one_hot_signal(c0_cfg, c0_addr, c0_valid);
  end
  
  
  // Ignore the read wave and phase taps
  assign r0_cfg = {r0_tap_7.cmd, r0_tap_6.cmd, r0_tap_5.cmd, r0_tap_4.cmd, 
                           r0_tap_3.cmd, r0_tap_2.cmd, r0_tap_1.cmd, r0_tap_0.cmd};
                           
  assign r0_cfg_low_masked = r0_cfg & partitionLowMask; // Mask off the values above the split point
  assign r0_cfg_high_masked = r0_cfg & partitionHighMask; // Mask off the values above the split point
  assign r0_cfg_rot = ((r0_cfg_low_masked << base) | (r0_cfg_low_masked >> (NUM_REGISTERS - numConstants - base))) & partitionLowMask; // Rotate and remask the result
  assign r0_cfg_combined = r0_cfg_high_masked | r0_cfg_rot;
  
  always @(r0_cfg_combined) begin
    encode_one_hot_signal(r0_cfg_combined, r0_addr, r0_valid);
    if(debug) begin
      $display("[@%5d] %m r0_addr=%b r0_cfg=%b r0_cfg_low_masked=%b r0_cfg_high_masked=%b r0_cfg_rot=%b r0_cfg_combined=%b partitionLow=%b partitionHigh=%b", $time,  r0_addr, r0_cfg, r0_cfg_low_masked, r0_cfg_high_masked, r0_cfg_rot, r0_cfg_combined, partitionLowMask, partitionHighMask);
    end
  end
  
  assign #(DELAY) r0 = configured && r0_valid ? mem[r0_addr] : {DPG_WIDTH{1'bz}};
  // Ignore the read wave and phase taps
  assign r1_cfg = {r1_tap_7.cmd, r1_tap_6.cmd, r1_tap_5.cmd, r1_tap_4.cmd, 
                           r1_tap_3.cmd, r1_tap_2.cmd, r1_tap_1.cmd, r1_tap_0.cmd};
                           
  assign r1_cfg_low_masked = r1_cfg & partitionLowMask; // Mask off the values above the split point
  assign r1_cfg_high_masked = r1_cfg & partitionHighMask; // Mask off the values above the split point
  assign r1_cfg_rot = ((r1_cfg_low_masked << base) | (r1_cfg_low_masked >> (NUM_REGISTERS - numConstants - base))) & partitionLowMask; // Rotate and remask the result
  assign r1_cfg_combined = r1_cfg_high_masked | r1_cfg_rot;
  
  always @(r1_cfg_combined) begin
    encode_one_hot_signal(r1_cfg_combined, r1_addr, r1_valid);
    if(debug) begin
      $display("[@%5d] %m r1_addr=%b r1_cfg=%b r1_cfg_low_masked=%b r1_cfg_high_masked=%b r1_cfg_rot=%b r1_cfg_combined=%b partitionLow=%b partitionHigh=%b", $time,  r1_addr, r1_cfg, r1_cfg_low_masked, r1_cfg_high_masked, r1_cfg_rot, r1_cfg_combined, partitionLowMask, partitionHighMask);
    end
  end
  
  assign #(DELAY) r1 = configured && r1_valid ? mem[r1_addr] : {DPG_WIDTH{1'bz}};
  // Ignore the read wave and phase taps
  assign r2_cfg = {r2_tap_7.cmd, r2_tap_6.cmd, r2_tap_5.cmd, r2_tap_4.cmd, 
                           r2_tap_3.cmd, r2_tap_2.cmd, r2_tap_1.cmd, r2_tap_0.cmd};
                           
  assign r2_cfg_low_masked = r2_cfg & partitionLowMask; // Mask off the values above the split point
  assign r2_cfg_high_masked = r2_cfg & partitionHighMask; // Mask off the values above the split point
  assign r2_cfg_rot = ((r2_cfg_low_masked << base) | (r2_cfg_low_masked >> (NUM_REGISTERS - numConstants - base))) & partitionLowMask; // Rotate and remask the result
  assign r2_cfg_combined = r2_cfg_high_masked | r2_cfg_rot;
  
  always @(r2_cfg_combined) begin
    encode_one_hot_signal(r2_cfg_combined, r2_addr, r2_valid);
    if(debug) begin
      $display("[@%5d] %m r2_addr=%b r2_cfg=%b r2_cfg_low_masked=%b r2_cfg_high_masked=%b r2_cfg_rot=%b r2_cfg_combined=%b partitionLow=%b partitionHigh=%b", $time,  r2_addr, r2_cfg, r2_cfg_low_masked, r2_cfg_high_masked, r2_cfg_rot, r2_cfg_combined, partitionLowMask, partitionHighMask);
    end
  end
  
  assign #(DELAY) r2 = configured && r2_valid ? mem[r2_addr] : {DPG_WIDTH{1'bz}};
  // Ignore the read wave and phase taps
  assign r3_cfg = {r3_tap_7.cmd, r3_tap_6.cmd, r3_tap_5.cmd, r3_tap_4.cmd, 
                           r3_tap_3.cmd, r3_tap_2.cmd, r3_tap_1.cmd, r3_tap_0.cmd};
                           
  assign r3_cfg_low_masked = r3_cfg & partitionLowMask; // Mask off the values above the split point
  assign r3_cfg_high_masked = r3_cfg & partitionHighMask; // Mask off the values above the split point
  assign r3_cfg_rot = ((r3_cfg_low_masked << base) | (r3_cfg_low_masked >> (NUM_REGISTERS - numConstants - base))) & partitionLowMask; // Rotate and remask the result
  assign r3_cfg_combined = r3_cfg_high_masked | r3_cfg_rot;
  
  always @(r3_cfg_combined) begin
    encode_one_hot_signal(r3_cfg_combined, r3_addr, r3_valid);
    if(debug) begin
      $display("[@%5d] %m r3_addr=%b r3_cfg=%b r3_cfg_low_masked=%b r3_cfg_high_masked=%b r3_cfg_rot=%b r3_cfg_combined=%b partitionLow=%b partitionHigh=%b", $time,  r3_addr, r3_cfg, r3_cfg_low_masked, r3_cfg_high_masked, r3_cfg_rot, r3_cfg_combined, partitionLowMask, partitionHighMask);
    end
  end
  
  assign #(DELAY) r3 = configured && r3_valid ? mem[r3_addr] : {DPG_WIDTH{1'bz}};
  
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      base <= 0;
      for(i = 0; i < NUM_REGISTERS; i = i+1) begin
        mem[i] <= INIT_VAL;
      end
    `ifdef POWER_SIM
      w0_tx_cnt <= 0;
      w0_bit_tx_cnt <= 0;
      old_w0 <= 0;
      // Active clock energy is currently accumulated with each write
      cycle_cnt <= 0;
    `endif
    end else if(configured) begin
      if(ctx == glbl.II-1) begin
        if(base == NUM_REGISTERS-numConstants-1) begin
          base <= 0;
        end else begin
          base <= base + 1;
        end
      end
      if(w0_valid) begin
        mem[w0_addr] <= w0;
      `ifdef POWER_SIM
        monitor_dpg_signal(w0, old_w0, w0_tx_cnt, w0_bit_tx_cnt);
        if(debug) begin
          $display("[@%5d]<%d> %m w0=%x old_w0=%x w0_tx_cnt=%x w0_bit_tx_cnt=%x", $time, glbl.ctx, w0, old_w0, w0_tx_cnt, w0_bit_tx_cnt);
        end
        old_w0 <= w0;
      `endif
        if(debug) begin
          $display("[@%5d]<%d><%d> %m  %d -> mem[%4d](%b,%b)", $time, ctx, base, w0, w0_addr, w0_cfg, w0_cfg_rot);
        end
      end
      if(c0_valid) begin
        mem[c0_addr] <= c0_src;
        if(debug) begin
          $display("[@%5d]<%d> %m  mem[%4d](%b) <- %d", $time, ctx, c0_addr, c0_cfg, c0_src);
        end
      end
    end
  end
  
  always @(*) begin
    if(configured && debug) begin
      if(r0_valid) begin
        $display("[@%5d]<%d><%d> %m  mem[%4d](%b,%b) -> %d", $time, ctx, base, r0_addr, r0_cfg, r0_cfg_rot, r0);
      end
      if(r1_valid) begin
        $display("[@%5d]<%d><%d> %m  mem[%4d](%b,%b) -> %d", $time, ctx, base, r1_addr, r1_cfg, r1_cfg_rot, r1);
      end
      if(r2_valid) begin
        $display("[@%5d]<%d><%d> %m  mem[%4d](%b,%b) -> %d", $time, ctx, base, r2_addr, r2_cfg, r2_cfg_rot, r2);
      end
      if(r3_valid) begin
        $display("[@%5d]<%d><%d> %m  mem[%4d](%b,%b) -> %d", $time, ctx, base, r3_addr, r3_cfg, r3_cfg_rot, r3);
      end
    end
  end
  `ifdef POWER_SIM
  `include "monitor_dpg_signal.v"
  
  always @(*) begin
    if(glbl.rdy && isCore) begin
      if(r0_valid) begin
        monitor_dpg_signal(r0, old_r0, r0_tx_cnt, r0_bit_tx_cnt);
        if(debug) begin
          $display("[@%5d]<%d> %m r0=%x old_r0=%x r0_tx_cnt=%x r0_bit_tx_cnt=%x", $time, glbl.ctx, r0, old_r0, r0_tx_cnt, r0_bit_tx_cnt);
        end
        old_r0 = r0;
      end
      if(r1_valid) begin
        monitor_dpg_signal(r1, old_r1, r1_tx_cnt, r1_bit_tx_cnt);
        if(debug) begin
          $display("[@%5d]<%d> %m r1=%x old_r1=%x r1_tx_cnt=%x r1_bit_tx_cnt=%x", $time, glbl.ctx, r1, old_r1, r1_tx_cnt, r1_bit_tx_cnt);
        end
        old_r1 = r1;
      end
      if(r2_valid) begin
        monitor_dpg_signal(r2, old_r2, r2_tx_cnt, r2_bit_tx_cnt);
        if(debug) begin
          $display("[@%5d]<%d> %m r2=%x old_r2=%x r2_tx_cnt=%x r2_bit_tx_cnt=%x", $time, glbl.ctx, r2, old_r2, r2_tx_cnt, r2_bit_tx_cnt);
        end
        old_r2 = r2;
      end
      if(r3_valid) begin
        monitor_dpg_signal(r3, old_r3, r3_tx_cnt, r3_bit_tx_cnt);
        if(debug) begin
          $display("[@%5d]<%d> %m r3=%x old_r3=%x r3_tx_cnt=%x r3_bit_tx_cnt=%x", $time, glbl.ctx, r3, old_r3, r3_tx_cnt, r3_bit_tx_cnt);
        end
        old_r3 = r3;
      end
    end else begin
      r0_tx_cnt = 0;
      r0_bit_tx_cnt = 0;
      old_r0 = 0;
      r1_tx_cnt = 0;
      r1_bit_tx_cnt = 0;
      old_r1 = 0;
      r2_tx_cnt = 0;
      r2_bit_tx_cnt = 0;
      old_r2 = 0;
      r3_tx_cnt = 0;
      r3_bit_tx_cnt = 0;
      old_r3 = 0;
    end // glbl.rdy && isCore
  end
  
  always @(*) begin
    if(glbl.rdy && isCore) begin
  read_tx_cnt = r0_tx_cnt + r1_tx_cnt + r2_tx_cnt + r3_tx_cnt;
  read_bit_tx_cnt = r0_bit_tx_cnt + r1_bit_tx_cnt + r2_bit_tx_cnt + r3_bit_tx_cnt;
  write_tx_cnt = w0_tx_cnt;
  write_bit_tx_cnt = w0_bit_tx_cnt;
    end // glbl.rdy && isCore
  end
  
  initial begin
    if(isCore) begin
      $cgra_hybrid_monitor(PWR_DOMAIN, PWR_MODEL, PLI_MODE, read_tx_cnt, read_bit_tx_cnt, write_tx_cnt, write_bit_tx_cnt, cycle_cnt);
    end
  end
  `endif

  /* automatically generated Verilog */
  primitives__structural_tap c0_tap_0(.in(c0_src[31:0]), .out(reg0_const_line[31:0]));
  primitives__structural_tap c0_tap_1(.in(c0_src[31:0]), .out(reg1_const_line[31:0]));
  primitives__structural_tap c0_tap_2(.in(c0_src[31:0]), .out(reg2_const_line[31:0]));
  primitives__structural_tap c0_tap_3(.in(c0_src[31:0]), .out(reg3_const_line[31:0]));
  primitives__structural_tap c0_tap_4(.in(c0_src[31:0]), .out(reg4_const_line[31:0]));
  primitives__structural_tap c0_tap_5(.in(c0_src[31:0]), .out(reg5_const_line[31:0]));
  primitives__structural_tap c0_tap_6(.in(c0_src[31:0]), .out(reg6_const_line[31:0]));
  primitives__structural_tap c0_tap_7(.in(c0_src[31:0]), .out(reg7_const_line[31:0]));
  primitives__constant c_0(.c(c0_src[31:0]));
  primitives__structural_tap contant_dummy_tap_0(.in(reg0_const_line[31:0]), 
      .out(reg0_data_signal[31:0]));
  primitives__structural_tap contant_dummy_tap_1(.in(reg1_const_line[31:0]), 
      .out(reg1_data_signal[31:0]));
  primitives__structural_tap contant_dummy_tap_2(.in(reg2_const_line[31:0]), 
      .out(reg2_data_signal[31:0]));
  primitives__structural_tap contant_dummy_tap_3(.in(reg3_const_line[31:0]), 
      .out(reg3_data_signal[31:0]));
  primitives__structural_tap contant_dummy_tap_4(.in(reg4_const_line[31:0]), 
      .out(reg4_data_signal[31:0]));
  primitives__structural_tap contant_dummy_tap_5(.in(reg5_const_line[31:0]), 
      .out(reg5_data_signal[31:0]));
  primitives__structural_tap contant_dummy_tap_6(.in(reg6_const_line[31:0]), 
      .out(reg6_data_signal[31:0]));
  primitives__structural_tap contant_dummy_tap_7(.in(reg7_const_line[31:0]), 
      .out(reg7_data_signal[31:0]));
  primitives__structural_tap feedback_phase_tap_0(.in(net_271[31:0]), 
      .out(reg0_wr_phase_signal[31:0]));
  primitives__structural_tap feedback_phase_tap_1(.in(net_39[31:0]), 
      .out(reg1_wr_phase_signal[31:0]));
  primitives__structural_tap feedback_phase_tap_2(.in(net_76[31:0]), 
      .out(reg2_wr_phase_signal[31:0]));
  primitives__structural_tap feedback_phase_tap_3(.in(net_113[31:0]), 
      .out(reg3_wr_phase_signal[31:0]));
  primitives__structural_tap feedback_phase_tap_4(.in(net_150[31:0]), 
      .out(reg4_wr_phase_signal[31:0]));
  primitives__structural_tap feedback_phase_tap_5(.in(net_187[31:0]), 
      .out(reg5_wr_phase_signal[31:0]));
  primitives__structural_tap feedback_phase_tap_6(.in(net_224[31:0]), 
      .out(reg6_wr_phase_signal[31:0]));
  primitives__structural_tap feedback_phase_tap_7(.in(net_261[31:0]), 
      .out(reg7_wr_phase_signal[31:0]));
  primitives__structural_tap feedback_wave_tap_0(.in(net_271[31:0]), .out(net_286[31:0]));
  primitives__structural_tap feedback_wave_tap_1(.in(net_39[31:0]), 
      .out(reg0_wr_wave_signal[31:0]));
  primitives__structural_tap feedback_wave_tap_2(.in(net_76[31:0]), 
      .out(reg1_wr_wave_signal[31:0]));
  primitives__structural_tap feedback_wave_tap_3(.in(net_113[31:0]), 
      .out(reg2_wr_wave_signal[31:0]));
  primitives__structural_tap feedback_wave_tap_4(.in(net_150[31:0]), 
      .out(reg3_wr_wave_signal[31:0]));
  primitives__structural_tap feedback_wave_tap_5(.in(net_187[31:0]), 
      .out(reg4_wr_wave_signal[31:0]));
  primitives__structural_tap feedback_wave_tap_6(.in(net_224[31:0]), 
      .out(reg5_wr_wave_signal[31:0]));
  primitives__structural_tap feedback_wave_tap_7(.in(net_261[31:0]), 
      .out(reg6_wr_wave_signal[31:0]));
  primitives__structural_tap r0_tap_0(.in(reg0_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_tap r0_tap_1(.in(reg1_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_tap r0_tap_2(.in(reg2_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_tap r0_tap_3(.in(reg3_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_tap r0_tap_4(.in(reg4_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_tap r0_tap_5(.in(reg5_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_tap r0_tap_6(.in(reg6_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_tap r0_tap_7(.in(reg7_rd_dummy_signal[31:0]), .out(r0[31:0]));
  primitives__structural_tap r1_tap_0(.in(reg0_rd_dummy_signal[31:0]), .out(r1[31:0]));
  primitives__structural_tap r1_tap_1(.in(reg1_rd_dummy_signal[31:0]), .out(r1[31:0]));
  primitives__structural_tap r1_tap_2(.in(reg2_rd_dummy_signal[31:0]), .out(r1[31:0]));
  primitives__structural_tap r1_tap_3(.in(reg3_rd_dummy_signal[31:0]), .out(r1[31:0]));
  primitives__structural_tap r1_tap_4(.in(reg4_rd_dummy_signal[31:0]), .out(r1[31:0]));
  primitives__structural_tap r1_tap_5(.in(reg5_rd_dummy_signal[31:0]), .out(r1[31:0]));
  primitives__structural_tap r1_tap_6(.in(reg6_rd_dummy_signal[31:0]), .out(r1[31:0]));
  primitives__structural_tap r1_tap_7(.in(reg7_rd_dummy_signal[31:0]), .out(r1[31:0]));
  primitives__structural_tap r2_tap_0(.in(reg0_rd_dummy_signal[31:0]), .out(r2[31:0]));
  primitives__structural_tap r2_tap_1(.in(reg1_rd_dummy_signal[31:0]), .out(r2[31:0]));
  primitives__structural_tap r2_tap_2(.in(reg2_rd_dummy_signal[31:0]), .out(r2[31:0]));
  primitives__structural_tap r2_tap_3(.in(reg3_rd_dummy_signal[31:0]), .out(r2[31:0]));
  primitives__structural_tap r2_tap_4(.in(reg4_rd_dummy_signal[31:0]), .out(r2[31:0]));
  primitives__structural_tap r2_tap_5(.in(reg5_rd_dummy_signal[31:0]), .out(r2[31:0]));
  primitives__structural_tap r2_tap_6(.in(reg6_rd_dummy_signal[31:0]), .out(r2[31:0]));
  primitives__structural_tap r2_tap_7(.in(reg7_rd_dummy_signal[31:0]), .out(r2[31:0]));
  primitives__structural_tap r3_tap_0(.in(reg0_rd_dummy_signal[31:0]), .out(r3[31:0]));
  primitives__structural_tap r3_tap_1(.in(reg1_rd_dummy_signal[31:0]), .out(r3[31:0]));
  primitives__structural_tap r3_tap_2(.in(reg2_rd_dummy_signal[31:0]), .out(r3[31:0]));
  primitives__structural_tap r3_tap_3(.in(reg3_rd_dummy_signal[31:0]), .out(r3[31:0]));
  primitives__structural_tap r3_tap_4(.in(reg4_rd_dummy_signal[31:0]), .out(r3[31:0]));
  primitives__structural_tap r3_tap_5(.in(reg5_rd_dummy_signal[31:0]), .out(r3[31:0]));
  primitives__structural_tap r3_tap_6(.in(reg6_rd_dummy_signal[31:0]), .out(r3[31:0]));
  primitives__structural_tap r3_tap_7(.in(reg7_rd_dummy_signal[31:0]), .out(r3[31:0]));
  primitives__structural_tap rd_dummy_partition_tap_0(.in(reg0_rd_wave_partition_signal[31:0]), 
      .out(reg0_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_partition_tap_1(.in(reg1_rd_wave_partition_signal[31:0]), 
      .out(reg1_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_partition_tap_2(.in(reg2_rd_wave_partition_signal[31:0]), 
      .out(reg2_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_partition_tap_3(.in(reg3_rd_wave_partition_signal[31:0]), 
      .out(reg3_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_partition_tap_4(.in(reg4_rd_wave_partition_signal[31:0]), 
      .out(reg4_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_partition_tap_5(.in(reg5_rd_wave_partition_signal[31:0]), 
      .out(reg5_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_partition_tap_6(.in(reg6_rd_wave_partition_signal[31:0]), 
      .out(reg6_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_phase_tap_0(.in(reg0_rd_phase_signal[31:0]), 
      .out(reg0_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_phase_tap_1(.in(reg1_rd_phase_signal[31:0]), 
      .out(reg1_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_phase_tap_2(.in(reg2_rd_phase_signal[31:0]), 
      .out(reg2_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_phase_tap_3(.in(reg3_rd_phase_signal[31:0]), 
      .out(reg3_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_phase_tap_4(.in(reg4_rd_phase_signal[31:0]), 
      .out(reg4_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_phase_tap_5(.in(reg5_rd_phase_signal[31:0]), 
      .out(reg5_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_phase_tap_6(.in(reg6_rd_phase_signal[31:0]), 
      .out(reg6_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_phase_tap_7(.in(reg7_rd_phase_signal[31:0]), 
      .out(reg7_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_wave_tap_0(.in(reg0_rd_wave_signal[31:0]), 
      .out(reg0_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_wave_tap_1(.in(reg1_rd_wave_signal[31:0]), 
      .out(reg1_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_wave_tap_2(.in(reg2_rd_wave_signal[31:0]), 
      .out(reg2_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_wave_tap_3(.in(reg3_rd_wave_signal[31:0]), 
      .out(reg3_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_wave_tap_4(.in(reg4_rd_wave_signal[31:0]), 
      .out(reg4_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_wave_tap_5(.in(reg5_rd_wave_signal[31:0]), 
      .out(reg5_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_wave_tap_6(.in(reg6_rd_wave_signal[31:0]), 
      .out(reg6_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_dummy_wave_tap_7(.in(reg7_rd_wave_signal[31:0]), 
      .out(reg7_rd_dummy_signal[31:0]));
  primitives__structural_tap rd_phase_tap_0(.in(net_271[31:0]), .out(reg0_rd_phase_signal[31:0]));
  primitives__structural_tap rd_phase_tap_1(.in(net_39[31:0]), .out(reg1_rd_phase_signal[31:0]));
  primitives__structural_tap rd_phase_tap_2(.in(net_76[31:0]), .out(reg2_rd_phase_signal[31:0]));
  primitives__structural_tap rd_phase_tap_3(.in(net_113[31:0]), .out(reg3_rd_phase_signal[31:0]));
  primitives__structural_tap rd_phase_tap_4(.in(net_150[31:0]), .out(reg4_rd_phase_signal[31:0]));
  primitives__structural_tap rd_phase_tap_5(.in(net_187[31:0]), .out(reg5_rd_phase_signal[31:0]));
  primitives__structural_tap rd_phase_tap_6(.in(net_224[31:0]), .out(reg6_rd_phase_signal[31:0]));
  primitives__structural_tap rd_phase_tap_7(.in(net_261[31:0]), .out(reg7_rd_phase_signal[31:0]));
  primitives__structural_tap rd_wave_partition_tap_0(.in(net_271[31:0]), 
      .out(reg0_rd_wave_partition_signal[31:0]));
  primitives__structural_tap rd_wave_partition_tap_1(.in(net_271[31:0]), 
      .out(reg1_rd_wave_partition_signal[31:0]));
  primitives__structural_tap rd_wave_partition_tap_2(.in(net_271[31:0]), 
      .out(reg2_rd_wave_partition_signal[31:0]));
  primitives__structural_tap rd_wave_partition_tap_3(.in(net_271[31:0]), 
      .out(reg3_rd_wave_partition_signal[31:0]));
  primitives__structural_tap rd_wave_partition_tap_4(.in(net_271[31:0]), 
      .out(reg4_rd_wave_partition_signal[31:0]));
  primitives__structural_tap rd_wave_partition_tap_5(.in(net_271[31:0]), 
      .out(reg5_rd_wave_partition_signal[31:0]));
  primitives__structural_tap rd_wave_partition_tap_6(.in(net_271[31:0]), 
      .out(reg6_rd_wave_partition_signal[31:0]));
  primitives__structural_tap rd_wave_partition_tap_7(.in(net_271[31:0]), 
      .out(reg7_rd_wave_partition_signal[31:0]));
  primitives__structural_tap rd_wave_tap_0(.in(net_39[31:0]), .out(reg0_rd_wave_signal[31:0]));
  primitives__structural_tap rd_wave_tap_1(.in(net_76[31:0]), .out(reg1_rd_wave_signal[31:0]));
  primitives__structural_tap rd_wave_tap_2(.in(net_113[31:0]), .out(reg2_rd_wave_signal[31:0]));
  primitives__structural_tap rd_wave_tap_3(.in(net_150[31:0]), .out(reg3_rd_wave_signal[31:0]));
  primitives__structural_tap rd_wave_tap_4(.in(net_187[31:0]), .out(reg4_rd_wave_signal[31:0]));
  primitives__structural_tap rd_wave_tap_5(.in(net_224[31:0]), .out(reg5_rd_wave_signal[31:0]));
  primitives__structural_tap rd_wave_tap_6(.in(net_261[31:0]), .out(reg6_rd_wave_signal[31:0]));
  primitives__structural_tap rd_wave_tap_7(.in(reg7_rd_wave_partition_signal[31:0]), 
      .out(reg7_rd_wave_signal[31:0]));
  primitives__structural_register register_0(.D(reg0_data_signal[31:0]), .Q(net_271[31:0]));
  primitives__structural_register register_1(.D(reg1_data_signal[31:0]), .Q(net_39[31:0]));
  primitives__structural_register register_2(.D(reg2_data_signal[31:0]), .Q(net_76[31:0]));
  primitives__structural_register register_3(.D(reg3_data_signal[31:0]), .Q(net_113[31:0]));
  primitives__structural_register register_4(.D(reg4_data_signal[31:0]), .Q(net_150[31:0]));
  primitives__structural_register register_5(.D(reg5_data_signal[31:0]), .Q(net_187[31:0]));
  primitives__structural_register register_6(.D(reg6_data_signal[31:0]), .Q(net_224[31:0]));
  primitives__structural_register register_7(.D(reg7_data_signal[31:0]), .Q(net_261[31:0]));
  primitives__structural_tap w0_tap_0(.in(w0[31:0]), .out(reg0_word_line[31:0]));
  primitives__structural_tap w0_tap_1(.in(w0[31:0]), .out(reg1_word_line[31:0]));
  primitives__structural_tap w0_tap_2(.in(w0[31:0]), .out(reg2_word_line[31:0]));
  primitives__structural_tap w0_tap_3(.in(w0[31:0]), .out(reg3_word_line[31:0]));
  primitives__structural_tap w0_tap_4(.in(w0[31:0]), .out(reg4_word_line[31:0]));
  primitives__structural_tap w0_tap_5(.in(w0[31:0]), .out(reg5_word_line[31:0]));
  primitives__structural_tap w0_tap_6(.in(w0[31:0]), .out(reg6_word_line[31:0]));
  primitives__structural_tap w0_tap_7(.in(w0[31:0]), .out(reg7_word_line[31:0]));
  primitives__structural_tap wr_dummy_partition_tap_0(.in(reg0_wr_wave_partition_signal[31:0]), 
      .out(reg0_data_signal[31:0]));
  primitives__structural_tap wr_dummy_partition_tap_1(.in(reg1_wr_wave_partition_signal[31:0]), 
      .out(reg1_data_signal[31:0]));
  primitives__structural_tap wr_dummy_partition_tap_2(.in(reg2_wr_wave_partition_signal[31:0]), 
      .out(reg2_data_signal[31:0]));
  primitives__structural_tap wr_dummy_partition_tap_3(.in(reg3_wr_wave_partition_signal[31:0]), 
      .out(reg3_data_signal[31:0]));
  primitives__structural_tap wr_dummy_partition_tap_4(.in(reg4_wr_wave_partition_signal[31:0]), 
      .out(reg4_data_signal[31:0]));
  primitives__structural_tap wr_dummy_partition_tap_5(.in(reg5_wr_wave_partition_signal[31:0]), 
      .out(reg5_data_signal[31:0]));
  primitives__structural_tap wr_dummy_partition_tap_6(.in(reg6_wr_wave_partition_signal[31:0]), 
      .out(reg6_data_signal[31:0]));
  primitives__structural_tap wr_dummy_phase_tap_0(.in(reg0_wr_phase_signal[31:0]), 
      .out(reg0_data_signal[31:0]));
  primitives__structural_tap wr_dummy_phase_tap_1(.in(reg1_wr_phase_signal[31:0]), 
      .out(reg1_data_signal[31:0]));
  primitives__structural_tap wr_dummy_phase_tap_2(.in(reg2_wr_phase_signal[31:0]), 
      .out(reg2_data_signal[31:0]));
  primitives__structural_tap wr_dummy_phase_tap_3(.in(reg3_wr_phase_signal[31:0]), 
      .out(reg3_data_signal[31:0]));
  primitives__structural_tap wr_dummy_phase_tap_4(.in(reg4_wr_phase_signal[31:0]), 
      .out(reg4_data_signal[31:0]));
  primitives__structural_tap wr_dummy_phase_tap_5(.in(reg5_wr_phase_signal[31:0]), 
      .out(reg5_data_signal[31:0]));
  primitives__structural_tap wr_dummy_phase_tap_6(.in(reg6_wr_phase_signal[31:0]), 
      .out(reg6_data_signal[31:0]));
  primitives__structural_tap wr_dummy_phase_tap_7(.in(reg7_wr_phase_signal[31:0]), 
      .out(reg7_data_signal[31:0]));
  primitives__structural_tap wr_dummy_tap_0(.in(reg0_word_line[31:0]), 
      .out(reg0_data_signal[31:0]));
  primitives__structural_tap wr_dummy_tap_1(.in(reg1_word_line[31:0]), 
      .out(reg1_data_signal[31:0]));
  primitives__structural_tap wr_dummy_tap_2(.in(reg2_word_line[31:0]), 
      .out(reg2_data_signal[31:0]));
  primitives__structural_tap wr_dummy_tap_3(.in(reg3_word_line[31:0]), 
      .out(reg3_data_signal[31:0]));
  primitives__structural_tap wr_dummy_tap_4(.in(reg4_word_line[31:0]), 
      .out(reg4_data_signal[31:0]));
  primitives__structural_tap wr_dummy_tap_5(.in(reg5_word_line[31:0]), 
      .out(reg5_data_signal[31:0]));
  primitives__structural_tap wr_dummy_tap_6(.in(reg6_word_line[31:0]), 
      .out(reg6_data_signal[31:0]));
  primitives__structural_tap wr_dummy_tap_7(.in(reg7_word_line[31:0]), 
      .out(reg7_data_signal[31:0]));
  primitives__structural_tap wr_dummy_wave_tap_0(.in(reg0_wr_wave_signal[31:0]), 
      .out(reg0_data_signal[31:0]));
  primitives__structural_tap wr_dummy_wave_tap_1(.in(reg1_wr_wave_signal[31:0]), 
      .out(reg1_data_signal[31:0]));
  primitives__structural_tap wr_dummy_wave_tap_2(.in(reg2_wr_wave_signal[31:0]), 
      .out(reg2_data_signal[31:0]));
  primitives__structural_tap wr_dummy_wave_tap_3(.in(reg3_wr_wave_signal[31:0]), 
      .out(reg3_data_signal[31:0]));
  primitives__structural_tap wr_dummy_wave_tap_4(.in(reg4_wr_wave_signal[31:0]), 
      .out(reg4_data_signal[31:0]));
  primitives__structural_tap wr_dummy_wave_tap_5(.in(reg5_wr_wave_signal[31:0]), 
      .out(reg5_data_signal[31:0]));
  primitives__structural_tap wr_dummy_wave_tap_6(.in(reg6_wr_wave_signal[31:0]), 
      .out(reg6_data_signal[31:0]));
  primitives__structural_tap wr_dummy_wave_tap_7(.in(reg7_wr_wave_partition_signal[31:0]), 
      .out(reg7_data_signal[31:0]));
  primitives__structural_tap wr_wave_partition_tap_0(.in(net_286[31:0]), 
      .out(reg0_wr_wave_partition_signal[31:0]));
  primitives__structural_tap wr_wave_partition_tap_1(.in(net_286[31:0]), 
      .out(reg1_wr_wave_partition_signal[31:0]));
  primitives__structural_tap wr_wave_partition_tap_2(.in(net_286[31:0]), 
      .out(reg2_wr_wave_partition_signal[31:0]));
  primitives__structural_tap wr_wave_partition_tap_3(.in(net_286[31:0]), 
      .out(reg3_wr_wave_partition_signal[31:0]));
  primitives__structural_tap wr_wave_partition_tap_4(.in(net_286[31:0]), 
      .out(reg4_wr_wave_partition_signal[31:0]));
  primitives__structural_tap wr_wave_partition_tap_5(.in(net_286[31:0]), 
      .out(reg5_wr_wave_partition_signal[31:0]));
  primitives__structural_tap wr_wave_partition_tap_6(.in(net_286[31:0]), 
      .out(reg6_wr_wave_partition_signal[31:0]));
  primitives__structural_tap wr_wave_partition_tap_7(.in(net_286[31:0]), 
      .out(reg7_wr_wave_partition_signal[31:0]));
endmodule   /* cells__regfile8_r4_w1_cydra_c1 */

module primitives__register(D, Q);
  /* user-specified Verilog parameters */
  parameter isIC=0;
  parameter isCore=0;
  parameter real JOULES_PER_BIT = 1.0;
  parameter real JOULES_PER_CLK = 1.0;
  parameter real STATIC_POWER = 1.0;
  parameter real DELAY = 1.0;
  parameter PWR_MODEL = "none";
  parameter debug = 0;
  parameter isMonitored = 0;
  localparam PWR_DOMAIN = isIC ? `IC : isCore ? `CLUSTER : 0;
  localparam INIT_VAL=32'h0;

  input [31:0] D;
  output [31:0] Q;

  /* user-specified Verilog declarations */
  reg [32-1:0] Q_int;
  wire                       clk;
  wire                       rst_n;
  reg [32-1:0] old_Q;
  reg [31:0] Q_tx_cnt, Q_bit_tx_cnt;

  /* user-specified Verilog code */
  // Hook up global signals
  assign                     clk = glbl.clk;
  assign                     rst_n = glbl.rst_n;
  assign #(DELAY) Q = Q_int;
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      Q_int <= INIT_VAL;
    end else begin
      Q_int <= D;
      if(debug) begin
        $display("[@%5d]<%d> %m registered d=%x q=%x", $time, glbl.ctx, D, Q);
      end
    end
  end
  `ifdef SELECTIVE_MONITORING
  initial begin
    if(isMonitored) begin
      $dumpvars(0, Q);
    end
  end
  `endif
  
  `ifdef POWER_SIM
  `include "monitor_dpg_signal.v"
  
  always @(Q, rst_n) begin
    if(rst_n && (isIC || isCore)) begin
      monitor_dpg_signal(Q, old_Q, Q_tx_cnt, Q_bit_tx_cnt);
  //    $display("[@%5d]<%d> %m Q=%x old_Q=%x Q_tx_cnt=%x Q_bit_tx_cnt=%x", $time, glbl.ctx, Q, old_Q, Q_tx_cnt, Q_bit_tx_cnt);
      old_Q = Q;
    end else begin
      Q_tx_cnt = 0;
      Q_bit_tx_cnt = 0;
      old_Q = 0;
    end
  end
  
  initial begin
    if(isIC || isCore) begin
      $cgra_hybrid_monitor(PWR_DOMAIN, PWR_MODEL, `PLI_MODE_IS_CLOCKED, Q_tx_cnt, Q_bit_tx_cnt);
    end
  end
  `endif

  /* automatically generated Verilog */
endmodule   /* primitives__register */

module cells__shiftRegister0x1(in, out);
  /* user-specified Verilog parameters */
  parameter configured=0;
  parameter debug=0;
  parameter isCore=0;
  localparam DPG_WIDTH=32;
  localparam wordsize=32;
  localparam isActive = configured;
  localparam NUM_REGISTERS = 1;
  localparam INIT_VAL=32'h0;
  // Power paramters for the registers
  parameter real REGISTER_JOULES_PER_BIT = 1.0;
  parameter real REGISTER_JOULES_PER_CLK = 1.0;
  parameter real REGISTER_JOULES_PER_INACTIVE_CLK = 1.0;
  parameter real REGISTER_STATIC_POWER = 1.0;
  parameter real REGISTER_DELAY = 1.0;
  parameter REGISTER_PWR_MODEL = "none";
  // Power paramters for the mux
  parameter real MUX_JOULES_PER_BIT = 1.0;
  parameter real MUX_JOULES_PER_CFG = 1.0;
  parameter real MUX_CFG_SRAM_POWER = 1.0;
  parameter real MUX_STATIC_POWER = 1.0;
  parameter real MUX_DELAY = 1.0;
  parameter MUX_PWR_MODEL = "none";

  input [31:0] in;
  output [31:0] out;

  trireg [31:0] clk_en0;
  trireg [31:0] reg0_data_signal;
  trireg [31:0] reg0_q_signal;
  trireg [31:0] wr_0_shift_enable_signal;

  /* user-specified Verilog declarations */
  wire clk, rst_n, init;
  wire shift_enable;
  wire [1:0] shift, hold;

  /* user-specified Verilog code */
  assign clk = glbl.clk;
  assign rst_n = glbl.rst_n;
  assign init = glbl.init;
  assign shift_enable = wr_tap_0.cmd;
  assign reg0_data_signal = in;
  assign clk_en0 = wr_tap_0.cmd;
  // Check the register write and feedback taps for invalid permutations
  assign shift = {wr_tap_0.cmd};
  assign hold = {feedback_tap_0.cmd};
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
    end else begin
      if(debug && shift != 0 && hold != 0) begin
        $display("[@%5d]<%d> %m has a shift and hold violation %b <=> %b", $time, glbl.ctx, shift, hold);
      end
      if(debug && (in || out || shift_enable)) begin
        $display("[@%5d]<%d> %m input=%x and output=%x and shift_enable=%b", $time, glbl.ctx, in, out, shift_enable);
      end
    end
  end

  /* automatically generated Verilog */
  primitives__structural_tap dummy_wr_tap_0(.in(wr_0_shift_enable_signal[31:0]), 
      .out(reg0_data_signal[31:0]));
  primitives__structural_tap feedback_tap_0(.in(reg0_q_signal[31:0]), 
      .out(reg0_data_signal[31:0]));
  /* begin Verilog_defparam for cells:mux2{sch} */
  defparam mux2_0.isCore = isCore;
  defparam mux2_0.JOULES_PER_BIT = MUX_JOULES_PER_BIT;
  defparam mux2_0.JOULES_PER_CFG = MUX_JOULES_PER_CFG;
  defparam mux2_0.STATIC_POWER = MUX_STATIC_POWER;
  defparam mux2_0.CFG_SRAM_POWER = MUX_CFG_SRAM_POWER;
  defparam mux2_0.DELAY = MUX_DELAY;
  defparam mux2_0.PWR_MODEL = MUX_PWR_MODEL;
  // end Verilog_defparam
  cells__mux2 mux2_0(.in00(reg0_q_signal[31:0]), .in01(in[31:0]), .out(out[31:0]));
  /* begin Verilog_defparam for primitives:pipe{sch} */
  defparam pipe_0.JOULES_PER_BIT = REGISTER_JOULES_PER_BIT;
  defparam pipe_0.JOULES_PER_CLK = REGISTER_JOULES_PER_CLK;
  defparam pipe_0.JOULES_PER_INACTIVE_CLK = REGISTER_JOULES_PER_INACTIVE_CLK;
  defparam pipe_0.STATIC_POWER = REGISTER_STATIC_POWER;
  defparam pipe_0.DELAY = REGISTER_DELAY;
  defparam pipe_0.PWR_MODEL = REGISTER_PWR_MODEL;
  defparam pipe_0.isCore = isCore;
  // end Verilog_defparam
  primitives__pipe pipe_0(.D(reg0_data_signal[31:0]), .clk_gate_(clk_en0[31:0]), 
      .Q(reg0_q_signal[31:0]));
  primitives__structural_tap wr_tap_0(.in(in[31:0]), .out(wr_0_shift_enable_signal[31:0]));
endmodule   /* cells__shiftRegister0x1 */
  /* user-specified Verilog external code */
  `ifndef OP_OFF
  `define OP_OFF    8'h00
  `endif
  `ifndef OP_MUL
  `define OP_MUL    8'h05
  `endif


module primitives__MADD(A, B, C, R);
  /* user-specified Verilog parameters */
  localparam DPG_WIDTH=32;
  localparam CONFIG_WORD_SIZE=9;
  parameter HOLD_LAST_RESULT=1;
  parameter debug=0;
  parameter configured=0;
  parameter real DELAY = 5;

  input [31:0] A;
  input [31:0] B;
  input [31:0] C;
  output [31:0] R;

  /* user-specified Verilog declarations */
  // Indicated that the ALU performs signed arithmetic
  wire signed [DPG_WIDTH-1:0] A, B, C, R;
  reg signed [DPG_WIDTH-1:0] prevR, tmpR;
  reg [CONFIG_WORD_SIZE-1:0] prevCmd;
  wire [CONFIG_WORD_SIZE-1:0] tmpCmd;
  wire                             rdy, rst_n, clk;
  wire                             hold_result, hold_cmd;
  wire [CONFIG_WORD_SIZE-1:0] cmd;
  defparam              ctrl.CONFIG_WORD_SIZE=CONFIG_WORD_SIZE;
  defparam              ctrl.configured = configured;
  dpg_controller ctrl(.cmd(cmd));
  assign rdy = glbl.rdy;
  assign rst_n = glbl.rst_n;
  assign clk = configured == 1 ? glbl.clk : 0;

  /* user-specified Verilog code */
  // Either hold the last result, or hold the last alu command
  assign hold_result = HOLD_LAST_RESULT && (!rdy || cmd == `OP_OFF);
  assign #(DELAY) R = hold_result ? prevR : tmpR;
  assign hold_cmd = rdy && cmd == `OP_OFF && !HOLD_LAST_RESULT;
  assign tmpCmd = hold_cmd ? prevCmd : cmd;
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      prevR <= 0;
      prevCmd <= 0;
    end else begin
      if(rdy && cmd != `OP_OFF) begin
        if(debug) begin
          $display("[@%5d]<%d> %m executed op=%d : a=%x b=%x r=%x", $time, glbl.ctx, cmd, A, B, R);
        end
        prevR <= tmpR;
        prevCmd <= cmd;
      end
    end
  end
  
  always @(*) begin
    tmpR = {DPG_WIDTH{1'bz}};
    if(rdy) begin
      case(tmpCmd)
        `OP_OFF: begin
          tmpR = {DPG_WIDTH{1'bz}};
        end
        `OP_MUL: tmpR = A * B;
        default: tmpR = A * B;
      endcase
    end
  //`ifdef POWER_SIM
  //  if(rdy && cmd != `OP_OFF) begin
  //    $pe_monitor(A, B);
  //  end
  //`endif
  end

  /* automatically generated Verilog */
endmodule   /* primitives__MADD */
  /* user-specified Verilog external code */
  `ifndef OP_OFF
  `define OP_OFF    8'h00
  `endif
  `ifndef OP_ZERO
  `define OP_ZERO   8'h01
  `endif
  `ifndef OP_ONE
  `define OP_ONE    8'h02
  `endif
  // Arithmetic Ops
  `ifndef OP_ADD
  `define OP_ADD    8'h03
  `endif
  `ifndef OP_SUB
  `define OP_SUB    8'h04
  `endif
  `ifndef OP_MUL
  `define OP_MUL    8'h05
  `endif
  `ifndef OP_DIV
  `define OP_DIV    8'h06
  `endif
  `ifndef OP_MOD
  `define OP_MOD    8'h07
  `endif
  `ifndef OP_SHR
  `define OP_SHR    8'h08
  `endif
  `ifndef OP_SHL
  `define OP_SHL    8'h09
  `endif
  `ifndef OP_ASHR
  `define OP_ASHR   8'h0a
  `endif
  `ifndef OP_ASHL
  `define OP_ASHL   8'h0b
  `endif
  `ifndef OP_NEGA
  `define OP_NEGA   8'h0c
  `endif
  `ifndef OP_NEGB
  `define OP_NEGB   8'h0d
  `endif
  // Comparison Ops
  `ifndef OP_LT
  `define OP_LT     8'h0e
  `endif
  `ifndef OP_LTE
  `define OP_LTE    8'h0f
  `endif
  `ifndef OP_GT
  `define OP_GT     8'h10
  `endif
  `ifndef OP_GTE
  `define OP_GTE    8'h11
  `endif
  `ifndef OP_EQ
  `define OP_EQ     8'h12
  `endif
  `ifndef OP_NEQ
  `define OP_NEQ    8'h13
  `endif
  // Logic Ops
  `ifndef OP_LNOTA
  `define OP_LNOTA  8'h14
  `endif
  `ifndef OP_LNOTB
  `define OP_LNOTB  8'h15
  `endif
  `ifndef OP_LOR
  `define OP_LOR    8'h16
  `endif
  `ifndef OP_LAND
  `define OP_LAND   8'h17
  `endif
  `ifndef OP_PASS_A
  `define OP_PASS_A 8'h18
  `endif
  `ifndef OP_PASS_B
  `define OP_PASS_B 8'h19
  `endif
  `ifndef OP_SELECT
  `define OP_SELECT 8'h1a
  `endif
  // Bitwise Ops
  `ifndef OP_NOTA
  `define OP_NOTA   8'h1b
  `endif
  `ifndef OP_NOTB
  `define OP_NOTB   8'h1c
  `endif
  `ifndef OP_AND
  `define OP_AND    8'h1d
  `endif
  `ifndef OP_OR
  `define OP_OR     8'h1e
  `endif
  `ifndef OP_XOR
  `define OP_XOR    8'h1f
  `endif
  // For specialized opcodes with immediate operands, use normal opcode tables
  // Encoding for ops with immediates:
  // 5 bits for primary opcode
  // 1 bit if B operand is immediate
  // 1 bit for B immediate value
  // 1 bit if A operand is immediate
  // 1 bit for A immediate value
  // bits[4:0] -> primary opcodes
  // bit[5] = 0 / 1 -> B immediate value
  // bit[6] = 1 -> B operand is immediate bit 5
  // bit[7] = 0 / 1 -> A immediate value
  // bit[8] = 1 -> A operand is immediate bit 7
  // Compare A with Zero
  `ifndef OP_EQ_0vsB
  `define OP_EQ_0vsB 9'h100 + `OP_EQ
  `endif
  `ifndef OP_NEQ_0vsB
  `define OP_NEQ_0vsB 9'h100 + `OP_NEQ
  `endif
  `ifndef OP_GT_0vsB
  `define OP_GT_0vsB 9'h100 + `OP_GT
  `endif
  `ifndef OP_GTE_0vsB
  `define OP_GTE_0vsB 9'h100 + `OP_GTE
  `endif
  `ifndef OP_LTE_0vsB
  `define OP_LTE_0vsB 9'h100 + `OP_LTE
  `endif
  `ifndef OP_LT_0vsB
  `define OP_LT_0vsB 9'h100 + `OP_LT
  `endif
  // Compare A with One
  `ifndef OP_EQ_1vsB
  `define OP_EQ_1vsB 9'h180 + `OP_EQ
  `endif
  `ifndef OP_NEQ_1vsB
  `define OP_NEQ_1vsB 9'h180 + `OP_NEQ
  `endif
  `ifndef OP_GT_1vsB
  `define OP_GT_1vsB 9'h180 + `OP_GT
  `endif
  `ifndef OP_GTE_1vsB
  `define OP_GTE_1vsB 9'h180 + `OP_GTE
  `endif
  `ifndef OP_LTE_1vsB
  `define OP_LTE_1vsB 9'h180 + `OP_LTE
  `endif
  `ifndef OP_LT_1vsB
  `define OP_LT_1vsB 9'h180 + `OP_LT
  `endif
  // Compare B with Zero
  `ifndef OP_EQ_Avs0
  `define OP_EQ_Avs0 9'h040 + `OP_EQ
  `endif
  `ifndef OP_NEQ_Avs0
  `define OP_NEQ_Avs0 9'h040 + `OP_NEQ
  `endif
  `ifndef OP_GT_Avs0
  `define OP_GT_Avs0 9'h040 + `OP_GT
  `endif
  `ifndef OP_GTE_Avs0
  `define OP_GTE_Avs0 9'h040 + `OP_GTE
  `endif
  `ifndef OP_LTE_Avs0
  `define OP_LTE_Avs0 9'h040 + `OP_LTE
  `endif
  `ifndef OP_LT_Avs0
  `define OP_LT_Avs0 9'h040 + `OP_LT
  `endif
  // Compare B with One
  `ifndef OP_EQ_Avs1
  `define OP_EQ_Avs1 9'h060 + `OP_EQ
  `endif
  `ifndef OP_NEQ_Avs1
  `define OP_NEQ_Avs1 9'h060 + `OP_NEQ
  `endif
  `ifndef OP_GT_Avs1
  `define OP_GT_Avs1 9'h060 + `OP_GT
  `endif
  `ifndef OP_GTE_Avs1
  `define OP_GTE_Avs1 9'h060 + `OP_GTE
  `endif
  `ifndef OP_LTE_Avs1
  `define OP_LTE_Avs1 9'h060 + `OP_LTE
  `endif
  `ifndef OP_LT_Avs1
  `define OP_LT_Avs1 9'h060 + `OP_LT
  `endif
  // ALU with Immediate B
  `ifndef OP_INC_A
  `define OP_INC_A 9'h060 + `OP_ADD
  `endif
  `ifndef OP_DEC_A
  `define OP_DEC_A 9'h060 + `OP_SUB
  `endif
  // For shift operations, don't use the normal opcode
  // encoding conventions, just use the upper 4 bits
  // as immediate values
  `ifndef OP_ASHR_Aby1
  `define OP_ASHR_Aby1 9'h020 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby2
  `define OP_ASHR_Aby2 9'h040 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby3
  `define OP_ASHR_Aby3 9'h060 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby4
  `define OP_ASHR_Aby4 9'h080 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby5
  `define OP_ASHR_Aby5 9'h0a0 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby6
  `define OP_ASHR_Aby6 9'h0c0 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby7
  `define OP_ASHR_Aby7 9'h0e0 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby8
  `define OP_ASHR_Aby8 9'h100 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Ab
  `define OP_ASHR_Aby9 9'h120 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby10
  `define OP_ASHR_Aby10 9'h140 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby11
  `define OP_ASHR_Aby11 9'h160 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby12
  `define OP_ASHR_Aby12 9'h180 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby13
  `define OP_ASHR_Aby13 9'h1a0 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby14
  `define OP_ASHR_Aby14 9'h1c0 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby15
  `define OP_ASHR_Aby15 9'h1e0 + `OP_ASHR
  `endif
  // ALU with Immediate A
  `ifndef OP_INC_B
  `define OP_INC_B 9'h180 + `OP_ADD
  `endif
  `ifndef OP_DEC_B
  `define OP_DEC_B 9'h180 + `OP_SUB
  `endif
  // Select with Immediate
  `ifndef OP_SELECT_Aor0
  `define OP_SELECT_Aor0 9'h040 + `OP_SELECT
  `endif
  `ifndef OP_SELECT_Aor1
  `define OP_SELECT_Aor1 9'h060 + `OP_SELECT
  `endif
  `ifndef OP_SELECT_0orB
  `define OP_SELECT_0orB 9'h100 + `OP_SELECT
  `endif
  `ifndef OP_SELECT_1orB
  `define OP_SELECT_1orB 9'h180 + `OP_SELECT
  `endif
  `ifndef OP_SELECT_0or1
  `define OP_SELECT_0or1 9'h160 + `OP_SELECT
  `endif
  `ifndef OP_SELECT_1or0
  `define OP_SELECT_1or0 9'h1c0 + `OP_SELECT
  `endif


module primitives__alu(A, B, S, F, R);
  /* user-specified Verilog parameters */
  localparam DPG_WIDTH=32;
  localparam CPG_WIDTH=32;
  localparam CONFIG_WORD_SIZE=9;
  parameter HOLD_LAST_RESULT=1;
  parameter debug=0;
  parameter configured=0;
  parameter real DELAY = 5.0;
  parameter PWR_MODEL = "none";
  localparam PLI_MODE = `PLI_MODE_DEVICE_CAN_BE_SCHEDULED | (configured ? `PLI_MODE_DEFAULT : `PLI_MODE_DEVICE_IS_DISABLED);

  input [31:0] A;
  input [31:0] B;
  input [31:0] S;
  output [31:0] F;
  output [31:0] R;

  /* user-specified Verilog declarations */
  // Indicated that the ALU performs signed arithmetic
  wire signed [DPG_WIDTH-1:0] A, B, R;
  wire signed [CPG_WIDTH-1:0] S, F;
  reg signed [DPG_WIDTH-1:0] prevR, tmpR;
  reg signed [CPG_WIDTH-1:0] prevF, tmpF;
  reg [CONFIG_WORD_SIZE-1:0] prevCmd;
  wire [CONFIG_WORD_SIZE-1:0] tmpCmd;
  wire                             rdy, rst_n, clk;
  wire                             hold_result, hold_cmd;
  wire [CONFIG_WORD_SIZE-1:0] cmd;
  reg signed [DPG_WIDTH-1:0] prevA, prevB;
  reg [31:0]	A_tx_cnt, A_bit_tx_cnt;
  reg [31:0]	B_tx_cnt, B_bit_tx_cnt;
  reg [31:0]	R_tx_cnt, R_bit_tx_cnt;
  reg [63:0] 	e;
  reg	c;
  real	alu_energy;
  
  defparam              ctrl.CONFIG_WORD_SIZE=CONFIG_WORD_SIZE;
  defparam              ctrl.configured = configured;
  dpg_controller ctrl(.cmd(cmd));
  assign rdy = glbl.rdy;
  assign rst_n = glbl.rst_n;
  assign clk = configured == 1 ? glbl.clk : 0;

  /* user-specified Verilog code */
  // Either hold the last result, or hold the last alu command
  assign hold_result = HOLD_LAST_RESULT && (!rdy || cmd == `OP_OFF);
  assign #(DELAY) R = hold_result ? prevR : tmpR;
  assign #(DELAY) F = hold_result ? prevF : tmpF;
  assign hold_cmd = rdy && cmd == `OP_OFF && !HOLD_LAST_RESULT;
  assign tmpCmd = hold_cmd ? prevCmd : cmd;
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      prevR <= 0;
      prevF <= 0;
      prevCmd <= 0;
      prevA <= 0;
      prevB <= 0;	 
    end else begin
      if(rdy && cmd != `OP_OFF) begin
        if(debug) begin
          $display("[@%5d]<%d> %m executed op=%d : a=%x b=%x s=%x r=%x", $time, glbl.ctx, cmd, A, B, S, R);
        end
        prevR <= tmpR;
        prevF <= tmpF;
        prevCmd <= cmd;
        prevA <= A;
        prevB <= B;
      end
    end
  end
  
  initial begin
    alu_energy = 0;      
  end
    
  always @(*) begin
    tmpR = {DPG_WIDTH{1'bz}};
    tmpF = {CPG_WIDTH{1'bz}};
    if(rdy) begin
      case(tmpCmd)
        `OP_OFF: begin
          tmpR = {DPG_WIDTH{1'bz}};
          tmpF = {CPG_WIDTH{1'bz}};
        end
        `OP_ZERO: tmpR = 0;
        `OP_ONE: tmpR = 0;
        // Arithmetic Ops
        `OP_ADD: tmpR = A + B;
        `OP_SUB: tmpR = A - B;
        `OP_MUL: tmpR = A * B;
        `OP_DIV: begin tmpR = B == 0 ? 32'hDEADBEEF : A / B; end
        `OP_MOD: tmpR = A % B;
        `OP_SHR: tmpR = A >> B;
        `OP_SHL: tmpR = A << B;
        `OP_ASHR: tmpR = A >>> B;
        `OP_ASHL: tmpR = A <<< B;
        `OP_NEGA: tmpR = -A;
        `OP_NEGB: tmpR = -B;
        // Comparison Ops
        `OP_LT: begin tmpF = A < B ? 1 : 0; tmpR = tmpF; end
        `OP_LTE: begin tmpF = A <= B ? 1 : 0; tmpR = tmpF; end
        `OP_GT: begin tmpF = A > B ? 1 : 0; tmpR = tmpF; end
        `OP_GTE: begin tmpF = A >= B ? 1 : 0; tmpR = tmpF; end
        `OP_EQ: begin tmpF = A == B ? 1 : 0; tmpR = tmpF; end
        `OP_NEQ: begin tmpF = A != B ? 1 : 0; tmpR = tmpF; end
        // Logic Ops
        `OP_LNOTA: begin tmpF = !A; tmpR = tmpF; end
        `OP_LNOTB: begin tmpF = !B; tmpR = tmpF; end
        `OP_LAND: begin tmpF = A && B; tmpR = tmpF; end
        `OP_LOR: begin tmpF = A || B; tmpR = tmpF; end
        `OP_PASS_A: tmpR = A;
        `OP_PASS_B: tmpR = B;
        `OP_SELECT: tmpR = S ? B : A;
        // Bitwise Ops
        `OP_NOTA: tmpR = ~A;
        `OP_NOTB: tmpR = ~B;
        `OP_AND: tmpR = A & B;
        `OP_OR: tmpR = A | B;
        `OP_XOR: tmpR = A ^ B;
        // Immediate Comparison Ops
        `OP_LT_0vsB: begin tmpF = 0 < B ? 1 : 0; tmpR = tmpF; end
        `OP_LTE_0vsB: begin tmpF = 0 <= B ? 1 : 0; tmpR = tmpF; end
        `OP_GT_0vsB: begin tmpF = 0 > B ? 1 : 0; tmpR = tmpF; end
        `OP_GTE_0vsB: begin tmpF = 0 >= B ? 1 : 0; tmpR = tmpF; end
        `OP_EQ_0vsB: begin tmpF = 0 == B ? 1 : 0; tmpR = tmpF; end
        `OP_NEQ_0vsB: begin tmpF = 0 != B ? 1 : 0; tmpR = tmpF; end
        `OP_LT_1vsB: begin tmpF = 1 < B ? 1 : 0; tmpR = tmpF; end
        `OP_LTE_1vsB: begin tmpF = 1 <= B ? 1 : 0; tmpR = tmpF; end
        `OP_GT_1vsB: begin tmpF = 1 > B ? 1 : 0; tmpR = tmpF; end
        `OP_GTE_1vsB: begin tmpF = 1 >= B ? 1 : 0; tmpR = tmpF; end
        `OP_EQ_1vsB: begin tmpF = 1 == B ? 1 : 0; tmpR = tmpF; end
        `OP_NEQ_1vsB: begin tmpF = 1 != B ? 1 : 0; tmpR = tmpF; end
        `OP_LT_Avs0: begin tmpF = A < 0 ? 1 : 0; tmpR = tmpF; end
        `OP_LTE_Avs0: begin tmpF = A <= 0 ? 1 : 0; tmpR = tmpF; end
        `OP_GT_Avs0: begin tmpF = A > 0 ? 1 : 0; tmpR = tmpF; end
        `OP_GTE_Avs0: begin tmpF = A >= 0 ? 1 : 0; tmpR = tmpF; end
        `OP_EQ_Avs0: begin tmpF = A == 0 ? 1 : 0; tmpR = tmpF; end
        `OP_NEQ_Avs0: begin tmpF = A != 0 ? 1 : 0; tmpR = tmpF; end
        `OP_LT_Avs1: begin tmpF = A < 1 ? 1 : 0; tmpR = tmpF; end
        `OP_LTE_Avs1: begin tmpF = A <= 1 ? 1 : 0; tmpR = tmpF; end
        `OP_GT_Avs1: begin tmpF = A > 1 ? 1 : 0; tmpR = tmpF; end
        `OP_GTE_Avs1: begin tmpF = A >= 1 ? 1 : 0; tmpR = tmpF; end
        `OP_EQ_Avs1: begin tmpF = A == 1 ? 1 : 0; tmpR = tmpF; end
        `OP_NEQ_Avs1: begin tmpF = A != 1 ? 1 : 0; tmpR = tmpF; end
        // Immediate Arithmetic Ops
        `OP_INC_A: tmpR = A + 1;
        `OP_DEC_A: tmpR = A - 1;
        `OP_INC_B: tmpR = 1 + B;
        `OP_DEC_B: tmpR = 1 - B;
        `OP_ASHR_Aby1: tmpR = A >>> 1;
        `OP_ASHR_Aby2: tmpR = A >>> 2;
        `OP_ASHR_Aby3: tmpR = A >>> 3;
        `OP_ASHR_Aby4: tmpR = A >>> 4;
        `OP_ASHR_Aby5: tmpR = A >>> 5;
        `OP_ASHR_Aby6: tmpR = A >>> 6;
        `OP_ASHR_Aby7: tmpR = A >>> 7;
        `OP_ASHR_Aby8: tmpR = A >>> 8;
        `OP_ASHR_Aby9: tmpR = A >>> 9;
        `OP_ASHR_Aby10: tmpR = A >>> 10;
        `OP_ASHR_Aby11: tmpR = A >>> 11;
        `OP_ASHR_Aby12: tmpR = A >>> 12;
        `OP_ASHR_Aby13: tmpR = A >>> 13;
        `OP_ASHR_Aby14: tmpR = A >>> 14;
        `OP_ASHR_Aby15: tmpR = A >>> 15;
        // Select with immediate
        `OP_SELECT_Aor0: tmpR = S ? 0 : A;
        `OP_SELECT_Aor1: tmpR = S ? 1 : A;
        `OP_SELECT_0orB: tmpR = S ? B : 0;
        `OP_SELECT_1orB: tmpR = S ? B : 1;
        `OP_SELECT_0or1: tmpR = S ? 1 : 0;
        `OP_SELECT_1or0: tmpR = S ? 0 : 1;
        default: tmpR = A;
      endcase
    end
  `ifdef POWER_SIM
    if(rdy && cmd != `OP_OFF) begin
      A_bit_tx_cnt = hamming_distance(A, prevA);
  //      $display("@[%5d] %m a=%x prevA=%x bit=%d", $time, A, prevA, A_bit_tx_cnt);
      B_bit_tx_cnt = hamming_distance(B, prevB);
      R_bit_tx_cnt = hamming_distance(tmpR, prevR);
      fu.lookup_energy(tmpCmd, A_bit_tx_cnt, B_bit_tx_cnt, R_bit_tx_cnt, e, c);
      alu_energy = alu_energy + $bitstoreal(e);      
  //      $display("@[%5d] %m opcode=%d a=%x b=%x r=%x e=%x(%e) c=%d energy=%e", $time, tmpCmd, A_bit_tx_cnt, B_bit_tx_cnt, R_bit_tx_cnt, e, $bitstoreal(e), c, alu_energy);
      if(c == 0) begin
        fu.record_pattern(tmpCmd, A, prevA, B, prevB, tmpR, prevR);
      end
    end
  `endif
  end
  
  `ifdef POWER_SIM
    `include "hamming_distance.v"
  /*
    initial begin                                                                                                                                                                                           
      $cgra_hybrid_fu_monitor(`CLUSTER, PWR_MODEL, PLI_MODE, alu_energy);                                                                                                         
    end
  */
  `endif

  /* automatically generated Verilog */
endmodule   /* primitives__alu */
  /* user-specified Verilog external code */
  `ifndef OP_OFF
  `define OP_OFF    8'h00
  `endif
  `ifndef OP_SHR
  `define OP_SHR    8'h08
  `endif
  `ifndef OP_SHL
  `define OP_SHL    8'h09
  `endif
  `ifndef OP_ASHR
  `define OP_ASHR   8'h0a
  `endif
  `ifndef OP_ASHL
  `define OP_ASHL   8'h0b
  `endif
  // For shift operations, don't use the normal opcode
  // encoding conventions, just use the upper 4 bits
  // as immediate values
  `ifndef OP_ASHR_Aby1
  `define OP_ASHR_Aby1 9'h020 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby2
  `define OP_ASHR_Aby2 9'h040 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby3
  `define OP_ASHR_Aby3 9'h060 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby4
  `define OP_ASHR_Aby4 9'h080 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby5
  `define OP_ASHR_Aby5 9'h0a0 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby6
  `define OP_ASHR_Aby6 9'h0c0 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby7
  `define OP_ASHR_Aby7 9'h0e0 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby8
  `define OP_ASHR_Aby8 9'h100 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Ab
  `define OP_ASHR_Aby9 9'h120 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby10
  `define OP_ASHR_Aby10 9'h140 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby11
  `define OP_ASHR_Aby11 9'h160 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby12
  `define OP_ASHR_Aby12 9'h180 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby13
  `define OP_ASHR_Aby13 9'h1a0 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby14
  `define OP_ASHR_Aby14 9'h1c0 + `OP_ASHR
  `endif
  `ifndef OP_ASHR_Aby15
  `define OP_ASHR_Aby15 9'h1e0 + `OP_ASHR
  `endif


module primitives__shifter(A, B, R);
  /* user-specified Verilog parameters */
  localparam DPG_WIDTH=32;
  localparam CONFIG_WORD_SIZE=9;
  parameter HOLD_LAST_RESULT=1;
  parameter debug=0;
  parameter configured=0;
  parameter real DELAY = 5;

  input [31:0] A;
  input [31:0] B;
  output [31:0] R;

  /* user-specified Verilog declarations */
  // Indicated that the ALU performs signed arithmetic
  wire signed [DPG_WIDTH-1:0] A, B, C, R;
  reg signed [DPG_WIDTH-1:0] prevR, tmpR;
  reg [CONFIG_WORD_SIZE-1:0] prevCmd;
  wire [CONFIG_WORD_SIZE-1:0] tmpCmd;
  wire                             rdy, rst_n, clk;
  wire                             hold_result, hold_cmd;
  wire [CONFIG_WORD_SIZE-1:0] cmd;
  defparam              ctrl.CONFIG_WORD_SIZE=CONFIG_WORD_SIZE;
  defparam              ctrl.configured = configured;
  dpg_controller ctrl(.cmd(cmd));
  assign rdy = glbl.rdy;
  assign rst_n = glbl.rst_n;
  assign clk = configured == 1 ? glbl.clk : 0;

  /* user-specified Verilog code */
  // Either hold the last result, or hold the last alu command
  assign hold_result = HOLD_LAST_RESULT && (!rdy || cmd == `OP_OFF);
  assign #(DELAY) R = hold_result ? prevR : tmpR;
  assign hold_cmd = rdy && cmd == `OP_OFF && !HOLD_LAST_RESULT;
  assign tmpCmd = hold_cmd ? prevCmd : cmd;
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      prevR <= 0;
      prevCmd <= 0;
    end else begin
      if(rdy && cmd != `OP_OFF) begin
        if(debug) begin
          $display("[@%5d]<%d> %m executed op=%d : a=%x b=%x r=%x", $time, glbl.ctx, cmd, A, B, R);
        end
        prevR <= tmpR;
        prevCmd <= cmd;
      end
    end
  end
  
  always @(*) begin
    tmpR = {DPG_WIDTH{1'bz}};
    if(rdy) begin
      // Mask off the upper bits, which encode immediate values
      case(tmpCmd)
        `OP_OFF: begin
          tmpR = {DPG_WIDTH{1'bz}};
        end
        `OP_SHR: tmpR = A >> B;
        `OP_SHL: tmpR = A << B;
        `OP_ASHR: tmpR = A >>> B;
        `OP_ASHL: tmpR = A <<< B;
        // Immediate Arithmetic Ops
        `OP_ASHR_Aby1: tmpR = A >>> 1;
        `OP_ASHR_Aby2: tmpR = A >>> 2;
        `OP_ASHR_Aby3: tmpR = A >>> 3;
        `OP_ASHR_Aby4: tmpR = A >>> 4;
        `OP_ASHR_Aby5: tmpR = A >>> 5;
        `OP_ASHR_Aby6: tmpR = A >>> 6;
        `OP_ASHR_Aby7: tmpR = A >>> 7;
        `OP_ASHR_Aby8: tmpR = A >>> 8;
        `OP_ASHR_Aby9: tmpR = A >>> 9;
        `OP_ASHR_Aby10: tmpR = A >>> 10;
        `OP_ASHR_Aby11: tmpR = A >>> 11;
        `OP_ASHR_Aby12: tmpR = A >>> 12;
        `OP_ASHR_Aby13: tmpR = A >>> 13;
        `OP_ASHR_Aby14: tmpR = A >>> 14;
        `OP_ASHR_Aby15: tmpR = A >>> 15;
        default: tmpR = A;
      endcase
    end
  //`ifdef POWER_SIM
  //  if(rdy && cmd != `OP_OFF) begin
  //    $pe_monitor(A, B);
  //  end
  //`endif
  end

  /* automatically generated Verilog */
endmodule   /* primitives__shifter */

module primitives__tap(in, out);
  /* user-specified Verilog parameters */
  parameter II=16;
  parameter muxgrp = "none";
  parameter muxelem = 0;
  parameter configured=0; // 0
  parameter isIC=0;
  parameter real JOULES_PER_BIT = 1.0;
  parameter real JOULES_PER_CFG = 1.0;
  parameter real STATIC_POWER = 1.0;
  localparam wordsize=32;
  parameter isMonitored = 0;
  parameter real DELAY = 0.5;

  input [31:0] in;
  inout [31:0] out;

  /* user-specified Verilog declarations */
  wire                              cmd;
  defparam ctrl.configured = configured;
  dpg_controller ctrl(.cmd(cmd));
  wire                              rdy;

  /* user-specified Verilog code */
  assign                       rdy = glbl.rdy;
  assign #(DELAY)       out = cmd ? in : {wordsize{1'bz}};
  `ifdef POWER_SIM
  `ifdef MONITOR_DISTRIBUTED_MUXES
  always @(*) begin
    if(configured && rdy && isIC) begin
      // Don't predicate based on cmd, or it will miss reconfiguration
      `ifdef SELECTIVE_MONITORING
      if(isMonitored) begin
      `endif
      $cgra_io_monitor(in, out, cmd, `IC, "IC", `PLI_MODE_DEFAULT);
      `ifdef SELECTIVE_MONITORING
      end
      `endif
    end
  end
  `endif
  `endif

  /* automatically generated Verilog */
endmodule   /* primitives__tap */

module primitives__uber_fu(A, B, S, X, Y, F, R);
  input [31:0] A;
  input [31:0] B;
  input [31:0] S;
  input [31:0] X;
  input [31:0] Y;
  output [31:0] F;
  output [31:0] R;

  trireg [31:0] net_65;
  trireg [31:0] net_66;
  trireg [31:0] net_67;

  primitives__MADD MADD_0(.A(X[31:0]), .B(Y[31:0]), .C(B[31:0]), .R(net_67[31:0]));
  primitives__alu alu_0(.A(A[31:0]), .B(B[31:0]), .S(S[31:0]), .F(F[31:0]), .R(net_65[31:0]));
  primitives__shifter shifter_0(.A(A[31:0]), .B(B[31:0]), .R(net_66[31:0]));
  primitives__tap tap_0(.in(net_66[31:0]), .out(R[31:0]));
  primitives__tap tap_1(.in(net_65[31:0]), .out(R[31:0]));
  primitives__tap tap_2(.in(net_67[31:0]), .out(R[31:0]));
endmodule   /* primitives__uber_fu */

module uber_fu_1x8(S, in0, in1, in2, in3, F, Out);
  input [31:0] S;
  input [31:0] in0;
  input [31:0] in1;
  input [31:0] in2;
  input [31:0] in3;
  output [31:0] F;
  output [31:0] Out;

  trireg [31:0] mux4_cpg_0_in03;
  trireg [31:0] net_413;
  trireg [31:0] net_414;
  trireg [31:0] net_446;
  trireg [31:0] net_545;
  trireg [31:0] net_546;
  trireg [31:0] net_575;
  trireg [31:0] net_580;
  trireg [31:0] net_595;
  trireg [31:0] net_598;
  trireg [31:0] net_614;
  trireg [31:0] net_615;
  trireg [31:0] net_628;
  trireg [31:0] net_629;
  trireg [31:0] net_631;
  trireg [31:0] net_632;
  trireg [31:0] net_633;
  trireg [31:0] net_647;
  trireg [31:0] net_649;
  trireg [31:0] net_650;
  trireg [31:0] net_654;
  trireg [31:0] net_655;

  cells_cpg__gatedFlipflop gatedFlipflop_0(.D(net_629[31:0]), .Q(net_614[31:0]));
  cells_cpg__gatedFlipflop gatedFlipflop_1(.D(net_629[31:0]), .Q(F[31:0]));
  cells__gatedRegister gatedRegister_0(.D(net_628[31:0]), .Q(net_575[31:0]));
  cells__gatedRegister gatedRegister_1(.D(net_628[31:0]), .Q(Out[31:0]));
  cells__gatedRegister gatedRegister_2(.D(in2[31:0]), .Q(net_580[31:0]));
  cells__gatedRegister gatedRegister_3(.D(in3[31:0]), .Q(net_615[31:0]));
  cells__mux2 mux2_0(.in00(net_628[31:0]), .in01(in0[31:0]), .out(net_414[31:0]));
  cells_cpg__mux2_cpg mux2_cpg_1(.in00(S[31:0]), .in01(net_629[31:0]), .out(net_413[31:0]));
  cells__mux4 mux4_0(.in00(net_575[31:0]), .in01(net_655[31:0]), .in02(in0[31:0]), 
      .in03(net_446[31:0]), .out(net_631[31:0]));
  cells__mux4 mux4_1(.in00(net_575[31:0]), .in01(net_654[31:0]), .in02(in0[31:0]), 
      .in03(net_446[31:0]), .out(net_632[31:0]));
  cells__mux4 mux4_2(.in00(net_575[31:0]), .in01(net_650[31:0]), .in02(in2[31:0]), 
      .in03(net_580[31:0]), .out(net_595[31:0]));
  cells__mux4 mux4_3(.in00(net_575[31:0]), .in01(net_649[31:0]), .in02(in3[31:0]), 
      .in03(net_615[31:0]), .out(net_598[31:0]));
  cells_cpg__mux4_cpg mux4_cpg_0(.in00(S[31:0]), .in01(net_614[31:0]), .in02(net_647[31:0]), 
      .in03(mux4_cpg_0_in03[31:0]), .out(net_633[31:0]));
  cells_cpg__regfile8_r1_w1_cpg_cydra_c1 regfile8_r1_w1_cpg_cydra_c1_0(.w0(net_413[31:0]), 
      .r0(net_647[31:0]));
  cells__regfile8_r4_w1_cydra_c1 regfile8_r4_w1_cydra_c1_0(.w0(net_414[31:0]), .r0(net_655[31:0]), 
      .r1(net_654[31:0]), .r2(net_650[31:0]), .r3(net_649[31:0]));
  primitives__register register_0(.D(net_595[31:0]), .Q(net_545[31:0]));
  primitives__register register_1(.D(net_598[31:0]), .Q(net_546[31:0]));
  cells__shiftRegister0x1 shiftRegister0x1_0(.in(in1[31:0]), .out(net_446[31:0]));
  primitives__uber_fu uber_fu_0(.A(net_631[31:0]), .B(net_632[31:0]), .S(net_633[31:0]), 
      .X(net_545[31:0]), .Y(net_546[31:0]), .F(net_629[31:0]), .R(net_628[31:0]));
endmodule   /* uber_fu_1x8 */
