#!/bin/sh

############################################################
# Settings
############################################################
YEARMIN=1979
YEARMAX=2019
VARS="LWdown__ SWdown__ Prcp____ PSurf____ Qair____ Wind____"
############################################################
# Original data
############################################################
PRJRUNMET=W5E5____
MONS="01 02 03 04 05 06 07 08 09 10 11 12"
############################################################
# gmt parameter
############################################################
#RFLAG=124.04166/130.95833/33.041664/43.958332  # for Thailand
#IFLAG=0.08333/0.08333                          # for Thailand
RFLAG=-179.95834/179.95834/-89.95834/89.95834   # for Globe
IFLAG=0.08333/0.08333                           # for Globe
############################################################
# macro
############################################################
ARGGLB=$ARGHLF
ARGRGN=$ARGGL5
LGLB=$LHLF
LRGN=$LGL5
SUFGLB=.hlf
SUFRGN=.gl5
############################################################
# input file
############################################################
#LNDMSKGLB=/workm/Doi/H08_20190701/map/dat/lnd_msk_/lndmsk.WFDEI.hlf
#LNDMSKRGN=../../map/dat/lnd_msk_/lndmsk.CAMA.gl5
############################################################
# Job
############################################################
for VAR in $VARS; do
    DIR="/home/kajiyama/H08/H08_20230612/met/dat/${VAR}/"   # original data
    YEAR=$YEARMIN
    while [ $YEAR -le $YEARMAX ]; do
        for MON in $MONS; do
            DAY=1
            DAYMAX=`htcal $YEAR $MON`
            while [ $DAY -le $DAYMAX ]; do
                DAY=`echo $DAY | awk '{printf("%2.2d",$1)}'`
                echo $DIR $YEAR $MON $DAY
#
                BINGLB=${DIR}${PRJRUNMET}${YEAR}${MON}${DAY}${SUFGLB}
#               htmaskrplc $ARGGLB $BINGLB $LNDMSKGLB eq 0 1.0E20 $BINGLB
                htlinear $ARGGLB $ARGRGN $BINGLB ${DIR}temp${SUFRGN}
                htformat $ARGRGN binary ascii3 ${DIR}temp${SUFRGN} ${DIR}temp.xyz
                sed -e 's/1.0000000E+20/NaN/g' ${DIR}temp.xyz > ${DIR}temp2.xyz 
                gmt surface ${DIR}temp2.xyz -R$RFLAG -I$IFLAG -G${DIR}grd -T0 -Ll0
#
                XYZ=${DIR}temp3.xyz  
                BIN=${DIR}W5E5____${YEAR}${MON}${DAY}${SUFRGN}    ###Experiment
                gmt grd2xyz ${DIR}grd > $XYZ
                htformat   $ARGRGN ascii3 binary $XYZ $BIN
#
                DAY=`expr $DAY + 1`
            done
        done
        IN=${DIR}${PRJRUNMET}${SUFRGN}
        httime $LRGN ${IN}DY ${YEAR} ${YEAR} ${IN}MO
        httime $LRGN ${IN}DY ${YEAR} ${YEAR} ${IN}YR
        YEAR=`expr $YEAR + 01`
    done
done
