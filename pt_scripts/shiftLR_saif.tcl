set power_enable_analysis TRUE

#####################################################################
#       link design
#####################################################################
set search_path		[list ./ ../synthesis ../synthesis/db ../benchmark]
set link_library	" * cp65npksdst_tt1p2v25c.db "

##########################################################
# Change this to switch between new design and benchmark #
read_verilog		../synthesis/ShiftLR.vh
#read_verilog		../benchmark/ShiftLR.vrl
##########################################################
current_design		ShiftLR
link


#####################################################################
#       clock required for average waveform
#####################################################################


##########################################################
# Change this to switch between new design and benchmark #
read_sdc ../synthesis/ShiftLR.sdc
# for a design without a clock input
#create_clock -name clock -period 1.4
# for a design with an input clock port
#create_clock -period 1.4 [get_port CLOCK]
##########################################################


# set the wire load model
#remove_wire_load_model ShiftLR
#set_wire_load_mode enclosed
#set_wire_load_model -name B0.1X0.1 -min
#set_wire_load_model -name B0.1X0.1 -max

#set_disable_timing [get_lib_pins ssc_core_typ/*/G]
#set timing_save_pin_arrival_and_slack true

#####################################################################
#       set transition time / annotate parasitics
#####################################################################
#read_parasitics	-pin_cap_included	invs.pex.netlist


#####################################################################
#       check/update/report timing
#####################################################################
#check_timing
#update_timing
#report_timing -max_paths 10 > shiftLR.rpt

#####################################################################
#       read switching activity file
#####################################################################
#read_saif "none.saif" -strip_path Alu
#report_switching_activity -list_not_annotated

set_switching_activity -toggle_count 0.25 -static_probability 0.5 LEFT
set_switching_activity -toggle_count 0.25 -static_probability 0.5 LOG
set_switching_activity -toggle_count 0.25 -static_probability 0.5 X
set_switching_activity -toggle_count 0.25 -static_probability 0.5 S

#####################################################################
#       check/update/report power
#####################################################################
check_power
update_power
report_power -hierarchy > shiftLR.rpt

# This is an optional step
#create_power_waveforms -output saif
#report_power

quit

