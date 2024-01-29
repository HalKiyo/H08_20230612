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
    # obtain [lon lat] in tk5 coordinate
    CRTTK5=`htid $ARGTK5 l $i`
    IFS=' ' read -ra ARR <<< $CRTTK5
    CURRENTLON=${ARR[0]}
    CURRENTLAT=${ARR[1]}

    # obtain [river next l] value in gl5 coordinate at [lon lat]
    LLLGL5=`htpoint $ARGGL5 lonlat $RIVNXL $CURRENTLON $CURRENTLAT`
    INT_LLLGL5=$(echo "scale=0; ${LLLGL5//.*/}" | bc)

    if [ "$INT_LLLGL5" -gt 0 ]; then
        # obtain [nxtlon nxtlat] of [river next l] at [lon lat]
        NXTGL5=`htid $ARGGL5 l $INT_LLLGL5`
        IFS=' ' read -ra NXTARR <<< $NXTGL5
        NEXTLON=${NXTARR[0]}
        NEXTLAT=${NXTARR[1]}

        # obtain [river next l] value in tk5 coordinate at [nxtlon nxtlat]
        NXTTK5=`htid $ARGTK5 lonlat $NEXTLON $NEXTLAT`
        IFS=' ' read -ra ARRIST <<< $NXTTK5
        LLLTK5=${ARRIST[2]}

        # print information
        echo $i
        echo $LLLTK5
        echo $CURRENTLON $CURRENTLAT
        echo $NEXTLON $NEXTLAT

        # insert [river next l] value in tk5 coordinat at [lon lat]
        htedit $ARGTK5 lonlat $TMPNXL $LLLTK5 $CURRENTLON $CURRENTLAT
    fi
done
