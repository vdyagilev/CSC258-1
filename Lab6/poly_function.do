
# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog -timescale 1ns/1ns poly_function.v

# Load simulation using mux as the top level simulation module.
vsim fpga_top

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# Set input values using the force command, signal names need to be in {} brackets.
force {CLOCK_50} 0 0 ns, 1 10 ns -r 20
force {KEY[0]} 0 0 ns, 1 40 ns 
force {KEY[1]} 1 60 ns, 0 80 ns, 1 100 ns, 0 120 ns, 1 140 ns, 0 160 ns, 1 180 ns, 0 200 ns, 1 220 ns
force {SW[7:0]} 00000101 0 ns, 000000100 110 ns, 00000011 150 ns, 00000010 190 ns
#A = 5, B = 4, C = 3, x = 2
#Cx^2 + Bx + A = 12 + 8 + 5 = 25 (11001)
# Run simulation for a few ns.
run 550 ns
