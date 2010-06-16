
** ALU simulation stimulus file for hspiceD

*****************************parameter settings *******************************
.param my_vdd=1.2V
.param my_sim_time=10ns

*****************************power rails **************************************
.GLOBAL vdd
.GLOBAL vdd!

*vdd vdd gnd DC=my_vdd
*vdd! vdd! gnd! DC=my_vdd
vddConst vddConst gnd DC=my_vdd

vss vss gnd DC=0V

*****************************Simulation settings ******************************

.TRAN 20e-12 my_sim_time START=0.0
.OP

.TEMP 25
.OPTION
+    ARTIST=2
+    INGOLD=2
+    PARHIER=LOCAL
+    PSF=2
+    POST

*****************************Include your netlist here ************************

.INCLUDE "Alu.sp"
*.INCLUDE "minbuf.sp"
.INCLUDE "cp65npksdst.lvs"

*vddConst is powered by dc voltage, but vdd is driven by VDDPFET
Vpd PD gnd pulse (0V my_vdd 1.0ns 10ps 10ps 4.99ns 10ns)
MPFET vdd PD vddConst vddConst pfet L=0.06u W=6u M=120
MBPFET vdd! PD vddConst vddConst pfet L=0.06u W=6u M=120

.vec alu.vec

*****************************get the energy ***********************************

*.meas tran Qtot integral i(vdd!) from=10ps to=my_sim_time
*.meas tran Qtot2 integral i(vdd) from=10ps to=my_sim_time
*.meas Etot param='my_vdd*(Qtot+Qtot2)
.meas tran Qtot integral i(vddConst) from=10ps to=my_sim_time
.meas Etot param='my_vdd*(Qtot)

*****************************Clock define *************************************

* have to precharge the nodes first
*Vclk CLK gnd pulse (0V my_vdd 10ps 10ps 10ps 490ps 1ns)

*****************************INPUTS *******************************************

* data inputs
*xain<0> A<0> ain<0> SEN_BUF_1

* clock input
*xclk CLK inclk SEN_BUF_16

** Cell Under Test

xalu Z<31> Z<30> Z<29> Z<28> Z<27> Z<26> Z<25> Z<24> Z<23> Z<22> Z<21> 
+ Z<20> Z<19> Z<18> Z<17> Z<16> Z<15> Z<14> Z<13> Z<12> Z<11> Z<10> Z<9> Z<8> 
+ Z<7> Z<6> Z<5> Z<4> Z<3> Z<2> Z<1> Z<0> A<31> A<30> A<29> A<28> A<27> A<26> 
+ A<25> A<24> A<23> A<22> A<21> A<20> A<19> A<18> A<17> A<16> A<15> A<14> A<13> 
+ A<12> A<11> A<10> A<9> A<8> A<7> A<6> A<5> A<4> A<3> A<2> A<1> A<0> B<31> 
+ B<30> B<29> B<28> B<27> B<26> B<25> B<24> B<23> B<22> B<21> B<20> B<19> B<18> 
+ B<17> B<16> B<15> B<14> B<13> B<12> B<11> B<10> B<9> B<8> B<7> B<6> B<5> B<4> 
+ B<3> B<2> B<1> B<0> INST<3> INST<2> INST<1> INST<0> FLAGS<3> FLAGS<2> 
+ FLAGS<1> FLAGS<0> Alu 

*****************************OUTPUTS ***********************************

* the outputs with 1f load
c_outcap<31> Z<31> gnd 1f
c_outcap<30> Z<30> gnd 1f
c_outcap<29> Z<29> gnd 1f
c_outcap<28> Z<28> gnd 1f
c_outcap<27> Z<27> gnd 1f
c_outcap<26> Z<26> gnd 1f
c_outcap<25> Z<25> gnd 1f
c_outcap<24> Z<24> gnd 1f
c_outcap<23> Z<23> gnd 1f
c_outcap<22> Z<22> gnd 1f
c_outcap<21> Z<21> gnd 1f
c_outcap<20> Z<20> gnd 1f
c_outcap<19> Z<19> gnd 1f
c_outcap<18> Z<18> gnd 1f
c_outcap<17> Z<17> gnd 1f
c_outcap<16> Z<16> gnd 1f
c_outcap<15> Z<15> gnd 1f
c_outcap<14> Z<14> gnd 1f
c_outcap<13> Z<13> gnd 1f
c_outcap<12> Z<12> gnd 1f
c_outcap<11> Z<11> gnd 1f
c_outcap<10> Z<10> gnd 1f
c_outcap<9> Z<9> gnd 1f
c_outcap<8> Z<8> gnd 1f
c_outcap<7> Z<7> gnd 1f
c_outcap<6> Z<6> gnd 1f
c_outcap<5> Z<5> gnd 1f
c_outcap<4> Z<4> gnd 1f
c_outcap<3> Z<3> gnd 1f
c_outcap<2> Z<2> gnd 1f
c_outcap<1> Z<1> gnd 1f
c_outcap<0> Z<0> gnd 1f

c_flagcap<3> FLAGS<3> gnd 1f
c_flagcap<2> FLAGS<2> gnd 1f
c_flagcap<1> FLAGS<1> gnd 1f
c_flagcap<0> FLAGS<0> gnd 1f
.end
