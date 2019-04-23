# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns DEC.v

# Load simulation using mux as the top level simulation module.
vsim DEC

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

#S[3] = c_3
#S[2] = c_2
#S[1] = c_1
#S[0] = c_0


#b
force {S[3]} 1
force {S[2]} 0
force {S[1]} 1
force {S[0]} 1

run 10ns

#A
force {S[3]} 1
force {S[2]} 0
force {S[1]} 1
force {S[0]} 0

run 10ns

#3
force {S[3]} 0
force {S[2]} 0
force {S[1]} 1
force {S[0]} 1

run 10ns

#1
force {S[3]} 0
force {S[2]} 0
force {S[1]} 0
force {S[0]} 1

run 10ns

#5
force {S[3]} 0
force {S[2]} 1
force {S[1]} 0
force {S[0]} 1

run 10ns

#5
force {S[3]} 0
force {S[2]} 1
force {S[1]} 0
force {S[0]} 1

run 10ns