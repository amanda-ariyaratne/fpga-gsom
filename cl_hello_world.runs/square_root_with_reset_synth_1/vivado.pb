
~
Sourcing tcl script '%s'
201*common2A
-/home/ec2-user/.Xilinx/Vivado/Vivado_init.tcl2default:defaultZ17-201h px? 
>
Refreshing IP repositories
234*coregenZ19-234h px? 
?
 Loaded user IP repository '%s'.
1135*coregen2Q
=/home/ec2-user/aws-fpga/hdk/common/shell_v04261818/hlx/design2default:defaultZ19-1700h px? 
~
"Loaded Vivado IP repository '%s'.
1332*coregen25
!/opt/Xilinx/Vivado/2021.1/data/ip2default:defaultZ19-2313h px? 
?
Command: %s
53*	vivadotcl2k
Wsynth_design -top square_root_with_reset -part xcvu9p-flgb2104-2-i -mode out_of_context2default:defaultZ4-113h px? 
:
Starting synth_design
149*	vivadotclZ4-321h px? 
?
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
xcvu9p2default:defaultZ17-347h px? 
?
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
xcvu9p2default:defaultZ17-349h px? 
Z
Loading part %s157*device2'
xcvu9p-flgb2104-2-i2default:defaultZ21-403h px? 
?
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
42default:defaultZ8-7079h px? 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px? 
_
#Helper process launched with PID %s4824*oasys2
50672default:defaultZ8-7075h px? 
?
%s*synth2?
?Starting RTL Elaboration : Time (s): cpu = 00:00:06 ; elapsed = 00:00:06 . Memory (MB): peak = 2962.863 ; gain = 226.656 ; free physical = 51809 ; free virtual = 66289
2default:defaulth px? 
?
synthesizing module '%s'%s4497*oasys2*
square_root_with_reset2default:default2
 2default:default2?
?/home/ec2-user/aws-fpga/hdk/cl/examples/cl_hello_world_hlx/example_projects/cl_hello_world.gen/sources_1/ip/square_root_with_reset/synth/square_root_with_reset.v2default:default2
602default:default8@Z8-6157h px? 
?
synthesizing module '%s'%s4497*oasys2
LUT12default:default2
 2default:default2M
7/opt/Xilinx/Vivado/2021.1/scripts/rt/data/unisim_comp.v2default:default2
591022default:default8@Z8-6157h px? 
?
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
LUT12default:default2
 2default:default2
12default:default2
12default:default2M
7/opt/Xilinx/Vivado/2021.1/scripts/rt/data/unisim_comp.v2default:default2
591022default:default8@Z8-6155h px? 
?
'done synthesizing module '%s'%s (%s#%s)4495*oasys2*
square_root_with_reset2default:default2
 2default:default2
172default:default2
12default:default2?
?/home/ec2-user/aws-fpga/hdk/cl/examples/cl_hello_world_hlx/example_projects/cl_hello_world.gen/sources_1/ip/square_root_with_reset/synth/square_root_with_reset.v2default:default2
602default:default8@Z8-6155h px? 
?
%s*synth2?
?Finished RTL Elaboration : Time (s): cpu = 00:00:12 ; elapsed = 00:00:13 . Memory (MB): peak = 3068.801 ; gain = 332.594 ; free physical = 52668 ; free virtual = 67149
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Handling Custom Attributes : Time (s): cpu = 00:00:13 ; elapsed = 00:00:14 . Memory (MB): peak = 3086.613 ; gain = 350.406 ; free physical = 52666 ; free virtual = 67146
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished RTL Optimization Phase 1 : Time (s): cpu = 00:00:13 ; elapsed = 00:00:14 . Memory (MB): peak = 3086.613 ; gain = 350.406 ; free physical = 52666 ; free virtual = 67146
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:00.072default:default2
00:00:00.072default:default2
3092.5512default:default2
0.0002default:default2
526572default:default2
671372default:defaultZ17-722h px? 
g
-Analyzing %s Unisim elements for replacement
17*netlist2
8752default:defaultZ29-17h px? 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
02default:defaultZ29-28h px? 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px? 
>

Processing XDC Constraints
244*projectZ1-262h px? 
=
Initializing timing engine
348*projectZ1-569h px? 
?
$Parsing XDC File [%s] for cell '%s'
848*designutils2?
?/home/ec2-user/aws-fpga/hdk/cl/examples/cl_hello_world_hlx/example_projects/cl_hello_world.gen/sources_1/ip/square_root_with_reset/square_root_with_reset_ooc.xdc2default:default2
inst	2default:default8Z20-848h px? 
?
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
create_clock: 2default:default2
00:00:052default:default2
00:00:052default:default2
3270.2382default:default2
0.0002default:default2
525442default:default2
670252default:defaultZ17-722h px? 
?
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2?
?/home/ec2-user/aws-fpga/hdk/cl/examples/cl_hello_world_hlx/example_projects/cl_hello_world.gen/sources_1/ip/square_root_with_reset/square_root_with_reset_ooc.xdc2default:default2
inst	2default:default8Z20-847h px? 
?
Parsing XDC File [%s]
179*designutils2?
?/home/ec2-user/aws-fpga/hdk/cl/examples/cl_hello_world_hlx/example_projects/cl_hello_world.runs/square_root_with_reset_synth_1/dont_touch.xdc2default:default8Z20-179h px? 
?
Finished Parsing XDC File [%s]
178*designutils2?
?/home/ec2-user/aws-fpga/hdk/cl/examples/cl_hello_world_hlx/example_projects/cl_hello_world.runs/square_root_with_reset_synth_1/dont_touch.xdc2default:default8Z20-178h px? 
H
&Completed Processing XDC Constraints

245*projectZ1-263h px? 
?
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:00.012default:default2
00:00:002default:default2
3270.2382default:default2
0.0002default:default2
525442default:default2
670252default:defaultZ17-722h px? 
?
!Unisim Transformation Summary:
%s111*project2Z
F  A total of 1 instances were transformed.
  FDE => FDRE: 1 instance 
2default:defaultZ1-111h px? 
?
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common24
 Constraint Validation Runtime : 2default:default2
00:00:00.092default:default2
00:00:00.062default:default2
3270.2382default:default2
0.0002default:default2
525432default:default2
670232default:defaultZ17-722h px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Constraint Validation : Time (s): cpu = 00:00:26 ; elapsed = 00:00:27 . Memory (MB): peak = 3270.238 ; gain = 534.031 ; free physical = 52655 ; free virtual = 67136
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
V
%s
*synth2>
*Start Loading Part and Timing Information
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
N
%s
*synth26
"Loading part: xcvu9p-flgb2104-2-i
2default:defaulth p
x
? 
B
 Reading net delay rules and data4578*oasysZ8-6742h px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Loading Part and Timing Information : Time (s): cpu = 00:00:26 ; elapsed = 00:00:27 . Memory (MB): peak = 3270.238 ; gain = 534.031 ; free physical = 52655 ; free virtual = 67136
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
Z
%s
*synth2B
.Start Applying 'set_property' XDC Constraints
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished applying 'set_property' XDC Constraints : Time (s): cpu = 00:00:26 ; elapsed = 00:00:27 . Memory (MB): peak = 3270.238 ; gain = 534.031 ; free physical = 52655 ; free virtual = 67136
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:28 ; elapsed = 00:00:30 . Memory (MB): peak = 3270.238 ; gain = 534.031 ; free physical = 52645 ; free virtual = 67127
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
$decloning instance '%s' (%s) to '%s'223*oasys2S
?inst/i_synth/SQRT_OP.SPD.OP/i_mant_calc.ROUND/EXTRA_LSB_BIT_DEL2default:default2*
delay__parameterized772default:default2T
@inst/i_synth/SQRT_OP.SPD.OP/i_mant_calc.ROUND/EXTRA_LSB_RND1_DEL2default:defaultZ8-223h px? 
?
$decloning instance '%s' (%s) to '%s'223*oasys2O
;inst/i_synth/SQRT_OP.SPD.OP/i_mant_calc.ROUND/EXP_INC_DELAY2default:default2*
delay__parameterized772default:default2T
@inst/i_synth/SQRT_OP.SPD.OP/i_mant_calc.ROUND/EXP_INC_RND1_DELAY2default:defaultZ8-223h px? 
?
$decloning instance '%s' (%s) to '%s'223*oasys25
!inst/i_synth/DELAY_DIVIDE_BY_ZERO2default:default2*
delay__parameterized772default:default2/
inst/i_synth/DELAY_OVERFLOW2default:defaultZ8-223h px? 
?
$decloning instance '%s' (%s) to '%s'223*oasys25
!inst/i_synth/DELAY_DIVIDE_BY_ZERO2default:default2*
delay__parameterized772default:default20
inst/i_synth/DELAY_UNDERFLOW2default:defaultZ8-223h px? 
?
$decloning instance '%s' (%s) to '%s'223*oasys25
!inst/i_synth/DELAY_DIVIDE_BY_ZERO2default:default2*
delay__parameterized772default:default25
!inst/i_synth/DELAY_ACCUM_OVERFLOW2default:defaultZ8-223h px? 
?
$decloning instance '%s' (%s) to '%s'223*oasys25
!inst/i_synth/DELAY_DIVIDE_BY_ZERO2default:default2*
delay__parameterized772default:default2;
'inst/i_synth/DELAY_ACCUM_INPUT_OVERFLOW2default:defaultZ8-223h px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
L
%s
*synth24
 Start RTL Component Statistics 
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
O
%s
*synth27
#Finished RTL Component Statistics 
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
H
%s
*synth20
Start Part Resource Summary
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s
*synth2p
\Part Resources:
DSPs: 6840 (col length:120)
BRAMs: 4320 (col length: RAMB18 360 RAMB36 180)
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
K
%s
*synth23
Finished Part Resource Summary
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
W
%s
*synth2?
+Start Cross Boundary and Area Optimization
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:31 ; elapsed = 00:00:33 . Memory (MB): peak = 3270.238 ; gain = 534.031 ; free physical = 52630 ; free virtual = 67117
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
R
%s
*synth2:
&Start Applying XDC Timing Constraints
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Applying XDC Timing Constraints : Time (s): cpu = 00:00:40 ; elapsed = 00:00:44 . Memory (MB): peak = 3443.754 ; gain = 707.547 ; free physical = 52190 ; free virtual = 66677
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
F
%s
*synth2.
Start Timing Optimization
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Timing Optimization : Time (s): cpu = 00:00:41 ; elapsed = 00:00:44 . Memory (MB): peak = 3465.785 ; gain = 729.578 ; free physical = 52186 ; free virtual = 66673
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
E
%s
*synth2-
Start Technology Mapping
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Technology Mapping : Time (s): cpu = 00:00:41 ; elapsed = 00:00:45 . Memory (MB): peak = 3481.801 ; gain = 745.594 ; free physical = 52184 ; free virtual = 66671
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s
*synth2'
Start IO Insertion
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
Q
%s
*synth29
%Start Flattening Before IO Insertion
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
T
%s
*synth2<
(Finished Flattening Before IO Insertion
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
H
%s
*synth20
Start Final Netlist Cleanup
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
K
%s
*synth23
Finished Final Netlist Cleanup
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished IO Insertion : Time (s): cpu = 00:00:45 ; elapsed = 00:00:48 . Memory (MB): peak = 3481.801 ; gain = 745.594 ; free physical = 52184 ; free virtual = 66670
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
O
%s
*synth27
#Start Renaming Generated Instances
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Renaming Generated Instances : Time (s): cpu = 00:00:45 ; elapsed = 00:00:48 . Memory (MB): peak = 3481.801 ; gain = 745.594 ; free physical = 52184 ; free virtual = 66670
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
L
%s
*synth24
 Start Rebuilding User Hierarchy
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:45 ; elapsed = 00:00:49 . Memory (MB): peak = 3481.801 ; gain = 745.594 ; free physical = 52184 ; free virtual = 66670
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
K
%s
*synth23
Start Renaming Generated Ports
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Renaming Generated Ports : Time (s): cpu = 00:00:45 ; elapsed = 00:00:49 . Memory (MB): peak = 3481.801 ; gain = 745.594 ; free physical = 52184 ; free virtual = 66670
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Handling Custom Attributes : Time (s): cpu = 00:00:45 ; elapsed = 00:00:49 . Memory (MB): peak = 3481.801 ; gain = 745.594 ; free physical = 52183 ; free virtual = 66670
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
J
%s
*synth22
Start Renaming Generated Nets
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Renaming Generated Nets : Time (s): cpu = 00:00:45 ; elapsed = 00:00:49 . Memory (MB): peak = 3481.801 ; gain = 745.594 ; free physical = 52183 ; free virtual = 66670
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
K
%s
*synth23
Start Writing Synthesis Report
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
A
%s
*synth2)

Report BlackBoxes: 
2default:defaulth p
x
? 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
? 
J
%s
*synth22
| |BlackBox name |Instances |
2default:defaulth p
x
? 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
? 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
? 
A
%s*synth2)

Report Cell Usage: 
2default:defaulth px? 
E
%s*synth2-
+------+--------+------+
2default:defaulth px? 
E
%s*synth2-
|      |Cell    |Count |
2default:defaulth px? 
E
%s*synth2-
+------+--------+------+
2default:defaulth px? 
E
%s*synth2-
|1     |LUT1    |    39|
2default:defaulth px? 
E
%s*synth2-
|2     |LUT2    |    56|
2default:defaulth px? 
E
%s*synth2-
|3     |LUT3    |   363|
2default:defaulth px? 
E
%s*synth2-
|4     |LUT4    |     7|
2default:defaulth px? 
E
%s*synth2-
|5     |LUT5    |     6|
2default:defaulth px? 
E
%s*synth2-
|6     |LUT6    |     8|
2default:defaulth px? 
E
%s*synth2-
|7     |MUXCY   |   424|
2default:defaulth px? 
E
%s*synth2-
|8     |SRL16E  |    21|
2default:defaulth px? 
E
%s*synth2-
|9     |SRLC32E |    11|
2default:defaulth px? 
E
%s*synth2-
|10    |XORCY   |   449|
2default:defaulth px? 
E
%s*synth2-
|11    |FDRE    |   938|
2default:defaulth px? 
E
%s*synth2-
+------+--------+------+
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Writing Synthesis Report : Time (s): cpu = 00:00:45 ; elapsed = 00:00:49 . Memory (MB): peak = 3481.801 ; gain = 745.594 ; free physical = 52183 ; free virtual = 66670
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
r
%s
*synth2Z
FSynthesis finished with 0 errors, 0 critical warnings and 0 warnings.
2default:defaulth p
x
? 
?
%s
*synth2?
?Synthesis Optimization Runtime : Time (s): cpu = 00:00:37 ; elapsed = 00:00:40 . Memory (MB): peak = 3481.801 ; gain = 561.969 ; free physical = 52209 ; free virtual = 66696
2default:defaulth p
x
? 
?
%s
*synth2?
?Synthesis Optimization Complete : Time (s): cpu = 00:00:45 ; elapsed = 00:00:49 . Memory (MB): peak = 3481.809 ; gain = 745.594 ; free physical = 52209 ; free virtual = 66696
2default:defaulth p
x
? 
B
 Translating synthesized netlist
350*projectZ1-571h px? 
?
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:00.032default:default2
00:00:00.032default:default2
3481.8092default:default2
0.0002default:default2
522972default:default2
667842default:defaultZ17-722h px? 
g
-Analyzing %s Unisim elements for replacement
17*netlist2
8732default:defaultZ29-17h px? 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
02default:defaultZ29-28h px? 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px? 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px? 
?
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2
00:00:002default:default2
3587.0122default:default2
0.0002default:default2
521982default:default2
666852default:defaultZ17-722h px? 
?
!Unisim Transformation Summary:
%s111*project2c
O  A total of 68 instances were transformed.
  (CARRY4) => CARRY8: 68 instances
2default:defaultZ1-111h px? 
g
$Synth Design complete, checksum: %s
562*	vivadotcl2
fcd178bb2default:defaultZ4-1430h px? 
U
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83h px? 
?
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
302default:default2
02default:default2
02default:default2
02default:defaultZ4-41h px? 
^
%s completed successfully
29*	vivadotcl2 
synth_design2default:defaultZ4-42h px? 
?
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
synth_design: 2default:default2
00:01:052default:default2
00:01:022default:default2
3587.0122default:default2
1012.8052default:default2
523442default:default2
668312default:defaultZ17-722h px? 
?
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2?
?/home/ec2-user/aws-fpga/hdk/cl/examples/cl_hello_world_hlx/example_projects/cl_hello_world.runs/square_root_with_reset_synth_1/square_root_with_reset.dcp2default:defaultZ17-1381h px? 
?
<Added synthesis output to IP cache for IP %s, cache-ID = %s
485*coretcl2*
square_root_with_reset2default:default2$
f7cda6c253faf5cc2default:defaultZ2-1648h px? 
R
Renamed %s cell refs.
330*coretcl2
2102default:defaultZ2-1174h px? 
?
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2?
?/home/ec2-user/aws-fpga/hdk/cl/examples/cl_hello_world_hlx/example_projects/cl_hello_world.runs/square_root_with_reset_synth_1/square_root_with_reset.dcp2default:defaultZ17-1381h px? 
?
%s4*runtcl2?
?Executing : report_utilization -file square_root_with_reset_utilization_synth.rpt -pb square_root_with_reset_utilization_synth.pb
2default:defaulth px? 
?
Exiting %s at %s...
206*common2
Vivado2default:default2,
Sun Mar 27 11:19:04 20222default:defaultZ17-206h px? 


End Record