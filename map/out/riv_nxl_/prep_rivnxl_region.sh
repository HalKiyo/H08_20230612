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
NUM=29
CITYNUM=$(printf "%08d" ${NUM})
echo $CITYNUM
exit
#
SUFRGN=.ln5
MAPRGN=.CAMA
#
LRGN=1728
XYRGN="48 36"
LONLATRGN="-3 1 50 53"
L2XRGN=${DIRH08}/map/dat/l2x_l2y_/l2x${SUFRGN}.txt
L2YRGN=${DIRH08}/map/dat/l2x_l2y_/l2y${SUFRGN}.txt
ARGRGN="$LRGN $XYRGN $L2XRGN $L2YRGN $LONLATRGN"

########################################################
# Output (Do not edit here unless you are an expert)
########################################################
DIRRIVNXL=../../out/riv_nxl_
#
MSKNXL=$DIRRIVNXL/masked/masked${CITYNUM}${MAPGL5}${SUFGL5}
NEWNXL=$DIRRIVNXL/rivnxl${MAPRGN}${SUFRGN}

########################################################
# Job (prepare output directory)
########################################################
if [ ! -d ${DIRRIVNXL} ]; then   mkdir -p ${DIRRIVNXL}; fi
########################################################
# Job (make files)
########################################################
htcreate $LRGN 0 $NEWNXL
for i in $(seq 1 $LRGN); do
    echo $i

    # obtain [lon lat] of [l(i) value] in RGN coordinate
    TMP1=`htid $ARGRGN l $i`
    IFS=' ' read -ra ARR1 <<< $TMP1
    CURRENTLON=${ARR1[0]}
    CURRENTLAT=${ARR1[1]}

    # obtain [river next l] value in gl5 coordinate at [lon lat]
    LCOORDINATEGL5=`htpoint $ARGGL5 lonlat $MSKNXL $CURRENTLON $CURRENTLAT`
    INT_LCOORDINATEGL5=$(echo "scale=0; ${LCOORDINATEGL5//.*/}" | bc)

    if [ "$INT_LCOORDINATEGL5" -gt 0 ]; then
        # obtain [nxtlon nxtlat] of [river next l] at [lon lat]
        TMP2=`htid $ARGGL5 l $INT_LCOORDINATEGL5`
        IFS=' ' read -ra ARR2 <<< $TMP2
        NEXTLON=${ARR2[0]}
        NEXTLAT=${ARR2[1]}

        # obtain [l value] of [nxtlon nxtlat] value in RGN coordinate
        TMP3=`htid $ARGRGN lonlat $NEXTLON $NEXTLAT`
        IFS=' ' read -ra ARR3 <<< $TMP3
        LCOORDINATERGN=${ARR3[2]}

        # print information
        echo $CURRENTLON $CURRENTLAT
        echo $NEXTLON $NEXTLAT

        # replace [river next l] value in RGN coordinat at [lon lat]
        htedit $ARGRGN lonlat $NEWNXL $LCOORDINATERGN $CURRENTLON $CURRENTLAT
    fi
done
