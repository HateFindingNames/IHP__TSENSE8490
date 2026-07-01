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
x1=4.5197145e-07
x2=7.2040692e-07
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
x1=4.5197145e-07
x2=7.2040692e-07
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
x1=4.5197145e-07
x2=7.2040692e-07
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
N 370 -430 380 -430 {lab=VDD}
N 370 -440 370 -430 {lab=VDD}
N 370 -370 380 -370 {lab=0}
N 370 -370 370 -360 {lab=0}
N 540 -190 540 -170 {lab=en_n}
N 540 -270 540 -240 {lab=VDD}
N 540 -140 540 -110 {lab=0}
N 540 -190 590 -190 {lab=en_n}
N 540 -210 540 -190 {lab=en_n}
N 350 -410 380 -410 {lab=en}
N 350 -390 380 -390 {lab=en_n}
N 920 -440 920 -420 {lab=VDD}
N 920 -420 940 -420 {lab=VDD}
N 920 -360 920 -340 {lab=0}
N 920 -360 940 -360 {lab=0}
N 1140 -420 1160 -420 {lab=Q0}
N 1140 -400 1160 -400 {lab=Q1}
N 1140 -380 1160 -380 {lab=Q2}
N 1140 -360 1160 -360 {lab=Q3}
N 990 -150 990 -130 {lab=Q3}
N 930 -150 930 -130 {lab=Q2}
N 870 -150 870 -130 {lab=Q1}
N 810 -150 810 -130 {lab=Q0}
N 690 -150 690 -130 {lab=ro_raw}
N 820 -400 940 -400 {lab=ro_buf}
N 620 -400 720 -400 {lab=ro_raw}
N 920 -380 940 -380 {lab=en_n}
N 500 -190 500 -140 {lab=en}
N 750 -150 750 -130 {lab=ro_buf}
N 430 -190 430 -130 {lab=en}
N 430 -190 500 -190 {lab=en}
N 500 -240 500 -190 {lab=en}
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
  python3 -u "$1" -k -j 2 "$2" 2>&1 | tee "$3"
\} sh $script $netlist $logfile &
"}
C {simulator_commands.sym} 0 -650 0 0 {name=basic
simulator=ngspice
only_toplevel=false 
value="
** ngr_lib cornerMOSlv.lib mos_tt
** ngr_lib cornerRES.lib res_typ
** ngr_out f_raw f_buf f_q0 f_q1 f_q2 f_q3
** ngr_temp 25
** ngr_name octs-full-tb
** ngr_param vdd 1.2

.option rshunt=1e12
.option klu
.param vdd=1.2
.csparam vth=\{vdd/2\}
.control

set rawfile = octs-full-tb.raw

tran 0.05n 2.5u



write $rawfile en en_n ro_raw ro_buf q0 q1 q2 q3
.endc
"
spice_ignore=true}
C {simulator_commands.sym} 0 -460 0 0 {name=Libs_Ngspice
simulator=ngspice
only_toplevel=false 
value="
.include sg13cmos5l_stdcell.spice

.lib cornerMOSlv.lib mos_tt
.lib cornerMOShv.lib mos_tt
.lib cornerRES.lib res_typ
.lib cornerDIO.lib dio_tt
"
}
C {vsource.sym} 320 -100 0 0 {name=Vdd value=\{vdd\} savecurrent=false}
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
C {gnd.sym} 320 -70 0 0 {name=l1 lab=0}
C {vdd.sym} 320 -130 0 0 {name=l9 lab=VDD}
C {vdd.sym} 120 -150 0 0 {name=l10 lab=VDD}
C {lab_pin.sym} 670 -400 1 0 {name=p7 sig_type=std_logic lab=ro_raw}
C {vdd.sym} 370 -440 0 0 {name=l2 lab=VDD}
C {gnd.sym} 370 -360 0 0 {name=l4 lab=0}
C {analog/temp-sens-core/temp_sens_core.sym} 500 -410 0 0 {name=x1 lstarv=0.46u cpar=0f}
C {gnd.sym} 430 -70 0 0 {name=l5 lab=0}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 520 -140 0 0 {name=M6
l=0.13u
w=1u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 520 -240 0 0 {name=M7
l=0.13u
w=2u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {gnd.sym} 540 -110 0 0 {name=l7 lab=0}
C {vdd.sym} 540 -270 0 0 {name=l23 lab=VDD}
C {vsource.sym} 430 -100 0 0 {name=V1 value="pulse 0 \{vdd\} 25n 1n 1n 225n 450n" savecurrent=false}
C {lab_pin.sym} 350 -390 0 0 {name=p4 sig_type=std_logic lab=en_n}
C {capa.sym} 690 -100 0 0 {name=C1
m=1
value=0.1f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 690 -70 0 0 {name=l8 lab=0}
C {analog/output_buffer_chain/output_buffer_chain.sym} 600 -280 0 0 {name=x2}
C {gnd.sym} 760 -360 0 0 {name=l11 lab=0}
C {vdd.sym} 760 -440 0 0 {name=l14 lab=VDD}
C {gnd.sym} 920 -340 0 0 {name=l13 lab=0}
C {vdd.sym} 920 -440 0 0 {name=l15 lab=VDD}
C {lab_pin.sym} 1160 -420 2 0 {name=p8 sig_type=std_logic lab=Q0}
C {lab_pin.sym} 1160 -380 2 0 {name=p9 sig_type=std_logic lab=Q2}
C {lab_pin.sym} 1160 -400 2 0 {name=p10 sig_type=std_logic lab=Q1}
C {lab_pin.sym} 1160 -360 2 0 {name=p11 sig_type=std_logic lab=Q3}
C {capa.sym} 810 -100 0 0 {name=C3
m=1
value=0.1f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 810 -70 0 0 {name=l16 lab=0}
C {capa.sym} 870 -100 0 0 {name=C4
m=1
value=0.1f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 870 -70 0 0 {name=l17 lab=0}
C {capa.sym} 930 -100 0 0 {name=C5
m=1
value=0.1f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 930 -70 0 0 {name=l18 lab=0}
C {capa.sym} 990 -100 0 0 {name=C6
m=1
value=0.1f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 990 -70 0 0 {name=l19 lab=0}
C {lab_pin.sym} 810 -150 2 0 {name=p12 sig_type=std_logic lab=Q0}
C {lab_pin.sym} 930 -150 2 0 {name=p13 sig_type=std_logic lab=Q2}
C {lab_pin.sym} 870 -150 2 0 {name=p14 sig_type=std_logic lab=Q1}
C {lab_pin.sym} 990 -150 2 0 {name=p15 sig_type=std_logic lab=Q3}
C {lab_pin.sym} 880 -400 1 0 {name=p16 sig_type=std_logic lab=ro_buf}
C {simulator_commands.sym} 130 -650 0 0 {name=pvt
simulator=ngspice
only_toplevel=false 
value="
** ngr_lib cornerMOSlv.lib mos_tt
** ngr_lib cornerRES.lib res_typ
** ngr_out f_raw f_buf f_q0 f_q1 f_q2 f_q3 i(vdd)
** ngr_temp -20 0 25 80 110 140
** ngr_name octs-full-tb-pvt
** ngr_param vdd 1.08 1.2 1.32

.option rshunt=1e12
.option klu
.param vdd=1.2
.csparam vth=\{vdd/2\}
.control
*set rawfile = octs-full-tb.raw

tran 0.05n 1.25u

meas tran tp_raw \\
  + TRIG v(ro_raw) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(ro_raw) VAL=$&vth TD=10n RISE=2
let f_raw = 1/tp_raw
print f_raw
meas tran tp_buf \\
  + TRIG v(ro_buf) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(ro_buf) VAL=$&vth TD=10n RISE=2
let f_buf = 1/tp_buf
print f_buf
meas tran tp_q0 \\
  + TRIG v(q0) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q0) VAL=$&vth TD=10n RISE=2
let f_q0 = 1/tp_q0
print f_q0
meas tran tp_q1 \\
  + TRIG v(q1) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q1) VAL=$&vth TD=10n RISE=2
let f_q1 = 1/tp_q1
print f_q1
meas tran tp_q2 \\
  + TRIG v(q2) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q2) VAL=$&vth TD=10n RISE=2
let f_q2 = 1/tp_q2
print f_q2
meas tran tp_q3 \\
  + TRIG v(q3) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q3) VAL=$&vth TD=10n RISE=2
let f_q3= 1/tp_q3
print f_q3

let isupply = i(vdd)
print isupply

write $rawfile en en_n ro_raw ro_buf q0 q1 q2 q3
.endc
"
}
C {lab_pin.sym} 690 -150 1 0 {name=p6 sig_type=std_logic lab=ro_raw}
C {simulator_commands.sym} 260 -650 0 0 {name=mc-mm-25c
simulator=ngspice
only_toplevel=false 
value="

* ===========================
* Checks per-device mismatch.
* - Does every run start?
* - Do all q0..q3 toggle?
* - f distribution
* ===========================

** ngr_lib cornerMOSlv.lib mos_tt_mismatch
** ngr_lib cornerRES.lib res_typ_mismatch
** ngr_out f_raw f_buf f_q0 f_q1 f_q2 f_q3
** ngr_temp 25
** ngr_runs 100
** ngr_name octs-full-tb-mc-mismatch-25c
** ngr_param vdd 1.2

.option rshunt=1e12
.option klu
.param vdd=1.2
.csparam vth=\{vdd/2\}
.control

tran 0.05n 1.25u

meas tran tp_raw \\
  + TRIG v(ro_raw) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(ro_raw) VAL=$&vth TD=10n RISE=2
let f_raw = 1/tp_raw
print f_raw
meas tran tp_buf \\
  + TRIG v(ro_buf) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(ro_buf) VAL=$&vth TD=10n RISE=2
let f_buf = 1/tp_buf
print f_buf
meas tran tp_q0 \\
  + TRIG v(q0) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q0) VAL=$&vth TD=10n RISE=2
let f_q0 = 1/tp_q0
print f_q0
meas tran tp_q1 \\
  + TRIG v(q1) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q1) VAL=$&vth TD=10n RISE=2
let f_q1 = 1/tp_q1
print f_q1
meas tran tp_q2 \\
  + TRIG v(q2) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q2) VAL=$&vth TD=10n RISE=2
let f_q2 = 1/tp_q2
print f_q2
meas tran tp_q3 \\
  + TRIG v(q3) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q3) VAL=$&vth TD=10n RISE=2
let f_q3= 1/tp_q3
print f_q3

write $rawfile en en_n ro_raw ro_buf q0 q1 q2 q3
.endc
"
spice_ignore=true}
C {digital/div16/xschem/div16.sym} 1040 -360 0 0 {name=x3}
C {simulator_commands.sym} 390 -650 0 0 {name=mc-mm-stat-pvt
simulator=ngspice
only_toplevel=false 
value="

* ===========================
* Checks per-device mismatch.
* - f_ro(T):
*   - slope
*   - linearity/monotonicity
* ===========================

** ngr_lib cornerMOSlv.lib mos_tt_mismatch mos_tt_stat
** ngr_lib cornerRES.lib res_typ_mismatch
** ngr_out f_raw f_buf f_q0 f_q1 f_q2 f_q3 ivdd
** ngr_temp -20 25 80 120 140
** ngr_runs 20
** ngr_name octs-full-tb-mc-mm-stat-pvt
** ngr_param vdd 1.08 1.2 1.32

.option rshunt=1e12
.option klu
.param vdd=1.2
.csparam vth=\{vdd/2\}
.control

tran 0.05n 300n

meas tran tp_raw \\
  + TRIG v(ro_raw) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(ro_raw) VAL=$&vth TD=10n RISE=2
let f_raw = 1/tp_raw
print f_raw
meas tran tp_buf \\
  + TRIG v(ro_buf) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(ro_buf) VAL=$&vth TD=10n RISE=2
let f_buf = 1/tp_buf
print f_buf
meas tran tp_q0 \\
  + TRIG v(q0) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q0) VAL=$&vth TD=10n RISE=2
let f_q0 = 1/tp_q0
print f_q0
meas tran tp_q1 \\
  + TRIG v(q1) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q1) VAL=$&vth TD=10n RISE=2
let f_q1 = 1/tp_q1
print f_q1
meas tran tp_q2 \\
  + TRIG v(q2) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q2) VAL=$&vth TD=10n RISE=2
let f_q2 = 1/tp_q2
print f_q2
meas tran tp_q3 \\
  + TRIG v(q3) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q3) VAL=$&vth TD=10n RISE=2
let f_q3= 1/tp_q3
print f_q3

print i(vdd)

write $rawfile en en_n ro_raw ro_buf q0 q1 q2 q3
.endc
"
spice_ignore=true}
C {simulator_commands.sym} 520 -650 0 0 {name=mc-stat-tsweep
simulator=ngspice
only_toplevel=false 
value="

* ===========================
* Checks chip-to-chip mismatch.
* - f_ro(T):
*   - slope
*   - linearity/monotonicity
* ===========================

** ngr_lib cornerMOSlv.lib mos_tt_stat
** ngr_lib cornerRES.lib res_typ_stat
** ngr_out f_raw f_buf f_q0 f_q1 f_q2 f_q3
** ngr_temp -20 25 80 120 140
** ngr_runs 100
** ngr_name octs-full-tb-mc-stat-tsweep
** ngr_param vdd 1.2

.option rshunt=1e12
.option klu
.param vdd=1.2
.csparam vth=\{vdd/2\}
.control

tran 0.05n 1.25u

meas tran tp_raw \\
  + TRIG v(ro_raw) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(ro_raw) VAL=$&vth TD=10n RISE=2
let f_raw = 1/tp_raw
print f_raw
meas tran tp_buf \\
  + TRIG v(ro_buf) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(ro_buf) VAL=$&vth TD=10n RISE=2
let f_buf = 1/tp_buf
print f_buf
meas tran tp_q0 \\
  + TRIG v(q0) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q0) VAL=$&vth TD=10n RISE=2
let f_q0 = 1/tp_q0
print f_q0
meas tran tp_q1 \\
  + TRIG v(q1) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q1) VAL=$&vth TD=10n RISE=2
let f_q1 = 1/tp_q1
print f_q1
meas tran tp_q2 \\
  + TRIG v(q2) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q2) VAL=$&vth TD=10n RISE=2
let f_q2 = 1/tp_q2
print f_q2
meas tran tp_q3 \\
  + TRIG v(q3) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q3) VAL=$&vth TD=10n RISE=2
let f_q3= 1/tp_q3
print f_q3

write $rawfile en en_n ro_raw ro_buf q0 q1 q2 q3
.endc
"
spice_ignore=true}
C {simulator_commands.sym} 650 -650 0 0 {name=mc-stat-tsweep1
simulator=ngspice
only_toplevel=false 
value="

* ===========================
* Checks chip-to-chip mismatch.
* - f_ro(T):
*   - slope
*   - linearity/monotonicity
* ===========================

** ngr_lib cornerMOSlv.lib mos_tt_mismatch mos_tt_stat
** ngr_lib cornerRES.lib res_typ_stat
** ngr_out f_raw f_buf f_q0 f_q1 f_q2 f_q3
** ngr_temp -20 25 80 120 140
** ngr_runs 50
** ngr_name octs-full-tb-mc-mm-stat-vt
** ngr_param vdd 1.08 1.2 1.32

.option rshunt=1e12
.option klu
.param vdd=1.2
.csparam vth=\{vdd/2\}
.control

tran 0.05n 1.25u

meas tran tp_raw \\
  + TRIG v(ro_raw) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(ro_raw) VAL=$&vth TD=10n RISE=2
let f_raw = 1/tp_raw
print f_raw
meas tran tp_buf \\
  + TRIG v(ro_buf) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(ro_buf) VAL=$&vth TD=10n RISE=2
let f_buf = 1/tp_buf
print f_buf
meas tran tp_q0 \\
  + TRIG v(q0) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q0) VAL=$&vth TD=10n RISE=2
let f_q0 = 1/tp_q0
print f_q0
meas tran tp_q1 \\
  + TRIG v(q1) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q1) VAL=$&vth TD=10n RISE=2
let f_q1 = 1/tp_q1
print f_q1
meas tran tp_q2 \\
  + TRIG v(q2) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q2) VAL=$&vth TD=10n RISE=2
let f_q2 = 1/tp_q2
print f_q2
meas tran tp_q3 \\
  + TRIG v(q3) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q3) VAL=$&vth TD=10n RISE=2
let f_q3= 1/tp_q3
print f_q3

write $rawfile en en_n ro_raw ro_buf q0 q1 q2 q3 isupply
.endc
"
spice_ignore=true}
C {lab_pin.sym} 430 -190 0 0 {name=p2 sig_type=std_logic lab=en}
C {capa.sym} 750 -100 0 0 {name=C2
m=1
value=0.1f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 750 -70 0 0 {name=l12 lab=0}
C {lab_pin.sym} 750 -150 1 0 {name=p17 sig_type=std_logic lab=ro_buf}
C {lab_pin.sym} 350 -410 0 0 {name=p5 sig_type=std_logic lab=en}
C {lab_pin.sym} 590 -190 2 0 {name=p3 sig_type=std_logic lab=en_n}
C {lab_pin.sym} 920 -380 0 0 {name=p1 sig_type=std_logic lab=en_n}
C {simulator_commands.sym} 260 -820 0 0 {name=mc-stat-25c
simulator=ngspice
only_toplevel=false 
value="

* ===========================
* Checks per-device mismatch.
* - Does every run start?
* - Do all q0..q3 toggle?
* - f distribution
* ===========================

** ngr_lib cornerMOSlv.lib mos_tt_stat
** ngr_lib cornerRES.lib res_typ_mismatch
** ngr_out f_raw f_buf f_q0 f_q1 f_q2 f_q3
** ngr_temp 25
** ngr_runs 100
** ngr_name octs-full-tb-mc-mismatch-25c
** ngr_param vdd 1.2

.option rshunt=1e12
.option klu
.param vdd=1.2
.csparam vth=\{vdd/2\}
.control

tran 0.05n 1.25u

meas tran tp_raw \\
  + TRIG v(ro_raw) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(ro_raw) VAL=$&vth TD=10n RISE=2
let f_raw = 1/tp_raw
print f_raw
meas tran tp_buf \\
  + TRIG v(ro_buf) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(ro_buf) VAL=$&vth TD=10n RISE=2
let f_buf = 1/tp_buf
print f_buf
meas tran tp_q0 \\
  + TRIG v(q0) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q0) VAL=$&vth TD=10n RISE=2
let f_q0 = 1/tp_q0
print f_q0
meas tran tp_q1 \\
  + TRIG v(q1) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q1) VAL=$&vth TD=10n RISE=2
let f_q1 = 1/tp_q1
print f_q1
meas tran tp_q2 \\
  + TRIG v(q2) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q2) VAL=$&vth TD=10n RISE=2
let f_q2 = 1/tp_q2
print f_q2
meas tran tp_q3 \\
  + TRIG v(q3) VAL=$&vth TD=10n RISE=1 \\
  + TARG v(q3) VAL=$&vth TD=10n RISE=2
let f_q3= 1/tp_q3
print f_q3

write $rawfile en en_n ro_raw ro_buf q0 q1 q2 q3
.endc
"
spice_ignore=true}
