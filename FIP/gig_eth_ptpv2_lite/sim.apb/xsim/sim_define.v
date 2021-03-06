`ifndef _SIM_DEFINE_V_
`define _SIM_DEFNE_V_
//-----------------------------------------------------------------------
// Copyright (c) 2013 by Ando Ki
// All rights reserved.
//
// This program is distributed in the hope that it
// will be useful to understand Ando Ki's work,
// BUT WITHOUT ANY WARRANTY.
//-----------------------------------------------------------------------
`define SIM      // define this for simulation case if you are not sure
`undef  SYN      // undefine this for simulation case
`define VCD       // define this for VCD waveform dump
`undef  DEBUG
`define RIGOR
//-----------------------------------------------------------------------
`define VIVADO
`undef  ISE
//-----------------------------------------------------------------------
`define FPGA_FAMILY         "ZYNQ7000"
//`define FPGA_FAMILY         "VirtexUS"
//`define AMBA_AXI4
//-----------------------------------------------------------------------
`define GMII_PHY_RESET
//-----------------------------------------------------------------------
`define PTPV2_DEBUG
//-----------------------------------------------------------------------
`endif
