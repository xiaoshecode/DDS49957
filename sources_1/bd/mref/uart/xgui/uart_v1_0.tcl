# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BAUD_RATE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BYTE_NUM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CHECK_SEL" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CLK_FREQ" -parent ${Page_0}


}

proc update_PARAM_VALUE.BAUD_RATE { PARAM_VALUE.BAUD_RATE } {
	# Procedure called to update BAUD_RATE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BAUD_RATE { PARAM_VALUE.BAUD_RATE } {
	# Procedure called to validate BAUD_RATE
	return true
}

proc update_PARAM_VALUE.BYTE_NUM { PARAM_VALUE.BYTE_NUM } {
	# Procedure called to update BYTE_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BYTE_NUM { PARAM_VALUE.BYTE_NUM } {
	# Procedure called to validate BYTE_NUM
	return true
}

proc update_PARAM_VALUE.CHECK_SEL { PARAM_VALUE.CHECK_SEL } {
	# Procedure called to update CHECK_SEL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CHECK_SEL { PARAM_VALUE.CHECK_SEL } {
	# Procedure called to validate CHECK_SEL
	return true
}

proc update_PARAM_VALUE.CLK_FREQ { PARAM_VALUE.CLK_FREQ } {
	# Procedure called to update CLK_FREQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLK_FREQ { PARAM_VALUE.CLK_FREQ } {
	# Procedure called to validate CLK_FREQ
	return true
}


proc update_MODELPARAM_VALUE.CLK_FREQ { MODELPARAM_VALUE.CLK_FREQ PARAM_VALUE.CLK_FREQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLK_FREQ}] ${MODELPARAM_VALUE.CLK_FREQ}
}

proc update_MODELPARAM_VALUE.BAUD_RATE { MODELPARAM_VALUE.BAUD_RATE PARAM_VALUE.BAUD_RATE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BAUD_RATE}] ${MODELPARAM_VALUE.BAUD_RATE}
}

proc update_MODELPARAM_VALUE.CHECK_SEL { MODELPARAM_VALUE.CHECK_SEL PARAM_VALUE.CHECK_SEL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CHECK_SEL}] ${MODELPARAM_VALUE.CHECK_SEL}
}

proc update_MODELPARAM_VALUE.BYTE_NUM { MODELPARAM_VALUE.BYTE_NUM PARAM_VALUE.BYTE_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BYTE_NUM}] ${MODELPARAM_VALUE.BYTE_NUM}
}

