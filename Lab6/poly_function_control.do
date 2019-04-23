vlib work

vlog -timescale 1ns/1ns poly_function.v


vsim control

log {/*}
add wave {/*}

force {clk} 0 0ns, 1 10ns -r 20
force {resetn} 0 0ns, 1 15 ns
force {go} 0 0ns, 1 20ns -r 40 

# Run simulation for a few ns.

run 320ns


