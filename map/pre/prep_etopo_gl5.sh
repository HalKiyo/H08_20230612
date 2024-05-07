#!/bin/sh

# by kkajiyama, 2023/08/28
# original file: https://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/bedrock/cell_registered/netcdf/ETOPO1_Bed_c_gmt4.grd.gz
# gmt version is 5.4.4

# to
########################################################
ORG=../org/ETOPO1/ETOPO1_Bed_c_gmt4.grd
NC=../org/ETOPO1/ETOPO1_Bed_c_gmt4.nc
TMP=temp.txt
DIROUT=../dat/elv_avg_
OUTGL1=${DIROUT}/ETOPO1__00000000.gl1
OUTGL5=${DIROUT}/ETOPO1__00000000.gl5
#########################################################
# directory
#########################################################
if [ ! -d $DIROUT ]; then
    mkdir -p $DIROUT
fi
#########################################################
# grd --> nc
#########################################################
#gunzip ${NC}.gz
#gmt grdreformat $ORG ${NC} # this command is only available with GMT version less than 4 and create netcdf3
#${NC} is created on nero which has GMT4.6.16
#########################################################
# nc --> gl1
#########################################################
HEADER=`ncdump -h $NC | wc | awk '{print $1+2}'`
ncdump -vz $NC | sed -e '1,'"$HEADER"'d' | sed -e '$d' | sed -e 's/,/ /g' | sed -e 's/;/ /g' > $TMP
./prog_etopo $TMP $OUTGL1
#########################################################
# gl1 --> gl5
#########################################################
htuscale 5 5 4320 2160 $L2XGL1 $L2YGL1 $L2XGL5 $L2YGL5 $OUTGL1 $OUTGL5 min
