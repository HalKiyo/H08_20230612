#!/bin/sh
########################################################
#to prepare domain
#by 2024/01/28, kajiyama, TokyoTech
########################################################
# Geographical setting (Edit here if you change spatial domain/resolution
########################################################
#5minx5min of global (.gl5)
LGL5=9331200
XYGL5="4320 2160"
L2XGL5=${DIRH08}/map/dat/l2x_l2y_/l2x.gl5.txt
L2YGL5=${DIRH08}/map/dat/l2x_l2y_/l2y.gl5.txt
LONLATGL5="-180 180 -90 90"
ARGGL5="$LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5"
SUFGL5=.gl5
MAPGL5=.CAMA

#5minx5min of tokyo (.tk5)
LTK5=1728
XYTK5="36 48"
L2XTK5=${DIRH08}/map/dat/l2x_l2y_/l2x.tk5.txt
L2YTK5=${DIRH08}/map/dat/l2x_l2y_/l2y.tk5.txt
LONLATTK5="138 141 34 38"
ARGTK5="$LTK5 $XYTK5 $L2XTK5 $L2YTK5 $LONLATTK5"
SUFTK5=.tk5
MAPTK5=.CAMA

########################################################
# Output (Do not edit here unless you are an expert)
########################################################
DIRRIVNXL=../../out/riv_nxl_
#
RIVNXL=$DIRRIVNXL/tmp${MAPGL5}${SUFGL5}
TMPNXL=$DIRRIVNXL/tmp${MAPTK5}${SUFTK5}

########################################################
# Job (prepare output directory)
########################################################
if [ ! -d ${DIRRIVNXL} ]; then   mkdir -p ${DIRRIVNXL}; fi
########################################################
# Job (make files)
########################################################
htcreate $LTK5 0 $TMPNXL
for i in $(seq 1 $LTK5); do
    echo $i

    # obtain [lon lat] of [l(i) value] in tk5 coordinate
    TMP1=`htid $ARGTK5 l $i`
    IFS=' ' read -ra ARR1 <<< $TMP1
    CURRENTLON=${ARR1[0]}
    CURRENTLAT=${ARR1[1]}

    # obtain [river next l] value in gl5 coordinate at [lon lat]
    LCOORDINATEGL5=`htpoint $ARGGL5 lonlat $RIVNXL $CURRENTLON $CURRENTLAT`
    INT_LCOORDINATEGL5=$(echo "scale=0; ${LCOORDINATEGL5//.*/}" | bc)

    if [ "$INT_LCOORDINATEGL5" -gt 0 ]; then
        # obtain [nxtlon nxtlat] of [river next l] at [lon lat]
        TMP2=`htid $ARGGL5 l $INT_LCOORDINATEGL5`
        IFS=' ' read -ra ARR2 <<< $TMP2
        NEXTLON=${ARR2[0]}
        NEXTLAT=${ARR2[1]}

        # obtain [l value] of [nxtlon nxtlat] value in tk5 coordinate
        TMP3=`htid $ARGTK5 lonlat $NEXTLON $NEXTLAT`
        IFS=' ' read -ra ARR3 <<< $TMP3
        LCOORDINATETK5=${ARR3[2]}

        # print information
        echo $CURRENTLON $CURRENTLAT
        echo $NEXTLON $NEXTLAT

        # replace [river next l] value in tk5 coordinat at [lon lat]
        htedit $ARGTK5 lonlat $TMPNXL $LCOORDINATETK5 $CURRENTLON $CURRENTLAT
    fi
done
