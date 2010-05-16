###################################################################

# Created by write_sdc on Sun May 16 00:56:28 2010

###################################################################
set sdc_version 1.7

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[31]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[30]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[29]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[28]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[27]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[26]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[25]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[24]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[23]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[22]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[21]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[20]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[19]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[18]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[17]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[16]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[15]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[14]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[13]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[12]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[11]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[10]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[9]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[8]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[7]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[6]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[5]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[4]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[3]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[2]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[1]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {X[0]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {S[4]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {S[3]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {S[2]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {S[1]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports {S[0]}]
set_driving_cell -lib_cell SEN_INV_1 [get_ports LEFT]
set_driving_cell -lib_cell SEN_INV_1 [get_ports LOG]
set_driving_cell -lib_cell SEN_INV_1 [get_ports clock]
create_clock [get_ports clock]  -period 1.4  -waveform {0 0.7}
set_input_delay -clock clock  0.1  [get_ports {X[31]}]
set_input_delay -clock clock  0.1  [get_ports {X[30]}]
set_input_delay -clock clock  0.1  [get_ports {X[29]}]
set_input_delay -clock clock  0.1  [get_ports {X[28]}]
set_input_delay -clock clock  0.1  [get_ports {X[27]}]
set_input_delay -clock clock  0.1  [get_ports {X[26]}]
set_input_delay -clock clock  0.1  [get_ports {X[25]}]
set_input_delay -clock clock  0.1  [get_ports {X[24]}]
set_input_delay -clock clock  0.1  [get_ports {X[23]}]
set_input_delay -clock clock  0.1  [get_ports {X[22]}]
set_input_delay -clock clock  0.1  [get_ports {X[21]}]
set_input_delay -clock clock  0.1  [get_ports {X[20]}]
set_input_delay -clock clock  0.1  [get_ports {X[19]}]
set_input_delay -clock clock  0.1  [get_ports {X[18]}]
set_input_delay -clock clock  0.1  [get_ports {X[17]}]
set_input_delay -clock clock  0.1  [get_ports {X[16]}]
set_input_delay -clock clock  0.1  [get_ports {X[15]}]
set_input_delay -clock clock  0.1  [get_ports {X[14]}]
set_input_delay -clock clock  0.1  [get_ports {X[13]}]
set_input_delay -clock clock  0.1  [get_ports {X[12]}]
set_input_delay -clock clock  0.1  [get_ports {X[11]}]
set_input_delay -clock clock  0.1  [get_ports {X[10]}]
set_input_delay -clock clock  0.1  [get_ports {X[9]}]
set_input_delay -clock clock  0.1  [get_ports {X[8]}]
set_input_delay -clock clock  0.1  [get_ports {X[7]}]
set_input_delay -clock clock  0.1  [get_ports {X[6]}]
set_input_delay -clock clock  0.1  [get_ports {X[5]}]
set_input_delay -clock clock  0.1  [get_ports {X[4]}]
set_input_delay -clock clock  0.1  [get_ports {X[3]}]
set_input_delay -clock clock  0.1  [get_ports {X[2]}]
set_input_delay -clock clock  0.1  [get_ports {X[1]}]
set_input_delay -clock clock  0.1  [get_ports {X[0]}]
set_input_delay -clock clock  0.1  [get_ports {S[4]}]
set_input_delay -clock clock  0.1  [get_ports {S[3]}]
set_input_delay -clock clock  0.1  [get_ports {S[2]}]
set_input_delay -clock clock  0.1  [get_ports {S[1]}]
set_input_delay -clock clock  0.1  [get_ports {S[0]}]
set_input_delay -clock clock  0.1  [get_ports LEFT]
set_input_delay -clock clock  0.1  [get_ports LOG]
set_output_delay -clock clock  0.1  [get_ports {Z[31]}]
set_output_delay -clock clock  0.1  [get_ports {Z[30]}]
set_output_delay -clock clock  0.1  [get_ports {Z[29]}]
set_output_delay -clock clock  0.1  [get_ports {Z[28]}]
set_output_delay -clock clock  0.1  [get_ports {Z[27]}]
set_output_delay -clock clock  0.1  [get_ports {Z[26]}]
set_output_delay -clock clock  0.1  [get_ports {Z[25]}]
set_output_delay -clock clock  0.1  [get_ports {Z[24]}]
set_output_delay -clock clock  0.1  [get_ports {Z[23]}]
set_output_delay -clock clock  0.1  [get_ports {Z[22]}]
set_output_delay -clock clock  0.1  [get_ports {Z[21]}]
set_output_delay -clock clock  0.1  [get_ports {Z[20]}]
set_output_delay -clock clock  0.1  [get_ports {Z[19]}]
set_output_delay -clock clock  0.1  [get_ports {Z[18]}]
set_output_delay -clock clock  0.1  [get_ports {Z[17]}]
set_output_delay -clock clock  0.1  [get_ports {Z[16]}]
set_output_delay -clock clock  0.1  [get_ports {Z[15]}]
set_output_delay -clock clock  0.1  [get_ports {Z[14]}]
set_output_delay -clock clock  0.1  [get_ports {Z[13]}]
set_output_delay -clock clock  0.1  [get_ports {Z[12]}]
set_output_delay -clock clock  0.1  [get_ports {Z[11]}]
set_output_delay -clock clock  0.1  [get_ports {Z[10]}]
set_output_delay -clock clock  0.1  [get_ports {Z[9]}]
set_output_delay -clock clock  0.1  [get_ports {Z[8]}]
set_output_delay -clock clock  0.1  [get_ports {Z[7]}]
set_output_delay -clock clock  0.1  [get_ports {Z[6]}]
set_output_delay -clock clock  0.1  [get_ports {Z[5]}]
set_output_delay -clock clock  0.1  [get_ports {Z[4]}]
set_output_delay -clock clock  0.1  [get_ports {Z[3]}]
set_output_delay -clock clock  0.1  [get_ports {Z[2]}]
set_output_delay -clock clock  0.1  [get_ports {Z[1]}]
set_output_delay -clock clock  0.1  [get_ports {Z[0]}]
