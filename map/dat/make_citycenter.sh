############################################################
# Geography
############################################################
L2X=/home/kajiyama/H08/H08_20230612/map/dat/l2x_l2y_/l2x.gl5.txt 
L2Y=/home/kajiyama/H08/H08_20230612/map/dat/l2x_l2y_/l2y.gl5.txt 
ARG="9331200 4320 2160 $L2X $L2Y -180 180 -90 90"
SUF=.gl5

############################################################
# Path
############################################################
DIROUT=../../map/dat/cty_cnt_/
CTYLST=/home/kajiyama/H08/H08_20230612/map/dat/cty_lst_/city_list03.txt

############################################################
# Job
############################################################
for ID in `seq 1 900`; do
  ID8=`echo $ID | awk '{printf("%8.8d",$1)}'`
  LON=`awk '($1=="'$ID'"){print $3}' $CTYLST`       # need check
  LAT=`awk '($1=="'$ID'"){print $4}' $CTYLST`       # need check
  NAME=`awk '($1=="'$ID'"){print $6}' $CTYLST`      # need check

  echo --------
  echo ID: $ID8
  echo LON: $LON
  echo LAT: $LAT
  echo Name: $NAME

  htcreate 9331200 0 ${DIROUT}city_${ID8}${SUF}
  IN=${DIROUT}city_${ID8}${SUF}
  htedit $ARG lonlat ${IN} 1 $LON $LAT

done

