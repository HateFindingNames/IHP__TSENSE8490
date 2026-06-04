v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 1300 -270 2100 -50 {flags=graph
y1=-0.086
y2=1.3
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=1e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
sim_type=tran
autoload=1
sweep=time
color=4
node=ro_raw
rawfile=$netlist_dir/temp-sens-core_pvt_tt.raw}
B 2 1300 -920 2100 -750 {flags=graph
y1=0
y2=4
ypos1=0
ypos2=1.3
divy=5
subdivy=1
unity=1
x1=0
x2=1e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="en
en_n"
color="5 6"
dataset=-1
unitx=G
logx=0
logy=0
sim_type=tran
autoload=1
sweep=time
digital=1
rawfile=$netlist_dir/temp-sens-core_pvt_tt.raw
vlegend=0
legendmag=1
legend=0}
B 2 1300 -510 2100 -290 {flags=graph
y1=-0.037875
y2=1.348125
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=1e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
sim_type=tran
autoload=1
sweep=time
color=4
node=ro_raw
rawfile=$netlist_dir/temp-sens-core_pvt_ss.raw}
B 2 1300 -750 2100 -530 {flags=graph
y1=-0.037875
y2=1.348125
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=1e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
sim_type=tran
autoload=1
sweep=time
color=4
node=ro_raw
rawfile=$netlist_dir/temp-sens-core_pvt_ff.raw}
T {tcleval(deltaf: [to_eng [expr [xschem raw value f]]]Hz)} 2120 -100 0 0 0.4 0.4 {floater=1}
N 130 -120 130 -110 {lab=0}
N 110 -110 130 -110 {lab=0}
N 90 -120 90 -110 {lab=0}
N 110 -110 110 -100 {lab=0}
N 90 -110 110 -110 {lab=0}
N 90 -190 90 -180 {lab=VDD}
N 130 -190 130 -180 {lab=VDD}
N 90 -190 130 -190 {lab=VDD}
N 350 -240 350 -170 {lab=EN}
N 350 -240 430 -240 {lab=EN}
N 470 -240 470 -220 {lab=EN_n}
N 430 -240 430 -190 {lab=EN}
N 470 -320 470 -290 {lab=VDD}
N 470 -190 470 -160 {lab=0}
N 470 -240 520 -240 {lab=EN_n}
N 470 -260 470 -240 {lab=EN_n}
N 430 -290 430 -240 {lab=EN}
N 280 -190 280 -170 {lab=VDD}
N 760 -190 770 -190 {lab=VDD}
N 760 -200 760 -190 {lab=VDD}
N 760 -130 770 -130 {lab=0}
N 760 -130 760 -120 {lab=0}
N 1010 -160 1050 -160 {lab=ro_raw}
N 710 -150 770 -150 {lab=EN_n}
N 710 -170 770 -170 {lab=EN}
C {vsource.sym} 280 -140 0 0 {name=Vdd value=1.2 savecurrent=false}
C {title.sym} 160 0 0 0 {name=l6 author="Dennis Hunter"}
C {devices/launcher.sym} 60 -330 0 0 {name=h3
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file rootname [file tail [xschem get current_name]]].raw
xschem setprop rect 2 0 fullxzoom
"
}
C {launcher.sym} 60 -370 0 0 {name=h4
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
C {sg13cmos5l_pr/ntap1.sym} 90 -150 2 0 {name=R3
model=ntap1
spiceprefix=X
w=0.78e-6
l=0.78e-6
}
C {sg13cmos5l_pr/ptap1.sym} 130 -150 0 0 {name=R4
model=ptap1
spiceprefix=X
w=0.78e-6
l=0.78e-6
}
C {gnd.sym} 110 -100 0 0 {name=l3 lab=0}
C {gnd.sym} 280 -110 0 0 {name=l1 lab=0}
C {vdd.sym} 280 -190 0 0 {name=l9 lab=VDD}
C {vdd.sym} 110 -190 0 0 {name=l10 lab=VDD}
C {lab_pin.sym} 350 -190 2 0 {name=p1 sig_type=std_logic lab=EN}
C {gnd.sym} 350 -110 0 0 {name=l12 lab=0}
C {simulator_commands.sym} 1140 -160 0 0 {name=EN_behavior_tt
simulator=ngspice
only_toplevel=false 
value="
.lib cornerMOSlv.lib mos_tt
.lib cornerRES.lib res_typ

.option rshunt=1e12
.option klu
.control

tran 0.1n 1u

meas tran tperiod \\
+ TRIG v(ro_raw) VAL=0.9 RISE=2 TD=60n \\
+ TARG v(ro_raw) VAL=0.9 RISE=3 TD=60n

let f = 1/tperiod

write temp-sens-core_pvt_tt.raw time ro_raw en en_n f
.endc
"
}
C {lab_pin.sym} 520 -240 2 0 {name=p2 sig_type=std_logic lab=EN_n}
C {simulator_commands.sym} 0 -520 0 0 {name=tff_includes
simulator=ngspice
only_toplevel=false 
value="
.include /foss/pdks/ihp-sg13cmos5l/libs.ref/sg13cmos5l_stdcell/spice/sg13cmos5l_stdcell.spice
"
}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 450 -190 0 0 {name=M6
l=0.13u
w=1u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 450 -290 0 0 {name=M7
l=0.13u
w=2u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {gnd.sym} 470 -160 0 0 {name=l5 lab=0}
C {vdd.sym} 470 -320 0 0 {name=l23 lab=VDD}
C {vsource.sym} 350 -140 0 0 {name=V2 value="pulse 0 1.2 50n 1n 1n 50n 100n" savecurrent=false}
C {lab_pin.sym} 1050 -160 2 0 {name=p7 sig_type=std_logic lab=ro_raw}
C {vdd.sym} 760 -200 0 0 {name=l2 lab=VDD}
C {gnd.sym} 760 -120 0 0 {name=l4 lab=0}
C {analog/temp-sens-core/temp_sens_core.sym} 890 -170 0 0 {name=x1 lstarv=0.46u cpar=0f}
C {lab_pin.sym} 710 -150 0 0 {name=p3 sig_type=std_logic lab=EN_n}
C {lab_pin.sym} 710 -170 0 0 {name=p4 sig_type=std_logic lab=EN}
C {simulator_commands.sym} 1140 -400 0 0 {name=EN_behavior_ss
simulator=ngspice
only_toplevel=false 
value="
.lib cornerMOSlv.lib mos_ss
.lib cornerRES.lib res_typ

.option rshunt=1e12
.option klu
.control

tran 0.1n 1u

meas tran tperiod \\
+ TRIG v(ro_raw) VAL=0.9 RISE=2 TD=100n \\
+ TARG v(ro_raw) VAL=0.9 RISE=3 TD=100n

let f = 1/tperiod

write temp-sens-core_pvt_ss.raw time ro_raw en en_n
.endc
"
spice_ignore=true}
C {simulator_commands.sym} 1140 -640 0 0 {name=EN_behavior_ff
simulator=ngspice
only_toplevel=false 
value="
.lib cornerMOSlv.lib mos_ff
.lib cornerRES.lib res_typ

.option rshunt=1e12
.option klu
.control

tran 0.1n 1u

meas tran tperiod \\
+ TRIG v(ro_raw) VAL=0.9 RISE=2 TD=100n \\
+ TARG v(ro_raw) VAL=0.9 RISE=3 TD=100n

let f = 1/tperiod

write temp-sens-core_pvt_ff.raw time ro_raw en en_n
.endc
"
spice_ignore=true}
