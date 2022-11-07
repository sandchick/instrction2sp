vlib work
vlog "./tb_work.v"
vlog "../RTL/ins2sp/divider.v"
vlog "../RTL/ins2sp/level_counter.v"
vlog "../RTL/ins2sp/spcounter.v"
#vlog "../RTL/ins2sp/ins2sp.v"
vsim -voptargs=+acc -c work.tb_work
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_work/clk
add wave -noupdate /tb_work/rst_n
add wave -noupdate -radix binary /tb_work/wlord
add wave -noupdate /tb_work/uspcounter/sp_out_single
add wave -noupdate /tb_work/uspcounter/wlord
add wave -noupdate {/tb_work/uspcounter/high_level_counter[0]/high_level_counter/en}
add wave -noupdate {/tb_work/uspcounter/high_level_counter[0]/high_level_counter/sign}
add wave -noupdate {/tb_work/uspcounter/high_level_counter[1]/high_level_counter/en}
add wave -noupdate {/tb_work/uspcounter/high_level_counter[1]/high_level_counter/sign}
add wave -noupdate {/tb_work/uspcounter/low_level_counter[1]/low_level_counter/en}
add wave -noupdate {/tb_work/uspcounter/low_level_counter[1]/low_level_counter/sign}
add wave -noupdate {/tb_work/uspcounter/divider[1]/udivider/a}
add wave -noupdate {/tb_work/uspcounter/divider[1]/udivider/b}
add wave -noupdate {/tb_work/uspcounter/divider[1]/udivider/yshang}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {398745 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 384
configure wave -valuecolwidth 182
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
run 1000ns