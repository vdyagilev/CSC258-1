
# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog -timescale 1ns/1ns poly_function.v

# Load simulation using mux as the top level simulation module.
vsim datapath 

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {clk} 0 0ns, 1 10 ns -r 20
force {resetn} 0 0ns, 1 15 ns
force {ld_a} 0 0 ns
force {ld_b} 0 0 ns
force {ld_c} 0 0 ns
force {ld_x} 0 0 ns
force {ld_r} 0 0 ns
force {alu_select_a} 00 0 ns
force {alu_select_b} 00 0 ns
force {alu_op} 0 0ns
force {ld_alu_out} 0 0ns
force {data_in} 00000001 0 ns
force {ld_a} 1 20 ns, 0 40 ns
force {ld_b} 1 40 ns, 0 60 ns
force {ld_c} 1 60 ns, 0 80 ns
force {ld_x} 1 80 ns, 0 100 ns
force {alu_select_a} 00 100 ns
force {alu_select_b} 01 100 ns
force {alu_op} 0 101 ns
force {ld_alu_out} 1 102 ns
force {ld_a} 1 102 ns, 0 120 ns
force {alu_select_a} 00 140 ns
force {alu_select_b} 10 140 ns
force  {alu_op} 0 141 ns
force {ld_a} 1 142 ns, 0 160 ns
force {alu_select_a} 00 180 ns
force {alu_select_b} 11 180 ns
force {alu_op} 1 181 ns
force {ld_r} 1 182 ns
run 300ns
