# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog -timescale 1ns/1ns ALU_REG.v

# Load simulation using mux as the top level simulation module.
vsim ALU_REG_demo 

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}


force {SW[0]} 1
force {SW[1]} 1 
force {SW[2]} 1
force {SW[3]} 1 

force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {SW[9]} 1

force {KEY[0]} 0 0, 1 10 -r 20
	
run 80ns


force {SW[0]} 0
force {SW[1]} 0 
force {SW[2]} 0
force {SW[3]} 0 

force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 1

force {SW[9]} 1

force {KEY[0]} 0 0, 1 10 -r 20
	
run 80ns


force {SW[0]} 1
force {SW[1]} 0 
force {SW[2]} 0
force {SW[3]} 0 

force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 1

force {SW[9]} 1

force {KEY[0]} 0 0, 1 10 -r 20
	
run 80ns



