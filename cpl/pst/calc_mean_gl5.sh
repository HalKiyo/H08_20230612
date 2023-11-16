#!/bin/sh
############################################################
#to   prepare mean value for coupled simulation
#by   2010/01/31, hanasaki, NIES: H08ver1.0
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=9331200
XY="4320 2160"
L2X=../../map/dat/l2x_l2y_/l2x.gl5.txt
L2Y=../../map/dat/l2x_l2y_/l2y.gl5.txt
LONLAT="-180 180 -90 90"
SUF=.gl5
############################################################
# Settings (Edit here)
############################################################
PRJ=W5E5      # project name of agricultral water demand simulation
RUN=N_C_      # project name of agricultral water demand simulation
YEARMIN=2019
YEARMAX=2019
YEAROUT=0000
############################################################
# Input (Do not edit here basically)
############################################################
DIR=../../lnd/out/DemAgr__
############################################################
# Job 
############################################################
htmean $L ${DIR}/${PRJ}${RUN}${SUF}YR $YEARMIN $YEARMAX $YEAROUT
