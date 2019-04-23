vlib work
vlog -timescale 1ns/1ns part2.v
vsim test
log {/*}
add wave {/*}

force {KEY_3} 0 0, 1 25, 0 40 
force {KEY_1} 0 0, 1 60, 0 75
force {reset_n} 0 0,1 10
force {clock} 0 0,1 5 -r 10
force {data} 7'b0000001 0, 7'b0000010 50 , 7'b0000000 240
force {color} 3'b010 
run 350ns


