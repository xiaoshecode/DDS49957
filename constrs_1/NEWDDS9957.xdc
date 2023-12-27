# DDS0
# 每个AD9910 共有 
set_property -dict {PACKAGE_PIN AF25 IOSTANDARD LVCMOS33} [get_ports {ad9910_masterrst[0]}]
# DDS0_SPI
set_property -dict {PACKAGE_PIN AE25 IOSTANDARD LVCMOS33} [get_ports {ad9910_csn[0]}]
set_property -dict {PACKAGE_PIN AK25 IOSTANDARD LVCMOS33} [get_ports {ad9910_sclk[0]}]
set_property -dict {PACKAGE_PIN AJ24 IOSTANDARD LVCMOS33} [get_ports {ad9910_mosi[0]}]
set_property -dict {PACKAGE_PIN AJ25 IOSTANDARD LVCMOS33} [get_ports {ad9910_miso[0]}]
# DDS0_CTRL
set_property -dict {PACKAGE_PIN AH24 IOSTANDARD LVCMOS33} [get_ports {ad9910_ioupdate[0]}]
set_property -dict {PACKAGE_PIN AE23 IOSTANDARD LVCMOS33} [get_ports {ad9910_pdclk_ch0_i}]
set_property -dict {PACKAGE_PIN AJ22 IOSTANDARD LVCMOS33} [get_ports {ad9910_Txenable_ch0_o}]
set_property -dict {PACKAGE_PIN AF22 IOSTANDARD LVCMOS33} [get_ports {ad9910_ch0_profile[0]}]
set_property -dict {PACKAGE_PIN AG23 IOSTANDARD LVCMOS33} [get_ports {ad9910_ch0_profile[1]}]
set_property -dict {PACKAGE_PIN AG24 IOSTANDARD LVCMOS33} [get_ports {ad9910_ch0_profile[2]}]
#DDS0_Dport
set_property -dict {PACKAGE_PIN AC25 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch0_o[15]}]
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33}  [get_ports {ad9910_Dport_ch0_o[14]}]
set_property -dict {PACKAGE_PIN AB24 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch0_o[13]}]
set_property -dict {PACKAGE_PIN Y23 IOSTANDARD LVCMOS33}  [get_ports {ad9910_Dport_ch0_o[12]}]
set_property -dict {PACKAGE_PIN AA23 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch0_o[11]}]
set_property -dict {PACKAGE_PIN AA22 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch0_o[10]}]
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch0_o[9]}]
set_property -dict {PACKAGE_PIN AC24 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch0_o[8]}]
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch0_o[7]}]
set_property -dict {PACKAGE_PIN AD24 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch0_o[6]}]
set_property -dict {PACKAGE_PIN AC21 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch0_o[5]}]
set_property -dict {PACKAGE_PIN AB23 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch0_o[4]}]
set_property -dict {PACKAGE_PIN Y21 IOSTANDARD LVCMOS33}  [get_ports {ad9910_Dport_ch0_o[3]}]
set_property -dict {PACKAGE_PIN AD22 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch0_o[2]}]
set_property -dict {PACKAGE_PIN AC22 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch0_o[1]}]
set_property -dict {PACKAGE_PIN AC20 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch0_o[0]}]
#DDS0_Fport
set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS33} [get_ports {ad9910_Fport_ch0_o[1]}]
set_property -dict {PACKAGE_PIN AB20 IOSTANDARD LVCMOS33} [get_ports {ad9910_Fport_ch0_o[0]}]
#DDS0_SYNC
set_property -dict {PACKAGE_PIN AD23 IOSTANDARD LVCMOS33} [get_ports {sync_clk[0]}]
# TODO:ext_prof_ch


# DDS1
set_property -dict {PACKAGE_PIN AF30 IOSTANDARD LVCMOS33} [get_ports {ad9910_masterrst[1]}]
set_property -dict {PACKAGE_PIN AF30 IOSTANDARD LVCMOS33} [get_ports {ad9910_masterrst[1]}]
set_property -dict {PACKAGE_PIN AE30 IOSTANDARD LVCMOS33} [get_ports {ad9910_ssn[1]}]
set_property -dict {PACKAGE_PIN AE30 IOSTANDARD LVCMOS33} [get_ports {ad9910_ssn[1]}]
set_property -dict {PACKAGE_PIN AK29 IOSTANDARD LVCMOS33} [get_ports {ad9910_sclk[1]}]
set_property -dict {PACKAGE_PIN AF28 IOSTANDARD LVCMOS33} [get_ports {ad9910_mosi[1]}]
#DDS1_CTRL
set_property -dict {PACKAGE_PIN AK28 IOSTANDARD LVCMOS33} [get_ports {ad9910_ioupdate[1]}]
set_property -dict {PACKAGE_PIN AK28 IOSTANDARD LVCMOS33} [get_ports {ad9910_ioupdate[1]}]
set_property -dict {PACKAGE_PIN AH26 IOSTANDARD LVCMOS33} [get_ports {ad9910_ch1_profile[0]}]
set_property -dict {PACKAGE_PIN AG28 IOSTANDARD LVCMOS33} [get_ports {ad9910_ch1_profile[1]}]
set_property -dict {PACKAGE_PIN AE26 IOSTANDARD LVCMOS33} [get_ports {ad9910_ch1_profile[2]}]
set_property -dict {PACKAGE_PIN AD27 IOSTANDARD LVCMOS33} [get_ports {ad9910_pdclk_ch1_i}]
set_property -dict {PACKAGE_PIN AJ26 IOSTANDARD LVCMOS33} [get_ports {ad9910_Txenable_ch1_o}]
#DDS1_Dport
set_property -dict {PACKAGE_PIN W28 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[15]}]
set_property -dict {PACKAGE_PIN W29 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[14]}]
set_property -dict {PACKAGE_PIN Y28 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[13]}]
set_property -dict {PACKAGE_PIN Y29 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[12]}]
set_property -dict {PACKAGE_PIN AA30 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[11]}]
set_property -dict {PACKAGE_PIN W27 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[10]}]
set_property -dict {PACKAGE_PIN Y26 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[9]}]
set_property -dict {PACKAGE_PIN Y30 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[8]}]
set_property -dict {PACKAGE_PIN AA27 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[7]}]
set_property -dict {PACKAGE_PIN AA28 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[6]}]
set_property -dict {PACKAGE_PIN AA26 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[5]}]
set_property -dict {PACKAGE_PIN AA25 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[4]}]
set_property -dict {PACKAGE_PIN AB28 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[3]}]
set_property -dict {PACKAGE_PIN AB25 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[2]}]
set_property -dict {PACKAGE_PIN AC30 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[1]}]
set_property -dict {PACKAGE_PIN AC29 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch1_o[0]}]
#DDS1_Fport
set_property -dict {PACKAGE_PIN AE29 IOSTANDARD LVCMOS33} [get_ports {ad9910_Fport_ch1_o[1]}]
set_property -dict {PACKAGE_PIN AD29 IOSTANDARD LVCMOS33} [get_ports {ad9910_Fport_ch1_o[0]}]
#DDS1_SYNC
set_property -dict {PACKAGE_PIN AB27 IOSTANDARD LVCMOS33} [get_ports {sync_clk[1]}]

# DDS2
set_property -dict {PACKAGE_PIN M27 IOSTANDARD LVCMOS33} [get_ports {ad9910_masterrst[2]}]
set_property -dict {PACKAGE_PIN N27 IOSTANDARD LVCMOS33} [get_ports {ad9910_ssn[2]}]
set_property -dict {PACKAGE_PIN M30 IOSTANDARD LVCMOS33} [get_ports {ad9910_sclk[2]}]
set_property -dict {PACKAGE_PIN M29 IOSTANDARD LVCMOS33} [get_ports {ad9910_mosi[2]}]
#DDS2_CTRL
set_property -dict {PACKAGE_PIN M24 IOSTANDARD LVCMOS33} [get_ports {ad9910_ioupdate[2]}]
set_property -dict {PACKAGE_PIN M24 IOSTANDARD LVCMOS33} [get_ports {ad9910_ioupdate[2]}]
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS33} [get_ports {ad9910_ch2_profile[0]}]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports {ad9910_ch2_profile[1]}]
set_property -dict {PACKAGE_PIN N24 IOSTANDARD LVCMOS33} [get_ports {ad9910_ch2_profile[2]}]
set_property -dict {PACKAGE_PIN L26 IOSTANDARD LVCMOS33} [get_ports {ad9910_pdclk_ch2_i}]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports {ad9910_Txenable_ch2_o}]
#DDS2_Dport
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[15]}]
set_property -dict {PACKAGE_PIN H29 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[14]}]
set_property -dict {PACKAGE_PIN J27 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[13]}]
set_property -dict {PACKAGE_PIN J28 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[12]}]
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[11]}]
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[10]}]
set_property -dict {PACKAGE_PIN J23 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[9]}]
set_property -dict {PACKAGE_PIN K23 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[8]}]
set_property -dict {PACKAGE_PIN J24 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[7]}]
set_property -dict {PACKAGE_PIN J29 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[6]}]
set_property -dict {PACKAGE_PIN K24 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[5]}]
set_property -dict {PACKAGE_PIN K30 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[4]}]
set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[3]}]
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[2]}]
set_property -dict {PACKAGE_PIN L30 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[1]}]
set_property -dict {PACKAGE_PIN L23 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch2_o[0]}]
#DDS2_Fport
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS33} [get_ports {ad9910_Fport_ch2_o[1]}]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports {ad9910_Fport_ch2_o[0]}]
#DDS2_SYNC
set_property -dict {PACKAGE_PIN L25 IOSTANDARD LVCMOS33} [get_ports {sync_clk[2]}]

# DDS3
set_property -dict {PACKAGE_PIN H26 IOSTANDARD LVCMOS33} [get_ports {ad9910_masterrst[3]}]
set_property -dict {PACKAGE_PIN H26 IOSTANDARD LVCMOS33} [get_ports {ad9910_masterrst[3]}]
set_property -dict {PACKAGE_PIN F30 IOSTANDARD LVCMOS33} [get_ports {ad9910_ssn[3]}]
set_property -dict {PACKAGE_PIN F30 IOSTANDARD LVCMOS33} [get_ports {ad9910_ssn[3]}]
set_property -dict {PACKAGE_PIN G29 IOSTANDARD LVCMOS33} [get_ports {ad9910_sclk[3]}]
set_property -dict {PACKAGE_PIN F27 IOSTANDARD LVCMOS33} [get_ports {ad9910_mosi[3]}]
#DDS3_CTRL
set_property -dict {PACKAGE_PIN G27 IOSTANDARD LVCMOS33} [get_ports {ad9910_ioupdate[3]}]
set_property -dict {PACKAGE_PIN H25 IOSTANDARD LVCMOS33} [get_ports {ad9910_ch3_profile[0]}]
set_property -dict {PACKAGE_PIN G28 IOSTANDARD LVCMOS33} [get_ports {ad9910_ch3_profile[1]}]
set_property -dict {PACKAGE_PIN F28 IOSTANDARD LVCMOS33} [get_ports {ad9910_ch3_profile[2]}]
set_property -dict {PACKAGE_PIN D26 IOSTANDARD LVCMOS33} [get_ports {ad9910_pdclk_ch3_i}]
set_property -dict {PACKAGE_PIN A30 IOSTANDARD LVCMOS33} [get_ports {ad9910_Txenable_ch3_o}]
#DDS3_Dport
set_property -dict {PACKAGE_PIN E23 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[15]}]
set_property -dict {PACKAGE_PIN G23 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[14]}]
set_property -dict {PACKAGE_PIN D24 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[13]}]
set_property -dict {PACKAGE_PIN G24 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[12]}]
set_property -dict {PACKAGE_PIN D23 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[11]}]
set_property -dict {PACKAGE_PIN A23 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[10]}]
set_property -dict {PACKAGE_PIN E25 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[9]}]
set_property -dict {PACKAGE_PIN F25 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[8]}]
set_property -dict {PACKAGE_PIN B23 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[7]}]
set_property -dict {PACKAGE_PIN E24 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[6]}]
set_property -dict {PACKAGE_PIN E26 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[5]}]
set_property -dict {PACKAGE_PIN F26 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[4]}]
set_property -dict {PACKAGE_PIN B24 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[3]}]
set_property -dict {PACKAGE_PIN AC27 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[2]}]
set_property -dict {PACKAGE_PIN B27 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[1]}]
set_property -dict {PACKAGE_PIN C24 IOSTANDARD LVCMOS33} [get_ports {ad9910_Dport_ch3_o[0]}]
#DDS3_Fport
set_property -dict {PACKAGE_PIN B28 IOSTANDARD LVCMOS33} [get_ports {ad9910_Fport_ch3_o[1]}]
set_property -dict {PACKAGE_PIN A28 IOSTANDARD LVCMOS33} [get_ports {ad9910_Fport_ch3_o[0]}]
#DDS3_SYNC
set_property -dict {PACKAGE_PIN G25 IOSTANDARD LVCMOS33} [get_ports {sync_clk[3]}]

#SYNC_CLK
#TODO

#CLK
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports {sys_clk}]

#RST
set_property -dict {PACKAGE_PIN Y25 IOSTANDARD LVCMOS33} [get_ports {rstn_i}]

#UART
set_property -dict {PACKAGE_PIN AH21 IOSTANDARD LVCMOS33} [get_ports UART_TXD]
set_property -dict {PACKAGE_PIN AJ21 IOSTANDARD LVCMOS33} [get_ports UART_RXD]

#JATG
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

#PLL
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS33} [get_ports {pll_cs}]
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33} [get_ports {pll_sclk}]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports {pll_sdi}]
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS33} [get_ports {pll_stat}]
set_property -dict {PACKAGE_PIN AC26 IOSTANDARD LVCMOS33} [get_ports {pll_lock_led}]
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33} [get_ports {ref_clk_sel}]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {pll_sync_in}]

#ILA
# create_debug_core u_ila_0 ila
# set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
# set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
# set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
# set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
# set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
# set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
# set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
# set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
# set_property port_width 1 [get_debug_ports u_ila_0/clk]
# connect_debug_port u_ila_0/clk [get_nets [list clk_inst/inst/clk_out2]]
# set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
# set_property port_width 1 [get_debug_ports u_ila_0/probe0]
# connect_debug_port u_ila_0/probe0 [get_nets [list pll_cs_OBUF]]
# create_debug_port u_ila_0 probe
# set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
# set_property port_width 1 [get_debug_ports u_ila_0/probe1]
# connect_debug_port u_ila_0/probe1 [get_nets [list pll_sdi_OBUF]]
# create_debug_port u_ila_0 probe
# set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
# set_property port_width 1 [get_debug_ports u_ila_0/probe2]
# connect_debug_port u_ila_0/probe2 [get_nets [list pll_sclk_OBUF]]
# set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
# set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
# set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
# connect_debug_port dbg_hub/clk [get_nets clk_20M]
