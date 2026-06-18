v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 1070 -1050 1870 -650 {flags=graph
y1=0
y2=2
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=3e-07
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
legendmag=1.0
node="en
en_n
q0
q1
q2
q3"
color="4 5 6 7 8 9"
dataset=-1
unitx=1
logx=0
logy=0
autoload=1
sim_type=tran
rawfile=$netlist_dir/octs-full-tb.raw
digital=1}
B 2 1070 -1270 1860 -1070 {flags=graph
y1=-0.036
y2=1.3
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=3e-07
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
legendmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
autoload=1
sim_type=tran
rawfile=$netlist_dir/octs-full-tb.raw
digital=0
color=4
node=ro_raw}
B 2 1070 -1480 1860 -1280 {flags=graph
y1=-0.036
y2=1.3
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=3e-07
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
legendmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
autoload=1
sim_type=tran
rawfile=$netlist_dir/octs-full-tb.raw
digital=0
color=5
node=ro_buf}
N 140 -80 140 -70 {lab=0}
N 120 -70 140 -70 {lab=0}
N 100 -80 100 -70 {lab=0}
N 120 -70 120 -60 {lab=0}
N 100 -70 120 -70 {lab=0}
N 100 -150 100 -140 {lab=VDD}
N 140 -150 140 -140 {lab=VDD}
N 100 -150 140 -150 {lab=VDD}
N 290 -150 290 -130 {lab=VDD}
N 370 -150 370 -130 {lab=EN_n}
N 500 -450 510 -450 {lab=VDD}
N 500 -460 500 -450 {lab=VDD}
N 500 -390 510 -390 {lab=0}
N 500 -390 500 -380 {lab=0}
N 450 -200 450 -130 {lab=EN}
N 450 -200 530 -200 {lab=EN}
N 570 -200 570 -180 {lab=EN_n}
N 530 -200 530 -150 {lab=EN}
N 570 -280 570 -250 {lab=VDD}
N 570 -150 570 -120 {lab=0}
N 570 -200 620 -200 {lab=EN_n}
N 570 -220 570 -200 {lab=EN_n}
N 530 -250 530 -200 {lab=EN}
N 480 -430 510 -430 {lab=EN}
N 480 -410 510 -410 {lab=EN_n}
N 1050 -460 1050 -440 {lab=VDD}
N 1050 -440 1070 -440 {lab=VDD}
N 1050 -380 1050 -360 {lab=0}
N 1050 -380 1070 -380 {lab=0}
N 1270 -440 1290 -440 {lab=Q0}
N 1270 -420 1290 -420 {lab=Q1}
N 1270 -400 1290 -400 {lab=Q2}
N 1270 -380 1290 -380 {lab=Q3}
N 990 -170 990 -150 {lab=Q3}
N 930 -170 930 -150 {lab=Q2}
N 870 -170 870 -150 {lab=Q1}
N 810 -170 810 -150 {lab=Q0}
N 1050 -400 1070 -400 {lab=0}
N 1050 -400 1050 -380 {lab=0}
N 750 -170 750 -150 {lab=ro_raw}
N 950 -420 1070 -420 {lab=ro_buf}
N 750 -420 850 -420 {lab=ro_raw}
C {title.sym} 160 0 0 0 {name=l6 author="Dennis Hunter"}
C {devices/launcher.sym} 70 -260 0 0 {name=h3
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file rootname [file tail [xschem get current_name]]].raw dc
xschem setprop rect 2 0 fullxzoom
"
}
C {launcher.sym} 70 -310 0 0 {name=h4
descr=SimulateNGSPICE
tclcommand="
# Setup the default simulation commands if not already set up
# for example by already launched simulations.
set_sim_defaults
puts $sim(spice,1,cmd) 

# Change the Xyce command. In the spice category there are currently
# 5 commands (0, 1, 2, 3, 4). Command 3 is the Xyce batch
# you can get the number by querying $sim(spice,n)
set sim(spice,1,cmd) \{ngspice  \\"$N\\" -a\}

# change the simulator to be used (Xyce)
set sim(spice,default) 0

# Create FET .save file
mkdir -p $netlist_dir
write_data [save_params] $netlist_dir/[file rootname [file tail [xschem get current_name]]].save

# run netlist and simulation
xschem netlist
simulate
"}
C {launcher.sym} 70 -210 0 0 {name=h1
descr=RunNGRUN.py
tclcommand="
xschem netlist

set sch_file [xschem get current_name]
set sch_dir [file dirname $sch_file]
set sch_base [file rootname [file tail $sch_file]]
set netlist [file join $sch_dir simulation $\{sch_base\}.spice]

set script $env(DESIGNS)/ngrun.py
set logfile [file join $sch_dir simulation ngrun.log]

if \{![file exists $netlist]\} \{
    tk_messageBox -icon error -message \\"Netlist not found:\\n$netlist\\"
    return
\}

if \{![file exists $script]\} \{
    tk_messageBox -icon error -message \\"Python script not found:\\n$script\\"
    return
\}

exec \{*\}$terminal -lc -u8 -hold -e sh -c \{
  python3 -u "$1" -k -j 1 "$2" 2>&1 | tee "$3"
\} sh $script $netlist $logfile &
"}
C {simulator_commands.sym} 0 -450 0 0 {name=octs-full-tb
simulator=ngspice
only_toplevel=false 
value="
** ngr_lib cornerMOSlv.lib mos_tt
** ngr_lib cornerRES.lib res_typ
** ngr_out tp_raw tp_buf tp_q0 tp_q1 tp_q2 tp_q3
** ngr_temp 25
** ngr_name octs-full-tb
** ngr_param vdd 1.2

.option rshunt=1e12
.option klu
.param vdd=1.2
.control

set rawfile = octs-full-tb.raw

tran 0.02n 500n

meas tran tp_raw \\
  + TRIG v(ro_raw) VAL=\{vdd/2\} TD=10n RISE=1 \\
  + TARG v(ro_raw) VAL=\{vdd/2\} TD=10n RISE=2
meas tran tp_buf \\
  + TRIG v(ro_buf) VAL=\{vdd/2\} TD=10n RISE=1 \\
  + TARG v(ro_buf) VAL=\{vdd/2\} TD=10n RISE=2
meas tran tp_q0 \\
  + TRIG v(q0) VAL=\{vdd/2\} TD=10n RISE=1 \\
  + TARG v(q0) VAL=\{vdd/2\} TD=10n RISE=2
meas tran tp_q1 \\
  + TRIG v(q1) VAL=\{vdd/2\} TD=10n RISE=1 \\
  + TARG v(q1) VAL=\{vdd/2\} TD=10n RISE=2
meas tran tp_q2 \\
  + TRIG v(q2) VAL=\{vdd/2\} TD=10n RISE=1 \\
  + TARG v(q2) VAL=\{vdd/2\} TD=10n RISE=2
meas tran tp_q3 \\
  + TRIG v(q3) VAL=\{vdd/2\} TD=10n RISE=1 \\
  + TARG v(q3) VAL=\{vdd/2\} TD=10n RISE=2

write $rawfile en en_n ro_raw ro_buf q0 q1 q2 q3
.endc
"
}
C {simulator_commands.sym} 0 -630 0 0 {name=Libs_Ngspice1
simulator=ngspice
only_toplevel=false 
value="
.lib cornerMOSlv.lib mos_tt
.lib cornerMOShv.lib mos_tt
.lib cornerRES.lib res_typ
.lib cornerDIO.lib dio_tt
"}
C {simulator_commands.sym} 130 -630 0 0 {name=div16_includes
simulator=ngspice
only_toplevel=false 
value="
.include sg13cmos5l_stdcell.spice
*.include digital/div16/div16.spice
"
}
C {vsource.sym} 290 -100 0 0 {name=Vdd value=\{vdd\} savecurrent=false}
C {sg13cmos5l_pr/ntap1.sym} 100 -110 2 0 {name=R3
model=ntap1
spiceprefix=X
w=0.78e-6
l=0.78e-6
}
C {sg13cmos5l_pr/ptap1.sym} 140 -110 0 0 {name=R4
model=ptap1
spiceprefix=X
w=0.78e-6
l=0.78e-6
}
C {gnd.sym} 120 -60 0 0 {name=l3 lab=0}
C {gnd.sym} 290 -70 0 0 {name=l1 lab=0}
C {vdd.sym} 290 -150 0 0 {name=l9 lab=VDD}
C {vdd.sym} 120 -150 0 0 {name=l10 lab=VDD}
C {lab_pin.sym} 370 -150 1 0 {name=p1 sig_type=std_logic lab=EN_n}
C {gnd.sym} 370 -70 0 0 {name=l12 lab=0}
C {vsource.sym} 370 -100 0 0 {name=V2 savecurrent=false
value="pulse 1.2 0 25n 1n 1n 225n 450n"}
C {lab_pin.sym} 800 -420 1 0 {name=p7 sig_type=std_logic lab=ro_raw}
C {vdd.sym} 500 -460 0 0 {name=l2 lab=VDD}
C {gnd.sym} 500 -380 0 0 {name=l4 lab=0}
C {analog/temp-sens-core/temp_sens_core.sym} 630 -430 0 0 {name=x1 lstarv=0.46u cpar=0f}
C {lab_pin.sym} 450 -150 2 0 {name=p2 sig_type=std_logic lab=EN}
C {gnd.sym} 450 -70 0 0 {name=l5 lab=0}
C {lab_pin.sym} 620 -200 2 0 {name=p3 sig_type=std_logic lab=EN_n}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 550 -150 0 0 {name=M6
l=0.13u
w=1u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 550 -250 0 0 {name=M7
l=0.13u
w=2u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {gnd.sym} 570 -120 0 0 {name=l7 lab=0}
C {vdd.sym} 570 -280 0 0 {name=l23 lab=VDD}
C {vsource.sym} 450 -100 0 0 {name=V1 value="pulse 0 1.2 50n 1n 1n 200n 400n" savecurrent=false}
C {lab_pin.sym} 480 -410 0 0 {name=p4 sig_type=std_logic lab=EN_n}
C {lab_pin.sym} 480 -430 0 0 {name=p5 sig_type=std_logic lab=EN}
C {capa.sym} 750 -120 0 0 {name=C1
m=1
value=0.1f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 750 -90 0 0 {name=l8 lab=0}
C {analog/output_buffer_chain/output_buffer_chain.sym} 730 -300 0 0 {name=x2}
C {gnd.sym} 890 -380 0 0 {name=l11 lab=0}
C {vdd.sym} 890 -460 0 0 {name=l14 lab=VDD}
C {gnd.sym} 1050 -360 0 0 {name=l13 lab=0}
C {vdd.sym} 1050 -460 0 0 {name=l15 lab=VDD}
C {lab_pin.sym} 1290 -440 2 0 {name=p8 sig_type=std_logic lab=Q0}
C {lab_pin.sym} 1290 -400 2 0 {name=p9 sig_type=std_logic lab=Q2}
C {lab_pin.sym} 1290 -420 2 0 {name=p10 sig_type=std_logic lab=Q1}
C {lab_pin.sym} 1290 -380 2 0 {name=p11 sig_type=std_logic lab=Q3}
C {capa.sym} 810 -120 0 0 {name=C2
m=1
value=0.1f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 810 -90 0 0 {name=l16 lab=0}
C {capa.sym} 870 -120 0 0 {name=C3
m=1
value=0.1f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 870 -90 0 0 {name=l17 lab=0}
C {capa.sym} 930 -120 0 0 {name=C4
m=1
value=0.1f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 930 -90 0 0 {name=l18 lab=0}
C {capa.sym} 990 -120 0 0 {name=C5
m=1
value=0.1f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 990 -90 0 0 {name=l19 lab=0}
C {lab_pin.sym} 810 -170 2 0 {name=p12 sig_type=std_logic lab=Q0}
C {lab_pin.sym} 930 -170 2 0 {name=p13 sig_type=std_logic lab=Q2}
C {lab_pin.sym} 870 -170 2 0 {name=p14 sig_type=std_logic lab=Q1}
C {lab_pin.sym} 990 -170 2 0 {name=p15 sig_type=std_logic lab=Q3}
C {lab_pin.sym} 1010 -420 1 0 {name=p16 sig_type=std_logic lab=ro_buf}
C {digital/div16/xschem/div16.sym} 1170 -380 0 0 {name=x3}
C {simulator_commands.sym} 130 -450 0 0 {name=octs-full-tb-pvt
simulator=ngspice
only_toplevel=false 
value="
** ngr_lib cornerMOSlv.lib mos_tt
** ngr_lib cornerRES.lib res_typ
** ngr_out tp_raw tp_buf tp_q0 tp_q1 tp_q2 tp_q3
** ngr_temp -20 0 25 80 110 140
** ngr_name octs-full-tb-pvt
** ngr_param vdd 1.08 1.2 1.32

.option rshunt=1e12
.option klu
.param vdd=1.2
.control
*set rawfile = octs-full-tb.raw

tran 0.05n 300n

meas tran tp_raw \\
  + TRIG v(ro_raw) VAL=0.6 TD=10n RISE=1 \\
  + TARG v(ro_raw) VAL=0.6 TD=10n RISE=2
meas tran tp_buf \\
  + TRIG v(ro_buf) VAL=0.6 TD=10n RISE=1 \\
  + TARG v(ro_buf) VAL=0.6 TD=10n RISE=2
meas tran tp_q0 \\
  + TRIG v(q0) VAL=0.6 TD=10n RISE=1 \\
  + TARG v(q0) VAL=0.6 TD=10n RISE=2
meas tran tp_q1 \\
  + TRIG v(q1) VAL=0.6 TD=10n RISE=1 \\
  + TARG v(q1) VAL=0.6 TD=10n RISE=2
meas tran tp_q2 \\
  + TRIG v(q2) VAL=0.6 TD=10n RISE=1 \\
  + TARG v(q2) VAL=0.6 TD=10n RISE=2
meas tran tp_q3 \\
  + TRIG v(q3) VAL=0.6 TD=10n RISE=1 \\
  + TARG v(q3) VAL=0.6 TD=10n RISE=2

write $rawfile en en_n ro_raw ro_buf q0 q1 q2 q3
.endc
"
spice_ignore=true}
C {simulator_commands.sym} 260 -450 0 0 {name=octs-full-tb-mc
simulator=ngspice
only_toplevel=false 
value="
** ngr_lib cornerMOSlv.lib mos_tt mos_ff mos_ss mos_sf mos_fs
** ngr_lib cornerRES.lib res_typ res_bcs res_wcs
** ngr_out tp_raw tp_buf tp_q0 tp_q1 tp_q2 tp_q3
** ngr_temp -20 0 25 80 110 140
** ngr_name octs-full-tb-mc
** ngr_param vdd 1.08 1.2 1.32

.option rshunt=1e12
.option klu
.param vdd=1.2
.control
*set rawfile = octs-full-tb.raw

tran 0.05n 300n

meas tran tp_raw \\
  + TRIG v(ro_raw) VAL=0.6 TD=10n RISE=1 \\
  + TARG v(ro_raw) VAL=0.6 TD=10n RISE=2
meas tran tp_buf \\
  + TRIG v(ro_buf) VAL=0.6 TD=10n RISE=1 \\
  + TARG v(ro_buf) VAL=0.6 TD=10n RISE=2
meas tran tp_q0 \\
  + TRIG v(q0) VAL=0.6 TD=10n RISE=1 \\
  + TARG v(q0) VAL=0.6 TD=10n RISE=2
meas tran tp_q1 \\
  + TRIG v(q1) VAL=0.6 TD=10n RISE=1 \\
  + TARG v(q1) VAL=0.6 TD=10n RISE=2
meas tran tp_q2 \\
  + TRIG v(q2) VAL=0.6 TD=10n RISE=1 \\
  + TARG v(q2) VAL=0.6 TD=10n RISE=2
meas tran tp_q3 \\
  + TRIG v(q3) VAL=0.6 TD=10n RISE=1 \\
  + TARG v(q3) VAL=0.6 TD=10n RISE=2

write $rawfile en en_n ro_raw ro_buf q0 q1 q2 q3
.endc
"
spice_ignore=true}
C {lab_pin.sym} 750 -170 1 0 {name=p6 sig_type=std_logic lab=ro_raw}
