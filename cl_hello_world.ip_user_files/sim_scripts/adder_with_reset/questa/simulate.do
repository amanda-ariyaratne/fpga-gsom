onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib adder_with_reset_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {adder_with_reset.udo}

run -all

quit -force
