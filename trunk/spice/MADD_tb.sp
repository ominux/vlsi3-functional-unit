
** MADD simulation stimulus file for hspiceD

*****************************parameter settings *******************************
.param my_vdd=1.2V
.param my_sim_time=17.0ns

*****************************power rails **************************************
.GLOBAL vdd
.GLOBAL vdd!

vdd vdd gnd DC=my_vdd
vdd! vdd! gnd! DC=my_vdd

*****************************Simulation settings ******************************

.TRAN 5e-12 my_sim_time START=0.0
.OP

.TEMP 25
.OPTION
+    ARTIST=2
+    INGOLD=2
+    PARHIER=LOCAL
+    PSF=2
+    POST

*****************************Include your netlist here ************************

.INCLUDE "MADD.sp"
.INCLUDE "minbuf.sp"

.vec madd.vec

*****************************get the energy ***********************************

.meas tran Qtot integral i(vdd!) from=30ps to=my_sim_time
.meas tran Qtot2 integral i(vdd) from=30ps to=my_sim_time
.meas Etot param='my_vdd*(Qtot+Qtot2)

*****************************Clock define *************************************

* have to precharge the nodes first
Vclk inclk gnd pulse (0V my_vdd 30ps 20ps 20ps 1.2ns 2.4ns)

*****************************INPUTS *******************************************

* data inputs
xain<9> vdd gnd ain<9> A<9> minbuff
xain<8> vdd gnd ain<8> A<8> minbuff
xain<7> vdd gnd ain<7> A<7> minbuff
xain<6> vdd gnd ain<6> A<6> minbuff
xain<5> vdd gnd ain<5> A<5> minbuff
xain<4> vdd gnd ain<4> A<4> minbuff
xain<3> vdd gnd ain<3> A<3> minbuff
xain<2> vdd gnd ain<2> A<2> minbuff
xain<1> vdd gnd ain<1> A<1> minbuff
xain<10> vdd gnd ain<10> A<10> minbuff
xain<19> vdd gnd ain<19> A<19> minbuff
xain<18> vdd gnd ain<18> A<18> minbuff
xain<17> vdd gnd ain<17> A<17> minbuff
xain<16> vdd gnd ain<16> A<16> minbuff
xain<15> vdd gnd ain<15> A<15> minbuff
xain<14> vdd gnd ain<14> A<14> minbuff
xain<13> vdd gnd ain<13> A<13> minbuff
xain<12> vdd gnd ain<12> A<12> minbuff
xain<11> vdd gnd ain<11> A<11> minbuff
xain<20> vdd gnd ain<20> A<20> minbuff
xain<29> vdd gnd ain<29> A<29> minbuff
xain<28> vdd gnd ain<28> A<28> minbuff
xain<27> vdd gnd ain<27> A<27> minbuff
xain<26> vdd gnd ain<26> A<26> minbuff
xain<25> vdd gnd ain<25> A<25> minbuff
xain<24> vdd gnd ain<24> A<24> minbuff
xain<23> vdd gnd ain<23> A<23> minbuff
xain<22> vdd gnd ain<22> A<22> minbuff
xain<21> vdd gnd ain<21> A<21> minbuff
xain<30> vdd gnd ain<30> A<30> minbuff
xain<31> vdd gnd ain<31> A<31> minbuff

xbin<9> vdd gnd bin<9> B<9> minbuff
xbin<8> vdd gnd bin<8> B<8> minbuff
xbin<7> vdd gnd bin<7> B<7> minbuff
xbin<6> vdd gnd bin<6> B<6> minbuff
xbin<5> vdd gnd bin<5> B<5> minbuff
xbin<4> vdd gnd bin<4> B<4> minbuff
xbin<3> vdd gnd bin<3> B<3> minbuff
xbin<2> vdd gnd bin<2> B<2> minbuff
xbin<1> vdd gnd bin<1> B<1> minbuff
xbin<10> vdd gnd bin<10> B<10> minbuff
xbin<19> vdd gnd bin<19> B<19> minbuff
xbin<18> vdd gnd bin<18> B<18> minbuff
xbin<17> vdd gnd bin<17> B<17> minbuff
xbin<16> vdd gnd bin<16> B<16> minbuff
xbin<15> vdd gnd bin<15> B<15> minbuff
xbin<14> vdd gnd bin<14> B<14> minbuff
xbin<13> vdd gnd bin<13> B<13> minbuff
xbin<12> vdd gnd bin<12> B<12> minbuff
xbin<11> vdd gnd bin<11> B<11> minbuff
xbin<20> vdd gnd bin<20> B<20> minbuff
xbin<29> vdd gnd bin<29> B<29> minbuff
xbin<28> vdd gnd bin<28> B<28> minbuff
xbin<27> vdd gnd bin<27> B<27> minbuff
xbin<26> vdd gnd bin<26> B<26> minbuff
xbin<25> vdd gnd bin<25> B<25> minbuff
xbin<24> vdd gnd bin<24> B<24> minbuff
xbin<23> vdd gnd bin<23> B<23> minbuff
xbin<22> vdd gnd bin<22> B<22> minbuff
xbin<21> vdd gnd bin<21> B<21> minbuff
xbin<30> vdd gnd bin<30> B<30> minbuff
xbin<31> vdd gnd bin<31> B<31> minbuff

xcin<9> vdd gnd cin<9> C<9> minbuff
xcin<8> vdd gnd cin<8> C<8> minbuff
xcin<7> vdd gnd cin<7> C<7> minbuff
xcin<6> vdd gnd cin<6> C<6> minbuff
xcin<5> vdd gnd cin<5> C<5> minbuff
xcin<4> vdd gnd cin<4> C<4> minbuff
xcin<3> vdd gnd cin<3> C<3> minbuff
xcin<2> vdd gnd cin<2> C<2> minbuff
xcin<1> vdd gnd cin<1> C<1> minbuff
xcin<10> vdd gnd cin<10> C<10> minbuff
xcin<19> vdd gnd cin<19> C<19> minbuff
xcin<18> vdd gnd cin<18> C<18> minbuff
xcin<17> vdd gnd cin<17> C<17> minbuff
xcin<16> vdd gnd cin<16> C<16> minbuff
xcin<15> vdd gnd cin<15> C<15> minbuff
xcin<14> vdd gnd cin<14> C<14> minbuff
xcin<13> vdd gnd cin<13> C<13> minbuff
xcin<12> vdd gnd cin<12> C<12> minbuff
xcin<11> vdd gnd cin<11> C<11> minbuff
xcin<20> vdd gnd cin<20> C<20> minbuff
xcin<29> vdd gnd cin<29> C<29> minbuff
xcin<28> vdd gnd cin<28> C<28> minbuff
xcin<27> vdd gnd cin<27> C<27> minbuff
xcin<26> vdd gnd cin<26> C<26> minbuff
xcin<25> vdd gnd cin<25> C<25> minbuff
xcin<24> vdd gnd cin<24> C<24> minbuff
xcin<23> vdd gnd cin<23> C<23> minbuff
xcin<22> vdd gnd cin<22> C<22> minbuff
xcin<21> vdd gnd cin<21> C<21> minbuff
xcin<30> vdd gnd cin<30> C<30> minbuff
xcin<31> vdd gnd cin<31> C<31> minbuff

* clock input
xclk vdd gnd inclk CLK minbuff

*****************************OUTPUTS ***********************************

* the outputs with 5f load
c_outcap<31> Z<31> gnd 5f
c_outcap<30> Z<30> gnd 5f
c_outcap<29> Z<29> gnd 5f
c_outcap<28> Z<28> gnd 5f
c_outcap<27> Z<27> gnd 5f
c_outcap<26> Z<26> gnd 5f
c_outcap<25> Z<25> gnd 5f
c_outcap<24> Z<24> gnd 5f
c_outcap<23> Z<23> gnd 5f
c_outcap<22> Z<22> gnd 5f
c_outcap<21> Z<21> gnd 5f
c_outcap<20> Z<20> gnd 5f
c_outcap<19> Z<19> gnd 5f
c_outcap<18> Z<18> gnd 5f
c_outcap<17> Z<17> gnd 5f
c_outcap<16> Z<16> gnd 5f
c_outcap<15> Z<15> gnd 5f
c_outcap<14> Z<14> gnd 5f
c_outcap<13> Z<13> gnd 5f
c_outcap<12> Z<12> gnd 5f
c_outcap<11> Z<11> gnd 5f
c_outcap<10> Z<10> gnd 5f
c_outcap<9> Z<9> gnd 5f
c_outcap<8> Z<8> gnd 5f
c_outcap<7> Z<7> gnd 5f
c_outcap<6> Z<6> gnd 5f
c_outcap<5> Z<5> gnd 5f
c_outcap<4> Z<4> gnd 5f
c_outcap<3> Z<3> gnd 5f
c_outcap<2> Z<2> gnd 5f
c_outcap<1> Z<1> gnd 5f
c_outcap<0> Z<0> gnd 5f

.end
