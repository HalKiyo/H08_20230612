SUF=.gl5

#for ID in `seq 1 450`; do
for ID in `seq 1 900`; do
  ID8=`echo $ID | awk '{printf("%8.8d",$1)}'`
  htformat 9331200 4320 2160 ../dat/l2x_l2y_/l2x.gl5.txt ../dat/l2x_l2y_/l2y.gl5.txt -180 180 -90 90 asciiu binary ../dat/cty_msk_/txt/city_${ID}.txt ./cty_msk_/city_${ID8}${SUF}
  echo $ID8
done

