* Path, Component, Release: cmos10lpe/relRF/HSPICE/models/design_model.inc, 10lpe_models, mod_cmos10lpe
* CMVC Revision: 1.6 08/03/28 17:00:54
***********************************************************************
*
*   Licensed Materials - Property of IBM
*
*   IBM CONFIDENTIAL
*   (C) 2008 IBM Corporation 
*
*   US Government Users Restricted Rights - Use, duplication
*   or disclosure restricted by GSA ADP Schedule contract with
*   IBM Corporation.
************************************************************************
* HSPICE include file for global switches, corner parameters
* and other user-defined settings
*******************************************************************************
* -----------------------------------------
* MonteCarlo, corner and fet matching controls:
* --------------------------
* mc_global=1 (default) -- This setting provides the most complete representation of the
*             statistical variations during chip manufacturing.
*             Global process variations are determined by random distributions.
*             Passive mismatch is determined by random distributions with a unique
*             set of values for each instance of the model.
*             Fet doping and geometric mismatch effects, if enabled are determined by
*             random distributions with a unique set of values for each instance of
*             the model.
* mc_global=0 -- This setting allows evaluation of effect of cross chip variation with the
*             global process set at a particular corner.  This is useful for example to
*             evaluate the worst case cell on the worst case chip for design containing
*             an SRAM.
*             Global process variation skewed by corner parameters (cor_*).
*             Passive mismatch is determined by random distributions with a unique
*             set of values for each instance of the model.
*             Fet doping and geometric mismatch effects, if enabled are determined by
*             random distributions with a unique set of values for each instance of
*             the model.
* mc_global=2 -- This setting provides another approach to finding the worst cell on the
*             worst chip.  All devices of a given type have the same global and mismatch
*             parameters so mismatch effects are not simulated.  But a 3 sigma chip mean
*             condition combined with a 3 sigma cross chip variation occurs with 3 sigma
*             probability rather than 6 sigma probability.
*             Global process variation determined by random distributions.
*             Passive mismatch is determined by random distributions with a unique
*             set of values for each instance of the model.
*             Fet doping and geometric mismatch effects, if enabled are determined by
*             are determined the random distributions for the corresponding global
*             effects.  Specifically ACLV is determined by chip mean delta L for that
*             FET type, ACWV is determined by chip mean delta W for that FET type and
*             dopant density matching is determined by chip mean vt variation for that
*             FET type.
* gstis      Switch to enable the STI stress model
* gstis=0   Disable the STI stress effect model, regardless if a FET netlist call has
*           or has not provided STI stress instance parameters
* gstis=1(default)--Default to no STI stress effect if no STI stress effect instance parameters
*           are provided.If the instance parameters are provided , the STI stress effect
*           is calculated using the provided instance parameters.
* gstis=2   Set the FET call with the STI stress effect default to GR minimum if no
*           STI stress effect instance parameters are provided in a FET netlist call.
*           Otherwise STI stress effect is calculated using the provided instance parameters
*           if provided.
* gwells      Switch to enable well proximity model
* gwells=0  Disable the well proximity model, regardless if a FET netlist call has
*           or has not provided well proximity effect instance parameters
* gwells=1(default)--Default to no well proximity effect if there are no instance parameters
*           provided.If instance parameters are provided, well proximity is calculated
*           using the provided instance parameters.
* gwells=2  Set well proximity parameters to GR minimum for if no well proximity instance
*           parameters are provided.Otherwise well proximity effect is calculated using the
*           provided instance parameters.
* fet_dop_mm  This switch enables variation of FET Vt and conductance due to random
*             variation in the number of dopant atoms under the channel between instances
*             of the same FET type.
* fet_dop_mm=1 (default) -- Dopant mismatch is enabled.
* fet_dop_mm=0 -- Dopant mismatch is disabled.
*
* fet_geo_mm  This switch enables variation of FET length (ACLV) and width (ACWV) between
*             instances of the same FET type.  The design manual specifies maximum FET
*             geometric mismatch values due to several layout conditions.  For a given
*             effect to be enabled both fet_geo_mm and the particular switch for that effect
*             must be enabled.  In addition random variation is specified for identical
*             instances and this variation is enabled when fet_geo_mm and grs are enabled.
* fet_geo_mm=1 (default) -- Geometric mismatch is enabled.
* fet_geo_mm=0 -- Geometric mismatch is disabled.
*
* pc_nest     This switch controls ACLV due to differences in printing nested vs. isolated
*             poly lines.  (Nested lines surrounded by closely spaced poly lines, isolated
*             lines are far from any other poly shapes.)
* pc_nest=1   (default) -- enabled
* pc_nest=0   -- disabled
* pc_nest=2   -- enabled and the difference between a nested and an isolated FET is
*             specified by pc_nest_add.
*             This is useful for model to hardware correlation work when this value is known
*             for a hardware sample and plnest is specified on the FET instances.
* Nested or Isolated global adder values selected by local instance switch (plnest).
* pc_nest=3   -- enabled Nested distribution set to 0. Isolated distribution global random.
* pc_orient   This switch controls ACLV due to differences in printing vertical vs.
*             horizontal poly lines.
* pc_orient=1 (default) -- enabled
* pc_orient=0 -- disabled
* pc_orient=2 -- enabled and the difference between a vertical and a horizontal FET is
*             specified by pc_orient_add.
*             This is useful for model to hardware correlation work when this value is known
*             for a hardware sample and plorient is specified on the FET instances.
* pc_orient=3   -- enabled Vertical distribution set to 0.
*                  Horizontal distribution global random.
* pc_dist     This switch controls ACLV due to FET instances being widely separated
*             on the chip.
* pc_dist=1   (default) -- enabled
* pc_dist=0   -- disabled
* pc_dist=2   -- enabled and the difference between a near and a distant FET is
*             specified by pc_dist_add.
*             This is useful for model to hardware correlation work when this value is known
*             for a hardware sample and pld200 is specified on the FET instances.
* pc_dist=3   -- enabled Within 200um distribution set to 0, Outside 200um
*               distribution is global random.
* *****************************************************************************
* -----------------------------------------
* Process corner parameters:
* --------------------------
* The following corner parameters affect one or more skew parameters for all devices
* affected by the physical property modeled by those parameters.  For example xcor_tox
* skews the oxide thickness in all thin oxide FETs and also in NCAPs.
*
* Set the following cor_* parameters between -3 and +3 to get the corresponding
* sigma variations in the skew parameters of the devices affected.
*
* Positive values of the corner parameter give following characteristics:
* cor_nmos: High current, high speed for NFETs
* cor_pmos: High current, high speed for PFETs
* The following corner parameters affect more than one group of devices in a
* A positive value for these corner parameters gives these
* characteristics:
* cor_tox   : Thin oxide thickness for NFETs, PFETs, ncap, pcap (high current, capacitance)
* cor_toxeg : Mid oxide thickness for Egnfets, Egpfets, egncap
* cor_toxdg : Thick oxide thickness for Dgnfets, Dgpfets, dgncap
* cor_pc  : Small gate length for NFETs, PFETs (high current)
*              (works in concert with xcor_nmos and xcorpmos)
* cor_rx  : Large width for for NFETs, PFETs (high current)
* cor_acv : ACV corner parameter, aclv,acwv,vt mismatch
******************************************************************************
* -----------------------------------------
* ESD Global switches:
* --------------------------
* esd_event = global parameter used for esd event switching
*             esd_event=0 esd high current features disabled
*             esd_event=1 esd high current features enabled for HBM
*             esd_event=2 esd high current features enabled for MM
*             esd_event=3 esd high current features enabled for CDM
*                                                        [unitless]
* esd_exit  = global parameter used to stop simulation if
*             ESD failure encountered
*             esd_event=0 continue simulation if ESD failure encountered
*             esd_event=1 stop simulation if ESD failure encountered
*                                                        [unitless]
* esd_extr  = global parameter used to include wiring resistance
*             and capacitance for pre-extraction simulation
*             esd_extr=0 wiring resistance and capacitance included
*             esd_extr=1 wiring resistance and capacitance set to 0
*                                                        [unitless]
******************************************************************************
*
* Switches
******Default for mc switches*****
.param
+   mc_global  = 1
+   gwells     = 1
+   gstis      = 1
+   fixed_cor_sw = 0
+   fet_cnr_sw = 0
+   pccrit_global= 1
+   grs         = 1
***** ESD Global switches ********
+   esd_event=0
+   esd_exit=0
+   esd_extr=1
*****  fet mis-match switches  *****
+   fet_dop_mm   = 1
+   fet_geo_mm   = 1
+   pc_nest_add  = 0
+   pc_orient_add= 0
+   pc_dist_add  = 0
+   pc_nest      = 1
+   pc_orient    = 1
+   pc_dist      = 1
+   pre_layout_sw = 0
*** Default corner sigma values = 0 (nominal) (-3,+3)
+  sigma      = 0
+  cor_rx     = sigma
+  cor_pc     = sigma
+  cor_tox    = sigma
+  cor_toxeg  = sigma
+  cor_toxdg  = sigma
+  cor_wirerc = sigma
+  cor_cap    = sigma
+  cor_res    = sigma
+  cor_vpnp   = sigma
+  cor_acv_corr  = sigma
+  cor_acv_uncorr  = sigma
+  cor_nmos   = sigma
+  cor_pmos   = sigma
********1/f Noise Corner *************
+  cor_noin = 0
+  cor_noip = 0
***************************************
*** BEOL wiring option.  must be set according to wiring option in use
*** as numbered in table in DM section 2
+ wireopt	  = 1
+ cor_sub         = cor_wirerc
+ cor_nw          = cor_res
+ cor_nband       = cor_wirerc
+ cor_pw          = cor_wirerc
+ cor_diff        = cor_wirerc
+ cor_ndnrw       = cor_wirerc
+ cor_ndiff       = cor_wirerc
+ cor_pdnrw       = cor_wirerc
+ cor_pdiff       = cor_wirerc
+ cor_pc_pc       = cor_wirerc
+ cor_pc_m1       = cor_wirerc
+ cor_sub_m1      = cor_wirerc
+ cor_m1          = cor_wirerc
+ cor_m2          = cor_wirerc
+ cor_m3          = cor_wirerc
+ cor_m4          = cor_wirerc
+ cor_m5          = cor_wirerc
+ cor_m6          = cor_wirerc
+ cor_b1          = cor_wirerc
+ cor_b2          = cor_wirerc
+ cor_b3          = cor_wirerc
+ cor_ba          = cor_wirerc
+ cor_bb          = cor_wirerc
+ cor_bd          = cor_wirerc
+ cor_ea          = cor_wirerc
+ cor_eb          = cor_wirerc
+ cor_lb          = cor_wirerc
+ cor_ld          = cor_wirerc
+ cor_oa          = cor_wirerc
+ cor_oi          = cor_wirerc
+ cor_sub_pc      = cor_wirerc
+ cor_diff_m1     = cor_wirerc
+ cor_v1	  = cor_wirerc
+ cor_v2	  = cor_wirerc
+ cor_v3	  = cor_wirerc
+ cor_v4	  = cor_wirerc
+ cor_v5	  = cor_wirerc
+ cor_wt	  = cor_wirerc
+ cor_wa	  = cor_wirerc
+ cor_wb	  = cor_wirerc
+ cor_w0	  = cor_wirerc
+ cor_w1	  = cor_wirerc
+ cor_w2	  = cor_wirerc
+ cor_yt	  = cor_wirerc
+ cor_nt	  = cor_wirerc
+ cor_ya	  = cor_wirerc
+ cor_jq	  = cor_wirerc
+ cor_jt	  = cor_wirerc
+ cor_vv	  = cor_wirerc
****************************************
* cor_xfet parameters
.param
+    cor_adnfet = 0
+    cor_adpfet = 0
+    cor_dgnfet = 0
+    cor_dgpfet = 0
+    cor_dgvnfet = 0
+    cor_dgvpfet = 0
+    cor_dgxnfet = 0
+    cor_dgxpfet = 0
+    cor_hvtnfet = 0
+    cor_hvtpfet = 0
+    cor_lvtnfet = 0
+    cor_lvtpfet = 0
+    cor_natdgnfet = 0
+    cor_natnfet = 0
+    cor_nfet = 0
+    cor_pfet = 0
+    cor_srpdanfet = 0
+    cor_srpdbnfet = 0
+    cor_srpdcnfet = 0
+    cor_srpddnfet = 0
+    cor_srpganfet = 0
+    cor_srpgbnfet = 0
+    cor_srpgcnfet = 0
+    cor_srpgdnfet = 0
+    cor_srpuapfet = 0
+    cor_srpubpfet = 0
+    cor_srpucpfet = 0
+    cor_srpudpfet = 0
******************************************************
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/functions.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/shared.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/fixed_corner.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/fet_dist.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/correlation.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/fet_param.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/beol_param.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/beol_dist.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/diode_param.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/esd_param.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/mosvar_param.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/havar_param.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/resistor_param.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/vpnp_param.inc'
.lib '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/lib.models.10lpe' 10lpe_models
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/nfet_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/pfet_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/lvtnfet_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/lvtpfet_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/hvtnfet_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/hvtpfet_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/dgnfet_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/dgpfet_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/dgvnfet_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/dgvpfet_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/dgnfettw.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/dgvnfettw.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/hvtnfettw.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/lvtnfettw.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/nfettw.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/dgnfettw_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/dgvnfettw_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/lvtnfettw_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/nfettw_rf.inc'
**** Passive includes
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/vpnp.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/ngrvpnp.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/vncap.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/mimcap.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/ncap.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/dgncap.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/pcap.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/havar.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/efuse.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/nwres.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/opppcres.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/oprppres.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/opndres.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/sblkndres.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/sblkpdres.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/esdvpnp.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/esdndsx.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/esdvnpn.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/esdscr_dw.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/esdscr_tw.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/esdvpnp_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/esdndsx_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/esdvnpn_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/esdscr_dw_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/esdscr_tw_rf.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/diodenwx.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/diodenx.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/diodepnw.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/diodepwtw.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/diodetwx.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/tdndsx.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/tdpdnw.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/indstack.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/symindp.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/indp.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/inds.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/bondpad.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/pex_res.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/pex_cap.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/pexwirecap.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/subc.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/single_RC.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/singlecpw.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/singlewire.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/coupled_RC.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/coupledcpw.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/coupledwires.inc'
.inc '/usr/nikola/groups/vlsi/data/cmos10lpe/IBM_PDK/cmos10lpe/relRF/HSPICE/models/rfline.inc'
