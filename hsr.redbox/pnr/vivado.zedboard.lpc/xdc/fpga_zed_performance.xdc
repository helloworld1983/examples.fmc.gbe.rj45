#--------------------------------------------------------
# Use this when 'HSR_PERFORMANCE' is defined

set_property PACKAGE_PIN Y11  [get_ports {host_probe_txen}];// JA1   (Y11 )
set_property PACKAGE_PIN AA11 [get_ports {host_probe_rxdv}];// JA2   (AA11)
set_property PACKAGE_PIN AB11 [get_ports {netA_probe_txen}];// JA7   (AB11)
set_property PACKAGE_PIN AB10 [get_ports {netA_probe_rxdv}];// JA8   (AB10)
set_property PACKAGE_PIN AB9  [get_ports {netB_probe_txen}];// JA9   (AB9 )
set_property PACKAGE_PIN AA8  [get_ports {netB_probe_rxdv}];// JA10  (AA8 )
set_property IOSTANDARD LVCMOS33 [get_ports {host_probe_*}  ]
set_property IOSTANDARD LVCMOS33 [get_ports {netA_probe_*}  ]
set_property IOSTANDARD LVCMOS33 [get_ports {netB_probe_*}  ]
set_input_delay 10 -clock [get_clocks CLK100] [get_ports *_probe_*]
set_false_path -from [get_ports *_probe_*]
#--------------------------------------------------------
