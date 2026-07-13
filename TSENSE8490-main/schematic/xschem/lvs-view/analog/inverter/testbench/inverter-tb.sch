v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 340 -780 1140 -380 {flags=graph
y1=0
y2=0.01
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=4e-06
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
rawfile=$netlist_dir/inverter-tb.raw
color="4 7"
node="a
y"}
N 290 -200 290 -180 {lab=A}
N 140 -200 140 -180 {lab=VSS}
N 620 -200 620 -180 {
lab=Y}
N 580 -250 580 -150 {lab=A}
N 640 -280 640 -250 {lab=VDD}
N 620 -250 640 -250 {
lab=VDD}
N 620 -280 640 -280 {lab=VDD}
N 620 -300 620 -280 {lab=VDD}
N 640 -150 640 -120 {lab=VSS}
N 620 -150 640 -150 {
lab=VSS}
N 620 -120 640 -120 {lab=VSS}
N 620 -120 620 -100 {lab=VSS}
N 620 -200 780 -200 {lab=Y}
N 620 -220 620 -200 {
lab=Y}
C {gnd.sym} 290 -120 0 0 {name=l1 lab=0}
C {vsource.sym} 290 -150 0 0 {name=V1 value="pulse 0 1.6 30n 1n 1n 10n 20n" savecurrent=false}
C {vsource.sym} 210 -150 0 0 {name=V2 value=1.2 savecurrent=false}
C {gnd.sym} 210 -120 0 0 {name=l3 lab=0}
C {lab_pin.sym} 140 -200 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {vdd.sym} 210 -180 0 0 {name=l2 lab=VDD}
C {code.sym} 0 -540 0 0 {name=transient only_toplevel=false value="
.param temp=27
.param WP=1.12u WN=0.74u
.control

tran 0.2n 100n

write inverter-tb.raw a y
.endc
"
}
C {devices/launcher.sym} 80 -360 0 0 {name=h3
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file rootname [file tail [xschem get current_name]]].raw
xschem setprop rect 2 0 fullxzoom
"
}
C {launcher.sym} 80 -400 0 0 {name=h4
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
C {simulator_commands.sym} 0 -700 0 0 {name=Libs_Ngspice1
simulator=ngspice
only_toplevel=false 
value="
.lib cornerMOSlv.lib mos_tt
.lib cornerMOShv.lib mos_tt
.lib cornerRES.lib res_typ
.lib cornerDIO.lib dio_tt
"}
C {vsource.sym} 140 -150 0 0 {name=V3 value=0 savecurrent=false}
C {gnd.sym} 140 -120 0 0 {name=l5 lab=0}
C {lab_pin.sym} 290 -200 0 0 {name=p2 sig_type=std_logic lab=A}
C {lab_wire.sym} 780 -200 0 1 {name=p3 sig_type=std_logic lab=Y}
C {capa.sym} 730 -170 0 0 {name=C2
m=1
value=0.2p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 730 -140 0 0 {name=l6 lab=0}
C {lab_pin.sym} 580 -200 0 0 {name=p5 sig_type=std_logic lab=A}
C {lab_pin.sym} 620 -100 3 0 {name=p6 sig_type=std_logic lab=VSS}
C {vdd.sym} 620 -300 0 0 {name=l7 lab=VDD}
C {title.sym} 160 0 0 0 {name=l8 author="Dennis Hunter"}
C {sg13g2_pr/sg13_lv_nmos.sym} 600 -150 0 0 {name=M1
l=0.13u
w=\{WN\}
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 600 -250 2 1 {name=M2
l=0.13
w=\{WP\}
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {code.sym} 120 -540 0 0 {name=transient1 only_toplevel=false value="
.param temp=27
.param WN=1u WP=1u
.control
set wr_vecnames
set wr_onespace
*set wr_singlescale

* create one persistent plot for all sweep results
setplot new
set scratch = $curplot

* sweep value lists
compose wn_list values 0.5u 1u 2u 4u
compose wp_list values 1u 2u 4u 8u

let nwp = length(wp_list)
let nwn = length(wn_list)
let nruns = nwn * nwp
let nlast = nruns - 1

* flattened table columns
compose run start=0 stop=$&nlast step=1
let wp_vec   = vector(length(run))
let wn_vec   = vector(length(run))
let tplh_vec = vector(length(run))
let tphl_vec = vector(length(run))

let iwn = 0
let k   = 0

while iwn < nwn
  let iwp = 0

  while iwp < nwp
    * current sweep values
    let wp_now = wp_list[iwp]
    let wn_now = wn_list[iwn]

    alterparam WP = $&wp_now
    alterparam WN = $&wn_now
    reset

    tran 0.2n 100n

    meas tran tplh trig v(a) val=0.8 td=20n rise=1 \\
    +              targ v(y) val=0.8 td=20n rise=1

    meas tran tphl trig v(a) val=0.8 td=20n fall=1 \\
    +              targ v(y) val=0.8 td=20n fall=1

    * remember current tran plot
    set dt = $curplot

    * go back to scratch plot and store one row
    setplot $scratch
    let wp_vec[k]   = wp_now
    let wn_vec[k]   = wn_now
    let tplh_vec[k] = \{$dt\}.tplh
    let tphl_vec[k] = \{$dt\}.tphl

    let k   = k + 1
    let iwp = iwp + 1
  end

  let iwn = iwn + 1
end

*wrdata inverter-tb-meas.tbl run wp_vec wn_vec tplh_vec tphl_vec
write inverter-tb-meas.raw run wp_vec wn_vec tplh_vec tphl_vec
*print wp_vec wn_vec tplh_vec tphl_vec > inverter-tb-meas.txt
.endc
"
}
C {devices/launcher.sym} 80 -320 0 0 {name=h1
descr="annotate_op" 
tclcommand="
xschem annotate_op $netlist_dir/inverter-tb.raw
"
}
C {ngspice_get_expr.sym} 1170 -410 0 0 {name=r1 node="
tcleval([xschem raw read $netlist_dir/[file tail [file rootname [xschem get current_name]]]-meas.raw
  set table "run,wp_vec,wn_vec,tplh_vec,tphl_vec"
  foreach run [xschem raw values run] wp_vec [xschem raw values wp_vec] wn_vec [xschem raw values wn_vec] tplh_vec [xschem raw values tplh_vec] tphl_vec [xschem raw values tphl_vec] \{
    append table \\\\n [run] \{,\} [to_eng $wp_vec] \{,\} [to_eng $wn_vec] \{,\} [to_eng $tplh_vec] \{,\} [to_eng $tphl_vec]
  \}
  xschem raw switch 0
  return [tabulate $table ,]])
"}
