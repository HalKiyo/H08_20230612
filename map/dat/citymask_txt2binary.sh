############################################################
# geography
############################################################
L2X=/home/kajiyama/H08/H08_20230612/map/dat/l2x_l2y_/l2x.gl5.txt 
L2Y=/home/kajiyama/H08/H08_20230612/map/dat/l2x_l2y_/l2y.gl5.txt 
ARG="9331200 4320 2160 $L2X $L2Y -180 180 -90 90"
SUF=.gl5

############################################################
# Job
############################################################
for ID in `seq 1 900`; do
  ID8=`echo $ID | awk '{printf("%8.8d",$1)}'`
  IN=../../map/dat/cty_msk_/txt/city_${ID}.txt
  OUT=../../map/dat/cty_msk_/city_${ID8}${SUF}
  htformat ARG asciiu binary ${IN} ${OUT}
  echo $ID8
done

