# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns mux4to1_final.v

# Load simulation using mux as the top level simulation module.
vsim mux4to1_final

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

#SW[3] = u
#SW[2] = v
#SW[1] = w
#SW[0] = x
#SW[8] = s_0
#SW[9] = s_1

# First testing case.
# Just checking simulation works.
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[9]} 0
force {SW[8]} 0
# Run simulation for a few ns.
run 10ns

# test case.
# Checking the output is equivalent to u when s_1s_0 = 00.
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[9]} 0
force {SW[8]} 0
run 10ns

# Checking the output is equivalent to v when s_1s_0 = 01.
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[9]} 0
force {SW[8]} 1
run 10ns

# Checking the output is equivalent to w when s_1s_0 = 10.
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[9]} 1
force {SW[8]} 0
run 10ns

# Checking the output is equivalent to x when s_1s_0 = 11.
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 1
force {SW[9]} 1
force {SW[8]} 1
run 10ns