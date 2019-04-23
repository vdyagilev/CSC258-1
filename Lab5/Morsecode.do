# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog -timescale 1ns/1ns Morsecode.v

# Load simulation using mux as the top level simulation module.
vsim Morsecode

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}
force {CLOCK_50} 1 0 ns, 0 10 ns -r 20
force {KEY[0]} 0 0 ns, 1 40ns, 0 1300ns, 1 1340ns 
force {KEY[1]} 1 0 ns, 0 80ns, 1 120 ns
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 3000 ns

