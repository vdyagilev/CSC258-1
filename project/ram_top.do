
#Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog -timescale 1ns/1ns project_demo_sim.v

# Load simulation using mux as the top level simulation module.
vsim -L altera_mf_ver ram_top 
 
# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {clock} 0 0ns, 1 10ns -r 20ns
force {reset_n} 0 0ns, 1 20ns
force {enable} 0 0ns, 1 10ns
force {key_input} 0010 600ns
force {erase_tail} 0 0ns, 1 200ns, 0 220ns, 1 690ns, 0 710ns
force {update_ram} 0 0ns, 1 290ns, 0 310ns, 1 730ns, 0 750ns
run 2000ns

