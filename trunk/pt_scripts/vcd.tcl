set power_enable_analysis TRUE


#####################################################################
#       link design
#####################################################################
set search_path         " . "
set link_library	" *  cp65npksdst_tt1p2v25c.db "

read_verilog		Alu.vrl
current_design		Alu
link


#####################################################################
#       set transition time / annotate parasitics
#####################################################################
#read_sdc ../src/hdl/gate/mac.sdc
#set_disable_timing [get_lib_pins ssc_core_typ/*/G]
#read_parasitics		../src/annotate/mac.spef.gz


#####################################################################
#       read switching activity file
#####################################################################
create_clock -name clk -period 2
#read_vcd "../sim/vcd.dump.gz" -strip_path "tb/macinst"
read_vcd "test.vcd"

#####################################################################
#       check/update/report timing 
#####################################################################
#check_timing
#update_timing
#report_timing

#####################################################################
#       check/update/report power 
#####################################################################
check_power
create_power_waveforms -format out -cycle_accurate -output vcd 
report_power

#quit

