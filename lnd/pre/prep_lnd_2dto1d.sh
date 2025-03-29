#!/bin/sh
##############################################################
#to   prepare 1 dimentional data
#by   2024/10/17, tamaoki, NIES: H08ver1.0
##############################################################
# Settings (Edit here if you change spacial domain/resolution) 
##############################################################
YEARMEAN=0000
YEARMIN=2000; YEARMAX=2001
MONS="01 02 03 04 05 06 07 08 09 10 11 12"
#
LALL=9332100                 # L for 2d data
LLND=2247551                  # L for 1d data
X=4320                       
Y=2160                       
L2XLND=../../map/dat/l2x_l2y_/l2x.g5o.txt
L2YLND=../../map/dat/l2x_l2y_/l2y.g5o.txt
LONLAT="-180 180 -90 90"
#
SUFIN=.gl5                  # Suffix for 2d data
SUFOUT=.g5o                 # Suffix for 1d data
MAP=.CAMA
#
PRJMET=W5E5
RUNMET=____
PRJMAP=GSW2
RUNMAP=____
#
#htdraw $LLND $X $Y $L2XLND $L2YLND $LONLAT $OUT $CPT $EPS
#############################################################
# Input Data
#############################################################
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUFIN}
DIRMET=../../met/dat
DIRMAP=../../map/dat
DIRLND=../../lnd/dat
DIRINI=../../lnd/ini
#METVARS="Tair____ LWdown__ SWdown__ Prcp____ PSurf___ Qair____ Rainf___ Snowf___ Wind____"
METVARS="Tair____ LWdown__ SWdown__ PSurf___ Qair____ Rainf___ Snowf___ Wind____"
MAPVARS="Albedo__"
LNDVARS="0.003 0.15 0.30 1.00 100.00 13000.00 2.00"
TAUVARS="gamma___ tau_____"
GWRVARS="fg rgmax"
INIVARS="150.0 283.15 0.0"
#############################################################
# Output Data
#############################################################
CPT=temp.cpt
EPS=temp.eps
PNG=temp.png

#############################################################
# Conversion (ALL --> LND)
#############################################################
YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
    for MON in $MONS; do
        for METVAR in $METVARS; do
            DAY=00
            DAYMAX=`htcal $YEAR $MON`
            while [ $DAY -le $DAYMAX ]; do
                DAY=`echo $DAY | awk '{printf("%2.2d",$1)}'`
                METDAT=${DIRMET}/${METVAR}/${PRJMET}${RUNMET}${YEAR}${MON}${DAY}${SUFIN}
                METOUT=${DIRMET}/${METVAR}/${PRJMET}${RUNMET}${YEAR}${MON}${DAY}${SUFOUT}
                echo $METDAT
                echo $METOUT
                ht2dto1d $LALL $X $Y $METDAT $LNDMSK $METOUT $L2XLND $L2YLND
                DAY=`expr $DAY + 1 | awk '{printf("%2.2d",$1)}'`
            done
        done
    done
    YEAR=`expr $YEAR + 1`
done
#
for METVAR in $METVARS; do
    MET0DA=${DIRMET}/${METVAR}/${PRJMET}${RUNMET}${YEARMEAN}0000${SUFIN}
    MET0OU=${DIRMET}/${METVAR}/${PRJMET}${RUNMET}${YEARMEAN}0000${SUFOUT}
    echo $MAP0DA
    echo $MAPOUT
    ht2dto1d $LALL $X $Y $MET0DA $LNDMSK $MET0OU $L2XLND $L2YLND
done

for MON in $MONS; do
    for MAPVAR in $MAPVARS; do
        MAPDAT=${DIRMAP}/${MAPVAR}/${PRJMAP}${RUNMAP}${YEARMEAN}${MON}00${SUFIN}
        MAPOUT=${DIRMAP}/${MAPVAR}/${PRJMAP}${RUNMAP}${YEARMEAN}${MON}00${SUFOUT}
        echo $MAPDAT
        echo $MAPOUT
        ht2dto1d $LALL $X $Y $MAPDAT $LNDMSK $MAPOUT $L2XLND $L2YLND
    done
done
#
for LNDVAR in $LNDVARS; do
    LNDDAT=${DIRLND}/uniform.${LNDVAR}${SUFIN}
    LNDOUT=${DIRLND}/uniform.${LNDVAR}${SUFOUT}
    echo $LNDDAT
    echo $LNDOUT
    ht2dto1d $LALL $X $Y $LNDDAT $LNDMSK $LNDOUT $L2XLND $L2YLND
done
#
for TAUVAR in $TAUVARS; do
    TAUDAT=${DIRLND}/${TAUVAR}/${PRJMET}${RUNMET}00000000${SUFIN}
    TAUOUT=${DIRLND}/${TAUVAR}/${PRJMET}${RUNMET}00000000${SUFOUT}
    echo $TAUDAT
    echo $TAUOUT
    ht2dto1d $LALL $X $Y $TAUDAT $LNDMSK $TAUOUT $L2XLND $L2YLND
done
#
for INIVAR in $INIVARS; do
    INIDAT=${DIRINI}/uniform.${INIVAR}${SUFIN}
    INIOUT=${DIRINI}/uniform.${INIVAR}${SUFOUT}
    echo $INIDAT
    echo $INIOUT
    ht2dto1d $LALL $X $Y $INIDAT $LNDMSK $INIOUT $L2XLND $L2YLND
done

for GWRVAR in $GWRVARS; do
    GWRDAT=${DIRLND}/gwr_____/${GWRVAR}${SUFIN}
    GWROUT=${DIRLND}/gwr_____/${GWRVAR}${SUFOUT}
    echo $GWRDAT
    echo $GWROUT
    ht2dto1d $LALL $X $Y $GWRDAT $LNDMSK $GWROUT $L2XLND $L2YLND
done

#############################################################
# Confirm (max, min, sum, ave)
#############################################################
#htstat $LLND $X $Y $L2XLND $L2YLND $LONLAT max $OUT
#htstat $LLND $X $Y $L2XLND $L2YLND $LONLAT min $OUT
#htstat $LLND $X $Y $L2XLND $L2YLND $LONLAT sum $OUT
#htstat $LLND $X $Y $L2XLND $L2YLND $LONLAT ave $OUT

##############################################################
## 1D-->2D (Graphic converison of meteorological data)
##############################################################
#if [ $VAR = "Tair____" ]; then
#    gmt makecpt -T0/330/110 -Z > $CPT
#elif [ $VAR = "LWdown__" ]; then
#        gmt makecpt -T0/550/110 -Z > $CPT
#elif [ $VAR = "SWdown__" ]; then
#    gmt makecpt -T0/330/110 -Z > $CPT
#elif [ $VAR = "Prcp____" ]; then
#    gmt makecpt -T0/0.0003/0.0001 -Z > $CPT
#elif [ $VAR = "PSurf___" ]; then
#    gmt makecpt -T0/110000/55000 -Z > $CPT
#elif [ $VAR = "Qair____" ]; then
#    gmt makecpt -T0/0.03/0.01 -Z > $CPT
#elif [ $VAR = "Rainf___" ]; then
#    gmt makecpt -T0/0.0003/0.0001 -Z > $CPT
#elif [ $VAR = "Snowf___" ]; then
#    gmt makecpt -T0/0.00007/0.000035 -Z > $CPT
#elif [ $VAR = "Wind____" ]; then
#    gmt makecpt -T0/15/5 -Z > $CPT
#    fi
#
#htdraw $LLND $X $Y $L2XLND $L2YLND $LONLAT $OUT $CPT $EPS
#    htconv $EPS $PNG rot
