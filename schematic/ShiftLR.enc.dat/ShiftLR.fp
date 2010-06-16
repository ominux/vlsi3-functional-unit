######################################################
#                                                    #
#  Cadence Design Systems                            #
#  FirstEncounter Floor Plan Information             #
#                                                    #
######################################################
# Created by First Encounter v06.20-s285_1 on Mon Jun  7 14:30:36 2010

Version: 8

Head Box: 0.0000 0.0000 78.0000 72.4000
IO Box: 0.0000 0.0000 78.0000 72.4000
Core Box: 20.0000 20.0000 58.0000 52.4000
UseStdUtil: false

######################################################
#  DesignRoutingHalo: <space> <bottomLayerName> <topLayerName>
######################################################

######################################################
#  Core Rows Parameters:                             #
######################################################
Row Spacing = 0.000000
Row SpacingType = 2
Row Flip = 2
Core Row Site: cp65_dst 

##############################################################################
#  DefRow: <name> <site> <x> <y> <orient> <num_x> <num_y> <step_x> <step_y>  #
##############################################################################
DefRow: ROW_0 cp65_dst 20.0000 20.0000 FS 190 1 0.2000 0.0000
DefRow: ROW_1 cp65_dst 20.0000 21.8000 N 190 1 0.2000 0.0000
DefRow: ROW_2 cp65_dst 20.0000 23.6000 FS 190 1 0.2000 0.0000
DefRow: ROW_3 cp65_dst 20.0000 25.4000 N 190 1 0.2000 0.0000
DefRow: ROW_4 cp65_dst 20.0000 27.2000 FS 190 1 0.2000 0.0000
DefRow: ROW_5 cp65_dst 20.0000 29.0000 N 190 1 0.2000 0.0000
DefRow: ROW_6 cp65_dst 20.0000 30.8000 FS 190 1 0.2000 0.0000
DefRow: ROW_7 cp65_dst 20.0000 32.6000 N 190 1 0.2000 0.0000
DefRow: ROW_8 cp65_dst 20.0000 34.4000 FS 190 1 0.2000 0.0000
DefRow: ROW_9 cp65_dst 20.0000 36.2000 N 190 1 0.2000 0.0000
DefRow: ROW_10 cp65_dst 20.0000 38.0000 FS 190 1 0.2000 0.0000
DefRow: ROW_11 cp65_dst 20.0000 39.8000 N 190 1 0.2000 0.0000
DefRow: ROW_12 cp65_dst 20.0000 41.6000 FS 190 1 0.2000 0.0000
DefRow: ROW_13 cp65_dst 20.0000 43.4000 N 190 1 0.2000 0.0000
DefRow: ROW_14 cp65_dst 20.0000 45.2000 FS 190 1 0.2000 0.0000
DefRow: ROW_15 cp65_dst 20.0000 47.0000 N 190 1 0.2000 0.0000
DefRow: ROW_16 cp65_dst 20.0000 48.8000 FS 190 1 0.2000 0.0000
DefRow: ROW_17 cp65_dst 20.0000 50.6000 N 190 1 0.2000 0.0000

######################################################
#  Track: dir start number space layer_num layer1 ...#
######################################################
Track: X 0.2000 389 0.2000 1 6
Track: Y 0.8000 90 0.8000 1 6
Track: Y 0.2000 361 0.2000 1 5
Track: X 0.2000 389 0.2000 1 5
Track: X 0.2000 389 0.2000 1 4
Track: Y 0.2000 361 0.2000 1 4
Track: Y 0.2000 361 0.2000 1 3
Track: X 0.2000 389 0.2000 1 3
Track: X 0.2000 389 0.2000 1 2
Track: Y 0.2000 361 0.2000 1 2
Track: X 0.2000 389 0.2000 1 1
Track: Y 0.2000 361 0.2000 1 1

######################################################
#  GCellGrid: dir start number space                 #
######################################################
GCellGrid: Y 72.4050 1 3.3050
GCellGrid: Y 6.1000 22 3.0000
GCellGrid: Y -0.0050 2 3.1050
GCellGrid: X 78.0050 1 2.9050
GCellGrid: X 6.1000 24 3.0000
GCellGrid: X -0.0050 2 3.1050

######################################################
#  SpareCell: cellName                               #
#  SpareInst: instName                               #
######################################################

######################################################
#  ScanGroup: groupName startPin stopPin             #
######################################################

######################################################
#  JtagCell:  leafCellName                           #
#  JtagInst:  <instName | HInstName>                 #
######################################################

######################################################################################
#  BlackBox: -cell <cell_name> { -size <x> <y> |  -area <um^2> | \                  #
#            -gatecount <count> <areapergate> <utilization> | \                     #
#            {-gateArea <gateAreaValue> [-macroArea <macroAreaValue>]} } \          #
#            [-minwidth <w> | -minheight <h> | -fixedwidh <w> | -fixedheight <h>] \ #
#            [-aspectratio <ratio>]                                                  #
#            [-boxList <nrConstraintBox>                                             #
#              ConstraintBox: <llx> <lly> <urx> <ury>                                #
#              ... ]                                                                 #
######################################################################################

#########################################################
#  PhysicalNet: <name> [-pwr|-gnd|-tiehi|-tielo]        #
#########################################################
PhysicalNet: VDD -pwr
PhysicalNet: VSS -gnd

#########################################################
#  PhysicalInstance: <name> <cell> <orient> <llx> <lly> #
#########################################################

#####################################################################
#  Group: <group_name> <nrHinst> [-isPhyHier]                       #
#    <inst_name>                                                    #
#    ...                                                            #
#####################################################################

#####################################################################
#  Fence:  <name> <llx> <lly> <urx> <ury> <nrConstraintBox>         #
#    ConstraintBox: <llx> <lly> <urx> <ury>                         #
#    ...                                                            #
#  Region: <name> <llx> <lly> <urx> <ury> <nrConstraintBox>         #
#    ConstraintBox: <llx> <lly> <urx> <ury>                         #
#    ...                                                            #
#  Guide:  <name> <llx> <lly> <urx> <ury> <nrConstraintBox>         #
#    ConstraintBox: <llx> <lly> <urx> <ury>                         #
#    ...                                                            #
#  SoftGuide: <name>                                                #
#    ...                                                            #
#####################################################################

###########################################################################
#  <HierarchicalPartitions>                                               #
#     <NetGroup name="group_name" nets=val spacing=val isOptOrder=val isAltLayer=val > #
#         <Net name="net_name" /> ...                                     #
#     </NetGroup>                                                         #
#     <Partition name="ptn_name"  hinst="name"                            #
#         coreToLeft=fval coreToRight=fval coreToTop=fval coreToBottom=fval   #
#         pinSpacingNorth=val pinSpacingWest=val pinSpacingSouth=val      #
#         pinSpacingEast=val  blockedLayers=xval routingStyle=x|m >       #
#         <TrackHalfPitch Horizontal=val Vertical=val />                  #
#         <SpacingHalo left=10.0 right=11.0 top=11.0 bottom=11.0 />       #
#         <Clone hinst="hinst_name" orient=R0|R90|... />                  #
#         <PinLayer side="N|W|S|E" Metal1=yes Metal2=yes ... />           #
#         <RowSize cellHeight=1.0 railWidth=1.0 />                        #
#         <RoutingHalo sideSize=11.0 bottomLayer=M1 topLayer=M2  />       #
#         <SpacingHalo left=11.0 right=11.0 top=11.0 bottom=11.0 />       #
#     </Partition>                                                        #
#     <CellPinGroup name="group_name" cell="cell_name"                    #
#                       pins=nr spacing=val isOptOrder=1 isAltLayer=1 >   #
#         <GroupFTerm name="term_name" /> ...                             #
#     </CellPinGroup>                                                     #
#     <PartitionPinBlockage layerMap=x llx=1 lly=2 urx=3 ury=4 name="n" />#
#     <PinGuide name="name" boxes=num cell="name" >                       #
#        <Box llx=11.0 lly=22.0 urx=33.0 ury=44.0 layer=id /> ...         #
#     </PinGuide>                                                         #
#     <CellPtnCut name="name" cuts=Num >                                  #
#        <Box llx=11.0 lly=22.0 urx=33.0 ury=44.0 /> ...                  #
#     </CellPtnCut>                                                       #
#  </HierarchicalPartitions>                                              #
###########################################################################
<HierarchicalPartitions>
</HierarchicalPartitions>

######################################################
#  Instance: <name> <orient> <llx> <lly>             #
######################################################

#################################################################
#  Block: <name> <orient> [<llx> <lly>]                         #
#         [<haloLeftMargin>  <haloBottomMargin>                 #
#          <haloRightMargin> <haloTopMargin> <haloFromInstBox>] #
#         [<IsInstDefCovered> <IsInstPreplaced>]                #
#                                                               #
#  Block with INT_MAX loc is for recording the halo block with  #
#  non-prePlaced status                                         #
#################################################################

######################################################
#  BlockLayerObstruct: <name> <layerX> ...           #
######################################################

######################################################
#  FeedthroughBuffer: <instName>                     #
######################################################

#################################################################
#  <PlacementBlockages>                                         #
#     <Blockage name="blk_name" type="hard|soft|partial">       #
#       <Attr density=1.2 inst="inst_name" pushdown=yes />      #
#       <Box llx=1 lly=2 urx=3 ury=4 /> ...                     #
#     </Blockage>                                               #
#  </PlacementBlockages>                                        #
#################################################################

###########################################################################
#  <RouteBlockages>                                                       #
#     <Blockage name="blk_name" type="User|RouteGuide|PtnCut|WideWire">   #
#       <Attr spacing=1.2 drw=1.2 inst="name" pushdown=yes fills=yes />   #
#       <Layer type="route|cut|masterslice" id=layerNo />                 #
#       <Box llx=1 lly=2 urx=3 ury=4 /> ...                               #
#       <Poly points=nr x0=1 y0=1 x1=2 y2=2 ...  />                       #
#     </Blockage>                                                         #
#  </RouteBlockages>                                                      #
###########################################################################

######################################################
#  PrerouteAsObstruct: <layer_treated_as_obstruct>   #
######################################################
PrerouteAsObstruct: 0x3

######################################################
#  NetWeight: <net_name> <weight (in integer)>       #
######################################################

#################################################################
#  SprFile: <file_name>                                         #
#################################################################
SprFile: ShiftLR.fp.spr

#########################################################################################
#  IOPin: <pinName> <x> <y> <side> <layerId> <width> <depth> {placed|fixed|cover|-} <nrBox> \ #
#         [-special] [-clock] [[-spacing <value>] | [-drw <value>]]                     #
#    PinBox: <llx> <lly> <urx> <ury> [-lyr <layerId>] \                                 #
#            [[-spacing <value>] | [-drw <value>]]                                      #
#    PinPoly: <nrPt> <x1> <y1> <x2> <y2> ...<xn> <yn> [-lyr <layerId>] \                #
#             [[-spacing <value>] | [-drw <value>]]                                     #
#    PinAntenna: <pinName> <ANTENNAPIN*> <value> LAYER <layer>                          #
#########################################################################################
IOPin: Z[31] 42.0000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 41.9500 72.3000 42.0500 72.4000 -lyr 3
IOPin: Z[30] 25.0000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 24.9500 72.3000 25.0500 72.4000 -lyr 3
IOPin: Z[29] 23.8000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 23.7500 72.3000 23.8500 72.4000 -lyr 3
IOPin: Z[28] 32.2000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 32.1500 72.3000 32.2500 72.4000 -lyr 3
IOPin: Z[27] 44.0000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 43.9500 72.3000 44.0500 72.4000 -lyr 3
IOPin: Z[26] 0.0000 51.2000 W 2 0.1000 0.1000 placed 1
  PinBox: 0.0000 51.1500 0.1000 51.2500 -lyr 2
IOPin: Z[25] 0.0000 42.8000 W 2 0.1000 0.1000 placed 1
  PinBox: 0.0000 42.7500 0.1000 42.8500 -lyr 2
IOPin: Z[24] 30.2000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 30.1500 0.0000 30.2500 0.1000 -lyr 3
IOPin: Z[23] 46.4000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 46.3500 0.0000 46.4500 0.1000 -lyr 3
IOPin: Z[22] 0.0000 22.4000 W 2 0.1000 0.1000 placed 1
  PinBox: 0.0000 22.3500 0.1000 22.4500 -lyr 2
IOPin: Z[21] 0.0000 22.4000 W 4 0.1000 0.1000 placed 1
  PinBox: 0.0000 22.3500 0.1000 22.4500 -lyr 4
IOPin: Z[20] 42.0000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 41.9500 0.0000 42.0500 0.1000 -lyr 3
IOPin: Z[19] 49.0000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 48.9500 0.0000 49.0500 0.1000 -lyr 3
IOPin: Z[18] 40.0000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 39.9500 0.0000 40.0500 0.1000 -lyr 3
IOPin: Z[17] 37.4000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 37.3500 0.0000 37.4500 0.1000 -lyr 3
IOPin: Z[16] 44.4000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 44.3500 0.0000 44.4500 0.1000 -lyr 3
IOPin: Z[15] 51.4000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 51.3500 0.0000 51.4500 0.1000 -lyr 3
IOPin: Z[14] 27.0000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 26.9500 0.0000 27.0500 0.1000 -lyr 3
IOPin: Z[13] 26.2000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 26.1500 0.0000 26.2500 0.1000 -lyr 3
IOPin: Z[12] 37.8000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 37.7500 0.0000 37.8500 0.1000 -lyr 3
IOPin: Z[11] 49.8000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 49.7500 0.0000 49.8500 0.1000 -lyr 3
IOPin: Z[10] 30.6000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 30.5500 0.0000 30.6500 0.1000 -lyr 3
IOPin: Z[9] 27.6000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 27.5500 0.0000 27.6500 0.1000 -lyr 3
IOPin: Z[8] 34.4000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 34.3500 0.0000 34.4500 0.1000 -lyr 3
IOPin: Z[7] 46.2000 0.0000 S 5 0.1000 0.1000 placed 1
  PinBox: 46.1500 0.0000 46.2500 0.1000 -lyr 5
IOPin: Z[6] 32.2000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 32.1500 0.0000 32.2500 0.1000 -lyr 3
IOPin: Z[5] 34.0000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 33.9500 0.0000 34.0500 0.1000 -lyr 3
IOPin: Z[4] 39.4000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 39.3500 0.0000 39.4500 0.1000 -lyr 3
IOPin: Z[3] 47.0000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 46.9500 72.3000 47.0500 72.4000 -lyr 3
IOPin: Z[2] 39.4000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 39.3500 72.3000 39.4500 72.4000 -lyr 3
IOPin: Z[1] 41.2000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 41.1500 72.3000 41.2500 72.4000 -lyr 3
IOPin: Z[0] 42.0000 72.4000 N 5 0.1000 0.1000 placed 1
  PinBox: 41.9500 72.3000 42.0500 72.4000 -lyr 5
IOPin: X[31] 78.0000 40.0000 E 2 0.1000 0.1000 placed 1
  PinBox: 77.9000 39.9500 78.0000 40.0500 -lyr 2
IOPin: X[30] 0.0000 40.6000 W 2 0.1000 0.1000 placed 1
  PinBox: 0.0000 40.5500 0.1000 40.6500 -lyr 2
IOPin: X[29] 0.0000 47.0000 W 2 0.1000 0.1000 placed 1
  PinBox: 0.0000 46.9500 0.1000 47.0500 -lyr 2
IOPin: X[28] 36.4000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 36.3500 72.3000 36.4500 72.4000 -lyr 3
IOPin: X[27] 78.0000 37.6000 E 2 0.1000 0.1000 placed 1
  PinBox: 77.9000 37.5500 78.0000 37.6500 -lyr 2
IOPin: X[26] 0.0000 41.6000 W 2 0.1000 0.1000 placed 1
  PinBox: 0.0000 41.5500 0.1000 41.6500 -lyr 2
IOPin: X[25] 0.0000 35.8000 W 2 0.1000 0.1000 placed 1
  PinBox: 0.0000 35.7500 0.1000 35.8500 -lyr 2
IOPin: X[24] 34.2000 0.0000 S 5 0.1000 0.1000 placed 1
  PinBox: 34.1500 0.0000 34.2500 0.1000 -lyr 5
IOPin: X[23] 78.0000 30.0000 E 2 0.1000 0.1000 placed 1
  PinBox: 77.9000 29.9500 78.0000 30.0500 -lyr 2
IOPin: X[22] 0.0000 22.8000 W 2 0.1000 0.1000 placed 1
  PinBox: 0.0000 22.7500 0.1000 22.8500 -lyr 2
IOPin: X[21] 0.0000 33.4000 W 2 0.1000 0.1000 placed 1
  PinBox: 0.0000 33.3500 0.1000 33.4500 -lyr 2
IOPin: X[20] 45.8000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 45.7500 0.0000 45.8500 0.1000 -lyr 3
IOPin: X[19] 78.0000 33.6000 E 2 0.1000 0.1000 placed 1
  PinBox: 77.9000 33.5500 78.0000 33.6500 -lyr 2
IOPin: X[18] 37.8000 0.0000 S 5 0.1000 0.1000 placed 1
  PinBox: 37.7500 0.0000 37.8500 0.1000 -lyr 5
IOPin: X[17] 38.2000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 38.1500 0.0000 38.2500 0.1000 -lyr 3
IOPin: X[16] 78.0000 37.0000 E 2 0.1000 0.1000 placed 1
  PinBox: 77.9000 36.9500 78.0000 37.0500 -lyr 2
IOPin: X[15] 78.0000 39.0000 E 2 0.1000 0.1000 placed 1
  PinBox: 77.9000 38.9500 78.0000 39.0500 -lyr 2
IOPin: X[14] 0.0000 41.0000 W 2 0.1000 0.1000 placed 1
  PinBox: 0.0000 40.9500 0.1000 41.0500 -lyr 2
IOPin: X[13] 0.0000 42.6000 W 4 0.1000 0.1000 placed 1
  PinBox: 0.0000 42.5500 0.1000 42.6500 -lyr 4
IOPin: X[12] 37.6000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 37.5500 72.3000 37.6500 72.4000 -lyr 3
IOPin: X[11] 78.0000 32.6000 E 2 0.1000 0.1000 placed 1
  PinBox: 77.9000 32.5500 78.0000 32.6500 -lyr 2
IOPin: X[10] 0.0000 40.2000 W 2 0.1000 0.1000 placed 1
  PinBox: 0.0000 40.1500 0.1000 40.2500 -lyr 2
IOPin: X[9] 0.0000 31.6000 W 2 0.1000 0.1000 placed 1
  PinBox: 0.0000 31.5500 0.1000 31.6500 -lyr 2
IOPin: X[8] 37.4000 0.0000 S 5 0.1000 0.1000 placed 1
  PinBox: 37.3500 0.0000 37.4500 0.1000 -lyr 5
IOPin: X[7] 78.0000 30.0000 E 4 0.1000 0.1000 placed 1
  PinBox: 77.9000 29.9500 78.0000 30.0500 -lyr 4
IOPin: X[6] 0.0000 29.2000 W 2 0.1000 0.1000 placed 1
  PinBox: 0.0000 29.1500 0.1000 29.2500 -lyr 2
IOPin: X[5] 0.0000 34.4000 W 2 0.1000 0.1000 placed 1
  PinBox: 0.0000 34.3500 0.1000 34.4500 -lyr 2
IOPin: X[4] 45.0000 0.0000 S 3 0.1000 0.1000 placed 1
  PinBox: 44.9500 0.0000 45.0500 0.1000 -lyr 3
IOPin: X[3] 78.0000 39.4000 E 2 0.1000 0.1000 placed 1
  PinBox: 77.9000 39.3500 78.0000 39.4500 -lyr 2
IOPin: X[2] 36.8000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 36.7500 72.3000 36.8500 72.4000 -lyr 3
IOPin: X[1] 38.8000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 38.7500 72.3000 38.8500 72.4000 -lyr 3
IOPin: X[0] 44.4000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 44.3500 72.3000 44.4500 72.4000 -lyr 3
IOPin: S[4] 48.6000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 48.5500 72.3000 48.6500 72.4000 -lyr 3
IOPin: S[3] 78.0000 46.0000 E 2 0.1000 0.1000 placed 1
  PinBox: 77.9000 45.9500 78.0000 46.0500 -lyr 2
IOPin: S[2] 53.8000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 53.7500 72.3000 53.8500 72.4000 -lyr 3
IOPin: S[1] 51.4000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 51.3500 72.3000 51.4500 72.4000 -lyr 3
IOPin: S[0] 50.4000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 50.3500 72.3000 50.4500 72.4000 -lyr 3
IOPin: LEFT 55.4000 72.4000 N 3 0.1000 0.1000 placed 1
  PinBox: 55.3500 72.3000 55.4500 72.4000 -lyr 3
IOPin: LOG 78.0000 42.6000 E 2 0.1000 0.1000 placed 1
  PinBox: 77.9000 42.5500 78.0000 42.6500 -lyr 2

#####################################################################
#  <Property>                                                       #
#     <obj_type name="inst_name" >                                  #
#       <prop name="name" type=type_name value=val />               #
#       <Attr name="name" type=type_name value=val />               #
#     </obj_type>                                                   #
#  </Property>                                                      #
#  where:                                                           #
#       type is data type: Box, String, Int, PTR, Loc, ouble, Bits  #
#       obj_type are: inst, Design, instTerm, Bump                  #
#####################################################################
<Properties>
  <Design name="ShiftLR">
  </Design>
</Properties>

###########################################################$############################################################################################
#  GlobalNetConnection: <net_name> {-pin|-inst|-net} <base_name_pattern> -type {pgpin|net|tiehi|tielo} {-all|-module <name>|-region <box>} [-override] #
########################################################################################################################################################
GlobalNetConnection: VDD -pin VDD -inst * -type pgpin -module {}
GlobalNetConnection: VSS -pin VSS -inst * -type pgpin -module {}

################################################################################
#  NetProperties: <net_name> [-special] [-def_prop {int|dbl|str} <value>]...   #
################################################################################
