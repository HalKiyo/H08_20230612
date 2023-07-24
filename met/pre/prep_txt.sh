############################################################
# Settings (Change here )
############################################################
#YEARMIN=2014
#YEARMAX=2099
YEARMIN=2010
YEARMAX=2019

############################################################
# Settings (Do not change here basically)
############################################################
PRJ=W5E5
RUN=____
#VARS="Tair_b1beta Qair_b1beta Rainf_b1beta Snowf_b1beta SWdown_b1beta LWdown_b1beta PSurf_b1beta Wind_era"
#GCMS="MIROC-ESM-CHEM NorESM1-M GFDL-ESM2M IPSL-CM5A-LR"
#VARS="dlwrfsfc dswrfsfc precsfc pressfc spfh2m tave2m wind10m"
#VARS="tas huss pr prsn ps rlds rsds sfcWind"
#VARS="tas huss pr prsn"
#VARS="ps rlds rsds sfcWind"
VARS="tas"
#VARS="pr prsn sfcWind"
#VARS="LWdown__ SWdown__ Prcp____ PSurf___ Qair____ Tair____ Wind____"
############################################################
# Geopgraphy (Do not change here basically)
############################################################
#L=259200
#L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
#SUF=.hlf
L=9331200
L2X=../../map/dat/l2x_l2y_/l2x.gl5.txt
L2Y=../../map/dat/l2x_l2y_/l2y.gl5.txt
SUF=.gl5
############################################################
# Job (Convert ascii file into binary file)
############################################################

#    VAR=Rainf_b1beta
#      VARNAME=Rainf; SUBDIROUT=Rainf___



for VAR in $VARS; do
    echo ${VAR}  
    if [ $VAR == rlds ]; then   
           DIR=LWdown__
    fi
    if [ $VAR == rsds ]; then   
           DIR=SWdown__
    fi
    if [ $VAR == pr ]; then   
           DIR=Prcp____
    fi
#    if [ $VAR == pr ]; then   
#           DIR=Rainf___
#    fi
    if [ $VAR == prsn ]; then   
           DIR=Snowf___
    fi
    if [ $VAR == ps ]; then   
           DIR=PSurf___
    fi
    if [ $VAR == huss ]; then   
           DIR=Qair____
    fi
    if [ $VAR == tas ]; then   
           DIR=Tair____
    fi
    if [ $VAR == sfcWind ]; then   
           DIR=Wind____
    fi
    YEAR=$YEARMIN
    while [ $YEAR -le $YEARMAX ]; do
        MON=01
        while [ $MON -le 12 ]; do
            MON=`echo $MON | awk '{printf("%2.2d",$1)}'`
            DAY=01
            DAYMAX=`htcal $YEAR $MON`
            while [ $DAY -le $DAYMAX ]; do
                echo "$YEAR $MON $DAY"
                DAY=`echo $DAY | awk '{printf("%2.2d",$1)}'` 
                ###############################################
                # modify file and htformat parameters 
                ###############################################
                #FILE="/home/kajiyama/H08/H08_20230612/met/org/W5E5v2/daily/${VAR}/${VAR}${YEAR}${MON}${DAY}.txt"
                FILE="/home/kajiyama/H08/H08_20230612/met/org/W5E5v2/daily/${VAR}/${VAR}${YEAR}${MON}${DAY}_gl5.txt"
                OUTPUT="/home/kajiyama/H08/H08_20230612/met/dat/${DIR}/${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}"
                #htformat 259200 720 360 $L2X $L2Y -180 180 -90 90 asciiu binary $FILE $OUTPUT
                htformat 9331200 4320 2160 $L2X $L2Y -180 180 -90 90 asciiu binary $FILE $OUTPUT
                DAY=`expr $DAY + 01`
            done
            MON=`expr $MON + 01`
        done
        YEAR=`expr $YEAR + 01`
        echo ${YEAR}
    done
done


