v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 330 -650 1130 -250 {flags=graph
y1=-0.026
y2=1.7
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=1e-07
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="out
vp"
color="4 6"
dataset=-1
unitx=1
logx=0
logy=0
autoload=1
sim_type=tran
rawfile=$netlist_dir/output_buffer_chain-tb.raw}
B 2 1160 -650 1960 -250 {flags=graph
y1=0
y2=0.01
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=10000000
x2=10000000
divx=5
subdivx=4
xlabmag=1.0
ylabmag=1.0
legendmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/output_buffer_chain-tb_ac.raw
sim_type=ac
autoload=1
color="6 5 8"
node="re(out)
im(out)
ph(out)"}
P 4 1 120 -300 {}
N 420 -190 420 -170 {lab=vp}
N 890 -160 930 -160 {lab=out}
N 890 -160 890 -140 {lab=out}
N 850 -160 890 -160 {lab=out}
C {analog/output_buffer_chain/output_buffer_chain.sym} 630 -40 0 0 {name=x1}
C {gnd.sym} 420 -110 0 0 {name=l1 lab=0}
C {vsource.sym} 420 -140 0 0 {name=V1 value="pulse 0 1.2 0 1n 1n 10n 20n" savecurrent=false}
C {vsource.sym} 340 -140 0 0 {name=V2 value=1.6 savecurrent=false}
C {gnd.sym} 340 -110 0 0 {name=l3 lab=0}
C {lab_pin.sym} 420 -190 0 0 {name=p4 sig_type=std_logic lab=vp}
C {lab_pin.sym} 750 -160 0 0 {name=p3 sig_type=std_logic lab=vp}
C {title.sym} 160 0 0 0 {name=l6 author="Dennis Hunter"}
C {simulator_commands_shown.sym} 0 -450 0 0 {
name=Libs_Ngspice
simulator=ngspice
only_toplevel=false
value="
.lib cornerMOSlv.lib mos_tt
.lib cornerMOShv.lib mos_tt
.lib cornerRES.lib res_typ
.lib cornerDIO.lib dio_tt
"
      }
C {devices/launcher.sym} 80 -80 0 0 {name=h3
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file rootname [file tail [xschem get current_name]]].raw dc
xschem setprop rect 2 0 fullxzoom
"
}
C {launcher.sym} 80 -120 0 0 {name=h4
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
C {lab_wire.sym} 930 -160 0 1 {name=p7 sig_type=std_logic lab=out}
C {code.sym} 0 -270 0 0 {name=transient only_toplevel=false value="
.param temp=27
.control
tran 0.2n 100n
* Propagation delay
* input threshold = 0.6 V  (50% of 1.2 V input swing)
* output threshold = 0.8 V (50% of 1.6 V supply)
meas tran tplh trig v(vp)      val=0.6 td=20n rise=1 \\
+               targ v(out) val=0.8 td=20n rise=1

meas tran tphl trig v(vp)      val=0.6 td=20n fall=1 \\
+               targ v(out) val=0.8 td=20n fall=1

* Output rise / fall time (10%..90% of 1.6 V)
meas tran trise_out trig v(out) val=0.16 td=20n rise=1 \\
+                    targ v(out) val=1.44 td=20n rise=1

meas tran tfall_out trig v(out) val=1.44 td=20n fall=1 \\
+                    targ v(out) val=0.16 td=20n fall=1

write output_buffer_chain-tb.raw vp out
.endc
"
}
C {code.sym} 120 -270 0 0 {name=ac only_toplevel=false value="
.param temp=27
.control
ac dec 1000 10meg 100meg
*plot db(v(out)) phase(v(out))
write output_buffer_chain-tb_ac.raw out
.endc
"}
C {capa.sym} 890 -110 0 0 {name=C1
m=1
value=0.2p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 890 -80 0 0 {name=l4 lab=0}
C {vdd.sym} 340 -170 0 0 {name=l2 lab=VDD}
C {vdd.sym} 790 -200 0 0 {name=l5 lab=VDD}
C {gnd.sym} 790 -120 0 0 {name=l7 lab=0}
