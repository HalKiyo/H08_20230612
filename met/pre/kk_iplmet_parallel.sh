#!/bin/bash

function iplmet() {
    ############################################################
    # Original data
    ############################################################
    PRJRUNMET=W5E5____
    MONS="01 02 03 04 05 06 07 08 09 10 11 12"
    ############################################################
    # gmt parameter
    ############################################################
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
    # Job
    ############################################################
    DIR="/home/kajiyama/H08/H08_20230612/met/dat/$1/"   # original data
    for MON in $MONS; do
        DAY=1
        DAYMAX=`htcal $2 $MON`
        while [ $DAY -le $DAYMAX ]; do
            DAY=`echo $DAY | awk '{printf("%2.2d",$1)}'`
            echo $DIR $2 $MON $DAY
#
            BINGLB=${DIR}${PRJRUNMET}${2}${MON}${DAY}${SUFGLB}
            #htmaskrplc $ARGGLB $BINGLB $LNDMSKGLB eq 0 1.0E20 $BINGLB
    ############################################################
    # save temp1, temp2, temp3 with identical name
    # so that parallel excecution will be possible
    # recommende to remove them after all calculation for storage 
    ############################################################
            ID=${2}${MON}${DAY}
            htlinear $ARGGLB $ARGRGN $BINGLB ${DIR}${ID}temp${SUFRGN}
            htformat $ARGRGN binary ascii3 ${DIR}${ID}temp${SUFRGN} ${DIR}${ID}temp.xyz
            sed -e 's/1.0000000E+20/NaN/g' ${DIR}${ID}temp.xyz > ${DIR}${ID}temp2.xyz 
            gmt surface ${DIR}${ID}temp2.xyz -R$RFLAG -I$IFLAG -G${DIR}${ID}temp.grd -T0 -Ll0
#
            XYZ=${DIR}${ID}temp3.xyz  
            BIN=${DIR}W5E5____${2}${MON}${DAY}${SUFRGN}    ###Experiment
            gmt grd2xyz ${DIR}${ID}temp.grd > $XYZ
            htformat   $ARGRGN ascii3 binary $XYZ $BIN
#
            DAY=`expr $DAY + 1`
        done
    done
    IN=${DIR}${PRJRUNMET}${SUFRGN}
    httime $LRGN ${IN}DY ${2} ${2} ${IN}MO
    httime $LRGN ${IN}DY ${2} ${2} ${IN}YR
}

YEARS="2001"
for YEAR in $YEARS; do
    iplmet LWdown__ $YEAR &
    iplmet SWdown__ $YEAR &
    iplmet Prcp____ $YEAR &
    iplmet Snowf___ $YEAR &
    iplmet PSurf___ $YEAR &
    iplmet Qair____ $YEAR &
    iplmet Wind____ $YEAR &
    iplmet Tair____ $YEAR &
    iplmet Rainf___ $YEAR &
    wait
done
