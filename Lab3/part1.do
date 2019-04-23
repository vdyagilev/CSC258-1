# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns mux7to1_demo.v

# Load simulation using mux as the top level simulation module.
vsim mux7to1

# Log all signals and add some signals to waveform window.
log {/*}

# add wave {/*} would add all items in top level simulation module.
add wave {/*}

#simulating 7 to 1 multiplexer

#Initial simulation
force {Input[0]} 0
force {Input[1]} 0
force {Input[2]} 0
force {Input[3]} 0
force {Input[4]} 0
force {Input[5]} 0
force {Input[6]} 0
force {MuxSelect[0]} 0
force {MuxSelect[1]} 0
force {MuxSelect[2]} 0
run 10ns

#Checking if Input[0] is properly streamed out.
force {Input[0]} 1
force {Input[1]} 0
force {Input[2]} 0
force {Input[3]} 0
force {Input[4]} 0
force {Input[5]} 0
force {Input[6]} 0
force {MuxSelect[0]} 0
force {MuxSelect[1]} 0
force {MuxSelect[2]} 0
run 10ns

#Checking if Input[1] is properly streamed out.
force {Input[0]} 0
force {Input[1]} 1
force {Input[2]} 0
force {Input[3]} 0
force {Input[4]} 0
force {Input[5]} 0
force {Input[6]} 0
force {MuxSelect[0]} 1
force {MuxSelect[1]} 0
force {MuxSelect[2]} 0
run 10ns

#Checking if Input[2] is properly streamed out.
force {Input[0]} 0
force {Input[1]} 0
force {Input[2]} 1
force {Input[3]} 0
force {Input[4]} 0
force {Input[5]} 0
force {Input[6]} 0
force {MuxSelect[0]} 0
force {MuxSelect[1]} 1
force {MuxSelect[2]} 0
run 10ns

#Checking if Input[3] is properly streamed out.
force {Input[0]} 0
force {Input[1]} 0
force {Input[2]} 0
force {Input[3]} 1
force {Input[4]} 0
force {Input[5]} 0
force {Input[6]} 0
force {MuxSelect[0]} 1
force {MuxSelect[1]} 1
force {MuxSelect[2]} 0
run 10ns

#Checking if Input[4] is properly streamed out.
force {Input[0]} 0
force {Input[1]} 0
force {Input[2]} 0
force {Input[3]} 0
force {Input[4]} 1
force {Input[5]} 0
force {Input[6]} 0
force {MuxSelect[0]} 0
force {MuxSelect[1]} 0
force {MuxSelect[2]} 1 
run 10ns

#Checking if Input[5] is properly streamed out.
force {Input[0]} 0
force {Input[1]} 0
force {Input[2]} 0
force {Input[3]} 0
force {Input[4]} 0
force {Input[5]} 1
force {Input[6]} 0
force {MuxSelect[0]} 1
force {MuxSelect[1]} 0
force {MuxSelect[2]} 1
run 10ns

#Checking if Input[6] is properly streamed out.
force {Input[0]} 0
force {Input[1]} 0
force {Input[2]} 0
force {Input[3]} 0
force {Input[4]} 0
force {Input[5]} 0
force {Input[6]} 1
force {MuxSelect[0]} 0
force {MuxSelect[1]} 1
force {MuxSelect[2]} 1
run 10ns