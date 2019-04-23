 
# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog -timescale 1ps/1ps ram32x4.v

# Load simulation using mux as the top level simulation module.
vsim -L altera_mf_ver ram32x4


# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# Set input values using the force command, signal names need to be in {} brackets.
force {address} 2#11111 0, 2#00001 20, 2#11111 40, 2#00010 70, 2#11111 150
force {clock} 0 0, 1 10 -r 20
force {data} 2#1010 0, 2#1111 30, 2#1011 70
force {wren} 0 0, 1 8, 0 18, 1 28, 0 38, 1 68, 0 78
run 200ps 
