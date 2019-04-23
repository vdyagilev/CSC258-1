# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns fbrca_demo.v

# Load simulation using mux as the top level simulation module.
vsim fbrca

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

#First test case.
#Just inputting all 0s.
force {cin} 0
force {A[0]} 0
force {A[1]} 0
force {A[2]} 0
force {A[3]} 0
force {B[0]} 0
force {B[1]} 0
force {B[2]} 0
force {B[3]} 0
run 10ns

#easy case (simple addition)
force {cin} 0
force {A[0]} 1
force {A[1]} 0
force {A[2]} 0
force {A[3]} 0
force {B[0]} 1
force {B[1]} 0
force {B[2]} 0
force {B[3]} 0
run 10ns

#No B
force {cin} 0
force {A[0]} 0
force {A[1]} 0
force {A[2]} 0
force {A[3]} 0
force {B[0]} 1
force {B[1]} 1
force {B[2]} 1
force {B[3]} 1
run 10ns

#testing the digits are added correctly
force {cin} 0
force {A[0]} 0
force {A[1]} 1
force {A[2]} 0
force {A[3]} 0
force {B[0]} 1
force {B[1]} 0
force {B[2]} 1
force {B[3]} 1
run 10ns

#simple test of carry in
force {cin} 1
force {A[0]} 1
force {A[1]} 0
force {A[2]} 0
force {A[3]} 0
force {B[0]} 1
force {B[1]} 0
force {B[2]} 0
force {B[3]} 0
run 10ns

#testing 1 + (-1) and testing that carry out works as supposed to
force {cin} 1
force {A[0]} 1
force {A[1]} 1
force {A[2]} 1
force {A[3]} 1
force {B[0]} 0
force {B[1]} 0
force {B[2]} 0
force {B[3]} 0
run 10ns

#testing carrying in and carrying out and carrying in between.
force {cin} 1
force {A[0]} 1
force {A[1]} 1
force {A[2]} 1
force {A[3]} 1
force {B[0]} 1
force {B[1]} 1
force {B[2]} 1
force {B[3]} 1
run 10ns
