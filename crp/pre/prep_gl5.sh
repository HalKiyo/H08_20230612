#!/bin/sh
############################################################
#to   prepare state varaiables and default parameters
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=9331200
XY="4320 2160"
L2X=../../map/dat/l2x_l2y_/l2x.gl5.txt
L2Y=../../map/dat/l2x_l2y_/l2x.gl5.txt
LONLAT="-180 180 -90 90"
SUF=.gl5
############################################################
# Basic settings (Edit here if you wish)
############################################################
PRJSIM=W5E5             # Project name of simulation
RUNSIM=LR__             # Run     name of simulation
PRJMET=W5E5             # Project name of meteorological input
RUNMET=____             # Run     name of meteorological input
YEARMIN=2019
YEARMAX=2019
YEAROUT=0000
############################################################
# Input (Do not change here basically)
############################################################
VARMETS="../../met/dat/SWdown__/${PRJMET}${RUNMET}${SUF} ../../met/dat/Tair____/${PRJMET}${RUNMET}${SUF}"
VARLNDS="../../lnd/out/PotEvap_/${PRJSIM}${RUNSIM}${SUF} ../../lnd/out/Evap____/${PRJSIM}${RUNSIM}${SUF}"
############################################################
# Job (Prepare directory)
############################################################
if [ ! -d ../../crp/ini ]; then  mkdir ../../crp/ini; fi
############################################################
# Job (Generate initial value)
############################################################
htcreate $L 0 ../../crp/ini/uniform.0.0${SUF}
############################################################
# Job (Generate temporal mean of meteorological input data)
############################################################
for VARMET in $VARMETS; do
  htmean $L ${VARMET}DY ${YEARMIN} ${YEARMAX} ${YEAROUT}
  htmean $L ${VARMET}MO ${YEARMIN} ${YEARMAX} ${YEAROUT}
done
############################################################
# Job (Generate temporal mean of land surface output data)
############################################################n
for VARLND in $VARLNDS; do
  htmean $L ${VARLND}DY ${YEARMIN} ${YEARMAX} ${YEAROUT}
  htmean $L ${VARLND}MO ${YEARMIN} ${YEARMAX} ${YEAROUT}
  httime $L ${VARLND}MO 0000 0000 ${VARLND}YR
done
