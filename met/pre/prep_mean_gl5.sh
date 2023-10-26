#!/bin/sh
######################################################
#to   prepare mean 
#by   2012/06/05, hanasaki
######################################################
# Geography (Edit here)
######################################################
L=9331200
SUF=.gl5
######################################################
# Settings (Edit here)
######################################################
PRJ=W5E5
RUN=____
IDXORG=DY
YEARMIN=2019; YEARMAX=2019; YEAROUT=0000
######################################################
# Macro (Do not edit below unless you are an expert)
######################################################
DIR=/home/kajiyama/H08/H08_20230612/met/dat
#SUBDIRS="Tair____ Qair____ PSurf___ Wind____ SWdown__ LWdown__ Snowf___ Prcp____ Rainf___"
SUBDIRS="Tair____"
######################################################
# Job
######################################################
for SUBDIR in $SUBDIRS; do
  echo $SUBDIR
  IN=${DIR}/${SUBDIR}/${PRJ}${RUN}${SUF}
  httime $L ${IN}${IDXORG} $YEARMIN $YEARMAX ${IN}MO
#  httime $L ${IN}${IDXORG} $YEARMIN $YEARMAX ${IN}YR
  htmean $L ${IN}MO        $YEARMIN $YEARMAX $YEAROUT
  htmean $L ${IN}YR        $YEARMIN $YEARMAX $YEAROUT
done


