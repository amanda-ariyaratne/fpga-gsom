// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
// Date        : Sun Mar 27 11:19:03 2022
// Host        : ip-172-31-74-77.ec2.internal running 64-bit Amazon Linux release 2 (Karoo)
// Command     : write_verilog -force -mode synth_stub
//               /home/ec2-user/aws-fpga/hdk/cl/examples/cl_hello_world_hlx/example_projects/cl_hello_world.gen/sources_1/ip/square_root_with_reset/square_root_with_reset_stub.v
// Design      : square_root_with_reset
// Purpose     : Stub declaration of top-level module interface
// Device      : xcvu9p-flgb2104-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "floating_point_v7_1_12,Vivado 2021.1" *)
module square_root_with_reset(aclk, aresetn, s_axis_a_tvalid, 
  s_axis_a_tready, s_axis_a_tdata, m_axis_result_tvalid, m_axis_result_tready, 
  m_axis_result_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,aresetn,s_axis_a_tvalid,s_axis_a_tready,s_axis_a_tdata[31:0],m_axis_result_tvalid,m_axis_result_tready,m_axis_result_tdata[31:0]" */;
  input aclk;
  input aresetn;
  input s_axis_a_tvalid;
  output s_axis_a_tready;
  input [31:0]s_axis_a_tdata;
  output m_axis_result_tvalid;
  input m_axis_result_tready;
  output [31:0]m_axis_result_tdata;
endmodule
