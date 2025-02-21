vlib work
vdel -all

vlib work

vlog master.sv		+acc
vlog slave.sv		+acc
vlog testbench.sv	+acc

vsim work.testbench
#	add wave -r *
do wave.do
run -all
