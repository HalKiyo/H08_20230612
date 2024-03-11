#!/bin/sh
############################################################
# INのファイルにCNLLSTから該当する導水路番号CNLをX,Yで挿入するコード
#
# STATE=destionation
# load: /map/org/Aoba/Exisiting_destination_H08_rev3.txt
# save: /map/org/Aoba/exisiting_destination.gl5
#
# SEQUENCE: 1-4, canal_id=14 has 4 origins
#
############################################################
# geography
############################################################
#
L2X=/home/kajiyama/H08/H08_20230612/map/dat/l2x_l2y_/l2x.gl5.txt
L2Y=/home/kajiyama/H08/H08_20230612/map/dat/l2x_l2y_/l2y.gl5.txt
ARG="9331200 4320 2160 $L2X $L2Y -180 180 -90 90"
SUF=.gl5
#
STATE=destination
SEQUENCE=4
#
############################################################
# input
############################################################
#
DIROUT=/home/kajiyama/H08/H08_20230612/map/org/Aoba
CNLLST=${DIROUT}/Existing_${STATE}_H08_rev3.txt
#
############################################################
# output
############################################################
#
OUT=${DIROUT}/existing_${STATE}_${SEQUENCE}${SUF}
#
############################################################
# job
############################################################
htcreate 9331200 0 ${OUT}
#
CNL=`awk '{print $2}' $CNLLST`
X=`awk '{print $3}' $CNLLST`
Y=`awk '{print $4}' $CNLLST`
CNT=`awk '{print $5}' $CNLLST`
paste -d ' ' <(echo "$CNL") <(echo "$X") <(echo "$Y") <(echo "$CNT") | while read -r canalid x y count; do
    if [ $count -eq $SEQUENCE ]; then
        echo $canalid
        echo $x
        echo $y
        htedit $ARG xy ${OUT} $canalid $x $y
    fi
done
