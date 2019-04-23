# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns DisplayCounter.v

# Load simulation using mux as the top level simulation module.
vsim DisplayCounter 

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

#initializing
force {SW[1:0]} 00
force {SW[3]} 0
force {SW[7:4]} 0000
force {KEY[0]} 0
force {KEY[1]} 0
force {CLOCK_50} 0 0, 1 10 
run 20ns

#Testing #1
force {SW[1:0]} 00
force {SW[3]} 1
force {SW[7:4]} 1010
force {KEY[0]} 1
force {KEY[1]} 1
force {CLOCK_50} 0 0, 1 10 -r 20
run 200ns

#Testing #2
force {SW[1:0]} 00
force {SW[3]} 1
force {SW[7:4]} 1010
force {KEY[0]} 1
force {KEY[1]} 0
force {CLOCK_50} 0 0, 1 10 -r 20
run 200ns
