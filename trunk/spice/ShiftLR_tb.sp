
** ShiftLR simulation stimulus file for hspiceD

*****************************parameter settings *******************************
.param my_vdd=1.2V
.param my_sim_time=3.0ns

*****************************power rails **************************************
.GLOBAL vdd
.GLOBAL vdd!

vdd vdd gnd DC=my_vdd
vdd! vdd! gnd! DC=my_vdd
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

.INCLUDE "ShiftLR.sp"
*.INCLUDE "minbuf.sp"
.INCLUDE "cp65npksdst.lvs"

.vec shiftlr.vec

*****************************get the energy ***********************************

.meas tran Qtot integral i(vdd!) from=30ps to=my_sim_time
.meas tran Qtot2 integral i(vdd) from=30ps to=my_sim_time
.meas Etot param='my_vdd*(Qtot+Qtot2)

*****************************Clock define *************************************

* have to precharge the nodes first
*Vclk CLK gnd pulse (0V my_vdd 30ps 20ps 20ps 1.2ns 2.4ns)

*****************************INPUTS *******************************************

*****************************CELL UNDER TEST ***************************
xshiftlr z<31> Z<30> Z<29> Z<28> Z<27> Z<26> Z<25> Z<24> Z<23> Z<22> 
+ Z<21> Z<20> Z<19> Z<18> Z<17> Z<16> Z<15> Z<14> Z<13> Z<12> Z<11> Z<10> Z<9> 
+ Z<8> Z<7> Z<6> Z<5> Z<4> Z<3> Z<2> Z<1> Z<0> X<31> X<30> X<29> X<28> X<27> 
+ X<26> X<25> X<24> X<23> X<22> X<21> X<20> X<19> X<18> X<17> X<16> X<15> X<14> 
+ X<13> X<12> X<11> X<10> X<9> X<8> X<7> X<6> X<5> X<4> X<3> X<2> X<1> X<0> 
+ S<4> S<3> S<2> S<1> S<0> LEFT LOG ShiftLR

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

.end
