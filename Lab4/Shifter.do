
# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog -timescale 1ns/1ns Shifter_demo.v

# Load simulation using mux as the top level simulation module.
vsim Shifter

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {LoadVal[7:0]} 10000000
force {Load_n} 0
force {ShiftRight} 0
force {ASR} 0
force {reset_n} 0
force {clk} 1 0, 0 10 -r 20 
run 40ns

force {LoadVal[7:0]} 10000000
force {Load_n} 0
force {ShiftRight} 0
force {ASR} 0
force {reset_n} 1
force {clk} 1 0, 0 10 -r 20 
run 40ns

