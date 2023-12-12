L="9331200"
XY="4320 2160" 
L2X="../../map/dat/l2x_l2y_/l2x.gl5.txt"
L2Y="../../map/dat/l2x_l2y_/l2y.gl5.txt"
LONLAT="-180 180 -90 90"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.gl5
MAP=.CAMA
############################################################
# Input (Do not change here basically)
############################################################
    DIRAGR=../../lnd/out/SupAgr__
    DIRIND=../../lnd/out/SupInd__
    DIRDOM=../../lnd/out/SupDom__
    DIRENV=../../riv/out/env_out_

#-------------------------------------------
PRJSIM=W5E5     # Project name for simulation results
RUNSIM=LECD    # Run     name for simulation results
PRJMET=W5E5     # Project name for met. data
RUNMET=____     # Run     name for met. data
PRCP=W5E5____
TEMP=W5E5____
YEARMIN=2019
YEARMAX=2019

#---------------------------------------------------------
#VARS="Rainf Snowf Evap Qtot SoilMoist SWE GW"           #####----need check------
#VARS="Rainf Snowf"
#VARS="GW"
VARS="AGR IND DOM"
#VARS="ENV"
YEARS="2019"
MONS="01 02 03 04 05 06 07 08 09 10 11 12"
#MONS="00"


for ID in `seq 1 100`; do
#for ID in `seq 101 200`; do
#for ID in `seq 201 300`; do
#for ID in `seq 301 400`; do
#for ID in `seq 401 500`; do
#for ID in `seq 501 600`; do
#for ID in `seq 601 700`; do
#for ID in `seq 701 800`; do
#for ID in `seq 901 902`; do


    ID8=`echo $ID | awk '{printf("%8.8d",$1)}'`
#  LON=`awk '($1=="'$ID'"){print $7}' $STNLST`       # need check
#  LAT=`awk '($1=="'$ID'"){print $8}' $STNLST`       # need check
#  NAME=`awk '($1=="'$ID'"){print $2}' $STNLST`      # need check

    for VAR in $VARS; do
#  echo $ID $VAR

        if [ $VAR = AGR ]; then
            DIR=$DIRAGR
            PRJ=$PRJSIM$RUNSIM
            MET=../../lnd/out/sum_citymask/${PRJSIM}${VAR}_AGR_${ID}.txt
        elif [ $VAR = IND ]; then
            DIR=$DIRIND
            PRJ=$PRJSIM$RUNSIM
            MET=../../lnd/out/sum_citymask/${PRJSIM}${VAR}_IND_${ID}.txt
        elif [ $VAR = DOM ]; then
            DIR=$DIRDOM
            PRJ=$PRJSIM$RUNSIM
            MET=../../lnd/out/sum_citymask/${PRJSIM}${VAR}_DOM_${ID}.txt
        elif [ $VAR = ENV ]; then
            DIR=$DIRENV
            PRJSIM=W5E5
            RUNSIM=LR__
            PRJ=$PRJSIM$RUNSIM
            MET=./sum_citymask/${PRJSIM}${VAR}_ENV_${ID}.txt
        else
            $VAR not found abort.
            exit
        fi

        if [ -f $MET ]; then 
            rm $MET
        fi

        YEAR=$YEARMIN

        for YEAR in $YEARS; do
            for MON in $MONS; do
                DAYNUM=`htcal $YEAR $MON`
#    htmaskrplc $ARG ${DIR}/${PRJ}${YEAR}${MON}00.gl5 /home/kajiyama/H08/H08_20230612/map/dat/lnd_msk_/lndmsk.CAMA.gl5 ne 1 0.0 ${DIR}/${PRJ}${YEAR}${MON}_${ID}.gl5
                htmaskrplc $ARG ${DIR}/${PRJ}${YEAR}${MON}00.gl5 /home/kajiyama/H08/H08_20230612/map/dat/cty_msk_/city_${ID8}.gl5 ne 1 0.0 ${DIR}/${PRJ}${YEAR}${MON}_cty_${ID8}.gl5

#    htmath 9331200 mul ${DIR}/${PRJ}${YEAR}${MON}_${ID}.gl5 ../../map/dat/lnd_ara_/lndara.WFDEI1.gl5 ${DIR}/${PRJ}${YEAR}${MON}_${ID}.gl5 

                SUM=`htstat $ARG sum ${DIR}/${PRJ}${YEAR}${MON}_cty_${ID8}.gl5`

#    SUMA=`echo $SUM | awk '{aa=(86400*$DAYNUM); print $1*aa}'`
                SUMB=`echo $SUM | awk '{print $1}'`

#   echo "A" $SUMA
#    echo "B" $SUMB
                echo $SUMB >> $MET
                rm --interactive=never ${DIR}/${PRJ}${YEAR}${MON}_cty_${ID8}.gl5
            done
        done

#  YEAR=`expr $YEAR + 1`

    done
done
