#!/bin/sh
############################################################
#to   prepare domain
#by   2010/03/31, hanasaki, NIES
############################################################
# Geographical setting (Edit here if you change spatial domain/resolution)
############################################################
#L=259200
#XY="720 360"
#LONLAT="-180 180 -90 90"
#SUF=.hlf

#1deg x 1deg of globe (.one)
#L=64800
#XY="360 180"
#LONLAT="-180 180 -90 90"
#SUF=.one

#5min x 5min of globe (.gl5)
#L=9331200
#XY="4320 2160"
#LONLAT="-180 180 -90 90"
#SUF=.gl5

#1min x 1min of globe (.gl1)
#L=233280000
#XY="21600 10800"
#LONLAT="-180 180 -90 90"
#SUF=.gl1

#5minx5min of tokyo (.tk5)
#L=1728
#XY="36 48"
#LONLAT="138 141 34 38"
#SUF=.tk5

#5minx5min of london (.ln5)
#L=1728
#XY="48 36"
#LONLAT="-3 1 50 53"
#SUF=.ln5

#5minx5min of paris (.pr5)
#L=5184
#XY="72 72"
#LONLAT="0 6 46 52"
#SUF=.pr5

#5minx5min of paris (.ls5)
#L=2304
#XY="48 48"
#LONLAT="-120 -116 32 36"
#SUF=.ls5

#5minx5min of paris (.ls5)
#L=1728
#XY="36 48"
#LONLAT="78 81 11 15"
#SUF=.ch5

#5minx5min of paris (.ls5)
L=1296
XY="36 36"
LONLAT="17 20 -35 -32"
SUF=.ct5

############################################################
# Output (Do not edit here unless you are an expert)
############################################################
DIRGRDARA=../dat/grd_ara_
DIRL2XL2Y=../dat/l2x_l2y_
#
GRDARA=$DIRGRDARA/grdara${SUF}
L2X=${DIRL2XL2Y}/l2x${SUF}.txt
L2Y=${DIRL2XL2Y}/l2y${SUF}.txt
############################################################
# Job (prepare output directory)
############################################################
if [ !  -d ${DIRL2XL2Y} ]; then   mkdir -p ${DIRL2XL2Y}; fi
if [ !  -d ${DIRGRDARA} ]; then   mkdir -p ${DIRGRDARA}; fi
############################################################
# Job (make files)
############################################################
htl2xl2y $L $XY $L2X $L2Y
prog_grdara $L $XY $L2X $L2Y $LONLAT $GRDARA
