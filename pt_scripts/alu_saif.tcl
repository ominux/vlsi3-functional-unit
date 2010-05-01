set power_enable_analysis TRUE

#####################################################################
#       link design
#####################################################################
#set search_path         " . "
set search_path		[list ./ ../synthesis ../benchmark]
set link_library	" * ../synthesis/cp65npksdst_tt1p2v25c.db "

#read_verilog		../synthesis/Alu.vh
read_verilog		../benchmark/Alu.vrl
current_design		Alu
link


#####################################################################
#       clock required for average waveform
#####################################################################
#read_sdc ../src/hdl/gate/mac.sdc
#set_disable_timing [get_lib_pins ssc_core_typ/*/G]
#set timing_save_pin_arrival_and_slack true


#####################################################################
#       set transition time / annotate parasitics
#####################################################################
#read_parasitics	-pin_cap_included	invs.pex.netlist


#####################################################################
#       check/update/report timing
#####################################################################
check_timing
update_timing
report_timing

#####################################################################
#       read switching activity file
#####################################################################
create_clock -name clk -period 4
#read_saif "nothing.saif" -strip_path Alu
#report_switching_activity -list_not_annotated

set_switching_activity -toggle_count 0 -static_probability 1 LEFT
set_switching_activity -toggle_count 0 -static_probability 1 LOG
set_switching_activity -toggle_count 0.25 -static_probability 0.5 X
set_switching_activity -toggle_count 0.25 -static_probability 0.5 S

#####################################################################
#       check/update/report power
#####################################################################
check_power
update_power
report_power -hierarchy > saif.rpt

# This is an optional step
create_power_waveforms -output saif
report_power

quit

