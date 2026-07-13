v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 710 -590 1510 -190 {flags=graph
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
clk
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
digital=1
rawfile=$netlist_dir/div16-tb.raw}
N 140 -90 140 -80 {lab=0}
N 120 -80 140 -80 {lab=0}
N 100 -90 100 -80 {lab=0}
N 120 -80 120 -70 {lab=0}
N 100 -80 120 -80 {lab=0}
N 100 -160 100 -150 {lab=VDD}
N 140 -160 140 -150 {lab=VDD}
N 100 -160 140 -160 {lab=VDD}
N 290 -160 290 -140 {lab=VDD}
N 370 -160 370 -140 {lab=EN_n}
N 410 -260 410 -240 {lab=0}
N 410 -260 430 -260 {lab=0}
N 390 -280 430 -280 {lab=EN_n}
N 410 -340 410 -320 {lab=VDD}
N 410 -320 430 -320 {lab=VDD}
N 770 -160 770 -140 {lab=Q3}
N 710 -160 710 -140 {lab=Q2}
N 650 -160 650 -140 {lab=Q1}
N 590 -160 590 -140 {lab=Q0}
N 630 -320 650 -320 {lab=Q0}
N 630 -300 650 -300 {lab=Q1}
N 630 -280 650 -280 {lab=Q2}
N 630 -260 650 -260 {lab=Q3}
N 470 -160 470 -140 {lab=CLK}
N 390 -300 430 -300 {lab=CLK}
C {title.sym} 160 0 0 0 {name=l6 author="Dennis Hunter"}
C {devices/launcher.sym} 70 -350 0 0 {name=h3
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file rootname [file tail [xschem get current_name]]].raw dc
xschem setprop rect 2 0 fullxzoom
"
}
C {launcher.sym} 70 -400 0 0 {name=h4
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
C {launcher.sym} 70 -300 0 0 {name=h1
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
C {vsource.sym} 290 -110 0 0 {name=Vdd value=1.2 savecurrent=false}
C {sg13cmos5l_pr/ntap1.sym} 100 -120 2 0 {name=R3
model=ntap1
spiceprefix=X
w=0.78e-6
l=0.78e-6
}
C {sg13cmos5l_pr/ptap1.sym} 140 -120 0 0 {name=R4
model=ptap1
spiceprefix=X
w=0.78e-6
l=0.78e-6
}
C {gnd.sym} 120 -70 0 0 {name=l3 lab=0}
C {gnd.sym} 290 -80 0 0 {name=l1 lab=0}
C {vdd.sym} 290 -160 0 0 {name=l9 lab=VDD}
C {vdd.sym} 120 -160 0 0 {name=l10 lab=VDD}
C {lab_pin.sym} 370 -160 1 0 {name=p1 sig_type=std_logic lab=EN_n}
C {gnd.sym} 370 -80 0 0 {name=l12 lab=0}
C {vsource.sym} 370 -110 0 0 {name=V2 savecurrent=false
value="pulse 1.2 0 50n 1n 1n 200n 400n"}
C {simulator_commands.sym} 0 -540 0 0 {name=div16-tb
simulator=ngspice
only_toplevel=false 
value="
** ngr_lib cornerMOSlv.lib mos_tt mos_ff mos_ss mos_tt_mismatch
** ngr_lib cornerRES.lib res_typ
** ngr_out f
** ngr_name div16-tb

.option rshunt=1e12
.option klu
*.param cpar=0
*.param lstarv=0.18u
.control
set rawfile = div16-tb.raw

tran 0.05n 1u

*meas tran tperiod \\
*  + TRIG v(ro_raw) VAL=0.6 RISE=2 TD=75n \\
*  + TARG v(ro_raw) VAL=0.6 RISE=3 TD=75n

write $rawfile clk en_n q0 q1 q2 q3
.endc
"
}
C {simulator_commands.sym} 0 -720 0 0 {name=Libs_Ngspice1
simulator=ngspice
only_toplevel=false 
value="
.lib cornerMOSlv.lib mos_tt
.lib cornerMOShv.lib mos_tt
.lib cornerRES.lib res_typ
.lib cornerDIO.lib dio_tt
"}
C {simulator_commands.sym} 130 -720 0 0 {name=div16_includes
simulator=ngspice
only_toplevel=false 
value="
.include sg13cmos5l_stdcell.spice
*.include digital/div16/div16.spice
"
}
C {digital/div16/xschem/div16.sym} 530 -260 0 0 {}
C {gnd.sym} 410 -240 0 0 {name=l2 lab=0}
C {vdd.sym} 410 -340 0 0 {name=l4 lab=VDD}
C {lab_pin.sym} 390 -280 0 0 {name=p2 sig_type=std_logic lab=EN_n}
C {lab_pin.sym} 650 -320 2 0 {name=p3 sig_type=std_logic lab=Q0}
C {lab_pin.sym} 650 -280 2 0 {name=p4 sig_type=std_logic lab=Q2}
C {lab_pin.sym} 650 -300 2 0 {name=p5 sig_type=std_logic lab=Q1}
C {lab_pin.sym} 650 -260 2 0 {name=p6 sig_type=std_logic lab=Q3}
C {capa.sym} 590 -110 0 0 {name=C1
m=1
value=0.1f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 590 -80 0 0 {name=l5 lab=0}
C {capa.sym} 650 -110 0 0 {name=C2
m=1
value=0.1f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 650 -80 0 0 {name=l7 lab=0}
C {capa.sym} 710 -110 0 0 {name=C3
m=1
value=0.1f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 710 -80 0 0 {name=l8 lab=0}
C {capa.sym} 770 -110 0 0 {name=C4
m=1
value=0.1f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 770 -80 0 0 {name=l11 lab=0}
C {lab_pin.sym} 590 -160 2 0 {name=p7 sig_type=std_logic lab=Q0}
C {lab_pin.sym} 710 -160 2 0 {name=p8 sig_type=std_logic lab=Q2}
C {lab_pin.sym} 650 -160 2 0 {name=p9 sig_type=std_logic lab=Q1}
C {lab_pin.sym} 770 -160 2 0 {name=p10 sig_type=std_logic lab=Q3}
C {gnd.sym} 470 -80 0 0 {name=l13 lab=0}
C {vsource.sym} 470 -110 0 0 {name=V3 savecurrent=false value="pulse 0 1.2 0 0.05n 0.05n 2.5n 5n"}
C {lab_pin.sym} 470 -160 1 0 {name=p11 sig_type=std_logic lab=CLK}
C {lab_pin.sym} 390 -300 0 0 {name=p12 sig_type=std_logic lab=CLK}
