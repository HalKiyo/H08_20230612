#!/bin/sh

############################################################
# Setting
##################################j##########################
# Tair is calculated by downscaling_Tair.py
#VARS="LWdown__ SWdown__ Prcp____ Snowf___ PSurf___ Qair____ Wind____ Tair____ Rainf___"
VARS="Snowf___"
############################################################
# Original data
############################################################
PRJRUNMET=W5E5____
#YEARS="2000 2001 2002 2003 2004 2005"
YEARS="2001"
#MONS="01 02 03 04 05 06 07 08 09 10 11 12"
MONS="06"
#DAYS="01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31"
DAYS="13"
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
#LNDMSKGLB=../../map/dat/lnd_msk_/lndmsk.WFDEI.hlf
#LNDMSKGLB=../../map/dat/lnd_msk_/lndmsk.WFDEI.gl5
#LNDMSKRGN=../../map/dat/lnd_msk_/lndmsk.CAMA.gl5
############################################################
# Job
############################################################
for VAR in $VARS; do
    DIR="/home/kajiyama/H08/H08_20230612/met/dat/${VAR}/"   # original data
    for YEAR in $YEARS; do
        for MON in $MONS; do
            for DAY in $DAYS; do
                DAY=`echo $DAY | awk '{printf("%2.2d",$1)}'`
                echo $DIR $YEAR $MON $DAY
#
                BINGLB=${DIR}${PRJRUNMET}${YEAR}${MON}${DAY}${SUFGLB}
                #htmaskrplc $ARGGLB $BINGLB $LNDMSKGLB eq 0 1.0E20 $BINGLB
############################################################
# save temp1, temp2, temp3 with identical name
# so that parallel excecution will be possible
# recommende to remove them after all calculation for storage 
############################################################
                ID=${YEAR}${MON}${DAY}
                htlinear $ARGGLB $ARGRGN $BINGLB ${DIR}${ID}temp${SUFRGN}
                htformat $ARGRGN binary ascii3 ${DIR}${ID}temp${SUFRGN} ${DIR}${ID}temp.xyz
                sed -e 's/1.0000000E+20/NaN/g' ${DIR}${ID}temp.xyz > ${DIR}${ID}temp2.xyz 
                gmt surface ${DIR}${ID}temp2.xyz -R$RFLAG -I$IFLAG -G${DIR}${ID}temp.grd -T0 -Ll0
#
                XYZ=${DIR}${ID}temp3.xyz  
                BIN=${DIR}W5E5____${YEAR}${MON}${DAY}${SUFRGN}    ###Experiment
                gmt grd2xyz ${DIR}${ID}temp.grd > $XYZ
                htformat   $ARGRGN ascii3 binary $XYZ $BIN
#
            done
        done
        IN=${DIR}${PRJRUNMET}${SUFRGN}
        httime $LRGN ${IN}DY ${YEAR} ${YEAR} ${IN}MO
        httime $LRGN ${IN}DY ${YEAR} ${YEAR} ${IN}YR
    done
done
