#!/bin/sh
############################################################
#to   prepare global canal data by Kitamura et al. (2014)
#by   2016/01/31, hanasaki
#
#to   prepare Mcdonald canal data in top 10 city by Kato (2020)
#to   prepare Hanasaki(2018) and shumilova(2018) 43 existing canals by Saritha & Kato (2022)
#
############################################################
#settings
###########################################################
MAP=.CAMA # @kajiyama
MAX=1 # maximum distance of implicit canal
OPT=within # within or nolimit
SUF=.gl5
#
LGL5="9331200"
XYGL5="4320 2160"
L2XGL5=/home/kajiyama/H08/H08_20230612/map/dat/l2x_l2y_/l2x.gl5.txt
L2YGL5=/home/kajiyama/H08/H08_20230612/map/dat/l2x_l2y_/l2y.gl5.txt
LONLATGL5="-180 180 -90 90"
ARGGL5="$LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5"
############################################################
# in
############################################################
# distination file of multiple origin
 BININ=../../map/org/Aoba/explicit_destination.bin
# origin file of 5min resolution
BINOUT=../../map/org/Aoba/existing_origin${SUF}
#
RIVSEQ=../../map/out/riv_seq_/rivseq${MAP}${SUF}
#
DIRCANORG=../../map/out/can_org_   # origin of canal water
DIRCANDES=../../map/out/can_des_   # destination of canal water
#
# l coordinate of CaMa implicit aqueduct
LCANIMPORG=$DIRCANORG/canorg.l.${OPT}.${MAX}${MAP}${SUF}
LCANIMPDES=$DIRCANDES/candes.l.${OPT}.${MAX}${MAP}.bin
############################################################
# out 
############################################################
#
# l coordinate of Saritha $ Aoba existing 43 canal data
LCANEXPORG=$DIRCANORG/canorg.l.canal.ext${SUF}
LCANEXPDES=$DIRCANDES/candes.l.canal.ext.bin
#
# l coordinate of merged aqueduct
LCANMRGORG=$DIRCANORG/canorg.l.merged.ext.${MAX}${MAP}${SUF}
LCANMRGDES=$DIRCANDES/candes.l.merged.ext.${MAX}${MAP}.bin
#
LOG=temp.log
############################################################
# job (print out non-zero points) gl5
############################################################
#
#htmaskrplc   $ARGGL5 $BININ  $BININ  le 0 1e+20 $BININ
#htmaskrplc   $ARGGL5 $BINOUT $BINOUT le 0 1e+20 $BINOUT
############################################################
# convert
############################################################
if [ !  -d $DIRCANORG ]; then  mkdir -p $DIRCANORG; fi
if [ !  -d $DIRCANDES ]; then  mkdir -p $DIRCANDES; fi
#
# fortran program for saritha & aoba canal file
prog_map_K14_gl5 $BININ $BINOUT $LCANIMPORG $LCANIMPDES $RIVSEQ  $LCANEXPORG $LCANEXPDES $LCANMRGORG $LCANMRGDES >> $LOG

echo Log: $LOG
