//---------------------------------------------------------------------------
// Copyright (c) 2016 by Ando Ki (andoki@gmail.com )                         
// The contents and codes along with it are prepared in the hope that        
// it will be useful to understand Ando Ki's work, but WITHOUT ANY WARRANTY. 
// The design is not guaranteed to work on all systems, and no technical     
// support will be provided for problems that might arise.                   
//                                                                           
// THIS DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.       
//---------------------------------------------------------------------------
// gen_amba_axi                                                              
//---------------------------------------------------------------------------
`timescale 1ns/1ns
//---------------------------------------------------------------------------
module axi_switch_m2s5
      #(parameter WIDTH_CID   = 4 // Channel ID width in bits
                , WIDTH_ID    = 4 // ID width in bits
                , WIDTH_AD    =32 // address width
                , WIDTH_DA    =32 // data width
                , WIDTH_DS    =(WIDTH_DA/8)  // data strobe width
                , WIDTH_SID   =(WIDTH_CID+WIDTH_ID)// ID for slave
                , WIDTH_AWUSER= 1 // Write-address user path
                , WIDTH_WUSER = 1 // Write-data user path
                , WIDTH_BUSER = 1 // Write-response user path
                , WIDTH_ARUSER= 1 // read-address user path
                , WIDTH_RUSER = 1 // read-data user path
                , SLAVE_EN0   = 1 , ADDR_BASE0  =32'h00000000 , ADDR_LENGTH0=12 // effective addre bits
                , SLAVE_EN1   = 1 , ADDR_BASE1  =32'h00002000 , ADDR_LENGTH1=12 // effective addre bits
                , SLAVE_EN2   = 1 , ADDR_BASE2  =32'h00004000 , ADDR_LENGTH2=12 // effective addre bits
                , SLAVE_EN3   = 1 , ADDR_BASE3  =32'h00006000 , ADDR_LENGTH3=12 // effective addre bits
                , SLAVE_EN4   = 1 , ADDR_BASE4  =32'h00008000 , ADDR_LENGTH4=12 // effective addre bits
                , NUM_MASTER  = 2  // should not be changed
                , NUM_SLAVE   = 5  // should not be changed
       )
(
       input   wire                      ARESETn
     , input   wire                      ACLK
     //--------------------------------------------------------------
     , input   wire  [WIDTH_CID-1:0]     M0_MID   // if not sure use 'h0
     , input   wire  [WIDTH_ID-1:0]      M0_AWID
     , input   wire  [WIDTH_AD-1:0]      M0_AWADDR
     `ifdef AMBA_AXI4
     , input   wire  [ 7:0]              M0_AWLEN
     , input   wire                      M0_AWLOCK
     `else
     , input   wire  [ 3:0]              M0_AWLEN
     , input   wire  [ 1:0]              M0_AWLOCK
     `endif
     , input   wire  [ 2:0]              M0_AWSIZE
     , input   wire  [ 1:0]              M0_AWBURST
     `ifdef  AMBA_AXI_CACHE
     , input   wire  [ 3:0]              M0_AWCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , input   wire  [ 2:0]              M0_AWPROT
     `endif
     , input   wire                      M0_AWVALID
     , output  wire                      M0_AWREADY
     `ifdef AMBA_AXI4
     , input   wire  [ 3:0]              M0_AWQOS
     , input   wire  [ 3:0]              M0_AWREGION
     `endif
     `ifdef AMBA_AXI_AWUSER
     , input   wire  [WIDTH_AWUSER-1:0]  M0_AWUSER
     `endif
     , input   wire  [WIDTH_ID-1:0]      M0_WID
     , input   wire  [WIDTH_DA-1:0]      M0_WDATA
     , input   wire  [WIDTH_DS-1:0]      M0_WSTRB
     , input   wire                      M0_WLAST
     , input   wire                      M0_WVALID
     , output  wire                      M0_WREADY
     `ifdef AMBA_AXI_WUSER
     , input   wire  [WIDTH_WUSER-1:0]   M0_WUSER
     `endif
     , output  wire  [WIDTH_ID-1:0]      M0_BID
     , output  wire  [ 1:0]              M0_BRESP
     , output  wire                      M0_BVALID
     , input   wire                      M0_BREADY
     `ifdef AMBA_AXI_BUSER
     , output  wire  [WIDTH_BUSER-1:0]   M0_BUSER
     `endif
     , input   wire  [WIDTH_ID-1:0]      M0_ARID
     , input   wire  [WIDTH_AD-1:0]      M0_ARADDR
     `ifdef AMBA_AXI4
     , input   wire  [ 7:0]              M0_ARLEN
     , input   wire                      M0_ARLOCK
     `else
     , input   wire  [ 3:0]              M0_ARLEN
     , input   wire  [ 1:0]              M0_ARLOCK
     `endif
     , input   wire  [ 2:0]              M0_ARSIZE
     , input   wire  [ 1:0]              M0_ARBURST
     `ifdef  AMBA_AXI_CACHE
     , input   wire  [ 3:0]              M0_ARCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , input   wire  [ 2:0]              M0_ARPROT
     `endif
     , input   wire                      M0_ARVALID
     , output  wire                      M0_ARREADY
     `ifdef AMBA_AXI4
     , input   wire  [ 3:0]              M0_ARQOS
     , input   wire  [ 3:0]              M0_ARREGION
     `endif
     `ifdef AMBA_AXI_ARUSER
     , input   wire  [WIDTH_ARUSER-1:0]  M0_ARUSER
     `endif
     , output  wire  [WIDTH_ID-1:0]      M0_RID
     , output  wire  [WIDTH_DA-1:0]      M0_RDATA
     , output  wire  [ 1:0]              M0_RRESP
     , output  wire                      M0_RLAST
     , output  wire                      M0_RVALID
     , input   wire                      M0_RREADY
     `ifdef AMBA_AXI_RUSER
     , output  wire  [WIDTH_RUSER-1:0]   M0_RUSER
     `endif
     //--------------------------------------------------------------
     , input   wire  [WIDTH_CID-1:0]     M1_MID   // if not sure use 'h1
     , input   wire  [WIDTH_ID-1:0]      M1_AWID
     , input   wire  [WIDTH_AD-1:0]      M1_AWADDR
     `ifdef AMBA_AXI4
     , input   wire  [ 7:0]              M1_AWLEN
     , input   wire                      M1_AWLOCK
     `else
     , input   wire  [ 3:0]              M1_AWLEN
     , input   wire  [ 1:0]              M1_AWLOCK
     `endif
     , input   wire  [ 2:0]              M1_AWSIZE
     , input   wire  [ 1:0]              M1_AWBURST
     `ifdef  AMBA_AXI_CACHE
     , input   wire  [ 3:0]              M1_AWCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , input   wire  [ 2:0]              M1_AWPROT
     `endif
     , input   wire                      M1_AWVALID
     , output  wire                      M1_AWREADY
     `ifdef AMBA_AXI4
     , input   wire  [ 3:0]              M1_AWQOS
     , input   wire  [ 3:0]              M1_AWREGION
     `endif
     `ifdef AMBA_AXI_AWUSER
     , input   wire  [WIDTH_AWUSER-1:0]  M1_AWUSER
     `endif
     , input   wire  [WIDTH_ID-1:0]      M1_WID
     , input   wire  [WIDTH_DA-1:0]      M1_WDATA
     , input   wire  [WIDTH_DS-1:0]      M1_WSTRB
     , input   wire                      M1_WLAST
     , input   wire                      M1_WVALID
     , output  wire                      M1_WREADY
     `ifdef AMBA_AXI_WUSER
     , input   wire  [WIDTH_WUSER-1:0]   M1_WUSER
     `endif
     , output  wire  [WIDTH_ID-1:0]      M1_BID
     , output  wire  [ 1:0]              M1_BRESP
     , output  wire                      M1_BVALID
     , input   wire                      M1_BREADY
     `ifdef AMBA_AXI_BUSER
     , output  wire  [WIDTH_BUSER-1:0]   M1_BUSER
     `endif
     , input   wire  [WIDTH_ID-1:0]      M1_ARID
     , input   wire  [WIDTH_AD-1:0]      M1_ARADDR
     `ifdef AMBA_AXI4
     , input   wire  [ 7:0]              M1_ARLEN
     , input   wire                      M1_ARLOCK
     `else
     , input   wire  [ 3:0]              M1_ARLEN
     , input   wire  [ 1:0]              M1_ARLOCK
     `endif
     , input   wire  [ 2:0]              M1_ARSIZE
     , input   wire  [ 1:0]              M1_ARBURST
     `ifdef  AMBA_AXI_CACHE
     , input   wire  [ 3:0]              M1_ARCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , input   wire  [ 2:0]              M1_ARPROT
     `endif
     , input   wire                      M1_ARVALID
     , output  wire                      M1_ARREADY
     `ifdef AMBA_AXI4
     , input   wire  [ 3:0]              M1_ARQOS
     , input   wire  [ 3:0]              M1_ARREGION
     `endif
     `ifdef AMBA_AXI_ARUSER
     , input   wire  [WIDTH_ARUSER-1:0]  M1_ARUSER
     `endif
     , output  wire  [WIDTH_ID-1:0]      M1_RID
     , output  wire  [WIDTH_DA-1:0]      M1_RDATA
     , output  wire  [ 1:0]              M1_RRESP
     , output  wire                      M1_RLAST
     , output  wire                      M1_RVALID
     , input   wire                      M1_RREADY
     `ifdef AMBA_AXI_RUSER
     , output  wire  [WIDTH_RUSER-1:0]   M1_RUSER
     `endif
     //--------------------------------------------------------------
     , output  wire   [WIDTH_SID-1:0]    S0_AWID
     , output  wire   [WIDTH_AD-1:0]     S0_AWADDR
     `ifdef AMBA_AXI4
     , output  wire   [ 7:0]             S0_AWLEN
     , output  wire                      S0_AWLOCK
     `else
     , output  wire   [ 3:0]             S0_AWLEN
     , output  wire   [ 1:0]             S0_AWLOCK
     `endif
     , output  wire   [ 2:0]             S0_AWSIZE
     , output  wire   [ 1:0]             S0_AWBURST
     `ifdef  AMBA_AXI_CACHE
     , output  wire   [ 3:0]             S0_AWCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , output  wire   [ 2:0]             S0_AWPROT
     `endif
     , output  wire                      S0_AWVALID
     , input   wire                      S0_AWREADY
     `ifdef AMBA_AXI4
     , output  wire   [ 3:0]             S0_AWQOS
     , output  wire   [ 3:0]             S0_AWREGION
     `endif
     `ifdef AMBA_AXI_AWUSER
     , output  wire   [WIDTH_AWUSER-1:0] S0_AWUSER
     `endif
     , output  wire   [WIDTH_SID-1:0]    S0_WID
     , output  wire   [WIDTH_DA-1:0]     S0_WDATA
     , output  wire   [WIDTH_DS-1:0]     S0_WSTRB
     , output  wire                      S0_WLAST
     , output  wire                      S0_WVALID
     , input   wire                      S0_WREADY
     `ifdef AMBA_AXI_WUSER
     , output  wire   [WIDTH_WUSER-1:0]  S0_WUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    S0_BID
     , input   wire   [ 1:0]             S0_BRESP
     , input   wire                      S0_BVALID
     , output  wire                      S0_BREADY
     `ifdef AMBA_AXI_BUSER
     , input   wire   [WIDTH_BUSER-1:0]  S0_BUSER
     `endif
     , output  wire   [WIDTH_SID-1:0]    S0_ARID
     , output  wire   [WIDTH_AD-1:0]     S0_ARADDR
     `ifdef AMBA_AXI4
     , output  wire   [ 7:0]             S0_ARLEN
     , output  wire                      S0_ARLOCK
     `else
     , output  wire   [ 3:0]             S0_ARLEN
     , output  wire   [ 1:0]             S0_ARLOCK
     `endif
     , output  wire   [ 2:0]             S0_ARSIZE
     , output  wire   [ 1:0]             S0_ARBURST
     `ifdef  AMBA_AXI_CACHE
     , output  wire   [ 3:0]             S0_ARCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , output  wire   [ 2:0]             S0_ARPROT
     `endif
     , output  wire                      S0_ARVALID
     , input   wire                      S0_ARREADY
     `ifdef AMBA_AXI4
     , output  wire   [ 3:0]             S0_ARQOS
     , output  wire   [ 3:0]             S0_ARREGION
     `endif
     `ifdef AMBA_AXI_ARUSER
     , output  wire   [WIDTH_ARUSER-1:0] S0_ARUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    S0_RID
     , input   wire   [WIDTH_DA-1:0]     S0_RDATA
     , input   wire   [ 1:0]             S0_RRESP
     , input   wire                      S0_RLAST
     , input   wire                      S0_RVALID
     , output  wire                      S0_RREADY
     `ifdef AMBA_AXI_RUSER
     , input   wire   [WIDTH_RUSER-1:0]  S0_RUSER
     `endif
     //--------------------------------------------------------------
     , output  wire   [WIDTH_SID-1:0]    S1_AWID
     , output  wire   [WIDTH_AD-1:0]     S1_AWADDR
     `ifdef AMBA_AXI4
     , output  wire   [ 7:0]             S1_AWLEN
     , output  wire                      S1_AWLOCK
     `else
     , output  wire   [ 3:0]             S1_AWLEN
     , output  wire   [ 1:0]             S1_AWLOCK
     `endif
     , output  wire   [ 2:0]             S1_AWSIZE
     , output  wire   [ 1:0]             S1_AWBURST
     `ifdef  AMBA_AXI_CACHE
     , output  wire   [ 3:0]             S1_AWCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , output  wire   [ 2:0]             S1_AWPROT
     `endif
     , output  wire                      S1_AWVALID
     , input   wire                      S1_AWREADY
     `ifdef AMBA_AXI4
     , output  wire   [ 3:0]             S1_AWQOS
     , output  wire   [ 3:0]             S1_AWREGION
     `endif
     `ifdef AMBA_AXI_AWUSER
     , output  wire   [WIDTH_AWUSER-1:0] S1_AWUSER
     `endif
     , output  wire   [WIDTH_SID-1:0]    S1_WID
     , output  wire   [WIDTH_DA-1:0]     S1_WDATA
     , output  wire   [WIDTH_DS-1:0]     S1_WSTRB
     , output  wire                      S1_WLAST
     , output  wire                      S1_WVALID
     , input   wire                      S1_WREADY
     `ifdef AMBA_AXI_WUSER
     , output  wire   [WIDTH_WUSER-1:0]  S1_WUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    S1_BID
     , input   wire   [ 1:0]             S1_BRESP
     , input   wire                      S1_BVALID
     , output  wire                      S1_BREADY
     `ifdef AMBA_AXI_BUSER
     , input   wire   [WIDTH_BUSER-1:0]  S1_BUSER
     `endif
     , output  wire   [WIDTH_SID-1:0]    S1_ARID
     , output  wire   [WIDTH_AD-1:0]     S1_ARADDR
     `ifdef AMBA_AXI4
     , output  wire   [ 7:0]             S1_ARLEN
     , output  wire                      S1_ARLOCK
     `else
     , output  wire   [ 3:0]             S1_ARLEN
     , output  wire   [ 1:0]             S1_ARLOCK
     `endif
     , output  wire   [ 2:0]             S1_ARSIZE
     , output  wire   [ 1:0]             S1_ARBURST
     `ifdef  AMBA_AXI_CACHE
     , output  wire   [ 3:0]             S1_ARCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , output  wire   [ 2:0]             S1_ARPROT
     `endif
     , output  wire                      S1_ARVALID
     , input   wire                      S1_ARREADY
     `ifdef AMBA_AXI4
     , output  wire   [ 3:0]             S1_ARQOS
     , output  wire   [ 3:0]             S1_ARREGION
     `endif
     `ifdef AMBA_AXI_ARUSER
     , output  wire   [WIDTH_ARUSER-1:0] S1_ARUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    S1_RID
     , input   wire   [WIDTH_DA-1:0]     S1_RDATA
     , input   wire   [ 1:0]             S1_RRESP
     , input   wire                      S1_RLAST
     , input   wire                      S1_RVALID
     , output  wire                      S1_RREADY
     `ifdef AMBA_AXI_RUSER
     , input   wire   [WIDTH_RUSER-1:0]  S1_RUSER
     `endif
     //--------------------------------------------------------------
     , output  wire   [WIDTH_SID-1:0]    S2_AWID
     , output  wire   [WIDTH_AD-1:0]     S2_AWADDR
     `ifdef AMBA_AXI4
     , output  wire   [ 7:0]             S2_AWLEN
     , output  wire                      S2_AWLOCK
     `else
     , output  wire   [ 3:0]             S2_AWLEN
     , output  wire   [ 1:0]             S2_AWLOCK
     `endif
     , output  wire   [ 2:0]             S2_AWSIZE
     , output  wire   [ 1:0]             S2_AWBURST
     `ifdef  AMBA_AXI_CACHE
     , output  wire   [ 3:0]             S2_AWCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , output  wire   [ 2:0]             S2_AWPROT
     `endif
     , output  wire                      S2_AWVALID
     , input   wire                      S2_AWREADY
     `ifdef AMBA_AXI4
     , output  wire   [ 3:0]             S2_AWQOS
     , output  wire   [ 3:0]             S2_AWREGION
     `endif
     `ifdef AMBA_AXI_AWUSER
     , output  wire   [WIDTH_AWUSER-1:0] S2_AWUSER
     `endif
     , output  wire   [WIDTH_SID-1:0]    S2_WID
     , output  wire   [WIDTH_DA-1:0]     S2_WDATA
     , output  wire   [WIDTH_DS-1:0]     S2_WSTRB
     , output  wire                      S2_WLAST
     , output  wire                      S2_WVALID
     , input   wire                      S2_WREADY
     `ifdef AMBA_AXI_WUSER
     , output  wire   [WIDTH_WUSER-1:0]  S2_WUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    S2_BID
     , input   wire   [ 1:0]             S2_BRESP
     , input   wire                      S2_BVALID
     , output  wire                      S2_BREADY
     `ifdef AMBA_AXI_BUSER
     , input   wire   [WIDTH_BUSER-1:0]  S2_BUSER
     `endif
     , output  wire   [WIDTH_SID-1:0]    S2_ARID
     , output  wire   [WIDTH_AD-1:0]     S2_ARADDR
     `ifdef AMBA_AXI4
     , output  wire   [ 7:0]             S2_ARLEN
     , output  wire                      S2_ARLOCK
     `else
     , output  wire   [ 3:0]             S2_ARLEN
     , output  wire   [ 1:0]             S2_ARLOCK
     `endif
     , output  wire   [ 2:0]             S2_ARSIZE
     , output  wire   [ 1:0]             S2_ARBURST
     `ifdef  AMBA_AXI_CACHE
     , output  wire   [ 3:0]             S2_ARCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , output  wire   [ 2:0]             S2_ARPROT
     `endif
     , output  wire                      S2_ARVALID
     , input   wire                      S2_ARREADY
     `ifdef AMBA_AXI4
     , output  wire   [ 3:0]             S2_ARQOS
     , output  wire   [ 3:0]             S2_ARREGION
     `endif
     `ifdef AMBA_AXI_ARUSER
     , output  wire   [WIDTH_ARUSER-1:0] S2_ARUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    S2_RID
     , input   wire   [WIDTH_DA-1:0]     S2_RDATA
     , input   wire   [ 1:0]             S2_RRESP
     , input   wire                      S2_RLAST
     , input   wire                      S2_RVALID
     , output  wire                      S2_RREADY
     `ifdef AMBA_AXI_RUSER
     , input   wire   [WIDTH_RUSER-1:0]  S2_RUSER
     `endif
     //--------------------------------------------------------------
     , output  wire   [WIDTH_SID-1:0]    S3_AWID
     , output  wire   [WIDTH_AD-1:0]     S3_AWADDR
     `ifdef AMBA_AXI4
     , output  wire   [ 7:0]             S3_AWLEN
     , output  wire                      S3_AWLOCK
     `else
     , output  wire   [ 3:0]             S3_AWLEN
     , output  wire   [ 1:0]             S3_AWLOCK
     `endif
     , output  wire   [ 2:0]             S3_AWSIZE
     , output  wire   [ 1:0]             S3_AWBURST
     `ifdef  AMBA_AXI_CACHE
     , output  wire   [ 3:0]             S3_AWCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , output  wire   [ 2:0]             S3_AWPROT
     `endif
     , output  wire                      S3_AWVALID
     , input   wire                      S3_AWREADY
     `ifdef AMBA_AXI4
     , output  wire   [ 3:0]             S3_AWQOS
     , output  wire   [ 3:0]             S3_AWREGION
     `endif
     `ifdef AMBA_AXI_AWUSER
     , output  wire   [WIDTH_AWUSER-1:0] S3_AWUSER
     `endif
     , output  wire   [WIDTH_SID-1:0]    S3_WID
     , output  wire   [WIDTH_DA-1:0]     S3_WDATA
     , output  wire   [WIDTH_DS-1:0]     S3_WSTRB
     , output  wire                      S3_WLAST
     , output  wire                      S3_WVALID
     , input   wire                      S3_WREADY
     `ifdef AMBA_AXI_WUSER
     , output  wire   [WIDTH_WUSER-1:0]  S3_WUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    S3_BID
     , input   wire   [ 1:0]             S3_BRESP
     , input   wire                      S3_BVALID
     , output  wire                      S3_BREADY
     `ifdef AMBA_AXI_BUSER
     , input   wire   [WIDTH_BUSER-1:0]  S3_BUSER
     `endif
     , output  wire   [WIDTH_SID-1:0]    S3_ARID
     , output  wire   [WIDTH_AD-1:0]     S3_ARADDR
     `ifdef AMBA_AXI4
     , output  wire   [ 7:0]             S3_ARLEN
     , output  wire                      S3_ARLOCK
     `else
     , output  wire   [ 3:0]             S3_ARLEN
     , output  wire   [ 1:0]             S3_ARLOCK
     `endif
     , output  wire   [ 2:0]             S3_ARSIZE
     , output  wire   [ 1:0]             S3_ARBURST
     `ifdef  AMBA_AXI_CACHE
     , output  wire   [ 3:0]             S3_ARCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , output  wire   [ 2:0]             S3_ARPROT
     `endif
     , output  wire                      S3_ARVALID
     , input   wire                      S3_ARREADY
     `ifdef AMBA_AXI4
     , output  wire   [ 3:0]             S3_ARQOS
     , output  wire   [ 3:0]             S3_ARREGION
     `endif
     `ifdef AMBA_AXI_ARUSER
     , output  wire   [WIDTH_ARUSER-1:0] S3_ARUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    S3_RID
     , input   wire   [WIDTH_DA-1:0]     S3_RDATA
     , input   wire   [ 1:0]             S3_RRESP
     , input   wire                      S3_RLAST
     , input   wire                      S3_RVALID
     , output  wire                      S3_RREADY
     `ifdef AMBA_AXI_RUSER
     , input   wire   [WIDTH_RUSER-1:0]  S3_RUSER
     `endif
     //--------------------------------------------------------------
     , output  wire   [WIDTH_SID-1:0]    S4_AWID
     , output  wire   [WIDTH_AD-1:0]     S4_AWADDR
     `ifdef AMBA_AXI4
     , output  wire   [ 7:0]             S4_AWLEN
     , output  wire                      S4_AWLOCK
     `else
     , output  wire   [ 3:0]             S4_AWLEN
     , output  wire   [ 1:0]             S4_AWLOCK
     `endif
     , output  wire   [ 2:0]             S4_AWSIZE
     , output  wire   [ 1:0]             S4_AWBURST
     `ifdef  AMBA_AXI_CACHE
     , output  wire   [ 3:0]             S4_AWCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , output  wire   [ 2:0]             S4_AWPROT
     `endif
     , output  wire                      S4_AWVALID
     , input   wire                      S4_AWREADY
     `ifdef AMBA_AXI4
     , output  wire   [ 3:0]             S4_AWQOS
     , output  wire   [ 3:0]             S4_AWREGION
     `endif
     `ifdef AMBA_AXI_AWUSER
     , output  wire   [WIDTH_AWUSER-1:0] S4_AWUSER
     `endif
     , output  wire   [WIDTH_SID-1:0]    S4_WID
     , output  wire   [WIDTH_DA-1:0]     S4_WDATA
     , output  wire   [WIDTH_DS-1:0]     S4_WSTRB
     , output  wire                      S4_WLAST
     , output  wire                      S4_WVALID
     , input   wire                      S4_WREADY
     `ifdef AMBA_AXI_WUSER
     , output  wire   [WIDTH_WUSER-1:0]  S4_WUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    S4_BID
     , input   wire   [ 1:0]             S4_BRESP
     , input   wire                      S4_BVALID
     , output  wire                      S4_BREADY
     `ifdef AMBA_AXI_BUSER
     , input   wire   [WIDTH_BUSER-1:0]  S4_BUSER
     `endif
     , output  wire   [WIDTH_SID-1:0]    S4_ARID
     , output  wire   [WIDTH_AD-1:0]     S4_ARADDR
     `ifdef AMBA_AXI4
     , output  wire   [ 7:0]             S4_ARLEN
     , output  wire                      S4_ARLOCK
     `else
     , output  wire   [ 3:0]             S4_ARLEN
     , output  wire   [ 1:0]             S4_ARLOCK
     `endif
     , output  wire   [ 2:0]             S4_ARSIZE
     , output  wire   [ 1:0]             S4_ARBURST
     `ifdef  AMBA_AXI_CACHE
     , output  wire   [ 3:0]             S4_ARCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , output  wire   [ 2:0]             S4_ARPROT
     `endif
     , output  wire                      S4_ARVALID
     , input   wire                      S4_ARREADY
     `ifdef AMBA_AXI4
     , output  wire   [ 3:0]             S4_ARQOS
     , output  wire   [ 3:0]             S4_ARREGION
     `endif
     `ifdef AMBA_AXI_ARUSER
     , output  wire   [WIDTH_ARUSER-1:0] S4_ARUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    S4_RID
     , input   wire   [WIDTH_DA-1:0]     S4_RDATA
     , input   wire   [ 1:0]             S4_RRESP
     , input   wire                      S4_RLAST
     , input   wire                      S4_RVALID
     , output  wire                      S4_RREADY
     `ifdef AMBA_AXI_RUSER
     , input   wire   [WIDTH_RUSER-1:0]  S4_RUSER
     `endif
);
     //-----------------------------------------------------------
     wire  [WIDTH_SID-1:0]     SD_AWID     ;
     wire  [WIDTH_AD-1:0]      SD_AWADDR   ;
     `ifdef AMBA_AXI4
     wire  [ 7:0]              SD_AWLEN    ;
     wire                      SD_AWLOCK   ;
     `else
     wire  [ 3:0]              SD_AWLEN    ;
     wire  [ 1:0]              SD_AWLOCK   ;
     `endif
     wire  [ 2:0]              SD_AWSIZE   ;
     wire  [ 1:0]              SD_AWBURST  ;
     `ifdef AMBA_AXI_CACHE
     wire  [ 3:0]              SD_AWCACHE  ;
     `endif
     `ifdef AMBA_AXI_PROT
     wire  [ 2:0]              SD_AWPROT   ;
     `endif
     wire                      SD_AWVALID  ;
     wire                      SD_AWREADY  ;
     `ifdef AMBA_AXI4
     wire  [ 3:0]              SD_AWQOS    ;
     wire  [ 3:0]              SD_AWREGION ;
     `endif
     wire  [WIDTH_SID-1:0]     SD_WID      ;
     wire  [WIDTH_DA-1:0]      SD_WDATA    ;
     wire  [WIDTH_DS-1:0]      SD_WSTRB    ;
     wire                      SD_WLAST    ;
     wire                      SD_WVALID   ;
     wire                      SD_WREADY   ;
     wire  [WIDTH_SID-1:0]     SD_BID      ;
     wire  [ 1:0]              SD_BRESP    ;
     wire                      SD_BVALID   ;
     wire                      SD_BREADY   ;
     wire  [WIDTH_SID-1:0]     SD_ARID     ;
     wire  [WIDTH_AD-1:0]      SD_ARADDR   ;
     `ifdef AMBA_AXI4
     wire  [ 7:0]              SD_ARLEN    ;
     wire                      SD_ARLOCK   ;
     `else
     wire  [ 3:0]              SD_ARLEN    ;
     wire  [ 1:0]              SD_ARLOCK   ;
     `endif
     wire  [ 2:0]              SD_ARSIZE   ;
     wire  [ 1:0]              SD_ARBURST  ;
     `ifdef AMBA_AXI_CACHE
     wire  [ 3:0]              SD_ARCACHE  ;
     `endif
     `ifdef AMBA_AXI_PROT
     wire  [ 2:0]              SD_ARPROT   ;
     `endif
     wire                      SD_ARVALID  ;
     wire                      SD_ARREADY  ;
     `ifdef AMBA_AXI4
     wire  [ 3:0]              SD_ARQOS    ;
     wire  [ 3:0]              SD_ARREGION ;
     `endif
     wire  [WIDTH_SID-1:0]     SD_RID      ;
     wire  [WIDTH_DA-1:0]      SD_RDATA    ;
     wire  [ 1:0]              SD_RRESP    ;
     wire                      SD_RLAST    ;
     wire                      SD_RVALID   ;
     wire                      SD_RREADY   ;
     //-----------------------------------------------------------
     // It is driven by axi_mtos_s?
     wire M0_AWREADY_S0  ,M0_AWREADY_S1  ,M0_AWREADY_S2  ,M0_AWREADY_S3  ,M0_AWREADY_S4  ,M0_AWREADY_SD  ;
     wire M0_WREADY_S0   ,M0_WREADY_S1   ,M0_WREADY_S2   ,M0_WREADY_S3   ,M0_WREADY_S4   ,M0_WREADY_SD   ;
     wire M0_ARREADY_S0  ,M0_ARREADY_S1  ,M0_ARREADY_S2  ,M0_ARREADY_S3  ,M0_ARREADY_S4  ,M0_ARREADY_SD  ;
     wire M1_AWREADY_S0  ,M1_AWREADY_S1  ,M1_AWREADY_S2  ,M1_AWREADY_S3  ,M1_AWREADY_S4  ,M1_AWREADY_SD  ;
     wire M1_WREADY_S0   ,M1_WREADY_S1   ,M1_WREADY_S2   ,M1_WREADY_S3   ,M1_WREADY_S4   ,M1_WREADY_SD   ;
     wire M1_ARREADY_S0  ,M1_ARREADY_S1  ,M1_ARREADY_S2  ,M1_ARREADY_S3  ,M1_ARREADY_S4  ,M1_ARREADY_SD  ;
     //-----------------------------------------------------------
     assign M0_AWREADY  = M0_AWREADY_S0  |M0_AWREADY_S1  |M0_AWREADY_S2  |M0_AWREADY_S3  |M0_AWREADY_S4  |M0_AWREADY_SD  ;
     assign M0_WREADY   = M0_WREADY_S0   |M0_WREADY_S1   |M0_WREADY_S2   |M0_WREADY_S3   |M0_WREADY_S4   |M0_WREADY_SD   ;
     assign M0_ARREADY  = M0_ARREADY_S0  |M0_ARREADY_S1  |M0_ARREADY_S2  |M0_ARREADY_S3  |M0_ARREADY_S4  |M0_ARREADY_SD  ;
     assign M1_AWREADY  = M1_AWREADY_S0  |M1_AWREADY_S1  |M1_AWREADY_S2  |M1_AWREADY_S3  |M1_AWREADY_S4  |M1_AWREADY_SD  ;
     assign M1_WREADY   = M1_WREADY_S0   |M1_WREADY_S1   |M1_WREADY_S2   |M1_WREADY_S3   |M1_WREADY_S4   |M1_WREADY_SD   ;
     assign M1_ARREADY  = M1_ARREADY_S0  |M1_ARREADY_S1  |M1_ARREADY_S2  |M1_ARREADY_S3  |M1_ARREADY_S4  |M1_ARREADY_SD  ;
     //-----------------------------------------------------------
     // It is driven by axi_stom_m?
     wire S0_BREADY_M0,S0_BREADY_M1;
     wire S0_RREADY_M0,S0_RREADY_M1;
     wire S1_BREADY_M0,S1_BREADY_M1;
     wire S1_RREADY_M0,S1_RREADY_M1;
     wire S2_BREADY_M0,S2_BREADY_M1;
     wire S2_RREADY_M0,S2_RREADY_M1;
     wire S3_BREADY_M0,S3_BREADY_M1;
     wire S3_RREADY_M0,S3_RREADY_M1;
     wire S4_BREADY_M0,S4_BREADY_M1;
     wire S4_RREADY_M0,S4_RREADY_M1;
     wire SD_BREADY_M0,SD_BREADY_M1;
     wire SD_RREADY_M0,SD_RREADY_M1;
     //-----------------------------------------------------------
     assign S0_BREADY = S0_BREADY_M0|S0_BREADY_M1;
     assign S0_RREADY = S0_RREADY_M0|S0_RREADY_M1;
     assign S1_BREADY = S1_BREADY_M0|S1_BREADY_M1;
     assign S1_RREADY = S1_RREADY_M0|S1_RREADY_M1;
     assign S2_BREADY = S2_BREADY_M0|S2_BREADY_M1;
     assign S2_RREADY = S2_RREADY_M0|S2_RREADY_M1;
     assign S3_BREADY = S3_BREADY_M0|S3_BREADY_M1;
     assign S3_RREADY = S3_RREADY_M0|S3_RREADY_M1;
     assign S4_BREADY = S4_BREADY_M0|S4_BREADY_M1;
     assign S4_RREADY = S4_RREADY_M0|S4_RREADY_M1;
     assign SD_BREADY = SD_BREADY_M0|SD_BREADY_M1;
     assign SD_RREADY = SD_RREADY_M0|SD_RREADY_M1;
     //-----------------------------------------------------------
     // drivne by axi_mtos_m?
     wire [NUM_MASTER-1:0] AWSELECT_OUT[0:NUM_SLAVE-1];
     wire [NUM_MASTER-1:0] ARSELECT_OUT[0:NUM_SLAVE-1];
     wire [NUM_MASTER-1:0] AWSELECT; // goes to default slave
     wire [NUM_MASTER-1:0] ARSELECT; // goes to default slave
     //-----------------------------------------------------------
     assign AWSELECT[0] = AWSELECT_OUT[0][0]|AWSELECT_OUT[1][0]|AWSELECT_OUT[2][0]|AWSELECT_OUT[3][0]|AWSELECT_OUT[4][0];
     assign AWSELECT[1] = AWSELECT_OUT[0][1]|AWSELECT_OUT[1][1]|AWSELECT_OUT[2][1]|AWSELECT_OUT[3][1]|AWSELECT_OUT[4][1];
     assign ARSELECT[0] = ARSELECT_OUT[0][0]|ARSELECT_OUT[1][0]|ARSELECT_OUT[2][0]|ARSELECT_OUT[3][0]|ARSELECT_OUT[4][0];
     assign ARSELECT[1] = ARSELECT_OUT[0][1]|ARSELECT_OUT[1][1]|ARSELECT_OUT[2][1]|ARSELECT_OUT[3][1]|ARSELECT_OUT[4][1];
     //-----------------------------------------------------------
     // masters to slave for slave 0
     axi_mtos_m2 #(.SLAVE_ID    (0           )
                  ,.SLAVE_EN    (SLAVE_EN0   )
                  ,.ADDR_BASE   (ADDR_BASE0  )
                  ,.ADDR_LENGTH (ADDR_LENGTH0)
                  ,.WIDTH_CID   (WIDTH_CID   )
                  ,.WIDTH_ID    (WIDTH_ID    )
                  ,.WIDTH_AD    (WIDTH_AD    )
                  ,.WIDTH_DA    (WIDTH_DA    )
                  ,.WIDTH_DS    (WIDTH_DS    )
                  ,.WIDTH_SID   (WIDTH_SID   )
                  ,.WIDTH_AWUSER(WIDTH_AWUSER)
                  ,.WIDTH_WUSER (WIDTH_WUSER )
                  ,.WIDTH_ARUSER(WIDTH_ARUSER)
                  ,.SLAVE_DEFAULT(1'b0)
                 )
     u_axi_mtos_s0 (
                                .ARESETn              (ARESETn      )
                              , .ACLK                 (ACLK         )
                              , .M0_MID               (M0_MID       )
                              , .M0_AWID              (M0_AWID      )
                              , .M0_AWADDR            (M0_AWADDR    )
                              , .M0_AWLEN             (M0_AWLEN     )
                              , .M0_AWLOCK            (M0_AWLOCK    )
                              , .M0_AWSIZE            (M0_AWSIZE    )
                              , .M0_AWBURST           (M0_AWBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M0_AWCACHE           (M0_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M0_AWPROT            (M0_AWPROT    )
         `endif
                              , .M0_AWVALID           (M0_AWVALID   )
                              , .M0_AWREADY           (M0_AWREADY_S0)
         `ifdef AMBA_AXI4
                              , .M0_AWQOS             (M0_AWQOS     )
                              , .M0_AWREGION          (M0_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
                              , .M0_AWUSER            (M0_AWUSER    )
         `endif
                              , .M0_WID               (M0_WID       )
                              , .M0_WDATA             (M0_WDATA     )
                              , .M0_WSTRB             (M0_WSTRB     )
                              , .M0_WLAST             (M0_WLAST     )
                              , .M0_WVALID            (M0_WVALID    )
                              , .M0_WREADY            (M0_WREADY_S0 )
         `ifdef AMBA_AXI_WUSER
                              , .M0_WUSER             (M0_WUSER     )
         `endif
                              , .M0_ARID              (M0_ARID      )
                              , .M0_ARADDR            (M0_ARADDR    )
                              , .M0_ARLEN             (M0_ARLEN     )
                              , .M0_ARLOCK            (M0_ARLOCK    )
                              , .M0_ARSIZE            (M0_ARSIZE    )
                              , .M0_ARBURST           (M0_ARBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M0_ARCACHE           (M0_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M0_ARPROT            (M0_ARPROT    )
         `endif
                              , .M0_ARVALID           (M0_ARVALID   )
                              , .M0_ARREADY           (M0_ARREADY_S0)
         `ifdef AMBA_AXI4
                              , .M0_ARQOS             (M0_ARQOS     )
                              , .M0_ARREGION          (M0_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
                              , .M0_ARUSER            (M0_ARUSER    )
         `endif
                              , .M1_MID               (M1_MID       )
                              , .M1_AWID              (M1_AWID      )
                              , .M1_AWADDR            (M1_AWADDR    )
                              , .M1_AWLEN             (M1_AWLEN     )
                              , .M1_AWLOCK            (M1_AWLOCK    )
                              , .M1_AWSIZE            (M1_AWSIZE    )
                              , .M1_AWBURST           (M1_AWBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M1_AWCACHE           (M1_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M1_AWPROT            (M1_AWPROT    )
         `endif
                              , .M1_AWVALID           (M1_AWVALID   )
                              , .M1_AWREADY           (M1_AWREADY_S0)
         `ifdef AMBA_AXI4
                              , .M1_AWQOS             (M1_AWQOS     )
                              , .M1_AWREGION          (M1_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
                              , .M1_AWUSER            (M1_AWUSER    )
         `endif
                              , .M1_WID               (M1_WID       )
                              , .M1_WDATA             (M1_WDATA     )
                              , .M1_WSTRB             (M1_WSTRB     )
                              , .M1_WLAST             (M1_WLAST     )
                              , .M1_WVALID            (M1_WVALID    )
                              , .M1_WREADY            (M1_WREADY_S0 )
         `ifdef AMBA_AXI_WUSER
                              , .M1_WUSER             (M1_WUSER     )
         `endif
                              , .M1_ARID              (M1_ARID      )
                              , .M1_ARADDR            (M1_ARADDR    )
                              , .M1_ARLEN             (M1_ARLEN     )
                              , .M1_ARLOCK            (M1_ARLOCK    )
                              , .M1_ARSIZE            (M1_ARSIZE    )
                              , .M1_ARBURST           (M1_ARBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M1_ARCACHE           (M1_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M1_ARPROT            (M1_ARPROT    )
         `endif
                              , .M1_ARVALID           (M1_ARVALID   )
                              , .M1_ARREADY           (M1_ARREADY_S0)
         `ifdef AMBA_AXI4
                              , .M1_ARQOS             (M1_ARQOS     )
                              , .M1_ARREGION          (M1_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
                              , .M1_ARUSER            (M1_ARUSER    )
         `endif
         , .S_AWID               (S0_AWID      )
         , .S_AWADDR             (S0_AWADDR    )
         , .S_AWLEN              (S0_AWLEN     )
         , .S_AWLOCK             (S0_AWLOCK    )
         , .S_AWSIZE             (S0_AWSIZE    )
         , .S_AWBURST            (S0_AWBURST   )
         `ifdef AMBA_AXI_CACHE
         , .S_AWCACHE            (S0_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
         , .S_AWPROT             (S0_AWPROT    )
         `endif
         , .S_AWVALID            (S0_AWVALID   )
         , .S_AWREADY            (S0_AWREADY   )
         `ifdef AMBA_AXI4
         , .S_AWQOS              (S0_AWQOS     )
         , .S_AWREGION           (S0_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
         , .S_AWUSER             (S0_AWUSER    )
         `endif
         , .S_WID                (S0_WID       )
         , .S_WDATA              (S0_WDATA     )
         , .S_WSTRB              (S0_WSTRB     )
         , .S_WLAST              (S0_WLAST     )
         , .S_WVALID             (S0_WVALID    )
         , .S_WREADY             (S0_WREADY    )
         `ifdef AMBA_AXI_WUSER
         , .S_WUSER              (S0_WUSER     )
         `endif
         , .S_ARID               (S0_ARID      )
         , .S_ARADDR             (S0_ARADDR    )
         , .S_ARLEN              (S0_ARLEN     )
         , .S_ARLOCK             (S0_ARLOCK    )
         , .S_ARSIZE             (S0_ARSIZE    )
         , .S_ARBURST            (S0_ARBURST   )
         `ifdef AMBA_AXI_CACHE
         , .S_ARCACHE            (S0_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
         , .S_ARPROT             (S0_ARPROT    )
         `endif
         , .S_ARVALID            (S0_ARVALID   )
         , .S_ARREADY            (S0_ARREADY   )
         `ifdef AMBA_AXI4
         , .S_ARQOS              (S0_ARQOS     )
         , .S_ARREGION           (S0_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
         , .S_ARUSER             (S0_ARUSER    )
         `endif
         , .AWSELECT_OUT         (AWSELECT_OUT[0])
         , .ARSELECT_OUT         (ARSELECT_OUT[0])
         , .AWSELECT_IN          (AWSELECT_OUT[0])// not used since non-default-slave
         , .ARSELECT_IN          (ARSELECT_OUT[0])// not used since non-default-slave
     );
     //-----------------------------------------------------------
     // masters to slave for slave 1
     axi_mtos_m2 #(.SLAVE_ID    (1           )
                  ,.SLAVE_EN    (SLAVE_EN1   )
                  ,.ADDR_BASE   (ADDR_BASE1  )
                  ,.ADDR_LENGTH (ADDR_LENGTH1)
                  ,.WIDTH_CID   (WIDTH_CID   )
                  ,.WIDTH_ID    (WIDTH_ID    )
                  ,.WIDTH_AD    (WIDTH_AD    )
                  ,.WIDTH_DA    (WIDTH_DA    )
                  ,.WIDTH_DS    (WIDTH_DS    )
                  ,.WIDTH_SID   (WIDTH_SID   )
                  ,.WIDTH_AWUSER(WIDTH_AWUSER)
                  ,.WIDTH_WUSER (WIDTH_WUSER )
                  ,.WIDTH_ARUSER(WIDTH_ARUSER)
                  ,.SLAVE_DEFAULT(1'b0)
                 )
     u_axi_mtos_s1 (
                                .ARESETn              (ARESETn      )
                              , .ACLK                 (ACLK         )
                              , .M0_MID               (M0_MID       )
                              , .M0_AWID              (M0_AWID      )
                              , .M0_AWADDR            (M0_AWADDR    )
                              , .M0_AWLEN             (M0_AWLEN     )
                              , .M0_AWLOCK            (M0_AWLOCK    )
                              , .M0_AWSIZE            (M0_AWSIZE    )
                              , .M0_AWBURST           (M0_AWBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M0_AWCACHE           (M0_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M0_AWPROT            (M0_AWPROT    )
         `endif
                              , .M0_AWVALID           (M0_AWVALID   )
                              , .M0_AWREADY           (M0_AWREADY_S1)
         `ifdef AMBA_AXI4
                              , .M0_AWQOS             (M0_AWQOS     )
                              , .M0_AWREGION          (M0_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
                              , .M0_AWUSER            (M0_AWUSER    )
         `endif
                              , .M0_WID               (M0_WID       )
                              , .M0_WDATA             (M0_WDATA     )
                              , .M0_WSTRB             (M0_WSTRB     )
                              , .M0_WLAST             (M0_WLAST     )
                              , .M0_WVALID            (M0_WVALID    )
                              , .M0_WREADY            (M0_WREADY_S1 )
         `ifdef AMBA_AXI_WUSER
                              , .M0_WUSER             (M0_WUSER     )
         `endif
                              , .M0_ARID              (M0_ARID      )
                              , .M0_ARADDR            (M0_ARADDR    )
                              , .M0_ARLEN             (M0_ARLEN     )
                              , .M0_ARLOCK            (M0_ARLOCK    )
                              , .M0_ARSIZE            (M0_ARSIZE    )
                              , .M0_ARBURST           (M0_ARBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M0_ARCACHE           (M0_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M0_ARPROT            (M0_ARPROT    )
         `endif
                              , .M0_ARVALID           (M0_ARVALID   )
                              , .M0_ARREADY           (M0_ARREADY_S1)
         `ifdef AMBA_AXI4
                              , .M0_ARQOS             (M0_ARQOS     )
                              , .M0_ARREGION          (M0_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
                              , .M0_ARUSER            (M0_ARUSER    )
         `endif
                              , .M1_MID               (M1_MID       )
                              , .M1_AWID              (M1_AWID      )
                              , .M1_AWADDR            (M1_AWADDR    )
                              , .M1_AWLEN             (M1_AWLEN     )
                              , .M1_AWLOCK            (M1_AWLOCK    )
                              , .M1_AWSIZE            (M1_AWSIZE    )
                              , .M1_AWBURST           (M1_AWBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M1_AWCACHE           (M1_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M1_AWPROT            (M1_AWPROT    )
         `endif
                              , .M1_AWVALID           (M1_AWVALID   )
                              , .M1_AWREADY           (M1_AWREADY_S1)
         `ifdef AMBA_AXI4
                              , .M1_AWQOS             (M1_AWQOS     )
                              , .M1_AWREGION          (M1_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
                              , .M1_AWUSER            (M1_AWUSER    )
         `endif
                              , .M1_WID               (M1_WID       )
                              , .M1_WDATA             (M1_WDATA     )
                              , .M1_WSTRB             (M1_WSTRB     )
                              , .M1_WLAST             (M1_WLAST     )
                              , .M1_WVALID            (M1_WVALID    )
                              , .M1_WREADY            (M1_WREADY_S1 )
         `ifdef AMBA_AXI_WUSER
                              , .M1_WUSER             (M1_WUSER     )
         `endif
                              , .M1_ARID              (M1_ARID      )
                              , .M1_ARADDR            (M1_ARADDR    )
                              , .M1_ARLEN             (M1_ARLEN     )
                              , .M1_ARLOCK            (M1_ARLOCK    )
                              , .M1_ARSIZE            (M1_ARSIZE    )
                              , .M1_ARBURST           (M1_ARBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M1_ARCACHE           (M1_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M1_ARPROT            (M1_ARPROT    )
         `endif
                              , .M1_ARVALID           (M1_ARVALID   )
                              , .M1_ARREADY           (M1_ARREADY_S1)
         `ifdef AMBA_AXI4
                              , .M1_ARQOS             (M1_ARQOS     )
                              , .M1_ARREGION          (M1_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
                              , .M1_ARUSER            (M1_ARUSER    )
         `endif
         , .S_AWID               (S1_AWID      )
         , .S_AWADDR             (S1_AWADDR    )
         , .S_AWLEN              (S1_AWLEN     )
         , .S_AWLOCK             (S1_AWLOCK    )
         , .S_AWSIZE             (S1_AWSIZE    )
         , .S_AWBURST            (S1_AWBURST   )
         `ifdef AMBA_AXI_CACHE
         , .S_AWCACHE            (S1_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
         , .S_AWPROT             (S1_AWPROT    )
         `endif
         , .S_AWVALID            (S1_AWVALID   )
         , .S_AWREADY            (S1_AWREADY   )
         `ifdef AMBA_AXI4
         , .S_AWQOS              (S1_AWQOS     )
         , .S_AWREGION           (S1_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
         , .S_AWUSER             (S1_AWUSER    )
         `endif
         , .S_WID                (S1_WID       )
         , .S_WDATA              (S1_WDATA     )
         , .S_WSTRB              (S1_WSTRB     )
         , .S_WLAST              (S1_WLAST     )
         , .S_WVALID             (S1_WVALID    )
         , .S_WREADY             (S1_WREADY    )
         `ifdef AMBA_AXI_WUSER
         , .S_WUSER              (S1_WUSER     )
         `endif
         , .S_ARID               (S1_ARID      )
         , .S_ARADDR             (S1_ARADDR    )
         , .S_ARLEN              (S1_ARLEN     )
         , .S_ARLOCK             (S1_ARLOCK    )
         , .S_ARSIZE             (S1_ARSIZE    )
         , .S_ARBURST            (S1_ARBURST   )
         `ifdef AMBA_AXI_CACHE
         , .S_ARCACHE            (S1_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
         , .S_ARPROT             (S1_ARPROT    )
         `endif
         , .S_ARVALID            (S1_ARVALID   )
         , .S_ARREADY            (S1_ARREADY   )
         `ifdef AMBA_AXI4
         , .S_ARQOS              (S1_ARQOS     )
         , .S_ARREGION           (S1_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
         , .S_ARUSER             (S1_ARUSER    )
         `endif
         , .AWSELECT_OUT         (AWSELECT_OUT[1])
         , .ARSELECT_OUT         (ARSELECT_OUT[1])
         , .AWSELECT_IN          (AWSELECT_OUT[1])// not used since non-default-slave
         , .ARSELECT_IN          (ARSELECT_OUT[1])// not used since non-default-slave
     );
     //-----------------------------------------------------------
     // masters to slave for slave 2
     axi_mtos_m2 #(.SLAVE_ID    (2           )
                  ,.SLAVE_EN    (SLAVE_EN2   )
                  ,.ADDR_BASE   (ADDR_BASE2  )
                  ,.ADDR_LENGTH (ADDR_LENGTH2)
                  ,.WIDTH_CID   (WIDTH_CID   )
                  ,.WIDTH_ID    (WIDTH_ID    )
                  ,.WIDTH_AD    (WIDTH_AD    )
                  ,.WIDTH_DA    (WIDTH_DA    )
                  ,.WIDTH_DS    (WIDTH_DS    )
                  ,.WIDTH_SID   (WIDTH_SID   )
                  ,.WIDTH_AWUSER(WIDTH_AWUSER)
                  ,.WIDTH_WUSER (WIDTH_WUSER )
                  ,.WIDTH_ARUSER(WIDTH_ARUSER)
                  ,.SLAVE_DEFAULT(1'b0)
                 )
     u_axi_mtos_s2 (
                                .ARESETn              (ARESETn      )
                              , .ACLK                 (ACLK         )
                              , .M0_MID               (M0_MID       )
                              , .M0_AWID              (M0_AWID      )
                              , .M0_AWADDR            (M0_AWADDR    )
                              , .M0_AWLEN             (M0_AWLEN     )
                              , .M0_AWLOCK            (M0_AWLOCK    )
                              , .M0_AWSIZE            (M0_AWSIZE    )
                              , .M0_AWBURST           (M0_AWBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M0_AWCACHE           (M0_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M0_AWPROT            (M0_AWPROT    )
         `endif
                              , .M0_AWVALID           (M0_AWVALID   )
                              , .M0_AWREADY           (M0_AWREADY_S2)
         `ifdef AMBA_AXI4
                              , .M0_AWQOS             (M0_AWQOS     )
                              , .M0_AWREGION          (M0_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
                              , .M0_AWUSER            (M0_AWUSER    )
         `endif
                              , .M0_WID               (M0_WID       )
                              , .M0_WDATA             (M0_WDATA     )
                              , .M0_WSTRB             (M0_WSTRB     )
                              , .M0_WLAST             (M0_WLAST     )
                              , .M0_WVALID            (M0_WVALID    )
                              , .M0_WREADY            (M0_WREADY_S2 )
         `ifdef AMBA_AXI_WUSER
                              , .M0_WUSER             (M0_WUSER     )
         `endif
                              , .M0_ARID              (M0_ARID      )
                              , .M0_ARADDR            (M0_ARADDR    )
                              , .M0_ARLEN             (M0_ARLEN     )
                              , .M0_ARLOCK            (M0_ARLOCK    )
                              , .M0_ARSIZE            (M0_ARSIZE    )
                              , .M0_ARBURST           (M0_ARBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M0_ARCACHE           (M0_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M0_ARPROT            (M0_ARPROT    )
         `endif
                              , .M0_ARVALID           (M0_ARVALID   )
                              , .M0_ARREADY           (M0_ARREADY_S2)
         `ifdef AMBA_AXI4
                              , .M0_ARQOS             (M0_ARQOS     )
                              , .M0_ARREGION          (M0_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
                              , .M0_ARUSER            (M0_ARUSER    )
         `endif
                              , .M1_MID               (M1_MID       )
                              , .M1_AWID              (M1_AWID      )
                              , .M1_AWADDR            (M1_AWADDR    )
                              , .M1_AWLEN             (M1_AWLEN     )
                              , .M1_AWLOCK            (M1_AWLOCK    )
                              , .M1_AWSIZE            (M1_AWSIZE    )
                              , .M1_AWBURST           (M1_AWBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M1_AWCACHE           (M1_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M1_AWPROT            (M1_AWPROT    )
         `endif
                              , .M1_AWVALID           (M1_AWVALID   )
                              , .M1_AWREADY           (M1_AWREADY_S2)
         `ifdef AMBA_AXI4
                              , .M1_AWQOS             (M1_AWQOS     )
                              , .M1_AWREGION          (M1_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
                              , .M1_AWUSER            (M1_AWUSER    )
         `endif
                              , .M1_WID               (M1_WID       )
                              , .M1_WDATA             (M1_WDATA     )
                              , .M1_WSTRB             (M1_WSTRB     )
                              , .M1_WLAST             (M1_WLAST     )
                              , .M1_WVALID            (M1_WVALID    )
                              , .M1_WREADY            (M1_WREADY_S2 )
         `ifdef AMBA_AXI_WUSER
                              , .M1_WUSER             (M1_WUSER     )
         `endif
                              , .M1_ARID              (M1_ARID      )
                              , .M1_ARADDR            (M1_ARADDR    )
                              , .M1_ARLEN             (M1_ARLEN     )
                              , .M1_ARLOCK            (M1_ARLOCK    )
                              , .M1_ARSIZE            (M1_ARSIZE    )
                              , .M1_ARBURST           (M1_ARBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M1_ARCACHE           (M1_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M1_ARPROT            (M1_ARPROT    )
         `endif
                              , .M1_ARVALID           (M1_ARVALID   )
                              , .M1_ARREADY           (M1_ARREADY_S2)
         `ifdef AMBA_AXI4
                              , .M1_ARQOS             (M1_ARQOS     )
                              , .M1_ARREGION          (M1_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
                              , .M1_ARUSER            (M1_ARUSER    )
         `endif
         , .S_AWID               (S2_AWID      )
         , .S_AWADDR             (S2_AWADDR    )
         , .S_AWLEN              (S2_AWLEN     )
         , .S_AWLOCK             (S2_AWLOCK    )
         , .S_AWSIZE             (S2_AWSIZE    )
         , .S_AWBURST            (S2_AWBURST   )
         `ifdef AMBA_AXI_CACHE
         , .S_AWCACHE            (S2_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
         , .S_AWPROT             (S2_AWPROT    )
         `endif
         , .S_AWVALID            (S2_AWVALID   )
         , .S_AWREADY            (S2_AWREADY   )
         `ifdef AMBA_AXI4
         , .S_AWQOS              (S2_AWQOS     )
         , .S_AWREGION           (S2_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
         , .S_AWUSER             (S2_AWUSER    )
         `endif
         , .S_WID                (S2_WID       )
         , .S_WDATA              (S2_WDATA     )
         , .S_WSTRB              (S2_WSTRB     )
         , .S_WLAST              (S2_WLAST     )
         , .S_WVALID             (S2_WVALID    )
         , .S_WREADY             (S2_WREADY    )
         `ifdef AMBA_AXI_WUSER
         , .S_WUSER              (S2_WUSER     )
         `endif
         , .S_ARID               (S2_ARID      )
         , .S_ARADDR             (S2_ARADDR    )
         , .S_ARLEN              (S2_ARLEN     )
         , .S_ARLOCK             (S2_ARLOCK    )
         , .S_ARSIZE             (S2_ARSIZE    )
         , .S_ARBURST            (S2_ARBURST   )
         `ifdef AMBA_AXI_CACHE
         , .S_ARCACHE            (S2_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
         , .S_ARPROT             (S2_ARPROT    )
         `endif
         , .S_ARVALID            (S2_ARVALID   )
         , .S_ARREADY            (S2_ARREADY   )
         `ifdef AMBA_AXI4
         , .S_ARQOS              (S2_ARQOS     )
         , .S_ARREGION           (S2_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
         , .S_ARUSER             (S2_ARUSER    )
         `endif
         , .AWSELECT_OUT         (AWSELECT_OUT[2])
         , .ARSELECT_OUT         (ARSELECT_OUT[2])
         , .AWSELECT_IN          (AWSELECT_OUT[2])// not used since non-default-slave
         , .ARSELECT_IN          (ARSELECT_OUT[2])// not used since non-default-slave
     );
     //-----------------------------------------------------------
     // masters to slave for slave 3
     axi_mtos_m2 #(.SLAVE_ID    (3           )
                  ,.SLAVE_EN    (SLAVE_EN3   )
                  ,.ADDR_BASE   (ADDR_BASE3  )
                  ,.ADDR_LENGTH (ADDR_LENGTH3)
                  ,.WIDTH_CID   (WIDTH_CID   )
                  ,.WIDTH_ID    (WIDTH_ID    )
                  ,.WIDTH_AD    (WIDTH_AD    )
                  ,.WIDTH_DA    (WIDTH_DA    )
                  ,.WIDTH_DS    (WIDTH_DS    )
                  ,.WIDTH_SID   (WIDTH_SID   )
                  ,.WIDTH_AWUSER(WIDTH_AWUSER)
                  ,.WIDTH_WUSER (WIDTH_WUSER )
                  ,.WIDTH_ARUSER(WIDTH_ARUSER)
                  ,.SLAVE_DEFAULT(1'b0)
                 )
     u_axi_mtos_s3 (
                                .ARESETn              (ARESETn      )
                              , .ACLK                 (ACLK         )
                              , .M0_MID               (M0_MID       )
                              , .M0_AWID              (M0_AWID      )
                              , .M0_AWADDR            (M0_AWADDR    )
                              , .M0_AWLEN             (M0_AWLEN     )
                              , .M0_AWLOCK            (M0_AWLOCK    )
                              , .M0_AWSIZE            (M0_AWSIZE    )
                              , .M0_AWBURST           (M0_AWBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M0_AWCACHE           (M0_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M0_AWPROT            (M0_AWPROT    )
         `endif
                              , .M0_AWVALID           (M0_AWVALID   )
                              , .M0_AWREADY           (M0_AWREADY_S3)
         `ifdef AMBA_AXI4
                              , .M0_AWQOS             (M0_AWQOS     )
                              , .M0_AWREGION          (M0_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
                              , .M0_AWUSER            (M0_AWUSER    )
         `endif
                              , .M0_WID               (M0_WID       )
                              , .M0_WDATA             (M0_WDATA     )
                              , .M0_WSTRB             (M0_WSTRB     )
                              , .M0_WLAST             (M0_WLAST     )
                              , .M0_WVALID            (M0_WVALID    )
                              , .M0_WREADY            (M0_WREADY_S3 )
         `ifdef AMBA_AXI_WUSER
                              , .M0_WUSER             (M0_WUSER     )
         `endif
                              , .M0_ARID              (M0_ARID      )
                              , .M0_ARADDR            (M0_ARADDR    )
                              , .M0_ARLEN             (M0_ARLEN     )
                              , .M0_ARLOCK            (M0_ARLOCK    )
                              , .M0_ARSIZE            (M0_ARSIZE    )
                              , .M0_ARBURST           (M0_ARBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M0_ARCACHE           (M0_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M0_ARPROT            (M0_ARPROT    )
         `endif
                              , .M0_ARVALID           (M0_ARVALID   )
                              , .M0_ARREADY           (M0_ARREADY_S3)
         `ifdef AMBA_AXI4
                              , .M0_ARQOS             (M0_ARQOS     )
                              , .M0_ARREGION          (M0_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
                              , .M0_ARUSER            (M0_ARUSER    )
         `endif
                              , .M1_MID               (M1_MID       )
                              , .M1_AWID              (M1_AWID      )
                              , .M1_AWADDR            (M1_AWADDR    )
                              , .M1_AWLEN             (M1_AWLEN     )
                              , .M1_AWLOCK            (M1_AWLOCK    )
                              , .M1_AWSIZE            (M1_AWSIZE    )
                              , .M1_AWBURST           (M1_AWBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M1_AWCACHE           (M1_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M1_AWPROT            (M1_AWPROT    )
         `endif
                              , .M1_AWVALID           (M1_AWVALID   )
                              , .M1_AWREADY           (M1_AWREADY_S3)
         `ifdef AMBA_AXI4
                              , .M1_AWQOS             (M1_AWQOS     )
                              , .M1_AWREGION          (M1_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
                              , .M1_AWUSER            (M1_AWUSER    )
         `endif
                              , .M1_WID               (M1_WID       )
                              , .M1_WDATA             (M1_WDATA     )
                              , .M1_WSTRB             (M1_WSTRB     )
                              , .M1_WLAST             (M1_WLAST     )
                              , .M1_WVALID            (M1_WVALID    )
                              , .M1_WREADY            (M1_WREADY_S3 )
         `ifdef AMBA_AXI_WUSER
                              , .M1_WUSER             (M1_WUSER     )
         `endif
                              , .M1_ARID              (M1_ARID      )
                              , .M1_ARADDR            (M1_ARADDR    )
                              , .M1_ARLEN             (M1_ARLEN     )
                              , .M1_ARLOCK            (M1_ARLOCK    )
                              , .M1_ARSIZE            (M1_ARSIZE    )
                              , .M1_ARBURST           (M1_ARBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M1_ARCACHE           (M1_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M1_ARPROT            (M1_ARPROT    )
         `endif
                              , .M1_ARVALID           (M1_ARVALID   )
                              , .M1_ARREADY           (M1_ARREADY_S3)
         `ifdef AMBA_AXI4
                              , .M1_ARQOS             (M1_ARQOS     )
                              , .M1_ARREGION          (M1_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
                              , .M1_ARUSER            (M1_ARUSER    )
         `endif
         , .S_AWID               (S3_AWID      )
         , .S_AWADDR             (S3_AWADDR    )
         , .S_AWLEN              (S3_AWLEN     )
         , .S_AWLOCK             (S3_AWLOCK    )
         , .S_AWSIZE             (S3_AWSIZE    )
         , .S_AWBURST            (S3_AWBURST   )
         `ifdef AMBA_AXI_CACHE
         , .S_AWCACHE            (S3_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
         , .S_AWPROT             (S3_AWPROT    )
         `endif
         , .S_AWVALID            (S3_AWVALID   )
         , .S_AWREADY            (S3_AWREADY   )
         `ifdef AMBA_AXI4
         , .S_AWQOS              (S3_AWQOS     )
         , .S_AWREGION           (S3_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
         , .S_AWUSER             (S3_AWUSER    )
         `endif
         , .S_WID                (S3_WID       )
         , .S_WDATA              (S3_WDATA     )
         , .S_WSTRB              (S3_WSTRB     )
         , .S_WLAST              (S3_WLAST     )
         , .S_WVALID             (S3_WVALID    )
         , .S_WREADY             (S3_WREADY    )
         `ifdef AMBA_AXI_WUSER
         , .S_WUSER              (S3_WUSER     )
         `endif
         , .S_ARID               (S3_ARID      )
         , .S_ARADDR             (S3_ARADDR    )
         , .S_ARLEN              (S3_ARLEN     )
         , .S_ARLOCK             (S3_ARLOCK    )
         , .S_ARSIZE             (S3_ARSIZE    )
         , .S_ARBURST            (S3_ARBURST   )
         `ifdef AMBA_AXI_CACHE
         , .S_ARCACHE            (S3_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
         , .S_ARPROT             (S3_ARPROT    )
         `endif
         , .S_ARVALID            (S3_ARVALID   )
         , .S_ARREADY            (S3_ARREADY   )
         `ifdef AMBA_AXI4
         , .S_ARQOS              (S3_ARQOS     )
         , .S_ARREGION           (S3_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
         , .S_ARUSER             (S3_ARUSER    )
         `endif
         , .AWSELECT_OUT         (AWSELECT_OUT[3])
         , .ARSELECT_OUT         (ARSELECT_OUT[3])
         , .AWSELECT_IN          (AWSELECT_OUT[3])// not used since non-default-slave
         , .ARSELECT_IN          (ARSELECT_OUT[3])// not used since non-default-slave
     );
     //-----------------------------------------------------------
     // masters to slave for slave 4
     axi_mtos_m2 #(.SLAVE_ID    (4           )
                  ,.SLAVE_EN    (SLAVE_EN4   )
                  ,.ADDR_BASE   (ADDR_BASE4  )
                  ,.ADDR_LENGTH (ADDR_LENGTH4)
                  ,.WIDTH_CID   (WIDTH_CID   )
                  ,.WIDTH_ID    (WIDTH_ID    )
                  ,.WIDTH_AD    (WIDTH_AD    )
                  ,.WIDTH_DA    (WIDTH_DA    )
                  ,.WIDTH_DS    (WIDTH_DS    )
                  ,.WIDTH_SID   (WIDTH_SID   )
                  ,.WIDTH_AWUSER(WIDTH_AWUSER)
                  ,.WIDTH_WUSER (WIDTH_WUSER )
                  ,.WIDTH_ARUSER(WIDTH_ARUSER)
                  ,.SLAVE_DEFAULT(1'b0)
                 )
     u_axi_mtos_s4 (
                                .ARESETn              (ARESETn      )
                              , .ACLK                 (ACLK         )
                              , .M0_MID               (M0_MID       )
                              , .M0_AWID              (M0_AWID      )
                              , .M0_AWADDR            (M0_AWADDR    )
                              , .M0_AWLEN             (M0_AWLEN     )
                              , .M0_AWLOCK            (M0_AWLOCK    )
                              , .M0_AWSIZE            (M0_AWSIZE    )
                              , .M0_AWBURST           (M0_AWBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M0_AWCACHE           (M0_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M0_AWPROT            (M0_AWPROT    )
         `endif
                              , .M0_AWVALID           (M0_AWVALID   )
                              , .M0_AWREADY           (M0_AWREADY_S4)
         `ifdef AMBA_AXI4
                              , .M0_AWQOS             (M0_AWQOS     )
                              , .M0_AWREGION          (M0_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
                              , .M0_AWUSER            (M0_AWUSER    )
         `endif
                              , .M0_WID               (M0_WID       )
                              , .M0_WDATA             (M0_WDATA     )
                              , .M0_WSTRB             (M0_WSTRB     )
                              , .M0_WLAST             (M0_WLAST     )
                              , .M0_WVALID            (M0_WVALID    )
                              , .M0_WREADY            (M0_WREADY_S4 )
         `ifdef AMBA_AXI_WUSER
                              , .M0_WUSER             (M0_WUSER     )
         `endif
                              , .M0_ARID              (M0_ARID      )
                              , .M0_ARADDR            (M0_ARADDR    )
                              , .M0_ARLEN             (M0_ARLEN     )
                              , .M0_ARLOCK            (M0_ARLOCK    )
                              , .M0_ARSIZE            (M0_ARSIZE    )
                              , .M0_ARBURST           (M0_ARBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M0_ARCACHE           (M0_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M0_ARPROT            (M0_ARPROT    )
         `endif
                              , .M0_ARVALID           (M0_ARVALID   )
                              , .M0_ARREADY           (M0_ARREADY_S4)
         `ifdef AMBA_AXI4
                              , .M0_ARQOS             (M0_ARQOS     )
                              , .M0_ARREGION          (M0_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
                              , .M0_ARUSER            (M0_ARUSER    )
         `endif
                              , .M1_MID               (M1_MID       )
                              , .M1_AWID              (M1_AWID      )
                              , .M1_AWADDR            (M1_AWADDR    )
                              , .M1_AWLEN             (M1_AWLEN     )
                              , .M1_AWLOCK            (M1_AWLOCK    )
                              , .M1_AWSIZE            (M1_AWSIZE    )
                              , .M1_AWBURST           (M1_AWBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M1_AWCACHE           (M1_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M1_AWPROT            (M1_AWPROT    )
         `endif
                              , .M1_AWVALID           (M1_AWVALID   )
                              , .M1_AWREADY           (M1_AWREADY_S4)
         `ifdef AMBA_AXI4
                              , .M1_AWQOS             (M1_AWQOS     )
                              , .M1_AWREGION          (M1_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
                              , .M1_AWUSER            (M1_AWUSER    )
         `endif
                              , .M1_WID               (M1_WID       )
                              , .M1_WDATA             (M1_WDATA     )
                              , .M1_WSTRB             (M1_WSTRB     )
                              , .M1_WLAST             (M1_WLAST     )
                              , .M1_WVALID            (M1_WVALID    )
                              , .M1_WREADY            (M1_WREADY_S4 )
         `ifdef AMBA_AXI_WUSER
                              , .M1_WUSER             (M1_WUSER     )
         `endif
                              , .M1_ARID              (M1_ARID      )
                              , .M1_ARADDR            (M1_ARADDR    )
                              , .M1_ARLEN             (M1_ARLEN     )
                              , .M1_ARLOCK            (M1_ARLOCK    )
                              , .M1_ARSIZE            (M1_ARSIZE    )
                              , .M1_ARBURST           (M1_ARBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M1_ARCACHE           (M1_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M1_ARPROT            (M1_ARPROT    )
         `endif
                              , .M1_ARVALID           (M1_ARVALID   )
                              , .M1_ARREADY           (M1_ARREADY_S4)
         `ifdef AMBA_AXI4
                              , .M1_ARQOS             (M1_ARQOS     )
                              , .M1_ARREGION          (M1_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
                              , .M1_ARUSER            (M1_ARUSER    )
         `endif
         , .S_AWID               (S4_AWID      )
         , .S_AWADDR             (S4_AWADDR    )
         , .S_AWLEN              (S4_AWLEN     )
         , .S_AWLOCK             (S4_AWLOCK    )
         , .S_AWSIZE             (S4_AWSIZE    )
         , .S_AWBURST            (S4_AWBURST   )
         `ifdef AMBA_AXI_CACHE
         , .S_AWCACHE            (S4_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
         , .S_AWPROT             (S4_AWPROT    )
         `endif
         , .S_AWVALID            (S4_AWVALID   )
         , .S_AWREADY            (S4_AWREADY   )
         `ifdef AMBA_AXI4
         , .S_AWQOS              (S4_AWQOS     )
         , .S_AWREGION           (S4_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
         , .S_AWUSER             (S4_AWUSER    )
         `endif
         , .S_WID                (S4_WID       )
         , .S_WDATA              (S4_WDATA     )
         , .S_WSTRB              (S4_WSTRB     )
         , .S_WLAST              (S4_WLAST     )
         , .S_WVALID             (S4_WVALID    )
         , .S_WREADY             (S4_WREADY    )
         `ifdef AMBA_AXI_WUSER
         , .S_WUSER              (S4_WUSER     )
         `endif
         , .S_ARID               (S4_ARID      )
         , .S_ARADDR             (S4_ARADDR    )
         , .S_ARLEN              (S4_ARLEN     )
         , .S_ARLOCK             (S4_ARLOCK    )
         , .S_ARSIZE             (S4_ARSIZE    )
         , .S_ARBURST            (S4_ARBURST   )
         `ifdef AMBA_AXI_CACHE
         , .S_ARCACHE            (S4_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
         , .S_ARPROT             (S4_ARPROT    )
         `endif
         , .S_ARVALID            (S4_ARVALID   )
         , .S_ARREADY            (S4_ARREADY   )
         `ifdef AMBA_AXI4
         , .S_ARQOS              (S4_ARQOS     )
         , .S_ARREGION           (S4_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
         , .S_ARUSER             (S4_ARUSER    )
         `endif
         , .AWSELECT_OUT         (AWSELECT_OUT[4])
         , .ARSELECT_OUT         (ARSELECT_OUT[4])
         , .AWSELECT_IN          (AWSELECT_OUT[4])// not used since non-default-slave
         , .ARSELECT_IN          (ARSELECT_OUT[4])// not used since non-default-slave
     );
     //-----------------------------------------------------------
     // masters to slave for default slave
     axi_mtos_m2 #(.SLAVE_ID    (NUM_SLAVE   )
                  ,.SLAVE_EN    (1'b1        ) // always enabled
                  ,.ADDR_BASE   (ADDR_BASE1  )
                  ,.ADDR_LENGTH (ADDR_LENGTH1)
                  ,.WIDTH_CID   (WIDTH_CID   )
                  ,.WIDTH_ID    (WIDTH_ID    )
                  ,.WIDTH_AD    (WIDTH_AD    )
                  ,.WIDTH_DA    (WIDTH_DA    )
                  ,.WIDTH_DS    (WIDTH_DS    )
                  ,.WIDTH_SID   (WIDTH_SID   )
                  ,.WIDTH_AWUSER(WIDTH_AWUSER)
                  ,.WIDTH_WUSER (WIDTH_WUSER )
                  ,.WIDTH_ARUSER(WIDTH_ARUSER)
                  ,.SLAVE_DEFAULT(1'b1)
                 )
     u_axi_mtos_sd (
           .ARESETn              (ARESETn      )
         , .ACLK                 (ACLK         )
                              , .M0_MID               (M0_MID       )
                              , .M0_AWID              (M0_AWID      )
                              , .M0_AWADDR            (M0_AWADDR    )
                              , .M0_AWLEN             (M0_AWLEN     )
                              , .M0_AWLOCK            (M0_AWLOCK    )
                              , .M0_AWSIZE            (M0_AWSIZE    )
                              , .M0_AWBURST           (M0_AWBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M0_AWCACHE           (M0_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M0_AWPROT            (M0_AWPROT    )
         `endif
                              , .M0_AWVALID           (M0_AWVALID   )
                              , .M0_AWREADY           (M0_AWREADY_SD)
         `ifdef AMBA_AXI4
                              , .M0_AWQOS             (M0_AWQOS     )
                              , .M0_AWREGION          (M0_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
                              , .M0_AWUSER            (M0_AWUSER    )
         `endif
                              , .M0_WID               (M0_WID       )
                              , .M0_WDATA             (M0_WDATA     )
                              , .M0_WSTRB             (M0_WSTRB     )
                              , .M0_WLAST             (M0_WLAST     )
                              , .M0_WVALID            (M0_WVALID    )
                              , .M0_WREADY            (M0_WREADY_SD )
         `ifdef AMBA_AXI_WUSER
                              , .M0_WUSER             (M0_WUSER     )
         `endif
                              , .M0_ARID              (M0_ARID      )
                              , .M0_ARADDR            (M0_ARADDR    )
                              , .M0_ARLEN             (M0_ARLEN     )
                              , .M0_ARLOCK            (M0_ARLOCK    )
                              , .M0_ARSIZE            (M0_ARSIZE    )
                              , .M0_ARBURST           (M0_ARBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M0_ARCACHE           (M0_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M0_ARPROT            (M0_ARPROT    )
         `endif
                              , .M0_ARVALID           (M0_ARVALID   )
                              , .M0_ARREADY           (M0_ARREADY_SD)
         `ifdef AMBA_AXI4
                              , .M0_ARQOS             (M0_ARQOS     )
                              , .M0_ARREGION          (M0_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
                              , .M0_ARUSER            (M0_ARUSER    )
         `endif
                              , .M1_MID               (M1_MID       )
                              , .M1_AWID              (M1_AWID      )
                              , .M1_AWADDR            (M1_AWADDR    )
                              , .M1_AWLEN             (M1_AWLEN     )
                              , .M1_AWLOCK            (M1_AWLOCK    )
                              , .M1_AWSIZE            (M1_AWSIZE    )
                              , .M1_AWBURST           (M1_AWBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M1_AWCACHE           (M1_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M1_AWPROT            (M1_AWPROT    )
         `endif
                              , .M1_AWVALID           (M1_AWVALID   )
                              , .M1_AWREADY           (M1_AWREADY_SD)
         `ifdef AMBA_AXI4
                              , .M1_AWQOS             (M1_AWQOS     )
                              , .M1_AWREGION          (M1_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
                              , .M1_AWUSER            (M1_AWUSER    )
         `endif
                              , .M1_WID               (M1_WID       )
                              , .M1_WDATA             (M1_WDATA     )
                              , .M1_WSTRB             (M1_WSTRB     )
                              , .M1_WLAST             (M1_WLAST     )
                              , .M1_WVALID            (M1_WVALID    )
                              , .M1_WREADY            (M1_WREADY_SD )
         `ifdef AMBA_AXI_WUSER
                              , .M1_WUSER             (M1_WUSER     )
         `endif
                              , .M1_ARID              (M1_ARID      )
                              , .M1_ARADDR            (M1_ARADDR    )
                              , .M1_ARLEN             (M1_ARLEN     )
                              , .M1_ARLOCK            (M1_ARLOCK    )
                              , .M1_ARSIZE            (M1_ARSIZE    )
                              , .M1_ARBURST           (M1_ARBURST   )
         `ifdef AMBA_AXI_CACHE
                              , .M1_ARCACHE           (M1_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
                              , .M1_ARPROT            (M1_ARPROT    )
         `endif
                              , .M1_ARVALID           (M1_ARVALID   )
                              , .M1_ARREADY           (M1_ARREADY_SD)
         `ifdef AMBA_AXI4
                              , .M1_ARQOS             (M1_ARQOS     )
                              , .M1_ARREGION          (M1_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
                              , .M1_ARUSER            (M1_ARUSER    )
         `endif
         , .S_AWID               (SD_AWID      )
         , .S_AWADDR             (SD_AWADDR    )
         , .S_AWLEN              (SD_AWLEN     )
         , .S_AWLOCK             (SD_AWLOCK    )
         , .S_AWSIZE             (SD_AWSIZE    )
         , .S_AWBURST            (SD_AWBURST   )
         `ifdef AMBA_AXI_CACHE
         , .S_AWCACHE            (SD_AWCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
         , .S_AWPROT             (SD_AWPROT    )
         `endif
         , .S_AWVALID            (SD_AWVALID   )
         , .S_AWREADY            (SD_AWREADY   )
         `ifdef AMBA_AXI4
         , .S_AWQOS              (SD_AWQOS     )
         , .S_AWREGION           (SD_AWREGION  )
         `endif
         `ifdef AMBA_AXI_AWUSER
         , .S_AWUSER             (SD_AWUSER    )
         `endif
         , .S_WID                (SD_WID       )
         , .S_WDATA              (SD_WDATA     )
         , .S_WSTRB              (SD_WSTRB     )
         , .S_WLAST              (SD_WLAST     )
         , .S_WVALID             (SD_WVALID    )
         , .S_WREADY             (SD_WREADY    )
         `ifdef AMBA_AXI_WUSER
         , .S_WUSER              (SD_WUSER     )
         `endif
         , .S_ARID               (SD_ARID      )
         , .S_ARADDR             (SD_ARADDR    )
         , .S_ARLEN              (SD_ARLEN     )
         , .S_ARLOCK             (SD_ARLOCK    )
         , .S_ARSIZE             (SD_ARSIZE    )
         , .S_ARBURST            (SD_ARBURST   )
         `ifdef AMBA_AXI_CACHE
         , .S_ARCACHE            (SD_ARCACHE   )
         `endif
         `ifdef AMBA_AXI_PROT
         , .S_ARPROT             (SD_ARPROT    )
         `endif
         , .S_ARVALID            (SD_ARVALID   )
         , .S_ARREADY            (SD_ARREADY   )
         `ifdef AMBA_AXI4
         , .S_ARQOS              (SD_ARQOS     )
         , .S_ARREGION           (SD_ARREGION  )
         `endif
         `ifdef AMBA_AXI_ARUSER
         , .S_ARUSER             (SD_ARUSER    )
         `endif
         , .AWSELECT_OUT         (             )// not used since default-slave
         , .ARSELECT_OUT         (             )// not used since default-slave
         , .AWSELECT_IN          (AWSELECT     )
         , .ARSELECT_IN          (ARSELECT     )
     );
     //-----------------------------------------------------------
     // slaves to master for master 0
     axi_stom_s5 #(.MASTER_ID(0)
                  ,.WIDTH_CID   (WIDTH_CID   )
                  ,.WIDTH_ID    (WIDTH_ID    )
                  ,.WIDTH_AD    (WIDTH_AD    )
                  ,.WIDTH_DA    (WIDTH_DA    )
                  ,.WIDTH_DS    (WIDTH_DS    )
                  ,.WIDTH_SID   (WIDTH_SID   )
                  ,.WIDTH_BUSER (WIDTH_BUSER)
                  ,.WIDTH_RUSER (WIDTH_RUSER )
                 )
     u_axi_stom_m0 (
           .ARESETn              (ARESETn     )
         , .ACLK                 (ACLK        )
         , .M_MID                (M0_MID      )
         , .M_BID                (M0_BID      )
         , .M_BRESP              (M0_BRESP    )
         , .M_BVALID             (M0_BVALID   )
         , .M_BREADY             (M0_BREADY   )
         `ifdef AMBA_AXI_BUSER
         , .M_BUSER              (M0_BUSER    )
         `endif
         , .M_RID                (M0_RID      )
         , .M_RDATA              (M0_RDATA    )
         , .M_RRESP              (M0_RRESP    )
         , .M_RLAST              (M0_RLAST    )
         , .M_RVALID             (M0_RVALID   )
         , .M_RREADY             (M0_RREADY   )
         `ifdef AMBA_AXI_RUSER
         , .M_RUSER              (M0_RUSER    )
         `endif
                           , .S0_BID               (S0_BID      )
                           , .S0_BRESP             (S0_BRESP    )
                           , .S0_BVALID            (S0_BVALID   )
                           , .S0_BREADY            (S0_BREADY_M0)
         `ifdef AMBA_AXI_BUSER
                           , .S0_BUSER             (S0_BUSER    )
         `endif
                           , .S0_RID               (S0_RID      )
                           , .S0_RDATA             (S0_RDATA    )
                           , .S0_RRESP             (S0_RRESP    )
                           , .S0_RLAST             (S0_RLAST    )
                           , .S0_RVALID            (S0_RVALID   )
                           , .S0_RREADY            (S0_RREADY_M0)
         `ifdef AMBA_AXI_RUSER
                           , .S0_RUSER             (S0_RUSER    )
         `endif
                           , .S1_BID               (S1_BID      )
                           , .S1_BRESP             (S1_BRESP    )
                           , .S1_BVALID            (S1_BVALID   )
                           , .S1_BREADY            (S1_BREADY_M0)
         `ifdef AMBA_AXI_BUSER
                           , .S1_BUSER             (S1_BUSER    )
         `endif
                           , .S1_RID               (S1_RID      )
                           , .S1_RDATA             (S1_RDATA    )
                           , .S1_RRESP             (S1_RRESP    )
                           , .S1_RLAST             (S1_RLAST    )
                           , .S1_RVALID            (S1_RVALID   )
                           , .S1_RREADY            (S1_RREADY_M0)
         `ifdef AMBA_AXI_RUSER
                           , .S1_RUSER             (S1_RUSER    )
         `endif
                           , .S2_BID               (S2_BID      )
                           , .S2_BRESP             (S2_BRESP    )
                           , .S2_BVALID            (S2_BVALID   )
                           , .S2_BREADY            (S2_BREADY_M0)
         `ifdef AMBA_AXI_BUSER
                           , .S2_BUSER             (S2_BUSER    )
         `endif
                           , .S2_RID               (S2_RID      )
                           , .S2_RDATA             (S2_RDATA    )
                           , .S2_RRESP             (S2_RRESP    )
                           , .S2_RLAST             (S2_RLAST    )
                           , .S2_RVALID            (S2_RVALID   )
                           , .S2_RREADY            (S2_RREADY_M0)
         `ifdef AMBA_AXI_RUSER
                           , .S2_RUSER             (S2_RUSER    )
         `endif
                           , .S3_BID               (S3_BID      )
                           , .S3_BRESP             (S3_BRESP    )
                           , .S3_BVALID            (S3_BVALID   )
                           , .S3_BREADY            (S3_BREADY_M0)
         `ifdef AMBA_AXI_BUSER
                           , .S3_BUSER             (S3_BUSER    )
         `endif
                           , .S3_RID               (S3_RID      )
                           , .S3_RDATA             (S3_RDATA    )
                           , .S3_RRESP             (S3_RRESP    )
                           , .S3_RLAST             (S3_RLAST    )
                           , .S3_RVALID            (S3_RVALID   )
                           , .S3_RREADY            (S3_RREADY_M0)
         `ifdef AMBA_AXI_RUSER
                           , .S3_RUSER             (S3_RUSER    )
         `endif
                           , .S4_BID               (S4_BID      )
                           , .S4_BRESP             (S4_BRESP    )
                           , .S4_BVALID            (S4_BVALID   )
                           , .S4_BREADY            (S4_BREADY_M0)
         `ifdef AMBA_AXI_BUSER
                           , .S4_BUSER             (S4_BUSER    )
         `endif
                           , .S4_RID               (S4_RID      )
                           , .S4_RDATA             (S4_RDATA    )
                           , .S4_RRESP             (S4_RRESP    )
                           , .S4_RLAST             (S4_RLAST    )
                           , .S4_RVALID            (S4_RVALID   )
                           , .S4_RREADY            (S4_RREADY_M0)
         `ifdef AMBA_AXI_RUSER
                           , .S4_RUSER             (S4_RUSER    )
         `endif
                           , .SD_BID               (SD_BID      )
                           , .SD_BRESP             (SD_BRESP    )
                           , .SD_BVALID            (SD_BVALID   )
                           , .SD_BREADY            (SD_BREADY_M0)
         `ifdef AMBA_AXI_BUSER
                           , .SD_BUSER             (SD_BUSER    )
         `endif
                           , .SD_RID               (SD_RID      )
                           , .SD_RDATA             (SD_RDATA    )
                           , .SD_RRESP             (SD_RRESP    )
                           , .SD_RLAST             (SD_RLAST    )
                           , .SD_RVALID            (SD_RVALID   )
                           , .SD_RREADY            (SD_RREADY_M0)
         `ifdef AMBA_AXI_RUSER
                           , .SD_RUSER             (SD_RUSER    )
         `endif
     );
     //-----------------------------------------------------------
     // slaves to master for master 1
     axi_stom_s5 #(.MASTER_ID(1)
                  ,.WIDTH_CID   (WIDTH_CID   )
                  ,.WIDTH_ID    (WIDTH_ID    )
                  ,.WIDTH_AD    (WIDTH_AD    )
                  ,.WIDTH_DA    (WIDTH_DA    )
                  ,.WIDTH_DS    (WIDTH_DS    )
                  ,.WIDTH_SID   (WIDTH_SID   )
                  ,.WIDTH_BUSER (WIDTH_BUSER)
                  ,.WIDTH_RUSER (WIDTH_RUSER )
                 )
     u_axi_stom_m1 (
           .ARESETn              (ARESETn     )
         , .ACLK                 (ACLK        )
         , .M_MID                (M1_MID      )
         , .M_BID                (M1_BID      )
         , .M_BRESP              (M1_BRESP    )
         , .M_BVALID             (M1_BVALID   )
         , .M_BREADY             (M1_BREADY   )
         `ifdef AMBA_AXI_BUSER
         , .M_BUSER              (M1_BUSER    )
         `endif
         , .M_RID                (M1_RID      )
         , .M_RDATA              (M1_RDATA    )
         , .M_RRESP              (M1_RRESP    )
         , .M_RLAST              (M1_RLAST    )
         , .M_RVALID             (M1_RVALID   )
         , .M_RREADY             (M1_RREADY   )
         `ifdef AMBA_AXI_RUSER
         , .M_RUSER              (M1_RUSER    )
         `endif
                           , .S0_BID               (S0_BID      )
                           , .S0_BRESP             (S0_BRESP    )
                           , .S0_BVALID            (S0_BVALID   )
                           , .S0_BREADY            (S0_BREADY_M1)
         `ifdef AMBA_AXI_BUSER
                           , .S0_BUSER             (S0_BUSER    )
         `endif
                           , .S0_RID               (S0_RID      )
                           , .S0_RDATA             (S0_RDATA    )
                           , .S0_RRESP             (S0_RRESP    )
                           , .S0_RLAST             (S0_RLAST    )
                           , .S0_RVALID            (S0_RVALID   )
                           , .S0_RREADY            (S0_RREADY_M1)
         `ifdef AMBA_AXI_RUSER
                           , .S0_RUSER             (S0_RUSER    )
         `endif
                           , .S1_BID               (S1_BID      )
                           , .S1_BRESP             (S1_BRESP    )
                           , .S1_BVALID            (S1_BVALID   )
                           , .S1_BREADY            (S1_BREADY_M1)
         `ifdef AMBA_AXI_BUSER
                           , .S1_BUSER             (S1_BUSER    )
         `endif
                           , .S1_RID               (S1_RID      )
                           , .S1_RDATA             (S1_RDATA    )
                           , .S1_RRESP             (S1_RRESP    )
                           , .S1_RLAST             (S1_RLAST    )
                           , .S1_RVALID            (S1_RVALID   )
                           , .S1_RREADY            (S1_RREADY_M1)
         `ifdef AMBA_AXI_RUSER
                           , .S1_RUSER             (S1_RUSER    )
         `endif
                           , .S2_BID               (S2_BID      )
                           , .S2_BRESP             (S2_BRESP    )
                           , .S2_BVALID            (S2_BVALID   )
                           , .S2_BREADY            (S2_BREADY_M1)
         `ifdef AMBA_AXI_BUSER
                           , .S2_BUSER             (S2_BUSER    )
         `endif
                           , .S2_RID               (S2_RID      )
                           , .S2_RDATA             (S2_RDATA    )
                           , .S2_RRESP             (S2_RRESP    )
                           , .S2_RLAST             (S2_RLAST    )
                           , .S2_RVALID            (S2_RVALID   )
                           , .S2_RREADY            (S2_RREADY_M1)
         `ifdef AMBA_AXI_RUSER
                           , .S2_RUSER             (S2_RUSER    )
         `endif
                           , .S3_BID               (S3_BID      )
                           , .S3_BRESP             (S3_BRESP    )
                           , .S3_BVALID            (S3_BVALID   )
                           , .S3_BREADY            (S3_BREADY_M1)
         `ifdef AMBA_AXI_BUSER
                           , .S3_BUSER             (S3_BUSER    )
         `endif
                           , .S3_RID               (S3_RID      )
                           , .S3_RDATA             (S3_RDATA    )
                           , .S3_RRESP             (S3_RRESP    )
                           , .S3_RLAST             (S3_RLAST    )
                           , .S3_RVALID            (S3_RVALID   )
                           , .S3_RREADY            (S3_RREADY_M1)
         `ifdef AMBA_AXI_RUSER
                           , .S3_RUSER             (S3_RUSER    )
         `endif
                           , .S4_BID               (S4_BID      )
                           , .S4_BRESP             (S4_BRESP    )
                           , .S4_BVALID            (S4_BVALID   )
                           , .S4_BREADY            (S4_BREADY_M1)
         `ifdef AMBA_AXI_BUSER
                           , .S4_BUSER             (S4_BUSER    )
         `endif
                           , .S4_RID               (S4_RID      )
                           , .S4_RDATA             (S4_RDATA    )
                           , .S4_RRESP             (S4_RRESP    )
                           , .S4_RLAST             (S4_RLAST    )
                           , .S4_RVALID            (S4_RVALID   )
                           , .S4_RREADY            (S4_RREADY_M1)
         `ifdef AMBA_AXI_RUSER
                           , .S4_RUSER             (S4_RUSER    )
         `endif
                           , .SD_BID               (SD_BID      )
                           , .SD_BRESP             (SD_BRESP    )
                           , .SD_BVALID            (SD_BVALID   )
                           , .SD_BREADY            (SD_BREADY_M1)
         `ifdef AMBA_AXI_BUSER
                           , .SD_BUSER             (SD_BUSER    )
         `endif
                           , .SD_RID               (SD_RID      )
                           , .SD_RDATA             (SD_RDATA    )
                           , .SD_RRESP             (SD_RRESP    )
                           , .SD_RLAST             (SD_RLAST    )
                           , .SD_RVALID            (SD_RVALID   )
                           , .SD_RREADY            (SD_RREADY_M1)
         `ifdef AMBA_AXI_RUSER
                           , .SD_RUSER             (SD_RUSER    )
         `endif
     );
     //-----------------------------------------------------------
     axi_default_slave #(.WIDTH_CID(WIDTH_CID)// Channel ID width in bits
                        ,.WIDTH_ID (WIDTH_ID )// ID width in bits
                        ,.WIDTH_AD (WIDTH_AD )// address width
                        ,.WIDTH_DA (WIDTH_DA )// data width
                        )
     u_axi_default_slave (
            .ARESETn  (ARESETn )
          , .ACLK     (ACLK    )
          , .AWID     (SD_AWID    )
          , .AWADDR   (SD_AWADDR  )
     `ifdef AMBA_AXI4
          , .AWLEN    (SD_AWLEN   )
          , .AWLOCK   (SD_AWLOCK  )
     `else
          , .AWLEN    (SD_AWLEN   )
          , .AWLOCK   (SD_AWLOCK  )
     `endif
          , .AWSIZE   (SD_AWSIZE  )
          , .AWBURST  (SD_AWBURST )
     `ifdef AMBA_AXI_CACHE
          , .AWCACHE  (SD_AWCACHE )
     `endif
     `ifdef AMBA_AXI_PROT
          , .AWPROT   (SD_AWPROT  )
     `endif
          , .AWVALID  (SD_AWVALID )
          , .AWREADY  (SD_AWREADY )
     `ifdef AMBA_AXI4
          , .AWQOS    (SD_AWQOS   )
          , .AWREGION (SD_AWREGION)
     `endif
          , .WID      (SD_WID     )
          , .WDATA    (SD_WDATA   )
          , .WSTRB    (SD_WSTRB   )
          , .WLAST    (SD_WLAST   )
          , .WVALID   (SD_WVALID  )
          , .WREADY   (SD_WREADY  )
          , .BID      (SD_BID     )
          , .BRESP    (SD_BRESP   )
          , .BVALID   (SD_BVALID  )
          , .BREADY   (SD_BREADY  )
          , .ARID     (SD_ARID    )
          , .ARADDR   (SD_ARADDR  )
     `ifdef AMBA_AXI4
          , .ARLEN    (SD_ARLEN   )
          , .ARLOCK   (SD_ARLOCK  )
     `else
          , .ARLEN    (SD_ARLEN   )
          , .ARLOCK   (SD_ARLOCK  )
     `endif
          , .ARSIZE   (SD_ARSIZE  )
          , .ARBURST  (SD_ARBURST )
     `ifdef AMBA_AXI_CACHE
          , .ARCACHE  (SD_ARCACHE )
     `endif
     `ifdef AMBA_AXI_PROT
          , .ARPROT   (SD_ARPROT  )
     `endif
          , .ARVALID  (SD_ARVALID )
          , .ARREADY  (SD_ARREADY )
     `ifdef AMBA_AXI4
          , .ARQOS    (SD_ARQOS   )
          , .ARREGION (SD_ARREGION)
     `endif
          , .RID      (SD_RID     )
          , .RDATA    (SD_RDATA   )
          , .RRESP    (SD_RRESP   )
          , .RLAST    (SD_RLAST   )
          , .RVALID   (SD_RVALID  )
          , .RREADY   (SD_RREADY  )
     );
     //-----------------------------------------------------------
     // synopsys translate_off
     initial begin
        wait(ARESETn==1'b0);
        wait(ARESETn==1'b1);
        repeat (2) @ (posedge ACLK);
        if ((1<<WIDTH_CID)<NUM_MASTER) begin
            $display("%m ERROR channel ID width (%2d) should be large enough to hold number %2d",
                        WIDTH_CID, NUM_MASTER);
        end
        if (M0_MID===M1_MID) begin
            $display("%m ERROR each master should have unique ID, but M0_MID:%d M1_MID:%d",
                      M0_MID, M1_MID);
        end
     end
     localparam ADDR_END0 = ADDR_BASE0 + (1<<ADDR_LENGTH0) - 1
              , ADDR_END1 = ADDR_BASE1 + (1<<ADDR_LENGTH1) - 1
              , ADDR_END2 = ADDR_BASE2 + (1<<ADDR_LENGTH2) - 1
              , ADDR_END3 = ADDR_BASE3 + (1<<ADDR_LENGTH3) - 1
              , ADDR_END4 = ADDR_BASE4 + (1<<ADDR_LENGTH4) - 1
              ;
     initial begin
         if ((ADDR_END0>=ADDR_BASE1)&&(ADDR_END0<=ADDR_END1)) $display("%m ERROR AXI address 0 and 1 overlapped 0x%08X:%08X:%08X", ADDR_END0, ADDR_BASE1, ADDR_END1);
         if ((ADDR_END0>=ADDR_BASE2)&&(ADDR_END0<=ADDR_END2)) $display("%m ERROR AXI address 0 and 2 overlapped 0x%08X:%08X:%08X", ADDR_END0, ADDR_BASE2, ADDR_END2);
         if ((ADDR_END0>=ADDR_BASE3)&&(ADDR_END0<=ADDR_END3)) $display("%m ERROR AXI address 0 and 3 overlapped 0x%08X:%08X:%08X", ADDR_END0, ADDR_BASE3, ADDR_END3);
         if ((ADDR_END0>=ADDR_BASE4)&&(ADDR_END0<=ADDR_END4)) $display("%m ERROR AXI address 0 and 4 overlapped 0x%08X:%08X:%08X", ADDR_END0, ADDR_BASE4, ADDR_END4);
         if ((ADDR_END1>=ADDR_BASE0)&&(ADDR_END1<=ADDR_END0)) $display("%m ERROR AXI address 1 and 0 overlapped 0x%08X:%08X:%08X", ADDR_END1, ADDR_BASE0, ADDR_END0);
         if ((ADDR_END1>=ADDR_BASE2)&&(ADDR_END1<=ADDR_END2)) $display("%m ERROR AXI address 1 and 2 overlapped 0x%08X:%08X:%08X", ADDR_END1, ADDR_BASE2, ADDR_END2);
         if ((ADDR_END1>=ADDR_BASE3)&&(ADDR_END1<=ADDR_END3)) $display("%m ERROR AXI address 1 and 3 overlapped 0x%08X:%08X:%08X", ADDR_END1, ADDR_BASE3, ADDR_END3);
         if ((ADDR_END1>=ADDR_BASE4)&&(ADDR_END1<=ADDR_END4)) $display("%m ERROR AXI address 1 and 4 overlapped 0x%08X:%08X:%08X", ADDR_END1, ADDR_BASE4, ADDR_END4);
         if ((ADDR_END2>=ADDR_BASE0)&&(ADDR_END2<=ADDR_END0)) $display("%m ERROR AXI address 2 and 0 overlapped 0x%08X:%08X:%08X", ADDR_END2, ADDR_BASE0, ADDR_END0);
         if ((ADDR_END2>=ADDR_BASE1)&&(ADDR_END2<=ADDR_END1)) $display("%m ERROR AXI address 2 and 1 overlapped 0x%08X:%08X:%08X", ADDR_END2, ADDR_BASE1, ADDR_END1);
         if ((ADDR_END2>=ADDR_BASE3)&&(ADDR_END2<=ADDR_END3)) $display("%m ERROR AXI address 2 and 3 overlapped 0x%08X:%08X:%08X", ADDR_END2, ADDR_BASE3, ADDR_END3);
         if ((ADDR_END2>=ADDR_BASE4)&&(ADDR_END2<=ADDR_END4)) $display("%m ERROR AXI address 2 and 4 overlapped 0x%08X:%08X:%08X", ADDR_END2, ADDR_BASE4, ADDR_END4);
         if ((ADDR_END3>=ADDR_BASE0)&&(ADDR_END3<=ADDR_END0)) $display("%m ERROR AXI address 3 and 0 overlapped 0x%08X:%08X:%08X", ADDR_END3, ADDR_BASE0, ADDR_END0);
         if ((ADDR_END3>=ADDR_BASE1)&&(ADDR_END3<=ADDR_END1)) $display("%m ERROR AXI address 3 and 1 overlapped 0x%08X:%08X:%08X", ADDR_END3, ADDR_BASE1, ADDR_END1);
         if ((ADDR_END3>=ADDR_BASE2)&&(ADDR_END3<=ADDR_END2)) $display("%m ERROR AXI address 3 and 2 overlapped 0x%08X:%08X:%08X", ADDR_END3, ADDR_BASE2, ADDR_END2);
         if ((ADDR_END3>=ADDR_BASE4)&&(ADDR_END3<=ADDR_END4)) $display("%m ERROR AXI address 3 and 4 overlapped 0x%08X:%08X:%08X", ADDR_END3, ADDR_BASE4, ADDR_END4);
         if ((ADDR_END4>=ADDR_BASE0)&&(ADDR_END4<=ADDR_END0)) $display("%m ERROR AXI address 4 and 0 overlapped 0x%08X:%08X:%08X", ADDR_END4, ADDR_BASE0, ADDR_END0);
         if ((ADDR_END4>=ADDR_BASE1)&&(ADDR_END4<=ADDR_END1)) $display("%m ERROR AXI address 4 and 1 overlapped 0x%08X:%08X:%08X", ADDR_END4, ADDR_BASE1, ADDR_END1);
         if ((ADDR_END4>=ADDR_BASE2)&&(ADDR_END4<=ADDR_END2)) $display("%m ERROR AXI address 4 and 2 overlapped 0x%08X:%08X:%08X", ADDR_END4, ADDR_BASE2, ADDR_END2);
         if ((ADDR_END4>=ADDR_BASE3)&&(ADDR_END4<=ADDR_END3)) $display("%m ERROR AXI address 4 and 3 overlapped 0x%08X:%08X:%08X", ADDR_END4, ADDR_BASE3, ADDR_END3);
     end
     // synopsys translate_on
     //-----------------------------------------------------------
endmodule
//---------------------------------------------------------------------------
module axi_arbiter_mtos_m2
     #(parameter WIDTH_CID=4 // Channel ID width in bits
               , WIDTH_ID =4 // Transaction ID
               , WIDTH_SID=(WIDTH_CID+WIDTH_ID)
               , NUM      =2 // num of masters
               )
(
       input  wire                  ARESETn
     , input  wire                  ACLK
     //-----------------------------------------------------------
     , input  wire  [NUM-1:0]       AWSELECT  // selected by address decoder
     , input  wire  [NUM-1:0]       AWVALID
     , input  wire  [NUM-1:0]       AWREADY
     , input  wire  [NUM-1:0]       AWLOCK    // lock-bit only not exclusive-bit
     , output wire  [NUM-1:0]       AWGRANT
     , input  wire  [WIDTH_SID-1:0] AWSID0   // {master_id,trans_id}
     , input  wire  [WIDTH_SID-1:0] AWSID1   // {master_id,trans_id}
     //-----------------------------------------------------------
     , input  wire  [NUM-1:0]       WVALID
     , input  wire  [NUM-1:0]       WLAST
     , input  wire  [NUM-1:0]       WREADY
     , output reg   [NUM-1:0]       WGRANT
     , input  wire  [WIDTH_SID-1:0] WSID0  // {master_id,trans_id}
     , input  wire  [WIDTH_SID-1:0] WSID1  // {master_id,trans_id}
     //-----------------------------------------------------------
     , input  wire  [NUM-1:0]       ARSELECT  // selected by address decoder
     , input  wire  [NUM-1:0]       ARVALID
     , input  wire  [NUM-1:0]       ARLOCK    // lock-bit only not exclusive-bit
     , input  wire  [NUM-1:0]       ARREADY
     , output wire  [NUM-1:0]       ARGRANT
     , input  wire  [WIDTH_SID-1:0] ARSID0   // {master_id,trans_id}
     , input  wire  [WIDTH_SID-1:0] ARSID1   // {master_id,trans_id}
     //-----------------------------------------------------------
     , input  wire  [WIDTH_CID-1:0] MID0 // master0 id
     , input  wire  [WIDTH_CID-1:0] MID1 // master1 id
);
     //-----------------------------------------------------------
     reg                  locked, unlock;
     reg  [WIDTH_SID-1:0] locksid; // {master_id,trans_id}
     //-----------------------------------------------------------
     wire [WIDTH_SID-1:0] granted_arsid = ({WIDTH_SID{ARGRANT[0]}}&ARSID0)
                                        | ({WIDTH_SID{ARGRANT[1]}}&ARSID1)
                                        ;
     reg  [NUM-1:0] argrant_reg;
     //-----------------------------------------------------------
     // The atomic access should consist of a read followed by a write.
     // The atomic access should be a single burst transfer.
     //-----------------------------------------------------------
     // read-address arbiter
     //-----------------------------------------------------------
     localparam STAR_RUN    = 'h0,
                STAR_WAIT   = 'h1,
                STAR_LOCK   = 'h2;
     reg [1:0] stateAR=STAR_RUN;
     always @ (posedge ACLK or negedge ARESETn) begin
           if (ARESETn==1'b0) begin
               locked      <= 1'b0;
               locksid     <=  'h0;
               argrant_reg <= 'h0;
               stateAR     <= STAR_RUN;
           end else begin
               case (stateAR)
               STAR_RUN: begin
                    if (|(ARGRANT&ARLOCK)) begin
                        // note that ARLOCK={M1_ARLOCK[1],M1_ALOCK[1]}
                        locked      <= 1'b1;
                        locksid     <= granted_arsid;
                        argrant_reg <= ARGRANT;
                        stateAR     <= STAR_LOCK;
                    end else begin
                        if (|ARGRANT) begin
                           // prevent the case that
                           // the granted-one is not completed due to ~ARREADY
                           // and new higher-priority-one joined,
                           // then things can go wrong.
                           if (~|(ARGRANT&ARREADY)) begin
                               argrant_reg <= ARGRANT;
                               stateAR     <= STAR_WAIT;
                           end
                        end
                    end
                    end // STAR_RUN
               STAR_WAIT: begin
                    if (|(ARGRANT&ARVALID&ARREADY)) begin
                        stateAR <= STAR_RUN;
                    end
                    end // STAR_WAIT
               STAR_LOCK: begin
                    if (unlock) begin
                        locked      <= 1'b0;
                        locksid     <=  'h0;
                        argrant_reg <=  'h0;
                        stateAR     <= STAR_RUN;
                    end
                    end // STAR_LOCK
               endcase
           end
     end
     //-----------------------------------------------------------
     assign ARGRANT = (stateAR==STAR_RUN) ? priority_sel(ARSELECT&ARVALID)
                                          : argrant_reg;
     //-----------------------------------------------------------
     // write-address arbiter
     //-----------------------------------------------------------
     wire [WIDTH_SID-1:0] fifo_push_din   = (AWGRANT[0]==1'b1) ? AWSID0
                                          : (AWGRANT[1]==1'b1) ? AWSID1
                                          : 'h0;
     wire                 fifo_push_valid = |(AWGRANT&AWREADY);
     wire                 fifo_pop_ready;
     wire                 fifo_pop_valid;
     wire [WIDTH_SID-1:0] fifo_pop_dout ;
     //-----------------------------------------------------------
     reg [NUM-1:0] awgrant_reg;
     //-----------------------------------------------------------
     localparam STAW_RUN    = 'h0,
                STAW_WAIT   = 'h1,
                STAW_LOCK   = 'h2;
     reg [1:0] stateAW=STAW_RUN;
     always @ (posedge ACLK or negedge ARESETn) begin
     if (ARESETn==1'b0) begin
         awgrant_reg <=  'h0;
         unlock      <= 1'b0;
         stateAW     <= STAW_RUN;
     end else begin
     case (stateAW)
     STAW_RUN: begin
          if (~locked) begin
              if (|AWGRANT) begin
                  if (~|(AWGRANT&AWREADY)) begin
                     awgrant_reg <= AWGRANT;
                     stateAW     <= STAW_WAIT;
                  end
              end
          end else begin
              if (locksid[WIDTH_SID-1:WIDTH_ID]==MID0) begin
                 if (AWSELECT[0]&AWVALID[0]) begin
                     if (locksid[WIDTH_SID-1:WIDTH_ID]==
                         AWSID0[WIDTH_SID-1:WIDTH_ID]) begin
                         awgrant_reg <= 6'b000001;
                         if (~AWLOCK[0]) unlock <= 1'b1;
                         else            unlock <= 1'b0;
                         stateAW <= STAW_LOCK;
                     end else begin
                         // synopsys translate_off
                         `ifdef RIGOR
                         $display("%04d %m ERROR un-expected write-request during lock AWID(0x%2x) from MID(%3d)",
                                          $time, AWSID0, MID0);
                         `endif
                         // synopsys translate_on
                     end
                 end
              end else if (locksid[WIDTH_SID-1:WIDTH_ID]==MID1) begin
                 if (AWSELECT[1]&AWVALID[1]) begin
                     if (locksid[WIDTH_SID-1:WIDTH_ID]==
                         AWSID1[WIDTH_SID-1:WIDTH_ID]) begin
                         awgrant_reg <= 2'h2;
                         if (~AWLOCK[1]) unlock <= 1'b1;
                         else            unlock <= 1'b0;
                         stateAW <= STAW_LOCK;
                     end else begin
                         // synopsys translate_off
                         `ifdef RIGOR
                         $display("%04d %m ERROR un-expected write-request during lock AWID(0x%2x) from MID(%3d)",
                                          $time, AWSID1, MID1);
                         `endif
                         // synopsys translate_on
                     end
                 end
              end
              // synopsys translate_off
              `ifdef RIGOR
              else begin
                   $display("%04d %m ERROR un-expected MID for lock 0x%x",
                                    $time, locksid[WIDTH_SID-1:WIDTH_ID]);
              end
              `endif
              // synopsys translate_on
          end
          end // STAW_RUN
     STAW_WAIT: begin
          if (|(AWGRANT&AWVALID&AWREADY)) begin
             awgrant_reg <= 'h0;
             stateAW     <= STAW_RUN;
          end
          end // STAW_WAIT
     STAW_LOCK: begin
          if (|(AWGRANT&AWVALID&AWREADY)) begin
             awgrant_reg <=  'h0;
             unlock      <= 1'b0;
             stateAW     <= STAW_RUN;
          end
          end // STAW_LOCK
     default: begin
          awgrant_reg <=  'h0;
          unlock      <= 1'b0;
          stateAW     <= STAW_RUN;
              end
     endcase
     end // if
     end // always
     //-----------------------------------------------------------
     assign AWGRANT = ((stateAW==STAW_RUN)&~locked) ? priority_sel(AWSELECT&AWVALID)
                                                    : awgrant_reg;
     //-----------------------------------------------------------
     axi_arbiter_fifo_sync #(.FDW(WIDTH_SID), .FAW(4))
     u_axi_arbiter_fifo_sync
     (
           .rstn     (ARESETn)
         , .clr      (1'b0   )
         , .clk      (ACLK   )
         , .wr_rdy   (               )
         , .wr_vld   (fifo_push_valid)
         , .wr_din   (fifo_push_din  )
         , .rd_rdy   (fifo_pop_ready )
         , .rd_vld   (fifo_pop_valid )
         , .rd_dout  (fifo_pop_dout  )
         , .full     (               )
         , .empty    ()
         , .fullN    ()
         , .emptyN   ()
         , .item_cnt ()
         , .room_cnt ()
     );
     //-----------------------------------------------------------
     wire active_wvalid = |(WGRANT&WVALID);
     wire active_wready = |WREADY;
     wire active_wlast  = |(WGRANT&WLAST);
     //-----------------------------------------------------------
     assign fifo_pop_ready = fifo_pop_valid
                           & active_wvalid
                           & active_wready
                           & active_wlast;
     //-----------------------------------------------------------
     always @ ( * ) begin
     if (~fifo_pop_valid) begin
         WGRANT = 2'h0;
     end else begin
              if (fifo_pop_dout[WIDTH_SID-1:WIDTH_ID]==MID0) WGRANT = 2'h1;
         else if (fifo_pop_dout[WIDTH_SID-1:WIDTH_ID]==MID1) WGRANT = 2'h2;
         else WGRANT = 2'h0;
     end // if
     end // always
     // synopsys translate_off
     `ifdef RIGOR
     always @ (negedge ACLK or negedge ARESETn) begin
          if (ARESETn==1'b1) begin
              if (fifo_pop_valid&~|WGRANT) begin
                  $display("%04d %m ERROR FIFO valid, but none granted WGRANT", $time);
              end
          end
     end
     `endif
     // synopsys translate_on
     //-----------------------------------------------------------
     function [NUM-1:0] priority_sel;
     input    [NUM-1:0] request;
     begin
          casex (request)
          2'bx1: priority_sel = 2'h1;
          2'b10: priority_sel = 2'h2;
          default:   priority_sel = 2'h0;
          endcase
     end
     endfunction
     //-----------------------------------------------------------
endmodule
//---------------------------------------------------------------------------
`ifndef AXI_ARBITER_FIFO_SYNC_V
`define AXI_ARBITER_FIFO_SYNC_V
//----------------------------------------------------------------
// axi_arbiter_fifo_sync.v
//----------------------------------------------------------------
// Synchronous FIFO
//----------------------------------------------------------------
// MACROS and PARAMETERS
//     FDW: bit-width of data
//     FAW: num of entries in power of 2
//----------------------------------------------------------------
// Features
//    * ready-valid handshake protocol
//    * lookahead full and empty -- see fullN and emptyN
//    * First-Word Fall-Through, but rd_vld indicates its validity
//----------------------------------------------------------------
//    * data moves when both ready(rdy) and valid(vld) is high.
//    * ready(rdy) means the receiver is ready to accept data.
//    * valid(vld) means the data is valid on 'data'.
//----------------------------------------------------------------
//
//               ___   _____   _____   _____   ____
//   clk           |___|   |___|   |___|   |___|
//               _______________________________
//   wr_rdy     
//                     _________________
//   wr_vld      ______|       ||      |___________  
//                      _______  ______
//   wr_din      XXXXXXX__D0___XX__D1__XXXX
//               ______________                        ____
//   empty                     |_______________________|
//                                     _________________
//   rd_rdy      ______________________|               |___
//                                     ________________
//   rd_vld      ______________________|       ||      |___
//                                      ________ _______
//   rd_dout     XXXXXXXXXXXXXXXXXXXXXXX__D0____X__D1___XXXX
//
//   full        __________________________________________
//
//----------------------------------------------------------------

module axi_arbiter_fifo_sync
     #(parameter FDW =32, // fifof data width
                 FAW =5,  // num of entries in 2 to the power FAW
                 FULN=4)  // lookahead-full
(
       input   wire           rstn// asynchronous reset (active low)
     , input   wire           clr // synchronous reset (active high)
     , input   wire           clk
     , output  wire           wr_rdy
     , input   wire           wr_vld
     , input   wire [FDW-1:0] wr_din
     , input   wire           rd_rdy
     , output  wire           rd_vld
     , output  wire [FDW-1:0] rd_dout
     , output  wire           full
     , output  wire           empty
     , output  wire           fullN  // lookahead full
     , output  wire           emptyN // lookahead empty
     , output  reg  [FAW:0]   item_cnt // num of elements in the FIFO to be read
     , output  wire [FAW:0]   room_cnt // num of rooms in the FIFO to be written
);
   //---------------------------------------------------
   localparam FDT = 1<<FAW;
   //---------------------------------------------------
   reg  [FAW:0]   fifo_head; // where data to be read
   reg  [FAW:0]   fifo_tail; // where data to be written
   reg  [FAW:0]   next_tail;
   reg  [FAW:0]   next_head;
   wire [FAW-1:0] read_addr = (rd_vld&rd_rdy) ? next_head[FAW-1:0] : fifo_head[FAW-1:0];
   //---------------------------------------------------
   // synopsys translate_off
   initial fifo_head = 'h0;
   initial fifo_tail = 'h0;
   initial next_head = 'h0;
   initial next_tail = 'h0;
   // synopsys translate_on
   //---------------------------------------------------
   // accept input
   // push data item into the entry pointed by fifo_tail
   //
   always @(posedge clk or negedge rstn) begin
      if (rstn==1'b0) begin
          fifo_tail <= 0;
          next_tail <= 1;
      end else if (clr) begin
          fifo_tail <= 0;
          next_tail <= 1;
      end else begin
          if (!full && wr_vld) begin
              fifo_tail <= next_tail;
              next_tail <= next_tail + 1;
          end 
      end
   end
   //---------------------------------------------------
   // provide output
   // pop data item from the entry pointed by fifo_head
   //
   always @(posedge clk or negedge rstn) begin
      if (rstn==1'b0) begin
          fifo_head <= 0;
          next_head <= 1;
      end else if (clr) begin
          fifo_head <= 0;
          next_head <= 1;
      end else begin
          if (!empty && rd_rdy) begin
              fifo_head <= next_head;
              next_head <= next_head + 1;
          end
      end
   end
   //---------------------------------------------------
   // how many items in the FIFO
   //
   assign  room_cnt = FDT-item_cnt;
   always @(posedge clk or negedge rstn) begin
      if (rstn==1'b0) begin
         item_cnt <= 0;
      end else if (clr) begin
         item_cnt <= 0;
      end else begin
         if (wr_vld&&!full&&(!rd_rdy||(rd_rdy&&empty))) begin
             item_cnt <= item_cnt + 1;
         end else
         if (rd_rdy&&!empty&&(!wr_vld||(wr_vld&&full))) begin
             item_cnt <= item_cnt - 1;
         end
      end
   end
   
   //---------------------------------------------------
   assign rd_vld = ~empty;
   assign wr_rdy = ~full;
   assign empty  = (fifo_head == fifo_tail);
   assign full   = (item_cnt>=FDT);
   //---------------------------------------------------
   assign fullN  = (item_cnt>=(FDT-FULN));
   assign emptyN = (item_cnt<=FULN);
   //---------------------------------------------------
   // synopsys translate_off
   `ifdef RIGOR
   always @(negedge clk or negedge rstn) begin
      if (rstn&&!clr) begin
          if ((item_cnt==0)&&(!empty))
             $display("%04d %m: empty flag mis-match: %d", $time, item_cnt);
          if ((item_cnt==FDT)&&(!full))
             $display("%04d %m: full flag mis-match: %d", $time, item_cnt);
          if (item_cnt>FDT)
             $display("%04d %m: fifo handling error: item_cnt>FDT %d:%d", $time, item_cnt, FDT);
          if ((item_cnt+room_cnt)!=FDT)
             $display("%04d %m: count mis-match: item_cnt:room_cnt %d:%d", $time, item_cnt, room_cnt);
      end
   end
   `endif
   // synopsys translate_on
   //---------------------------------------------------
   reg [FDW-1:0] Mem [0:FDT-1];
   assign rd_dout  = Mem[fifo_head[FAW-1:0]];
   always @(posedge clk) begin
       if (!full && wr_vld) begin
           Mem[fifo_tail[FAW-1:0]] <= wr_din;
       end
   end
   //---------------------------------------------------
endmodule
`endif
//---------------------------------------------------------------------------
module axi_arbiter_stom_s5
     #(parameter NUM=5) // num of slaves
(
       input  wire           ARESETn
     , input  wire           ACLK
     //-----------------------------------------------------------
     , input  wire  [NUM:0]  BSELECT  // selected by comparing trans_id
     , input  wire  [NUM:0]  BVALID
     , input  wire  [NUM:0]  BREADY
     , output wire  [NUM:0]  BGRANT
     //-----------------------------------------------------------
     , input  wire  [NUM:0]  RSELECT  // selected by comparing trans_id
     , input  wire  [NUM:0]  RVALID
     , input  wire  [NUM:0]  RREADY
     , input  wire  [NUM:0]  RLAST
     , output wire  [NUM:0]  RGRANT
);
     //-----------------------------------------------------------
     // read-data arbiter
     //-----------------------------------------------------------
     reg [NUM:0] rgrant_reg;
     //-----------------------------------------------------------
     localparam STR_RUN    = 'h0,
                STR_WAIT   = 'h1;
     reg stateR=STR_RUN;
     always @ (posedge ACLK or negedge ARESETn) begin
           if (ARESETn==1'b0) begin
               rgrant_reg  <= 'h0;
               stateR      <= STR_RUN;
           end else begin
               case (stateR)
               STR_RUN: begin
                    if (|RGRANT) begin
                       if (~|(RGRANT&RREADY&RLAST)) begin
                           rgrant_reg <= RGRANT;
                           stateR     <= STR_WAIT;
                       end
                    end
                    end // STR_RUN
               STR_WAIT: begin
                    if (|(RGRANT&RVALID&RREADY&RLAST)) begin
                        rgrant_reg <= 'h0;
                        stateR     <= STR_RUN;
                    end
                    end // STR_WAIT
               endcase
           end
     end
     //-----------------------------------------------------------
     assign RGRANT = (stateR==STR_RUN) ? priority_sel(RSELECT&RVALID)
                                       : rgrant_reg;
     //-----------------------------------------------------------
     // write-response arbiter
     //-----------------------------------------------------------
     reg [NUM:0] bgrant_reg;
     localparam STB_RUN    = 'h0,
                STB_WAIT   = 'h1;
     reg stateB=STB_RUN;
     always @ (posedge ACLK or negedge ARESETn) begin
           if (ARESETn==1'b0) begin
               bgrant_reg  <= 'h0;
               stateB      <= STB_RUN;
           end else begin
               case (stateB)
               STB_RUN: begin
                    if (|BGRANT) begin
                       if (~|(BGRANT&BREADY)) begin
                           bgrant_reg <= BGRANT;
                           stateB     <= STB_WAIT;
                       end
                    end
                    end // STB_RUN
               STB_WAIT: begin
                    if (|(BGRANT&BVALID&BREADY)) begin
                        bgrant_reg <= 'h0;
                        stateB     <= STB_RUN;
                    end
                    end // STB_WAIT
               endcase
           end
     end
     //-----------------------------------------------------------
     assign BGRANT = (stateB==STB_RUN) ? priority_sel(BSELECT&BVALID)
                                       : bgrant_reg;
     //-----------------------------------------------------------
     function [NUM:0] priority_sel;
        input [NUM:0] request;
     begin
          casex (request)
          6'bxxxxx1: priority_sel = 6'h1;
          6'bxxxx10: priority_sel = 6'h2;
          6'bxxx100: priority_sel = 6'h4;
          6'bxx1000: priority_sel = 6'h8;
          6'bx10000: priority_sel = 6'h10;
          6'b100000: priority_sel = 6'h20;
          default: priority_sel = 6'h0;
          endcase
     end
     endfunction
     //-----------------------------------------------------------
endmodule
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
module axi_mtos_m2
       #(parameter SLAVE_ID     =0    // for reference
                 , SLAVE_EN     =1'b1 // the slave is available when 1
                 , ADDR_BASE    =32'h0000_0000
                 , ADDR_LENGTH  =12 // effective addre bits
                 , WIDTH_CID    =4  // Channel ID width in bits
                 , WIDTH_ID     =4  // ID width in bits
                 , WIDTH_AD     =32 // address width
                 , WIDTH_DA     =32 // data width
                 , WIDTH_DS     =(WIDTH_DA/8)  // data strobe width
                 , WIDTH_SID    =WIDTH_CID+WIDTH_ID // ID for slave
                 , WIDTH_AWUSER =1 // Write-address user path
                 , WIDTH_WUSER  =1 // Write-data user path
                 , WIDTH_ARUSER =1 // read-address user path
                 , NUM_MASTER   =2    // number of master
                 , SLAVE_DEFAULT=1'b0  // default-salve when 1
        )
(
       input   wire                      ARESETn
     , input   wire                      ACLK
     //--------------------------------------------------------------
     , input   wire  [WIDTH_CID-1:0]     M0_MID
     , input   wire  [WIDTH_ID-1:0]      M0_AWID
     , input   wire  [WIDTH_AD-1:0]      M0_AWADDR
     `ifdef AMBA_AXI4
     , input   wire  [ 7:0]              M0_AWLEN
     , input   wire                      M0_AWLOCK
     `else
     , input   wire  [ 3:0]              M0_AWLEN
     , input   wire  [ 1:0]              M0_AWLOCK
     `endif
     , input   wire  [ 2:0]              M0_AWSIZE
     , input   wire  [ 1:0]              M0_AWBURST
     `ifdef  AMBA_AXI_CACHE
     , input   wire  [ 3:0]              M0_AWCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , input   wire  [ 2:0]              M0_AWPROT
     `endif
     , input   wire                      M0_AWVALID
     , output  wire                      M0_AWREADY
     `ifdef AMBA_AXI4
     , input   wire  [ 3:0]              M0_AWQOS
     , input   wire  [ 3:0]              M0_AWREGION
     `endif
     `ifdef AMBA_AXI_AWUSER
     , input   wire  [WIDTH_AWUSER-1:0]  M0_AWUSER
     `endif
     , input   wire  [WIDTH_ID-1:0]      M0_WID
     , input   wire  [WIDTH_DA-1:0]      M0_WDATA
     , input   wire  [WIDTH_DS-1:0]      M0_WSTRB
     , input   wire                      M0_WLAST
     , input   wire                      M0_WVALID
     , output  wire                      M0_WREADY
     `ifdef AMBA_AXI_WUSER
     , input   wire  [WIDTH_WUSER-1:0]   M0_WUSER
     `endif
     , input   wire  [WIDTH_ID-1:0]      M0_ARID
     , input   wire  [WIDTH_AD-1:0]      M0_ARADDR
     `ifdef AMBA_AXI4
     , input   wire  [ 7:0]              M0_ARLEN
     , input   wire                      M0_ARLOCK
     `else
     , input   wire  [ 3:0]              M0_ARLEN
     , input   wire  [ 1:0]              M0_ARLOCK
     `endif
     , input   wire  [ 2:0]              M0_ARSIZE
     , input   wire  [ 1:0]              M0_ARBURST
     `ifdef  AMBA_AXI_CACHE
     , input   wire  [ 3:0]              M0_ARCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , input   wire  [ 2:0]              M0_ARPROT
     `endif
     , input   wire                      M0_ARVALID
     , output  wire                      M0_ARREADY
     `ifdef AMBA_AXI4
     , input   wire  [ 3:0]              M0_ARQOS
     , input   wire  [ 3:0]              M0_ARREGION
     `endif
     `ifdef AMBA_AXI_ARUSER
     , input   wire  [WIDTH_ARUSER-1:0]  M0_ARUSER
     `endif
     //--------------------------------------------------------------
     , input   wire  [WIDTH_CID-1:0]     M1_MID
     , input   wire  [WIDTH_ID-1:0]      M1_AWID
     , input   wire  [WIDTH_AD-1:0]      M1_AWADDR
     `ifdef AMBA_AXI4
     , input   wire  [ 7:0]              M1_AWLEN
     , input   wire                      M1_AWLOCK
     `else
     , input   wire  [ 3:0]              M1_AWLEN
     , input   wire  [ 1:0]              M1_AWLOCK
     `endif
     , input   wire  [ 2:0]              M1_AWSIZE
     , input   wire  [ 1:0]              M1_AWBURST
     `ifdef  AMBA_AXI_CACHE
     , input   wire  [ 3:0]              M1_AWCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , input   wire  [ 2:0]              M1_AWPROT
     `endif
     , input   wire                      M1_AWVALID
     , output  wire                      M1_AWREADY
     `ifdef AMBA_AXI4
     , input   wire  [ 3:0]              M1_AWQOS
     , input   wire  [ 3:0]              M1_AWREGION
     `endif
     `ifdef AMBA_AXI_AWUSER
     , input   wire  [WIDTH_AWUSER-1:0]  M1_AWUSER
     `endif
     , input   wire  [WIDTH_ID-1:0]      M1_WID
     , input   wire  [WIDTH_DA-1:0]      M1_WDATA
     , input   wire  [WIDTH_DS-1:0]      M1_WSTRB
     , input   wire                      M1_WLAST
     , input   wire                      M1_WVALID
     , output  wire                      M1_WREADY
     `ifdef AMBA_AXI_WUSER
     , input   wire  [WIDTH_WUSER-1:0]   M1_WUSER
     `endif
     , input   wire  [WIDTH_ID-1:0]      M1_ARID
     , input   wire  [WIDTH_AD-1:0]      M1_ARADDR
     `ifdef AMBA_AXI4
     , input   wire  [ 7:0]              M1_ARLEN
     , input   wire                      M1_ARLOCK
     `else
     , input   wire  [ 3:0]              M1_ARLEN
     , input   wire  [ 1:0]              M1_ARLOCK
     `endif
     , input   wire  [ 2:0]              M1_ARSIZE
     , input   wire  [ 1:0]              M1_ARBURST
     `ifdef  AMBA_AXI_CACHE
     , input   wire  [ 3:0]              M1_ARCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , input   wire  [ 2:0]              M1_ARPROT
     `endif
     , input   wire                      M1_ARVALID
     , output  wire                      M1_ARREADY
     `ifdef AMBA_AXI4
     , input   wire  [ 3:0]              M1_ARQOS
     , input   wire  [ 3:0]              M1_ARREGION
     `endif
     `ifdef AMBA_AXI_ARUSER
     , input   wire  [WIDTH_ARUSER-1:0]  M1_ARUSER
     `endif
     //--------------------------------------------------------------
     , output  reg    [WIDTH_SID-1:0]    S_AWID
     , output  reg    [WIDTH_AD-1:0]     S_AWADDR
     `ifdef AMBA_AXI4
     , output  reg    [ 7:0]             S_AWLEN
     , output  reg                       S_AWLOCK
     `else
     , output  reg    [ 3:0]             S_AWLEN
     , output  reg    [ 1:0]             S_AWLOCK
     `endif
     , output  reg    [ 2:0]             S_AWSIZE
     , output  reg    [ 1:0]             S_AWBURST
     `ifdef  AMBA_AXI_CACHE
     , output  reg    [ 3:0]             S_AWCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , output  reg    [ 2:0]             S_AWPROT
     `endif
     , output  reg                       S_AWVALID
     , input   wire                      S_AWREADY
     `ifdef AMBA_AXI4
     , output  reg    [ 3:0]             S_AWQOS
     , output  reg    [ 3:0]             S_AWREGION
     `endif
     `ifdef AMBA_AXI_AWUSER
     , output  reg    [WIDTH_AWUSER-1:0] S_AWUSER
     `endif
     , output  reg    [WIDTH_SID-1:0]    S_WID
     , output  reg    [WIDTH_DA-1:0]     S_WDATA
     , output  reg    [WIDTH_DS-1:0]     S_WSTRB
     , output  reg                       S_WLAST
     , output  reg                       S_WVALID
     , input   wire                      S_WREADY
     `ifdef AMBA_AXI_WUSER
     , output  reg    [WIDTH_WUSER-1:0]  S_WUSER
     `endif
     , output  reg    [WIDTH_SID-1:0]    S_ARID
     , output  reg    [WIDTH_AD-1:0]     S_ARADDR
     `ifdef AMBA_AXI4
     , output  reg    [ 7:0]             S_ARLEN
     , output  reg                       S_ARLOCK
     `else
     , output  reg    [ 3:0]             S_ARLEN
     , output  reg    [ 1:0]             S_ARLOCK
     `endif
     , output  reg    [ 2:0]             S_ARSIZE
     , output  reg    [ 1:0]             S_ARBURST
     `ifdef  AMBA_AXI_CACHE
     , output  reg    [ 3:0]             S_ARCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , output  reg    [ 2:0]             S_ARPROT
     `endif
     , output  reg                       S_ARVALID
     , input   wire                      S_ARREADY
     `ifdef AMBA_AXI4
     , output  reg    [ 3:0]             S_ARQOS
     , output  reg    [ 3:0]             S_ARREGION
     `endif
     `ifdef AMBA_AXI_ARUSER
     , output  reg    [WIDTH_ARUSER-1:0] S_ARUSER
     `endif
     //-----------------------------------------------------------
     , output  wire  [NUM_MASTER-1:0]    AWSELECT_OUT
     , output  wire  [NUM_MASTER-1:0]    ARSELECT_OUT
     , input   wire  [NUM_MASTER-1:0]    AWSELECT_IN
     , input   wire  [NUM_MASTER-1:0]    ARSELECT_IN
);
     //-----------------------------------------------------------
     reg  [NUM_MASTER-1:0] AWSELECT;
     reg  [NUM_MASTER-1:0] ARSELECT;
     wire [NUM_MASTER-1:0] AWGRANT, WGRANT, ARGRANT;
     //-----------------------------------------------------------
     assign  AWSELECT_OUT = AWSELECT;
     assign  ARSELECT_OUT = ARSELECT;
     //-----------------------------------------------------------
     always @ ( * ) begin
        if (SLAVE_DEFAULT=='h0) begin
            AWSELECT[0] = SLAVE_EN[0]&(M0_AWADDR[WIDTH_AD-1:ADDR_LENGTH]==ADDR_BASE[WIDTH_AD-1:ADDR_LENGTH]);
            AWSELECT[1] = SLAVE_EN[0]&(M1_AWADDR[WIDTH_AD-1:ADDR_LENGTH]==ADDR_BASE[WIDTH_AD-1:ADDR_LENGTH]);

            ARSELECT[0] = SLAVE_EN[0]&(M0_ARADDR[WIDTH_AD-1:ADDR_LENGTH]==ADDR_BASE[WIDTH_AD-1:ADDR_LENGTH]);
            ARSELECT[1] = SLAVE_EN[0]&(M1_ARADDR[WIDTH_AD-1:ADDR_LENGTH]==ADDR_BASE[WIDTH_AD-1:ADDR_LENGTH]);
        end else begin
            AWSELECT = ~AWSELECT_IN & {M1_AWVALID,M0_AWVALID};
            ARSELECT = ~ARSELECT_IN & {M1_ARVALID,M0_ARVALID};
        end
     end
     //-----------------------------------------------------------
     wire [NUM_MASTER-1:0] AWVALID_ALL = {M1_AWVALID,M0_AWVALID};
     wire [NUM_MASTER-1:0] AWREADY_ALL = {M1_AWREADY,M0_AWREADY};
     `ifdef AMBA_AXI4
     wire [NUM_MASTER-1:0] AWLOCK_ALL = {M1_AWLOCK,M0_AWLOCK};
     `else
     wire [NUM_MASTER-1:0] AWLOCK_ALL = {M1_AWLOCK[1],M0_AWLOCK[1]};
     `endif
     wire [NUM_MASTER-1:0] ARVALID_ALL = {M1_ARVALID,M0_ARVALID};
     wire [NUM_MASTER-1:0] ARREADY_ALL = {M1_ARREADY,M0_ARREADY};
     `ifdef AMBA_AXI4
     wire [NUM_MASTER-1:0] ARLOCK_ALL = {M1_ARLOCK,M0_ARLOCK};
     `else
     wire [NUM_MASTER-1:0] ARLOCK_ALL = {M1_ARLOCK[1],M0_ARLOCK[1]};
     `endif
     wire [NUM_MASTER-1:0] WVALID_ALL = {M1_WVALID,M0_WVALID};
     wire [NUM_MASTER-1:0] WREADY_ALL = {M1_WREADY,M0_WREADY};
     wire [NUM_MASTER-1:0] WLAST_ALL = {M1_WLAST,M0_WLAST};
     //-----------------------------------------------------------
     axi_arbiter_mtos_m2 #(.WIDTH_CID(WIDTH_CID) // Channel ID width in bits
                          ,.WIDTH_ID (WIDTH_ID ) // Transaction ID
                          )
     u_axi_arbiter_mtos_m2 (
           .ARESETn  (ARESETn           )
         , .ACLK     (ACLK              )
         , .AWSELECT (AWSELECT          )
         , .AWVALID  (AWVALID_ALL       )
         , .AWREADY  (AWREADY_ALL       )
         , .AWLOCK   (AWLOCK_ALL        )
         , .AWGRANT  (AWGRANT           )
         , .AWSID0  ({M0_MID,M0_AWID}  )
         , .AWSID1  ({M1_MID,M1_AWID}  )
         , .WVALID   (WVALID_ALL        )
         , .WREADY   (WREADY_ALL        )
         , .WLAST    (WLAST_ALL         )
         , .WGRANT   (WGRANT            )
         , .WSID0    ({M0_MID,M0_WID}   )
         , .WSID1    ({M1_MID,M1_WID}   )
         , .ARSELECT (ARSELECT          )
         , .ARVALID  (ARVALID_ALL       )
         , .ARREADY  (ARREADY_ALL       )
         , .ARLOCK   (ARLOCK_ALL        )
         , .ARGRANT  (ARGRANT           )
         , .ARSID0   ({M0_MID,M0_ARID}  )
         , .ARSID1   ({M1_MID,M1_ARID}  )
         , .MID0     (M0_MID            )
         , .MID1     (M1_MID            )
     );
     //-----------------------------------------------------------
     localparam NUM_AW_WIDTH = 0
                    + WIDTH_SID          //S_AWID
                    + WIDTH_AD           //S_AWADDR
                      `ifdef AMBA_AXI4
                    +  8                 //S_AWLEN
                    +  1                 //S_AWLOCK
                      `else
                    +  4                 //S_AWLEN
                    +  2                 //S_AWLOCK
                      `endif
                    +  3                 //S_AWSIZE
                    +  2                 //S_AWBURST
                       `ifdef  AMBA_AXI_CACHE
                    +  4                 //S_AWCACHE
                       `endif
                       `ifdef AMBA_AXI_PROT
                    +  3                 //S_AWPROT
                       `endif
                    +  1                 //S_AWVALID
                      `ifdef AMBA_AXI4
                    +  4                 //S_AWQOS
                    +  4                 //S_AWREGION
                      `endif
                      `ifdef AMBA_AXI_AWUSER
                    + WIDTH_AWUSER       //S_AWUSER
                      `endif
                    ;
     localparam NUM_W_WIDTH = 0
                    + WIDTH_SID          //S_WID
                    + WIDTH_DA           //S_WDATA
                    + WIDTH_DS           //S_WSTRB
                    + 1                  //S_WLAST
                    + 1                  //S_WVALID
                      `ifdef AMBA_AXI_WUSER
                    + WIDTH_WUSER        //S_WUSER
                      `endif
                    ;
     localparam NUM_AR_WIDTH = 0
                    + WIDTH_SID          //S_ARID
                    + WIDTH_AD           //S_ARADDR
                      `ifdef AMBA_AXI4
                    +  8                 //S_ARLEN
                    +  1                 //S_ARLOCK
                      `else
                    +  4                 //S_ARLEN
                    +  2                 //S_ARLOCK
                      `endif
                    +  3                 //S_ARSIZE
                    +  2                 //S_ARBURST
                       `ifdef  AMBA_AXI_CACHE
                    +  4                 //S_ARCACHE
                       `endif
                       `ifdef AMBA_AXI_PROT
                    +  3                 //S_ARPROT
                       `endif
                    +  1                 //S_ARVALID
                      `ifdef AMBA_AXI4
                    +  4                 //S_ARQOS
                    +  4                 //S_ARREGION
                      `endif
                      `ifdef AMBA_AXI_ARUSER
                    + WIDTH_ARUSER       //S_ARUSER
                      `endif
                    ;
     //-----------------------------------------------------------
     wire [NUM_AW_WIDTH-1:0] bus_aw[0:NUM_MASTER-1];
     wire [NUM_W_WIDTH-1 :0] bus_w [0:NUM_MASTER-1];
     wire [NUM_AR_WIDTH-1:0] bus_ar[0:NUM_MASTER-1];
     //-----------------------------------------------------------
     assign M0_AWREADY = AWGRANT[0]&S_AWREADY;
     assign M1_AWREADY = AWGRANT[1]&S_AWREADY;

     assign M0_WREADY  = WGRANT [0]&S_WREADY;
     assign M1_WREADY  = WGRANT [1]&S_WREADY;

     assign M0_ARREADY = ARGRANT[0]&S_ARREADY;
     assign M1_ARREADY = ARGRANT[1]&S_ARREADY;
     //-----------------------------------------------------------
     assign bus_aw[0] = {  M0_MID // master 0 master channel id
                          ,M0_AWID
                          ,M0_AWADDR
                          ,M0_AWLEN
                          ,M0_AWLOCK
                          ,M0_AWSIZE
                          ,M0_AWBURST
     `ifdef AMBA_AXI_CACHE
                          ,M0_AWCACHE
     `endif
     `ifdef AMBA_AXI_PROT
                          ,M0_AWPROT
     `endif
                          ,M0_AWVALID
     `ifdef AMBA_AXI4
                          ,M0_AWQOS
                          ,M0_AWREGION
     `endif
     `ifdef AMBA_AXI_AWUSER
                          ,M0_AWUSER
     `endif
                        };
     assign bus_aw[1] = {  M1_MID // master 1 master channel id
                          ,M1_AWID
                          ,M1_AWADDR
                          ,M1_AWLEN
                          ,M1_AWLOCK
                          ,M1_AWSIZE
                          ,M1_AWBURST
     `ifdef AMBA_AXI_CACHE
                          ,M1_AWCACHE
     `endif
     `ifdef AMBA_AXI_PROT
                          ,M1_AWPROT
     `endif
                          ,M1_AWVALID
     `ifdef AMBA_AXI4
                          ,M1_AWQOS
                          ,M1_AWREGION
     `endif
     `ifdef AMBA_AXI_AWUSER
                          ,M1_AWUSER
     `endif
                        };
     //-----------------------------------------------------------
     assign bus_w[0]  = {  M0_MID
                          ,M0_WID
                          ,M0_WDATA
                          ,M0_WSTRB
                          ,M0_WLAST
                          ,M0_WVALID
     `ifdef AMBA_AXI_WUSER
                          ,M0_WUSER
     `endif
                        };
     assign bus_w[1]  = {  M1_MID
                          ,M1_WID
                          ,M1_WDATA
                          ,M1_WSTRB
                          ,M1_WLAST
                          ,M1_WVALID
     `ifdef AMBA_AXI_WUSER
                          ,M1_WUSER
     `endif
                        };
     //-----------------------------------------------------------
     assign bus_ar[0] = {  M0_MID
                          ,M0_ARID
                          ,M0_ARADDR
                          ,M0_ARLEN
                          ,M0_ARLOCK
                          ,M0_ARSIZE
                          ,M0_ARBURST
     `ifdef AMBA_AXI_CACHE
                          ,M0_ARCACHE
     `endif
     `ifdef AMBA_AXI_PROT
                          ,M0_ARPROT
     `endif
                          ,M0_ARVALID
     `ifdef AMBA_AXI4
                          ,M0_ARQOS
                          ,M0_ARREGION
     `endif
     `ifdef AMBA_AXI_ARUSER
                          ,M0_ARUSER
     `endif
                        };
     assign bus_ar[1] = {  M1_MID
                          ,M1_ARID
                          ,M1_ARADDR
                          ,M1_ARLEN
                          ,M1_ARLOCK
                          ,M1_ARSIZE
                          ,M1_ARBURST
     `ifdef AMBA_AXI_CACHE
                          ,M1_ARCACHE
     `endif
     `ifdef AMBA_AXI_PROT
                          ,M1_ARPROT
     `endif
                          ,M1_ARVALID
     `ifdef AMBA_AXI4
                          ,M1_ARQOS
                          ,M1_ARREGION
     `endif
     `ifdef AMBA_AXI_ARUSER
                          ,M1_ARUSER
     `endif
                        };
     //-----------------------------------------------------------
     `define S_AWBUS {S_AWID\
                     ,S_AWADDR\
                     ,S_AWLEN\
                     ,S_AWLOCK\
                     ,S_AWSIZE\
                     ,S_AWBURST\
                     `ifdef AMBA_AXI_CACHE\
                     ,S_AWCACHE\
                     `endif\
                     `ifdef AMBA_AXI_PROT\
                     ,S_AWPROT\
                     `endif\
                     ,S_AWVALID\
                     `ifdef AMBA_AXI4\
                     ,S_AWQOS\
                     ,S_AWREGION\
                     `endif\
                     `ifdef AMBA_AXI_AWUSER\
                     ,S_AWUSER\
                     `endif\
                     }
     always @ ( AWGRANT, bus_aw[0], bus_aw[1] ) begin
            `ifdef AMBA_AXI_MUX
            case (AWGRANT)
            2'h1:  `S_AWBUS = bus_aw[0];
            2'h2:  `S_AWBUS = bus_aw[1];
            default:    `S_AWBUS = 'h0;
            endcase
            `else
            `S_AWBUS = ({NUM_AW_WIDTH{AWGRANT[0]}}&bus_aw[0])
                     | ({NUM_AW_WIDTH{AWGRANT[1]}}&bus_aw[1])
                     ;
            `endif
     end
     `define S_WBUS {S_WID\
                    ,S_WDATA\
                    ,S_WSTRB\
                    ,S_WLAST\
                    ,S_WVALID\
                    `ifdef AMBA_AXI_WUSER\
                    ,S_WUSER\
                    `endif\
                    }
     always @ ( WGRANT, bus_w[0], bus_w[1] ) begin
            `ifdef AMBA_AXI_MUX
            case (WGRANT)
            2'h1:  `S_WBUS = bus_w[0];
            2'h2:  `S_WBUS = bus_w[1];
            default:    `S_WBUS = 'h0;
            endcase
            `else
            `S_WBUS = ({NUM_W_WIDTH{WGRANT[0]}}&bus_w[0])
                    | ({NUM_W_WIDTH{WGRANT[1]}}&bus_w[1])
                    ;
            `endif
     end
     `define S_ARBUS {S_ARID\
                     ,S_ARADDR\
                     `ifdef AMBA_AXI4\
                     ,S_ARLEN\
                     ,S_ARLOCK\
                     `else\
                     ,S_ARLEN\
                     ,S_ARLOCK\
                     `endif\
                     ,S_ARSIZE\
                     ,S_ARBURST\
                     `ifdef AMBA_AXI_CACHE\
                     ,S_ARCACHE\
                     `endif\
                     `ifdef AMBA_AXI_PROT\
                     ,S_ARPROT\
                     `endif\
                     ,S_ARVALID\
                     `ifdef AMBA_AXI4\
                     ,S_ARQOS\
                     ,S_ARREGION\
                     `endif\
                     `ifdef AMBA_AXI_ARUSER\
                     ,S_ARUSER\
                     `endif\
                     }
     always @ ( ARGRANT, bus_ar[0], bus_ar[1] ) begin
            `ifdef AMBA_AXI_MUX
            case (ARGRANT)
            2'h1:  `S_ARBUS = bus_ar[0];
            2'h2:  `S_ARBUS = bus_ar[1];
            default:    `S_ARBUS = 'h0;
            endcase
            `else
            `S_ARBUS = ({NUM_AR_WIDTH{ARGRANT[0]}}&bus_ar[0])
                     | ({NUM_AR_WIDTH{ARGRANT[1]}}&bus_ar[1])
                     ;
            `endif
     end
     //-----------------------------------------------------------
endmodule
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
module axi_stom_s5
       #(parameter MASTER_ID   = 0 // for reference
                 , WIDTH_CID   = 4 // Channel ID width in bits
                 , WIDTH_ID    = 4 // ID width in bits
                 , WIDTH_AD    =32 // address width
                 , WIDTH_DA    =32 // data width
                 , WIDTH_DS    =(WIDTH_DA/8)  // data strobe width
                 , WIDTH_SID   =WIDTH_CID+WIDTH_ID // ID for slave
                 , WIDTH_BUSER = 1 // Write-response user path
                 , WIDTH_RUSER = 1 // read-data user path
        )
(
       input   wire                      ARESETn
     , input   wire                      ACLK
     //--------------------------------------------------------------
     , input   wire  [WIDTH_CID-1:0]     M_MID
     , output  reg   [WIDTH_ID-1:0]      M_BID
     , output  reg   [ 1:0]              M_BRESP
     , output  reg                       M_BVALID
     , input   wire                      M_BREADY
     `ifdef AMBA_AXI_BUSER
     , output  reg   [WIDTH_BUSER-1:0]   M_BUSER
     `endif
     , output  reg   [WIDTH_ID-1:0]      M_RID
     , output  reg   [WIDTH_DA-1:0]      M_RDATA
     , output  reg   [ 1:0]              M_RRESP
     , output  reg                       M_RLAST
     , output  reg                       M_RVALID
     , input   wire                      M_RREADY
     `ifdef AMBA_AXI_RUSER
     , output  reg   [WIDTH_RUSER-1:0]   M_RUSER
     `endif
     //--------------------------------------------------------------
     , input   wire   [WIDTH_SID-1:0]    S0_BID
     , input   wire   [ 1:0]             S0_BRESP
     , input   wire                      S0_BVALID
     , output  wire                      S0_BREADY
     `ifdef AMBA_AXI_BUSER
     , input   wire   [WIDTH_BUSER-1:0]  S0_BUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    S0_RID
     , input   wire   [WIDTH_DA-1:0]     S0_RDATA
     , input   wire   [ 1:0]             S0_RRESP
     , input   wire                      S0_RLAST
     , input   wire                      S0_RVALID
     , output  wire                      S0_RREADY
     `ifdef AMBA_AXI_RUSER
     , input   wire   [WIDTH_RUSER-1:0]  S0_RUSER
     `endif
     //--------------------------------------------------------------
     , input   wire   [WIDTH_SID-1:0]    S1_BID
     , input   wire   [ 1:0]             S1_BRESP
     , input   wire                      S1_BVALID
     , output  wire                      S1_BREADY
     `ifdef AMBA_AXI_BUSER
     , input   wire   [WIDTH_BUSER-1:0]  S1_BUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    S1_RID
     , input   wire   [WIDTH_DA-1:0]     S1_RDATA
     , input   wire   [ 1:0]             S1_RRESP
     , input   wire                      S1_RLAST
     , input   wire                      S1_RVALID
     , output  wire                      S1_RREADY
     `ifdef AMBA_AXI_RUSER
     , input   wire   [WIDTH_RUSER-1:0]  S1_RUSER
     `endif
     //--------------------------------------------------------------
     , input   wire   [WIDTH_SID-1:0]    S2_BID
     , input   wire   [ 1:0]             S2_BRESP
     , input   wire                      S2_BVALID
     , output  wire                      S2_BREADY
     `ifdef AMBA_AXI_BUSER
     , input   wire   [WIDTH_BUSER-1:0]  S2_BUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    S2_RID
     , input   wire   [WIDTH_DA-1:0]     S2_RDATA
     , input   wire   [ 1:0]             S2_RRESP
     , input   wire                      S2_RLAST
     , input   wire                      S2_RVALID
     , output  wire                      S2_RREADY
     `ifdef AMBA_AXI_RUSER
     , input   wire   [WIDTH_RUSER-1:0]  S2_RUSER
     `endif
     //--------------------------------------------------------------
     , input   wire   [WIDTH_SID-1:0]    S3_BID
     , input   wire   [ 1:0]             S3_BRESP
     , input   wire                      S3_BVALID
     , output  wire                      S3_BREADY
     `ifdef AMBA_AXI_BUSER
     , input   wire   [WIDTH_BUSER-1:0]  S3_BUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    S3_RID
     , input   wire   [WIDTH_DA-1:0]     S3_RDATA
     , input   wire   [ 1:0]             S3_RRESP
     , input   wire                      S3_RLAST
     , input   wire                      S3_RVALID
     , output  wire                      S3_RREADY
     `ifdef AMBA_AXI_RUSER
     , input   wire   [WIDTH_RUSER-1:0]  S3_RUSER
     `endif
     //--------------------------------------------------------------
     , input   wire   [WIDTH_SID-1:0]    S4_BID
     , input   wire   [ 1:0]             S4_BRESP
     , input   wire                      S4_BVALID
     , output  wire                      S4_BREADY
     `ifdef AMBA_AXI_BUSER
     , input   wire   [WIDTH_BUSER-1:0]  S4_BUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    S4_RID
     , input   wire   [WIDTH_DA-1:0]     S4_RDATA
     , input   wire   [ 1:0]             S4_RRESP
     , input   wire                      S4_RLAST
     , input   wire                      S4_RVALID
     , output  wire                      S4_RREADY
     `ifdef AMBA_AXI_RUSER
     , input   wire   [WIDTH_RUSER-1:0]  S4_RUSER
     `endif
     //--------------------------------------------------------------
     , input   wire   [WIDTH_SID-1:0]    SD_BID
     , input   wire   [ 1:0]             SD_BRESP
     , input   wire                      SD_BVALID
     , output  wire                      SD_BREADY
     `ifdef AMBA_AXI_BUSER
     , input   wire   [WIDTH_BUSER-1:0]  SD_BUSER
     `endif
     , input   wire   [WIDTH_SID-1:0]    SD_RID
     , input   wire   [WIDTH_DA-1:0]     SD_RDATA
     , input   wire   [ 1:0]             SD_RRESP
     , input   wire                      SD_RLAST
     , input   wire                      SD_RVALID
     , output  wire                      SD_RREADY
     `ifdef AMBA_AXI_RUSER
     , input   wire   [WIDTH_RUSER-1:0]  SD_RUSER
     `endif
);
     //-----------------------------------------------------------
     localparam NUM=5;
     //-----------------------------------------------------------
     wire [NUM:0] BSELECT, RSELECT;
     wire [NUM:0] BGRANT , RGRANT ;
     //-----------------------------------------------------------
     assign BSELECT[0]   = (S0_BID[WIDTH_SID-1:WIDTH_ID]==M_MID);
     assign BSELECT[1]   = (S1_BID[WIDTH_SID-1:WIDTH_ID]==M_MID);
     assign BSELECT[2]   = (S2_BID[WIDTH_SID-1:WIDTH_ID]==M_MID);
     assign BSELECT[3]   = (S3_BID[WIDTH_SID-1:WIDTH_ID]==M_MID);
     assign BSELECT[4]   = (S4_BID[WIDTH_SID-1:WIDTH_ID]==M_MID);
     assign BSELECT[5]   = (SD_BID[WIDTH_SID-1:WIDTH_ID]==M_MID);
     //-----------------------------------------------------------
     assign RSELECT[0]   = (S0_RID[WIDTH_SID-1:WIDTH_ID]==M_MID);
     assign RSELECT[1]   = (S1_RID[WIDTH_SID-1:WIDTH_ID]==M_MID);
     assign RSELECT[2]   = (S2_RID[WIDTH_SID-1:WIDTH_ID]==M_MID);
     assign RSELECT[3]   = (S3_RID[WIDTH_SID-1:WIDTH_ID]==M_MID);
     assign RSELECT[4]   = (S4_RID[WIDTH_SID-1:WIDTH_ID]==M_MID);
     assign RSELECT[5]   = (SD_RID[WIDTH_SID-1:WIDTH_ID]==M_MID);
     //-----------------------------------------------------------
     axi_arbiter_stom_s5 #(.NUM(NUM))
     u_axi_arbiter_stom_s5 (
           .ARESETn  (ARESETn)
         , .ACLK     (ACLK   )
         , .BSELECT  (BSELECT)
         , .BVALID   ({SD_BVALID,S4_BVALID,S3_BVALID,S2_BVALID,S1_BVALID,S0_BVALID})
         , .BREADY   ({SD_BREADY,S4_BREADY,S3_BREADY,S2_BREADY,S1_BREADY,S0_BREADY})
         , .BGRANT   (BGRANT )
         , .RSELECT  (RSELECT)
         , .RVALID   ({SD_RVALID,S4_RVALID,S3_RVALID,S2_RVALID,S1_RVALID,S0_RVALID})
         , .RREADY   ({SD_RREADY,S4_RREADY,S3_RREADY,S2_RREADY,S1_RREADY,S0_RREADY})
         , .RLAST    ({SD_RLAST,S4_RLAST,S3_RLAST,S2_RLAST,S1_RLAST,S0_RLAST})
         , .RGRANT   (RGRANT )
     );
     //-----------------------------------------------------------
     localparam NUM_B_WIDTH = 0
                    + WIDTH_ID           //M_BID
                    +  2                 //M_BRESP
                    +  1                 //M_BVALID
                      `ifdef AMBA_AXI_BUSER
                    + WIDTH_BUSER        //M_BUSER
                      `endif
                    ;
     localparam NUM_R_WIDTH = 0
                    + WIDTH_ID           //M_RID
                    + WIDTH_DA           //M_RDATA
                    +  2                 //M_RRESP
                    +  1                 //M_RLAST
                    +  1                 //M_RVALID
                      `ifdef AMBA_AXI_RUSER
                    + WIDTH_RUSER        //M_RUSER
                      `endif
                    ;
     //-----------------------------------------------------------
     wire [NUM_B_WIDTH-1:0] bus_b[0:NUM];
     wire [NUM_R_WIDTH-1:0] bus_r[0:NUM];
     //-----------------------------------------------------------
     assign bus_b[0] = {  S0_BID[WIDTH_ID-1:0]
                         ,S0_BRESP
                         ,S0_BVALID
     `ifdef AMBA_AXI_BUSER
                         ,S0_BUSER
     `endif
                       };
     assign bus_b[1] = {  S1_BID[WIDTH_ID-1:0]
                         ,S1_BRESP
                         ,S1_BVALID
     `ifdef AMBA_AXI_BUSER
                         ,S1_BUSER
     `endif
                       };
     assign bus_b[2] = {  S2_BID[WIDTH_ID-1:0]
                         ,S2_BRESP
                         ,S2_BVALID
     `ifdef AMBA_AXI_BUSER
                         ,S2_BUSER
     `endif
                       };
     assign bus_b[3] = {  S3_BID[WIDTH_ID-1:0]
                         ,S3_BRESP
                         ,S3_BVALID
     `ifdef AMBA_AXI_BUSER
                         ,S3_BUSER
     `endif
                       };
     assign bus_b[4] = {  S4_BID[WIDTH_ID-1:0]
                         ,S4_BRESP
                         ,S4_BVALID
     `ifdef AMBA_AXI_BUSER
                         ,S4_BUSER
     `endif
                       };
     assign bus_b[NUM] = {SD_BID[WIDTH_ID-1:0]
                         ,SD_BRESP
                         ,SD_BVALID
     `ifdef AMBA_AXI_BUSER
                         ,SD_BUSER
     `endif
                       };
     //-----------------------------------------------------------
     assign bus_r[0] = {  S0_RID[WIDTH_ID-1:0]
                         ,S0_RDATA
                         ,S0_RRESP
                         ,S0_RLAST
                         ,S0_RVALID
     `ifdef AMBA_AXI_RUSER
                         ,S0_RUSER
     `endif
                       };
     assign bus_r[1] = {  S1_RID[WIDTH_ID-1:0]
                         ,S1_RDATA
                         ,S1_RRESP
                         ,S1_RLAST
                         ,S1_RVALID
     `ifdef AMBA_AXI_RUSER
                         ,S1_RUSER
     `endif
                       };
     assign bus_r[2] = {  S2_RID[WIDTH_ID-1:0]
                         ,S2_RDATA
                         ,S2_RRESP
                         ,S2_RLAST
                         ,S2_RVALID
     `ifdef AMBA_AXI_RUSER
                         ,S2_RUSER
     `endif
                       };
     assign bus_r[3] = {  S3_RID[WIDTH_ID-1:0]
                         ,S3_RDATA
                         ,S3_RRESP
                         ,S3_RLAST
                         ,S3_RVALID
     `ifdef AMBA_AXI_RUSER
                         ,S3_RUSER
     `endif
                       };
     assign bus_r[4] = {  S4_RID[WIDTH_ID-1:0]
                         ,S4_RDATA
                         ,S4_RRESP
                         ,S4_RLAST
                         ,S4_RVALID
     `ifdef AMBA_AXI_RUSER
                         ,S4_RUSER
     `endif
                       };
     assign bus_r[NUM] = {SD_RID[WIDTH_ID-1:0]
                         ,SD_RDATA
                         ,SD_RRESP
                         ,SD_RLAST
                         ,SD_RVALID
     `ifdef AMBA_AXI_RUSER
                         ,SD_RUSER
     `endif
                       };
     //-----------------------------------------------------------
     `define M_BBUS {M_BID[WIDTH_ID-1:0]\
                    ,M_BRESP\
                    ,M_BVALID\
                    `ifdef AMBA_AXI_BUSER\
                    ,M_BUSER\
                    `endif\
                    }
     always @ ( BGRANT, bus_b[0], bus_b[1], bus_b[2], bus_b[3], bus_b[4], bus_b[NUM] ) begin
            `ifdef AMBA_AXI_MUX
            case (BGRANT)
            6'h1: `M_BBUS = bus_b[0];
            6'h2: `M_BBUS = bus_b[1];
            6'h4: `M_BBUS = bus_b[2];
            6'h8: `M_BBUS = bus_b[3];
            6'h10: `M_BBUS = bus_b[4];
            6'h20: `M_BBUS = bus_b[NUM];
            default:    `M_BBUS = 'h0;
            endcase
            `else
            `M_BBUS = ({NUM_B_WIDTH{BGRANT[0]}}&bus_b[0])
                    | ({NUM_B_WIDTH{BGRANT[1]}}&bus_b[1])
                    | ({NUM_B_WIDTH{BGRANT[2]}}&bus_b[2])
                    | ({NUM_B_WIDTH{BGRANT[3]}}&bus_b[3])
                    | ({NUM_B_WIDTH{BGRANT[4]}}&bus_b[4])
                    | ({NUM_B_WIDTH{BGRANT[NUM]}}&bus_b[NUM]);
            `endif
     end
     `define M_RBUS {M_RID[WIDTH_ID-1:0]\
                    ,M_RDATA\
                    ,M_RRESP\
                    ,M_RLAST\
                    ,M_RVALID\
                    `ifdef AMBA_AXI_RUSER\
                    ,M_RUSER\
                    `endif\
                    }
     always @ ( RGRANT, bus_r[0], bus_r[1], bus_r[2], bus_r[3], bus_r[4], bus_r[NUM] ) begin
            `ifdef AMBA_AXI_MUX
            case (RGRANT)
            6'h1: `M_RBUS = bus_r[0];
            6'h2: `M_RBUS = bus_r[1];
            6'h4: `M_RBUS = bus_r[2];
            6'h8: `M_RBUS = bus_r[3];
            6'h10: `M_RBUS = bus_r[4];
            6'h20: `M_RBUS = bus_r[NUM];
            default:    `M_RBUS = 'h0;
            endcase
            `else
            `M_RBUS = ({NUM_R_WIDTH{RGRANT[0]}}&bus_r[0])
                    | ({NUM_R_WIDTH{RGRANT[1]}}&bus_r[1])
                    | ({NUM_R_WIDTH{RGRANT[2]}}&bus_r[2])
                    | ({NUM_R_WIDTH{RGRANT[3]}}&bus_r[3])
                    | ({NUM_R_WIDTH{RGRANT[4]}}&bus_r[4])
                    | ({NUM_R_WIDTH{RGRANT[NUM]}}&bus_r[NUM]);
            `endif
     end
     //-----------------------------------------------------------
     assign S0_BREADY = BGRANT[0]&M_BREADY;
     assign S1_BREADY = BGRANT[1]&M_BREADY;
     assign S2_BREADY = BGRANT[2]&M_BREADY;
     assign S3_BREADY = BGRANT[3]&M_BREADY;
     assign S4_BREADY = BGRANT[4]&M_BREADY;
     assign SD_BREADY = BGRANT[NUM]&M_BREADY;

     assign S0_RREADY = RGRANT[0]&M_RREADY;
     assign S1_RREADY = RGRANT[1]&M_RREADY;
     assign S2_RREADY = RGRANT[2]&M_RREADY;
     assign S3_RREADY = RGRANT[3]&M_RREADY;
     assign S4_RREADY = RGRANT[4]&M_RREADY;
     assign SD_RREADY = RGRANT[NUM]&M_RREADY;
     //-----------------------------------------------------------
endmodule
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
`ifndef AXI_DEFAULT_SLAVE_V
`define AXI_DEFAULT_SLAVE_V
module axi_default_slave
     #(parameter WIDTH_CID=4        // Channel ID width in bits
               , WIDTH_ID=4         // ID width in bits
               , WIDTH_AD=32        // address width
               , WIDTH_DA=32       // data width
               , WIDTH_DS=WIDTH_DA/8  // data strobe width
               , WIDTH_SID=WIDTH_CID+WIDTH_ID
      )
(
       input  wire                 ARESETn
     , input  wire                 ACLK
     , input  wire [WIDTH_SID-1:0] AWID
     , input  wire [WIDTH_AD-1:0]  AWADDR
     `ifdef AMBA_AXI4
     , input  wire [ 7:0]          AWLEN
     , input  wire                 AWLOCK
     `else
     , input  wire [ 3:0]          AWLEN
     , input  wire [ 1:0]          AWLOCK
     `endif
     , input  wire [ 2:0]          AWSIZE
     , input  wire [ 1:0]          AWBURST
     `ifdef AMBA_AXI_CACHE
     , input  wire [ 3:0]          AWCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , input  wire [ 2:0]          AWPROT
     `endif
     , input  wire                 AWVALID
     , output reg                  AWREADY
     `ifdef AMBA_AXI4
     , input  wire [ 3:0]          AWQOS
     , input  wire [ 3:0]          AWREGION
     `endif
     , input  wire [WIDTH_SID-1:0] WID
     , input  wire [WIDTH_DA-1:0]  WDATA
     , input  wire [WIDTH_DS-1:0]  WSTRB
     , input  wire                 WLAST
     , input  wire                 WVALID
     , output reg                  WREADY
     , output reg  [WIDTH_SID-1:0] BID
     , output wire [ 1:0]          BRESP
     , output reg                  BVALID
     , input  wire                 BREADY
     , input  wire [WIDTH_SID-1:0] ARID
     , input  wire [WIDTH_AD-1:0]  ARADDR
     `ifdef AMBA_AXI4
     , input  wire [ 7:0]          ARLEN
     , input  wire                 ARLOCK
     `else
     , input  wire [ 3:0]          ARLEN
     , input  wire [ 1:0]          ARLOCK
     `endif
     , input  wire [ 2:0]          ARSIZE
     , input  wire [ 1:0]          ARBURST
     `ifdef AMBA_AXI_CACHE
     , input  wire [ 3:0]          ARCACHE
     `endif
     `ifdef AMBA_AXI_PROT
     , input  wire [ 2:0]          ARPROT
     `endif
     , input  wire                 ARVALID
     , output reg                  ARREADY
     `ifdef AMBA_AXI4
     , input  wire [ 3:0]          ARQOS
     , input  wire [ 3:0]          ARREGION
     `endif
     , output reg  [WIDTH_SID-1:0] RID
     , output wire [WIDTH_DA-1:0]  RDATA
     , output wire [ 1:0]          RRESP
     , output reg                  RLAST
     , output reg                  RVALID
     , input  wire                 RREADY
);
     //-----------------------------------------------------------
     // write case
     //-----------------------------------------------------------
     assign BRESP = 2'b11; // DECERR: decode error
     reg [WIDTH_SID-1:0] awid_reg;
     `ifdef AMBA_AXI4
     reg [8:0] countW, awlen_reg;
     `else
     reg [4:0] countW, awlen_reg;
     `endif
     //-----------------------------------------------------------
     localparam STW_IDLE   = 'h0,
                STW_RUN    = 'h1,
                STW_WAIT   = 'h2,
                STW_RSP    = 'h3;
     reg [1:0] stateW=STW_IDLE;
     always @ (posedge ACLK or negedge ARESETn) begin
         if (ARESETn==1'b0) begin
             AWREADY   <= 1'b0;
             WREADY    <= 1'b0;
             BID       <=  'h0;
             BVALID    <= 1'b0;
             countW    <=  'h0;
             awlen_reg <=  'h0;
             awid_reg  <=  'h0;
             stateW    <= STW_IDLE;
         end else begin
             case (stateW)
             STW_IDLE: begin
                 if (AWVALID==1'b1) begin
                     AWREADY <= 1'b1;
                     stateW  <= STW_RUN;
                 end
                 end // STW_IDLE
             STW_RUN: begin
                 if ((AWVALID==1'b1)&&(AWREADY==1'b1)) begin
                      AWREADY   <= 1'b0;
                      WREADY    <= 1'b1;
                      awlen_reg <= {1'b0,AWLEN};
                      awid_reg  <= AWID;
                      stateW    <= STW_WAIT;
                 end else begin
                 end
                 end // STW_IDLE
             STW_WAIT: begin
                 if (WVALID==1'b1) begin
                     if ((countW>=awlen_reg)||(WLAST==1'b1)) begin
                         BID    <= awid_reg;
                         BVALID <= 1'b1;
                         WREADY <= 1'b0;
                         countW <= 'h0;
                         stateW <= STW_RSP;
                         // synopsys translate_off
                         if (WLAST==1'b0) begin
                             $display("%04d %m Error expecting WLAST", $time);
                         end
                         // synopsys translate_on
                     end else begin
                         countW <= countW + 1;
                     end
                 end
                 // synopsys translate_off
                 if ((WVALID==1'b1)&&(WID!=awid_reg)) begin
                     $display("%04d %m Error AWID(0x%x):WID(0x%x) mismatch", $time, awid_reg, WID);
                 end
                 // synopsys translate_on
                 end // STW_WAIT
             STW_RSP: begin
                 if (BREADY==1'b1) begin
                     BVALID  <= 1'b0;
                     if (AWVALID==1'b1) begin
                         AWREADY <= 1'b1;
                         stateW  <= STW_RUN;
                     end else begin
                         stateW  <= STW_IDLE;
                     end
                 end
                 end // STW_RSP
             endcase
         end
     end
     //-----------------------------------------------------------
     // read case
     //-----------------------------------------------------------
     assign RRESP = 2'b11; // DECERR; decode error
     assign RDATA = ~'h0;
     reg [WIDTH_SID-1:0] arid_reg;
     `ifdef AMBA_AXI4
     reg [8:0] countR, arlen_reg;
     `else
     reg [4:0] countR, arlen_reg;
     `endif
     //-----------------------------------------------------------
     localparam STR_IDLE   = 'h0,
                STR_RUN    = 'h1,
                STR_WAIT   = 'h2,
                STR_END    = 'h3;
     reg [1:0] stateR=STR_IDLE;
     always @ (posedge ACLK or negedge ARESETn) begin
         if (ARESETn==1'b0) begin
             ARREADY   <= 1'b0;
             RID       <=  'h0;
             RLAST     <= 1'b0;
             RVALID    <= 1'b0;
             arid_reg  <=  'h0;
             arlen_reg <=  'h0;
             countR    <=  'h0;
             stateR    <= STR_IDLE;
         end else begin
             case (stateR)
             STR_IDLE: begin
                 if (ARVALID==1'b1) begin
                      ARREADY   <= 1'b1;
                      stateR    <= STR_RUN;
                 end
                 end // STR_IDLE
             STR_RUN: begin
                 if ((ARVALID==1'b1)&&(ARREADY==1'b1)) begin
                      ARREADY   <= 1'b0;
                      arlen_reg <= ARLEN+1;
                      arid_reg  <= ARID;
                      RID       <= ARID;
                      RVALID    <= 1'b1;
                      RLAST     <= (ARLEN=='h0) ? 1'b1 : 1'b0;
                      countR    <=  'h2;
                      stateR    <= STR_WAIT;
                 end
                 end // STR_IDLE
             STR_WAIT: begin
                 if (RREADY==1'b1) begin
                     if (countR>=(arlen_reg+1)) begin
                         RVALID  <= 1'b0;
                         RLAST   <= 1'b0;
                         countR  <= 'h0;
                         stateR  <= STR_END;
                     end else begin
                         if (countR==arlen_reg) RLAST  <= 1'b1;
                         countR <= countR + 1;
                     end
                 end
                 end // STR_WAIT
             STR_END: begin
                 if (ARVALID==1'b1) begin
                      ARREADY   <= 1'b1;
                      stateR    <= STR_RUN;
                 end else begin
                      stateR    <= STR_IDLE;
                 end
                 end // STR_END
             endcase
         end
     end
     //-----------------------------------------------------------
endmodule
`endif
//---------------------------------------------------------------------------
