#/**************************************************/
#/* Compile Script for Synopsys                    */
#/*                                                */
#/* dc_shell-t -f compile_ALU.tcl                  */
#/*                                                */
#/* IBM 65nm PDK		                               */
#/**************************************************/

#/* All verilog files, separated by spaces         */
# for synthesis of just the ALU
set my_verilog_files [list Alu.v]
#set my_verilog_files [list alu_behavioral.v]

#/* Top-level Module                               */
set my_toplevel Alu

#/* To synthesize to different corners */
set corner	"_tt1p2v25c"

#/* The name of the clock pin. If no clock-pin     */
#/* exists, pick anything                          */
set my_clock_pin CLOCK

#/* Target frequency in MHz for optimization       */
#set my_clk_freq_MHz 700
set my_clk_freq_MHz 1000

#/* Target frequency in MHz for optimization       */
#set my_period 1.4
set my_period 1.0

#/* Delay of input signals (Clock-to-Q, Package etc.)  */
#set my_input_delay_ns 0.1
set my_input_delay_ns 0.0

#/* Reserved time for output signals (Holdtime etc.)   */
#set my_output_delay_ns 0.1
set my_output_delay_ns 0.0


#/**************************************************/
#/* No modifications needed below                  */
#/**************************************************/
set current_dir ./
set db_path ./db
set verilog_path ../verilog
set benchmark_path ../benchmark
set libName	"cp65npksdst"
set search_path [concat  $search_path  $current_dir $verilog_path $benchmark_path $db_path]

set link_library  [subst {${libName}${corner}.db}]
set target_library [subst {${libName}${corner}.db}]
set symbol_library [subst {${libName}.sdb}]

# not sure if I need this
set alib_library_analysis_path $current_dir

define_design_lib WORK -path ../WORK
set verilogout_show_unconnected_pins "true"

analyze -f verilog $my_verilog_files

elaborate $my_toplevel

current_design $my_toplevel

link
uniquify

#set my_period [expr 1000 / $my_clk_freq_MHz]

set find_clock [ find port [list $my_clock_pin] ]
if {  $find_clock != [list] } {
   set clk_name $my_clock_pin
   create_clock -period $my_period $clk_name
} else {
   set clk_name vclk
   create_clock -period $my_period -name $clk_name
}

set_driving_cell  -lib_cell SEN_INV_1  [all_inputs]
set_input_delay $my_input_delay_ns -clock $clk_name [remove_from_collection [all_inputs] $my_clock_pin]
set_output_delay $my_output_delay_ns -clock $clk_name [all_outputs]

set_max_dynamic_power 0.2 mW

compile -ungroup_all -map_effort high -power_effort high
compile_ultra -incremental

check_design
report_constraint -all_violators

set filename [format "%s%s"  $my_toplevel ".vh"]
write -f verilog -output $filename

set filename [format "%s%s"  $my_toplevel ".sdc"]
write_sdc $filename

#set filename [format "%s%s"  $my_toplevel ".db"]
#write -f db -hier -output $filename

# normal
redirect timing.rep.Alu { report_timing }
redirect cell.rep.Alu { report_cell }
redirect power.rep.Alu { report_power }

quit
