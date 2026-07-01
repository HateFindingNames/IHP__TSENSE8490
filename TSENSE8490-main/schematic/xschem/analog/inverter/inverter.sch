v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 230 -10 230 50 {
lab=neg}
N 280 -40 280 50 {
lab=neg}
N 230 -40 280 -40 {
lab=neg}
N 230 -140 280 -140 {
lab=pos}
N 230 -90 230 -70 {
lab=out}
N 230 -240 230 -170 {
lab=pos}
N 280 -240 280 -140 {
lab=pos}
N 160 -40 190 -40 {
lab=in}
N 160 -140 190 -140 {
lab=in}
N 230 -90 360 -90 {
lab=out}
N 230 -110 230 -90 {
lab=out}
N 230 -240 280 -240 {
lab=pos}
N 230 50 280 50 {lab=neg}
N 160 -90 160 -40 {lab=in}
N 120 -90 160 -90 {lab=in}
N 160 -140 160 -90 {lab=in}
N 230 50 230 70 {lab=neg}
N 230 -260 230 -240 {lab=pos}
C {sg13g2_pr/sg13_lv_nmos.sym} 210 -40 0 0 {name=M1
l=0.13u
w=\{wn\}
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 210 -140 2 1 {name=M2
l=0.13u
*w=1.12u
w=\{wp\}
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {ipin.sym} 120 -90 0 0 {name=p1 lab=in}
C {iopin.sym} 230 -260 3 0 {name=p2 lab=pos}
C {iopin.sym} 230 70 1 0 {name=p3 lab=neg}
C {opin.sym} 360 -90 0 0 {name=p4 lab=out
}
