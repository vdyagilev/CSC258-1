# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns ALU_demo.v

# Load simulation using mux as the top level simulation module.
vsim ALU

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {A[0]} 1
force {A[1]} 1
force {A[2]} 0
force {A[3]} 0
force {B[0]} 1
force {B[1]} 1
force {B[2]} 1
force {B[3]} 0
force {select[0]} 0
force {select[1]} 0
force {select[2]} 0
run 10ns

force {A[0]} 1
force {A[1]} 1
force {A[2]} 0
force {A[3]} 0
force {B[0]} 1
force {B[1]} 1
force {B[2]} 1
force {B[3]} 0
force {select[0]} 1
force {select[1]} 0
force {select[2]} 0
run 10ns

force {A[0]} 1
force {A[1]} 1
force {A[2]} 0
force {A[3]} 0
force {B[0]} 1
force {B[1]} 1
force {B[2]} 1
force {B[3]} 0
force {select[0]} 0
force {select[1]} 1
force {select[2]} 0
run 10ns

force {A[0]} 1
force {A[1]} 1
force {A[2]} 0
force {A[3]} 0
force {B[0]} 1
force {B[1]} 1
force {B[2]} 1
force {B[3]} 0
force {select[0]} 1
force {select[1]} 1
force {select[2]} 0
run 10ns

force {A[0]} 1
force {A[1]} 1
force {A[2]} 0
force {A[3]} 0
force {B[0]} 1
force {B[1]} 1
force {B[2]} 1
force {B[3]} 0
force {select[0]} 0
force {select[1]} 0
force {select[2]} 1
run 10ns

force {A[0]} 1
force {A[1]} 1
force {A[2]} 0
force {A[3]} 0
force {B[0]} 1
force {B[1]} 1
force {B[2]} 1
force {B[3]} 0
force {select[0]} 1
force {select[1]} 0
force {select[2]} 1
run 10ns