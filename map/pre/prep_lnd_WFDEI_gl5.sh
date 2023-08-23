#!/bin/sh
############################################################
#to   prepare WATCH geographical data
#by   2010/03/31, hanasaki, NIES
############################################################
# Geography (Do not edit here: 0.5 deg global only)
############################################################
L=259200
XY="720 360"
SUF=.gl5
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
L2XGL5=../../map/dat/l2x_l2y_/l2x.gl5.txt
L2YGL5=../../map/dat/l2x_l2y_/l2y.gl5.txt
LONLAT="-180 180 -90 90"

############################################################
# Input (Do not edit here unless you are an expert)
############################################################
LNDMSKTXT=../../map/org/WFDEI/lndmsk.WFDEI.hlf.txt
LNDARATXT=../../map/org/WFDEI/lndara.WFDEI.hlf.txt
NATMSKTXT=../../map/org/WFDEI/C05_____20000000.WFDEI.hlf.txt
#####@menaka
GRDARAGL5=../../map/dat/grd_ara_/grdara.gl5
############################################################
# Output (Do not edit here unless you are an expert)
############################################################
DIRLNDMSK=../../map/dat/lnd_msk_
DIRLNDARA=../../map/dat/lnd_ara_
DIRNATMSK=../../map/dat/nat_msk_
#
LNDMSK=${DIRLNDMSK}/lndmsk.WFDEI.hlf
LNDARA=${DIRLNDARA}/lndara.WFDEI.hlf
NATMSK=${DIRNATMSK}/C05_____20000000.WFDEI.hlf
#
LNDMSKGL5=${DIRLNDMSK}/lndmsk.WFDEI.gl5
LNDARAGL5=${DIRLNDARA}/lndara.WFDEI.gl5
NATMSKGL5=${DIRNATMSK}/C05_____20000000.WFDEI.gl5
############################################################
# Job (prepare directory)
############################################################
if [ !  -d ${DIRLNDMSK} ]; then  mkdir -p ${DIRLNDMSK}; fi
if [ !  -d ${DIRLNDARA} ]; then  mkdir -p ${DIRLNDARA}; fi
if [ !  -d ${DIRNATMSK} ]; then  mkdir -p ${DIRNATMSK}; fi
############################################################
# Job (create files)
############################################################
#htformat $L $XY $L2X $L2Y $LONLAT asciiu binary ${LNDMSKTXT} $LNDMSK
#htformat $L $XY $L2X $L2Y $LONLAT asciiu binary ${LNDARATXT} $LNDARA
#htformat $L $XY $L2X $L2Y $LONLAT asciiu binary ${NATMSKTXT} $NATMSK
############################################################ # edited @menaka
prog_hlf2gl5 $L2X $L2Y $L2XGL5 $L2YGL5 $LNDMSK $LNDMSKGL5
#htmask $ARGGL5 $GRDARAGL5 $LNDMSKGL5 eq 1 $LNDARAGL5 
prog_hlf2gl5 $L2X $L2Y $L2XGL5 $L2YGL5 $LNDARA $LNDARAGL5
prog_hlf2gl5 $L2X $L2Y $L2XGL5 $L2YGL5 $NATMSK $NATMSKGL5
