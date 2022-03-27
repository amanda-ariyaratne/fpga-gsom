#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/opt/Xilinx/Vitis/2021.1/bin:/opt/Xilinx/Vivado/2021.1/bin
else
  PATH=/opt/Xilinx/Vitis/2021.1/bin:/opt/Xilinx/Vivado/2021.1/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/ec2-user/aws-fpga/hdk/cl/examples/cl_hello_world_hlx/example_projects/cl_hello_world.runs/divider_with_reset_synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log divider_with_reset.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source divider_with_reset.tcl
