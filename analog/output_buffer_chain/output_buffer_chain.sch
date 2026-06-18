v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Small} 110 -360 0 0 0.4 0.4 {}
T {Medium} 280 -360 0 0 0.4 0.4 {}
T {Large} 470 -360 0 0 0.4 0.4 {}
N 140 -100 140 -50 {lab=VSS}
N 500 -100 500 -50 {lab=VSS}
N 320 -100 320 -50 {lab=VSS}
N 140 -150 140 -130 {lab=#net1}
N 280 -150 280 -100 {lab=#net1}
N 460 -150 460 -100 {lab=#net2}
N 500 -150 500 -130 {lab=OUT}
N 100 -150 100 -100 {lab=IN}
N 320 -150 320 -130 {lab=#net2}
N 320 -150 460 -150 {lab=#net2}
N 320 -170 320 -150 {lab=#net2}
N 460 -200 460 -150 {lab=#net2}
N 140 -150 280 -150 {lab=#net1}
N 140 -170 140 -150 {lab=#net1}
N 280 -200 280 -150 {lab=#net1}
N 500 -150 600 -150 {lab=OUT}
N 500 -170 500 -150 {lab=OUT}
N 40 -150 100 -150 {lab=IN}
N 100 -200 100 -150 {lab=IN}
N 140 -250 140 -200 {lab=VDD}
N 320 -250 320 -200 {lab=VDD}
N 500 -250 500 -200 {lab=VDD}
N 320 -250 500 -250 {lab=VDD}
N 140 -250 320 -250 {lab=VDD}
N 320 -50 500 -50 {lab=VSS}
N 140 -50 320 -50 {lab=VSS}
N 320 -260 320 -250 {lab=VDD}
N 320 -50 320 -40 {lab=VSS}
C {sg13g2_pr/sg13_lv_nmos.sym} 120 -100 0 0 {name=M1
l=0.45u
w=2.0u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 120 -200 2 1 {name=M2
l=0.45u
w=1.0u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} 300 -100 0 0 {name=M3
l=0.45u
w=4.0u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 300 -200 2 1 {name=M4
l=0.45u
w=2.0u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} 480 -100 0 0 {name=M5
l=0.45u
w=16.0u
ng=2
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 480 -200 2 1 {name=M6
l=0.45u
w=8.0u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {ipin.sym} 40 -150 0 0 {name=p0 lab=IN}
C {opin.sym} 600 -150 0 0 {name=p2 lab=OUT}
C {iopin.sym} 320 -40 1 0 {name=p3 lab=VSS}
C {iopin.sym} 320 -260 3 0 {name=p1 lab=VDD}
