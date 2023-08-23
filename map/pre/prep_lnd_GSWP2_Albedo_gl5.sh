#!/bin/sh
############################################################
#to   prepare Albedo for WFD
#by   2011/12/25, hanasaki
############################################################
# Preparation
############################################################
#
# 1) Albedo was not included in the standard data sef of 
# WATCH Foring Data (WFD; 0.5deg x 0.5deg). Therefore, Albedo of
# GSWP2 (1deg x 1deg) is interpolated for temporal use.
# 
# 2) Prepare 10 year mean monthly GSWP2 Albedo data.
#
############################################################
# Settings (Do not change below)
############################################################
PRJ=GSW2
RUN=____
YEARMIN=0000
YEARMAX=0000
MONS="01 02 03 04 05 06 07 08 09 10 11 12"
DAY=00
L2XONE=../../map/dat/l2x_l2y_/l2x.one.txt
L2YONE=../../map/dat/l2x_l2y_/l2y.one.txt
L2XHLF=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2YHLF=../../map/dat/l2x_l2y_/l2y.hlf.txt
L2XGL5=../../map/dat/l2x_l2y_/l2x.gl5.txt
L2YGL5=../../map/dat/l2x_l2y_/l2y.gl5.txt
############################################################
# Preparation
############################################################
if [ !  -d ../../map/dat/Albedo__ ]; then
  mkdir -p ../../map/dat/Albedo__
fi
#
YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
  for MON in $MONS; do
    #ASC=../../map/org/GSWP2/${PRJ}${RUN}${YEAR}${MON}00.one.txt
    ASC=../../map/org/GSWP2_Albedo/${PRJ}${RUN}${YEAR}${MON}00.one.txt #edited @Menaka
    ONE=../../map/dat/Albedo__/${PRJ}${RUN}${YEAR}${MON}00.one
    HLF=../../map/dat/Albedo__/${PRJ}${RUN}${YEAR}${MON}00.hlf
    GL5=../../map/dat/Albedo__/${PRJ}${RUN}${YEAR}${MON}00.gl5 # for 5min
    htformat $ARGONE asciiu binary $ASC $ONE
    prog_one2hlf $L2XONE $L2YONE $L2XHLF $L2YHLF $ONE $HLF
    prog_hlf2gl5 $L2XHLF $L2YHLF $L2XGL5 $L2YGL5 $HLF $GL5
  done
  YEAR=`expr $YEAR + 1`
done


