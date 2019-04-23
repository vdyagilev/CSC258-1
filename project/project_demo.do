
#Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog -timescale 1ns/1ns project_demo_sim.v

# Load simulation using mux as the top level simulation module.
vsim -L altera_mf_ver test 
 
# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {CLOCK_50} 0 0ns, 1 10ns -r 20ns
force {SW[9]} 0 0ns, 1 20ns
force {SW[3:0]} 0010 1000ns

run 2000ns