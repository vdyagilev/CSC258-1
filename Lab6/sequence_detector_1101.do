
# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog -timescale 1ns/1ns sequence_detector.v

# Load simulation using mux as the top level simulation module.
vsim sequence_detector

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {SW[0]} 0 0, 1 10
force {SW[1]} 0 
force {KEY[0]} 0
run 10ns

force {SW[0]} 1
force {SW[1]} 0 0, 1 5, 0 45, 1 65 
force {KEY[0]} 1 0, 0 10 -repeat 20
run 100