v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 460 -1170 1260 -770 {flags=graph
y1=1.5e-05
y2=1.9e-05
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=-40
x2=125
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node=i(vmeas)
color=4
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/push-pull-temp-tb.raw
sim_type=dc
autoload=1}
N 730 -580 730 -510 {lab=VDD}
N 550 -510 690 -510 {lab=vgp}
N 550 -520 550 -510 {lab=vgp}
N 500 -510 550 -510 {lab=vgp}
N 500 -510 500 -470 {lab=vgp}
N 490 -510 500 -510 {lab=vgp}
N 450 -470 500 -470 {lab=vgp}
N 450 -480 450 -470 {lab=vgp}
N 550 -190 550 -180 {lab=vgn}
N 500 -230 500 -190 {lab=vgn}
N 500 -190 550 -190 {lab=vgn}
N 450 -580 450 -510 {lab=VDD}
N 370 -150 510 -150 {lab=0}
N 370 -550 510 -550 {lab=VDD}
N 550 -580 730 -580 {lab=VDD}
N 450 -470 450 -460 {lab=vgp}
N 490 -190 500 -190 {lab=vgn}
N 450 -230 450 -220 {lab=vgn}
N 450 -230 500 -230 {lab=vgn}
N 550 -120 730 -120 {lab=0}
N 730 -190 730 -120 {lab=0}
N 550 -580 550 -550 {lab=VDD}
N 450 -580 550 -580 {lab=VDD}
N 450 -190 450 -120 {lab=0}
N 550 -150 550 -120 {lab=0}
N 450 -120 550 -120 {lab=0}
N 550 -190 690 -190 {lab=vgn}
N 450 -250 450 -230 {lab=vgn}
N 450 -120 450 -100 {lab=0}
N 730 -480 730 -380 {lab=#net1}
N 730 -320 730 -220 {lab=#net2}
N 180 -470 180 -450 {lab=#net3}
N 180 -240 180 -220 {lab=#net4}
N 180 -240 350 -240 {lab=#net4}
N 180 -260 180 -240 {lab=#net4}
N 180 -470 350 -470 {lab=#net3}
N 180 -490 180 -470 {lab=#net3}
N 550 -440 550 -430 {lab=VDD}
N 550 -280 550 -270 {lab=0}
N 450 -430 550 -430 {lab=VDD}
N 450 -280 550 -280 {lab=0}
N 350 -470 350 -430 {lab=#net3}
N 350 -430 410 -430 {lab=#net3}
N 350 -280 350 -240 {lab=#net4}
N 350 -280 410 -280 {lab=#net4}
C {title.sym} 160 0 0 0 {name=l6 author="Dennis Hunter"}
C {vsource.sym} 50 -320 0 0 {name=V1 value=1.2 savecurrent=false}
C {gnd.sym} 50 -290 0 0 {name=l1 lab=0}
C {vdd.sym} 50 -350 0 0 {name=l9 lab=VDD}
C {devices/launcher.sym} 620 -680 0 0 {name=h3
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/push-pull-temp-tb.raw dc; xschem redraw
xschem raw_read $netlist_dir/push-pull-dc-sweep-tb.raw; xschem redraw
xschem setprop rect 2 0 fullxzoom
"
}
C {launcher.sym} 620 -720 0 0 {name=h4
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
C {simulator_commands_shown.sym} 0 -1140 0 0 {
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
C {simulator_commands_shown.sym} 0 -960 0 0 {name=NGSPICE transient1
simulator=ngspice
only_toplevel=false 
value="
#.include temp-sensing-ring-osci.save
.save all
.option rshunt=1e12
.param W=10u
.param temp=27
.control

reset
dc temp -40 125 0.5

write push-pull-temp-tb.raw
.endc
"
}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 710 -510 0 0 {name=M1
l=2u
w=1.5u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 530 -550 0 0 {name=M21
l=0.13u
w=1.5u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 530 -150 0 0 {name=M22
l=0.13u
w=1.5u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 470 -510 0 1 {name=M23
l=2u
w=1.5u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 470 -190 0 1 {name=M24
l=2u
w=1.5u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {lab_wire.sym} 670 -510 2 0 {name=p4 sig_type=std_logic lab=vgp}
C {lab_wire.sym} 620 -190 0 0 {name=p5 sig_type=std_logic lab=vgn}
C {gnd.sym} 450 -100 0 0 {name=l4 lab=0}
C {gnd.sym} 370 -150 0 0 {name=l5 lab=0}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 710 -190 0 0 {name=M4
l=2u
w=1.5u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {vdd.sym} 450 -580 0 0 {name=l8 lab=VDD}
C {vdd.sym} 450 -310 0 0 {name=l11 lab=VDD}
C {vdd.sym} 370 -550 0 0 {name=l10 lab=VDD}
C {ammeter.sym} 730 -350 0 0 {name=Vmeas savecurrent=true spice_ignore=0}
C {gnd.sym} 450 -400 0 0 {name=l2 lab=0}
C {sg13cmos5l_pr/rsil.sym} 180 -520 0 0 {name=R1
w=0.5e-6
l=75e-6
model=rsil
body=sub!
spiceprefix=X
b=0
m=1
value="expr_eng(  ( 9.0e-6 / @w + 7.0 * ( (@b + 1)* @l + ( 1.081*( @w + 1.0e-8 ) + 0.18e-6 )*@b ) / ( @w + 1.0e-8 ) ) / @m  )"
}
C {sg13cmos5l_pr/rsil.sym} 180 -420 0 0 {name=R2
w=0.5e-6
l=10e-6
model=rsil
body=sub!
spiceprefix=X
b=0
m=1
value="expr_eng(  ( 9.0e-6 / @w + 7.0 * ( (@b + 1)* @l + ( 1.081*( @w + 1.0e-8 ) + 0.18e-6 )*@b ) / ( @w + 1.0e-8 ) ) / @m  )"
}
C {gnd.sym} 180 -390 0 0 {name=l3 lab=0}
C {vdd.sym} 180 -550 0 0 {name=l13 lab=VDD}
C {sg13cmos5l_pr/rsil.sym} 180 -190 0 0 {name=R4
w=0.5e-6
l=75e-6
model=rsil
body=sub!
spiceprefix=X
b=0
m=1
value="expr_eng(  ( 9.0e-6 / @w + 7.0 * ( (@b + 1)* @l + ( 1.081*( @w + 1.0e-8 ) + 0.18e-6 )*@b ) / ( @w + 1.0e-8 ) ) / @m  )"
}
C {sg13cmos5l_pr/rsil.sym} 180 -290 0 0 {name=R3
w=0.5e-6
l=10e-6
model=rsil
body=sub!
spiceprefix=X
b=0
m=1
value="expr_eng(  ( 9.0e-6 / @w + 7.0 * ( (@b + 1)* @l + ( 1.081*( @w + 1.0e-8 ) + 0.18e-6 )*@b ) / ( @w + 1.0e-8 ) ) / @m  )"
}
C {gnd.sym} 180 -160 0 0 {name=l14 lab=0}
C {vdd.sym} 180 -320 0 0 {name=l15 lab=VDD}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 430 -430 0 0 {name=M2
l=0.13u
w=1u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 430 -280 0 0 {name=M3
l=0.13u
w=1u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {gnd.sym} 550 -270 0 0 {name=l7 lab=0}
C {vdd.sym} 550 -440 0 0 {name=l12 lab=VDD}
