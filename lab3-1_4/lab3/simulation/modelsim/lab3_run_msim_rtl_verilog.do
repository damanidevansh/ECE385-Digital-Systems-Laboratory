transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/zacha/Downloads/385_lab4_adders_provided_fa20 {C:/Users/zacha/Downloads/385_lab4_adders_provided_fa20/addermethods.sv}
vlog -sv -work work +incdir+C:/Users/zacha/Downloads/385_lab4_adders_provided_fa20 {C:/Users/zacha/Downloads/385_lab4_adders_provided_fa20/router.sv}
vlog -sv -work work +incdir+C:/Users/zacha/Downloads/385_lab4_adders_provided_fa20 {C:/Users/zacha/Downloads/385_lab4_adders_provided_fa20/reg_17.sv}
vlog -sv -work work +incdir+C:/Users/zacha/Downloads/385_lab4_adders_provided_fa20 {C:/Users/zacha/Downloads/385_lab4_adders_provided_fa20/lookahead_adder.sv}
vlog -sv -work work +incdir+C:/Users/zacha/Downloads/385_lab4_adders_provided_fa20 {C:/Users/zacha/Downloads/385_lab4_adders_provided_fa20/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/zacha/Downloads/385_lab4_adders_provided_fa20 {C:/Users/zacha/Downloads/385_lab4_adders_provided_fa20/control.sv}
vlog -sv -work work +incdir+C:/Users/zacha/Downloads/385_lab4_adders_provided_fa20 {C:/Users/zacha/Downloads/385_lab4_adders_provided_fa20/adder2.sv}

