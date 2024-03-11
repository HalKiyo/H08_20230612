#!/bin/sh
############################################################
# INのファイルにCNLLSTから該当する導水路番号CNLをX,Yで挿入するコード
#
# STATE=origin
# load: /map/org/Aoba/Exisiting_origin_H08_rev3.txt
# save: /map/org/Aoba/exisiting_origin.gl5
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
STATE=origin
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
OUT=${DIROUT}/existing_${STATE}${SUF}
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
    if [ $count -eq 1 ]; then
        echo $canalid
        echo $x
        echo $y
        htedit $ARG xy ${OUT} $canalid $x $y
    fi
done
