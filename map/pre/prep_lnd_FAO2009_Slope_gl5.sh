#!/bin/sh
############################################################
#to   prepare global slope data
#by   2015/10/07, hanasaki
#
#     Original Data:
#     FAO Harmonized World Soil Database v1.2
#     Data available at IIASA's web site.
#
############################################################
# settings (Do not edit)
############################################################
CLSS="1 2 3 4 5 6 7 8"
############################################################
# output (Do not edit)
############################################################
DIR=../../map/dat/slp_cls_
############################################################
# geography (Do not edit)
############################################################
LGL5=9331200
XYGL5="4320 2160"
L2XGL5=/home/kajiyama/H08/H08_20230612/map/dat/l2x_l2y_/l2x.gl5.txt
L2YGL5=/home/kajiyama/H08/H08_20230612/map/dat/l2x_l2y_/l2y.gl5.txt
LONLATGL5="-180 180 -90 90"
ARGGL5="$LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5"
#
LHLF=259200
XYHLF="720 360"
L2XHLF=/home/kajiyama/H08/H08_20230612/map/dat/l2x_l2y_/l2x.hlf.txt
L2YHLF=/home/kajiyama/H08/H08_20230612/map/dat/l2x_l2y_/l2y.hlf.txt
LONLATHLF="-180 180 -90 90"
ARGHLF="$LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF"
############################################################
# macro
############################################################
if [ ! -d $DIR ];then mkdir $DIR; fi
TMPASC=temp.txt
TMPHLF=temp.hlf
TMPGL5=temp.gl5
SUMHLF=${DIR}/FAO2009_00000000.sum.hlf
SUMGL5=${DIR}/FAO2009_00000000.sum.gl5
############################################################
# job
############################################################
LOG=temp.log
if [ -f $LOG ]; then
  /bin/rm $LOG
fi
htcreate $LHLF 0 $SUMHLF
htcreate $LGL5 0 $SUMGL5
#
for CLS in $CLSS; do
#
# in
#
  ASC=../../map/org/FAO2009_Slope/GloSlopesCl${CLS}_5min.asc
#
# out
#
  GL5=${DIR}/FAO2009_00000000.Cl${CLS}.gl5
  HLF=${DIR}/FAO2009_00000000.Cl${CLS}.hlf
#
  sed -e '1,6d' $ASC > $TMPASC
#
  htformat $ARGGL5 asciiu binary $TMPASC $GL5
#
  htuscale 6 6 $XYHLF $L2XGL5 $L2YGL5 $L2XHLF $L2YHLF $GL5 $HLF avg
  htmaskrplc $ARGHLF $HLF $HLF eq 1.0E20 0.0 $TMPHLF >> $LOG
  htmath $LHLF add $TMPHLF $SUMHLF $SUMHLF
  # for sum gl5
  htmaskrplc $ARGGL5 $GL5 $GL5 eq 1.0E20 0.0 $TMPGL5 >> $LOG
  htmath $LGL5 add $TMPGL5 $SUMGL5 $SUMGL5
done
echo Log: $LOG
