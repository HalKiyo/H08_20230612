#!/bin/sh
############################################################
#to   prepare global canal data by Kitamura et al. (2014)
#by   2016/01/31, hanasaki
#
#
#
#
############################################################
#settings
###########################################################
MAP=.CAMA # @kajiyama
MAX=6
OPT=within
SUF=.gl5
ARG=$ARGGL5
L=$LGL5
############################################################
# in
############################################################
# HLF
#ORGINHLF=../../map/org/K14/in__3___20000000.hlf.txt
#ORGOUTHLF=../../map/org/K14/out_3___20000000.hlf.txt
# GL5
 ORGIN=../../map/org/K14/in__3___20000000${SUF}.txt.org
ORGOUT=../../map/org/K14/out_3___20000000${SUF}.txt.org
#
#RIVSEQHLF=../../map/out/riv_seq_/rivseq${MAP}.hlf
RIVSEQ=../../map/out/riv_seq_/rivseq${MAP}${SUF}
############################################################
# out 
############################################################
# BININHLF=../../map/org/K14/in__3___20000000.hlf
#BINOUTHLF=../../map/org/K14/out_3___20000000.hlf
# ASCINHLF=../../map/org/K14/in__3___20000000.hlf.txt
#ASCOUTHLF=../../map/org/K14/out_3___20000000.hlf.txt
#
 BININ=../../map/org/K14/in__3___20000000${SUF}
BINOUT=../../map/org/K14/out_3___20000000${SUF}
 ASCIN=../../map/org/K14/in__3___20000000${SUF}.txt
ASCOUT=../../map/org/K14/out_3___20000000${SUF}.txt
#
DIRCANORG=../../map/out/can_org_   # origin of canal water
DIRCANDES=../../map/out/can_des_   # destination of canal water
# hlf
#LCANEXPORGHLF=$DIRCANORG/canorg.l.canal.K14.hlf
#LCANEXPDESHLF=$DIRCANDES/candes.l.canal.K14.hlf.bin
#LCANIMPORGHLF=$DIRCANORG/canorg.l.${OPT}.${MAX}${MAP}.hlf
#LCANIMPDESHLF=$DIRCANDES/candes.l.${OPT}.${MAX}${MAP}.hlf.bin
#LCANMRGORGHLF=$DIRCANORG/canorg.l.merged.${MAX}${MAP}.hlf
#LCANMRGDESHLF=$DIRCANDES/candes.l.merged.${MAX}${MAP}.hlf.bin
# gl5
LCANEXPORG=$DIRCANORG/canorg.l.canal.K14${SUF}
LCANEXPDES=$DIRCANDES/candes.l.canal.K14.bin
LCANIMPORG=$DIRCANORG/canorg.l.${OPT}.${MAX}${MAP}${SUF}
LCANIMPDES=$DIRCANDES/candes.l.${OPT}.${MAX}${MAP}.bin
LCANMRGORG=$DIRCANORG/canorg.l.merged.${MAX}${MAP}${SUF}
LCANMRGDES=$DIRCANDES/candes.l.merged.${MAX}${MAP}.bin
#
LOG=temp.log
############################################################
# job
############################################################
#htformat $ARGHLF asciiu binary $ORGINHLF  $BININHLF
#htformat $ARGHLF asciiu binary $ORGOUTHLF $BINOUTHLF
# gl5
htformat $ARG asciiu binary $ORGIN  $BININ
htformat $ARG asciiu binary $ORGOUT  $BINOUT
#############################################################
## job (fix problem: remove 33 of in 37.75,-121.75 and 30 of in -121.25,37.25)hlf
#############################################################
#htedit $ARGHLF lonlat $BININHLF 1.0E20 -121.75 37.75 >  $LOG
#htedit $ARGHLF lonlat $BININHLF 1.0E20 -121.25 37.25 >> $LOG
#############################################################
## job (fix problem: remove 33 of in 37.79,-121.79 and 30 of in -121.29,37.29)gl5
#############################################################
#htedit $ARGGL5 lonlat $BININGL5 1.0E20 -121.791667 37.791667 >> $LOG
#htedit $ARGGL5 lonlat $BININGL5 1.0E20 -121.291667 37.291667 >> $LOG
############################################################
# convert to gl5 (only out locations)
############################################################
#prog_hlf2gl5 $L2XHLF $L2YHLF $L2XGL5 $L2YGL5 $BININHLF $BININGL5
#prog_hlf2gl5 $L2XHLF $L2YHLF $L2XGL5 $L2YGL5 $BINOUTHLF $BINOUTGL5
############################################################ 
# job (print out non-zero points) hlf
############################################################
#htmask   $ARGHLF $BININHLF  $BININHLF  ne 0 $BININHLF  all > $ASCINHLF
#htmask   $ARGHLF $BINOUTHLF $BINOUTHLF ne 0 $BINOUTHLF all > $ASCOUTHLF
############################################################ 
# job (print out non-zero points) gl5
############################################################
#htmask   $ARG $BININ  $BININ  ne 0 $BININ  all > $ASCIN
#htmask   $ARG $BINOUT $BINOUT ne 0 $BINOUT all > $ASCOUT
htmaskrplc   $ARG $BININ  $BININ  le 0 1e+20 $BININ  all > $ASCIN
htmaskrplc   $ARG $BINOUT $BINOUT le 0 1e+20 $BINOUT all > $ASCOUT
############################################################
############################################################
# convert
############################################################
if [ !  -d $DIRCANORG ]; then  mkdir -p $DIRCANORG; fi
if [ !  -d $DIRCANDES ]; then  mkdir -p $DIRCANDES; fi
#
#n0rec=17
#n0recout=10
#
#echo prog_map_K14 $BININHLF $BINOUTHLF $LCANIMPORGHLF $LCANIMPDESHLF $RIVSEQHLF $LCANEXPORGHLF  $LCANEXPDESHLF $LCANMRGORGHLF $LCANMRGDESHLF $L2HLF $n0rec $n0recout >> $LOG
#prog_map_K14 $BININHLF $BINOUTHLF $LCANIMPORGHLF $LCANIMPDESHLF $RIVSEQHLF                   $LCANEXPORGHLF  $LCANEXPDESHLF $LCANMRGORGHLF $LCANMRGDESHLF                    $LHLF $n0rec $n0recout >> $LOG

#n0rec=102
#n0recout=60
#
prog_map_K14_gl5 $BININ $BINOUT $LCANIMPORG $LCANIMPDES $RIVSEQ $LCANEXPORG $LCANEXPDES $LCANMRGORG $LCANMRGDES >> $LOG
echo Log: $LOG
