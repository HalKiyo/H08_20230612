#!/bin/sh
############################################################
#to   prepare global canal data by Kitamura et al. (2014)
#by   2016/01/31, hanasaki
#
#to   prepare Mcdonald canal data in top 20 city by Kato (2022)
#to   prepare Hanasaki(2018) and shumilova(2018) 40 existing canals(2020)
#
############################################################
#settings
###########################################################
MAP=.CAMA # @kajiyama
MAX=6 # maximum distance of implicit canal
OPT=within # within or nolimit
SUF=.gl5
#
LGL5="9331200"
XYGL5="4320 2160"
L2XGL5=${DIRH08}/map/dat/l2x_l2y_/l2x.gl5.txt
L2YGL5=${DIRH08}/map/dat/l2x_l2y_/l2y.gl5.txt
ARGGL5="$LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5"
############################################################
# in
############################################################
#
 BININ=../../map/org/Saritha/explicit_destination.bin
BINOUT=../../map/dat/city_water_map/explicit_city_origin${SUF}
#
RIVSEQ=../../map/out/riv_seq_/rivseq${MAP}${SUF}
############################################################
# out 
############################################################
#
 ASCIN=../../map/org/Saritha/explicit_destination.txt
ASCOUT=../../map/org/Saritha/explicit_city_origin.txt
#
DIRCANORG=../../map/out/can_org_   # origin of canal water
DIRCANDES=../../map/out/can_des_   # destination of canal water
#
# Saritha existing 43 canal data
LCANEXPORG=$DIRCANORG/canorg.l.canal.ext${SUF}
LCANEXPDES=$DIRCANDES/candes.l.canal.ext.bin
LCANIMPORG=$DIRCANORG/canorg.l.${OPT}.${MAX}${MAP}${SUF}
LCANIMPDES=$DIRCANDES/candes.l.${OPT}.${MAX}${MAP}.bin
LCANMRGORG=$DIRCANORG/canorg.l.merged.ext.${MAX}${MAP}${SUF}
LCANMRGDES=$DIRCANDES/candes.l.merged.ext.${MAX}${MAP}.bin
#
LOG=temp.log
############################################################
# job (print out non-zero points) gl5
############################################################
#
htmaskrplc   $ARGGL5 $BININ  $BININ  le 0 1e+20 $BININ  all > $ASCIN
htmaskrplc   $ARGGL5 $BINOUT $BINOUT le 0 1e+20 $BINOUT all > $ASCOUT
############################################################
# convert
############################################################
if [ !  -d $DIRCANORG ]; then  mkdir -p $DIRCANORG; fi
if [ !  -d $DIRCANDES ]; then  mkdir -p $DIRCANDES; fi
# for saritha canal file
prog_map_K14_gl5 $BININ $BINOUT $LCANIMPORG $LCANIMPDES $RIVSEQ
echo Log: $LOG
