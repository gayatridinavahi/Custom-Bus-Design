onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Clock & Reset}
add wave -noupdate -group {Clock & Reset} -format Logic /testbench/clk
add wave -noupdate -group {Clock & Reset} -format Logic /testbench/rst
add wave -noupdate -expand -group {Master Request Signals from Processor}
add wave -noupdate -group {Master Request Signals from Processor} -group {Write Request}
add wave -noupdate -group {Master Request Signals from Processor} -format Logic /testbench/wr_start
add wave -noupdate -group {Master Request Signals from Processor} -group {Read Request}
add wave -noupdate -group {Master Request Signals from Processor} -format Logic /testbench/rd_start
add wave -noupdate -expand -group {Bus Interface Signals}
add wave -noupdate -group {Bus Interface Signals} -format Logic /testbench/m_req
add wave -noupdate -group {Bus Interface Signals} -format Logic /testbench/m_r0_w1
add wave -noupdate -group {Bus Interface Signals} -format Literal -radix hexadecimal /testbench/m_wr_data
add wave -noupdate -group {Bus Interface Signals} -format Literal -radix hexadecimal /testbench/m_rd_data
add wave -noupdate -group {Bus Interface Signals} -format Logic /testbench/s_ack
add wave -noupdate -group {Bus Interface Signals} -format Logic /testbench/s_data_ack
add wave -noupdate -group {Bus Interface Signals} -format Logic /testbench/m_done
add wave -noupdate -expand -group {Master State Machine}
add wave -noupdate -group {Master State Machine} -format Literal /testbench/master_inst/m_current_state
add wave -noupdate -expand -group {Slave State Machine}
add wave -noupdate -group {Slave State Machine} -format Literal /testbench/slave_inst/s_current_state
add wave -noupdate -expand -group {Data Stored by Slave}
add wave -noupdate -group {Data Stored by Slave} -format Literal -radix hexadecimal /testbench/slave_inst/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {47519 ps} 0}
configure wave -namecolwidth 255
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {677250 ps}
