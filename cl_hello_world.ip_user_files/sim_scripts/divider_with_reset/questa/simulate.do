onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib divider_with_reset_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {divider_with_reset.udo}

run -all

quit -force
