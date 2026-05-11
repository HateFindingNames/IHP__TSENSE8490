v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 510 -660 1310 -350 {flags=graph
y1=0
y2=1.9
ypos1=0
ypos2=1.9
divy=5
subdivy=1
unity=1
x1=2.836005e-17
x2=1e-07
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="vin
vout
rst_n"
color="4 5 6"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tff_tb.raw
autoload=1
sim_type=tran
digital=1
vlegend=0
rainbow=0
legend=1}
N 340 -280 340 -190 {lab=vdd}
N 820 -240 850 -240 {lab=vout}
N 400 -240 400 -190 {lab=vin}
N 580 -200 720 -200 {lab=rst_n}
N 580 -200 580 -190 {lab=rst_n}
N 400 -240 720 -240 {lab=vin}
N 340 -280 770 -280 {lab=vdd}
C {simulator_commands.sym} 120 -590 0 0 {name=tff_includes
simulator=ngspice
only_toplevel=false 
value="
.include /foss/pdks/ihp-sg13cmos5l/libs.ref/sg13cmos5l_stdcell/spice/sg13cmos5l_stdcell.spice
"
}
C {simulator_commands.sym} -10 -590 0 0 {name=Libs_Ngspice
simulator=ngspice
only_toplevel=false 
value="
.lib cornerMOSlv.lib mos_tt
.lib cornerMOShv.lib mos_tt
.lib cornerRES.lib res_typ
.lib cornerDIO.lib dio_tt
"
}
C {digital/tff/xschem/tff.sym} 720 -160 0 0 {name=x1}
C {gnd.sym} 400 -130 0 0 {name=l1 lab=0}
C {vsource.sym} 400 -160 0 0 {name=V1 value="pulse 0 1.2 0 1n 1n 10n 20n" savecurrent=false}
C {vsource.sym} 340 -160 0 0 {name=V2 value=1.2 savecurrent=false}
C {gnd.sym} 340 -130 0 0 {name=l2 lab=0}
C {gnd.sym} 770 -160 0 0 {name=l3 lab=0}
C {lab_pin.sym} 850 -240 2 0 {name=p1 sig_type=std_logic lab=vout}
C {simulator_commands_shown.sym} 270 -590 0 0 {name="NGSPICE transient"
simulator=ngspice
only_toplevel=false 
value="
.param temp=27
.control
tran 0.2n 100n
write tff_tb.raw
.endc
"}
C {devices/launcher.sym} 190 -350 0 0 {name=h3
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file rootname [file tail [xschem get current_name]]].raw dc
xschem setprop rect 2 0 fullxzoom
"
}
C {launcher.sym} 190 -400 0 0 {name=h4
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
C {lab_pin.sym} 400 -220 0 0 {name=p2 sig_type=std_logic lab=vin}
C {lab_pin.sym} 340 -220 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {gnd.sym} 580 -130 0 0 {name=l4 lab=0}
C {vsource.sym} 580 -160 0 0 {name=V3 value="pwl 0 0 5n 0 5.1n 1.2" savecurrent=false}
C {lab_pin.sym} 580 -200 0 0 {name=p4 sig_type=std_logic lab=rst_n}
