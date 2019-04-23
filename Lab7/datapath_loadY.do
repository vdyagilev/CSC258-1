vlib work

vlog -timescale 1ns/1ns part2.v

vsim datapath

log {/*}

add wave {/*}

force {clock} 0 0, 1 10 -repeat 20

force {data} 0000011

force {color} 001
force {reset_n} 0
force {enable} 0 
force {ld_x} 0
force {ld_y} 0
force {ld_c} 0

run 100

force {clock} 0 0, 1 10 -repeat 20

force {data} 0000011

force {color} 001
force {reset_n} 1
force {enable} 0
force {ld_x} 0
force {ld_y} 1
force {ld_c} 0

run 100


