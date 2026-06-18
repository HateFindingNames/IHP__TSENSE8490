v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 310 -810 1110 -410 {flags=graph
y1=1.8e+08
y2=4.6e+08
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=-20
x2=140
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
sim_type=table
autoload=1
hilight_wave=-1
vlegend=0
legend=1
mode=Line
color=4
node=frequency
hcursor1_y=2.4289826e+08
rawfile=$netlist_dir/temp-sens-core_temp-sweep.raw}
B 2 1130 -810 1930 -410 {flags=graph
y1=-0.031
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
dataset=-1
unitx=1
logx=0
logy=0
sim_type=tran
autoload=1
color=4
node=tran5.v(ro_raw)
rawfile=$netlist_dir/temp-sens-core_temp-sweep_temp25_wave.raw}
B 2 1130 -1230 1930 -830 {flags=graph
y1=0
y2=1.3
ypos1=0
ypos2=1.3
divy=5
subdivy=1
unity=1
x1=0
x2=3e-07
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="tran5.en
tran5.en_n"
color="5 6"
dataset=-1
unitx=1
logx=0
logy=0
sim_type=tran
autoload=1
sweep=time
digital=1
rawfile=$netlist_dir/temp-sens-core_temp-sweep_temp25_wave.raw}
T {tcleval([
  xschem raw read "$netlist_dir/temp-sens-core_temp-sweep_temp25_wave"
  set v [xschem raw value f 0 0]

  return "tt/f = [to_eng $v]Hz"
])
} 1137.5 -405 0 0 0.2 0.2 {floater=1}
N 130 -120 130 -110 {lab=0}
N 110 -110 130 -110 {lab=0}
N 90 -120 90 -110 {lab=0}
N 110 -110 110 -100 {lab=0}
N 90 -110 110 -110 {lab=0}
N 90 -190 90 -180 {lab=VDD}
N 130 -190 130 -180 {lab=VDD}
N 90 -190 130 -190 {lab=VDD}
N 280 -190 280 -170 {lab=VDD}
N 760 -180 770 -180 {lab=VDD}
N 760 -190 760 -180 {lab=VDD}
N 760 -120 770 -120 {lab=0}
N 760 -120 760 -110 {lab=0}
N 1030 -150 1050 -150 {lab=ro_raw}
N 390 -240 390 -170 {lab=EN}
N 390 -240 470 -240 {lab=EN}
N 510 -240 510 -220 {lab=EN_n}
N 470 -240 470 -190 {lab=EN}
N 510 -320 510 -290 {lab=VDD}
N 510 -190 510 -160 {lab=0}
N 510 -240 560 -240 {lab=EN_n}
N 510 -260 510 -240 {lab=EN_n}
N 470 -290 470 -240 {lab=EN}
N 740 -160 770 -160 {lab=EN}
N 740 -140 770 -140 {lab=EN_n}
N 1030 -150 1030 -130 {lab=ro_raw}
N 1010 -150 1030 -150 {lab=ro_raw}
C {vsource.sym} 280 -140 0 0 {name=Vdd value=1.2 savecurrent=false}
C {title.sym} 160 0 0 0 {name=l6 author="Dennis Hunter"}
C {devices/launcher.sym} 60 -460 0 0 {name=h3
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file rootname [file tail temp-sens-core_temp-sweep_temp25_wave]].raw
xschem raw_read $netlist_dir/[file rootname [file tail temp-sens-core_temp-sweep]].raw
xschem setprop rect 2 0 fullxzoom
"
}
C {launcher.sym} 60 -500 0 0 {name=h4
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
C {lab_pin.sym} 1050 -150 2 0 {name=p7 sig_type=std_logic lab=ro_raw}
C {simulator_commands.sym} 0 -660 0 0 {name=temp_sweep
simulator=ngspice
only_toplevel=false 
value="
** ngr_lib cornerMOSlv.lib mos_tt mos_ff mos_ss mos_tt_mismatch
** ngr_lib cornerRES.lib res_typ
** ngr_out f
** ngr_name temp-sens-core_temp-sweep-tb

.option rshunt=1e12
.option klu
*.param cpar=0
*.param lstarv=0.18u
.control
let temp_start = -20
let temp_stop = 140
let temp_delta = 10

* Create one plot that will hold the sweep results
setplot new
set scratch = $curplot

compose temperature start=$&temp_start stop=$&temp_stop step=$&temp_delta
let frequency = vector(length(temperature))

let i = 0
let tcur = temp_start
while tcur <= temp_stop
  option temp = $&tcur

  tran 0.05n 300n

  meas tran tperiod \\
  + TRIG v(ro_raw) VAL=0.6 RISE=2 TD=75n \\
  + TARG v(ro_raw) VAL=0.6 RISE=3 TD=75n

  * Remember the just-created tran plot
  set dt = $curplot

  * Go back to the scratch plot before touching loop variables
  setplot $scratch

  if tcur = 20
    write temp-sens-core_temp-sweep_temp25_wave.raw \{$dt\}.time \{$dt\}.v(ro_raw) \{$dt\}.en \{$dt\}.en_n
    let time25 = \{$dt\}.time
    let f = 1/\{$dt\}.tperiod
    print f
    let ro_raw25 = \{$dt\}.v(ro_raw)
  end

  let frequency[i] = 1/\{$dt\}.tperiod
  let tcur = tcur + temp_delta
  let i = i+1
end

setplot $scratch

*settype temp-sweep temperature
settype frequency frequency
*setscale frequency temperature
**write temp-sens-core_temp-sweep.raw temperature frequency
write $rawfile temperature ro_raw en en_n frequency
.endc
"
}
C {simulator_commands.sym} 0 -840 0 0 {name=Libs_Ngspice1
simulator=ngspice
only_toplevel=false 
value="
.lib cornerMOSlv.lib mos_tt
.lib cornerMOShv.lib mos_tt
.lib cornerRES.lib res_typ
.lib cornerDIO.lib dio_tt
"}
C {simulator_commands.sym} 130 -840 0 0 {name=tff_includes
simulator=ngspice
only_toplevel=false 
value="
.include sg13cmos5l_stdcell.spice
"
}
C {vdd.sym} 760 -190 0 0 {name=l2 lab=VDD}
C {gnd.sym} 760 -110 0 0 {name=l4 lab=0}
C {analog/temp-sens-core/temp_sens_core.sym} 890 -160 0 0 {name=x1 lstarv=0.46u cpar=0f}
C {lab_pin.sym} 390 -190 2 0 {name=p1 sig_type=std_logic lab=EN}
C {gnd.sym} 390 -110 0 0 {name=l12 lab=0}
C {lab_pin.sym} 560 -240 2 0 {name=p2 sig_type=std_logic lab=EN_n}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 490 -190 0 0 {name=M6
l=0.13u
w=1u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 490 -290 0 0 {name=M7
l=0.13u
w=2u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {gnd.sym} 510 -160 0 0 {name=l5 lab=0}
C {vdd.sym} 510 -320 0 0 {name=l23 lab=VDD}
C {vsource.sym} 390 -140 0 0 {name=V2 value="pulse 0 1.2 50n 1n 1n 200n 400n" savecurrent=false}
C {lab_pin.sym} 740 -140 0 0 {name=p3 sig_type=std_logic lab=EN_n}
C {lab_pin.sym} 740 -160 0 0 {name=p4 sig_type=std_logic lab=EN}
C {capa.sym} 1030 -100 0 0 {name=C1
m=1
value=0.2f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 1030 -70 0 0 {name=l7 lab=0}
C {launcher.sym} 60 -415 0 0 {name=h2
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
