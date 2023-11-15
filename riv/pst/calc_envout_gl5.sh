#!/bin/sh
############################################################
#to   calculate environmental flow
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Basic settings (Edit here if you change settings)
############################################################
PRJ=W5E5
RUN=LR__
YEARMIN=2019
YEARMAX=2019
LDBG=27641
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=933120
XY="4320 2160"
L2X=../../map/dat/l2x_l2y_/l2x.gl5.txt
L2Y=../../map/dat/l2x_l2y_/l2y.gl5.txt
LONLAT="-180 180 -90 90"
SUF=.gl5
MAP=.CAMA
############################################################
# Input (Do not edit here basically)
############################################################
LNDARA=../../map/dat/lnd_ara_/lndara${MAP}${SUF}
#FLWDIR=../../map/dat/flw_dir_/flwdir${MAP}${SUF}
FRIVMOU=../../map/out/riv_mou_/rivmou${MAP}${SUF}
RIVARA=../../map/out/riv_ara_/rivara${MAP}${SUF}
############################################################
# Input (Do not edit here basically)
############################################################
DIRRIVOUT=../../riv/out/riv_out_
RIVOUT=${DIRRIVOUT}/${PRJ}${RUN}${SUF}MO
############################################################
# Output directory (Do not edit here basically)
############################################################
DIRENVTYP=../../riv/out/env_typ_
DIRENVFLG=../../riv/out/env_flg_
DIRENVOUT=../../riv/out/env_out_
############################################################
# Output (Do not edit here basically)
############################################################
ENVTYP=${DIRENVTYP}/${PRJ}${RUN}${SUF}YR
ENVFLG=${DIRENVFLG}/${PRJ}${RUN}${SUF}MO
ENVOUT=${DIRENVOUT}/${PRJ}${RUN}${SUF}MO
ENVOUTYEAR=${DIRENVOUT}/${PRJ}${RUN}${SUF}YR
############################################################
# Job (Prepare output directory)
############################################################
if [ ! -d $DIRENVTYP ]; then mkdir $DIRENVTYP; fi
if [ ! -d $DIRENVOUT ]; then mkdir $DIRENVOUT; fi
if [ ! -d $DIRENVFLG ]; then mkdir $DIRENVFLG; fi
############################################################
# Job
############################################################
YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
  prog_envout $L $YEAR $LDBG $RIVARA $RIVOUT $ENVTYP $ENVOUT $ENVFLG
  YEAR=`expr $YEAR + 1`
done

httime $L $ENVOUT     $YEARMIN $YEARMAX $ENVOUTYEAR
htmean $L $ENVOUT     $YEARMIN $YEARMAX 0000 
htmean $L $ENVOUTYEAR $YEARMIN $YEARMAX 0000 

#htmask $L $XY $L2X $L2Y $LONLAT ${DIRRIVOUT}/${PRJ}${RUN}${YEARMIN}0000${SUF} $FLWDIR eq 9 temp${SUF}
#htmask $L $XY $L2X $L2Y $LONLAT ${DIRENVOUT}/${PRJ}${RUN}${YEARMIN}0000${SUF} $FLWDIR eq 9 temp${SUF}
htmask $L $XY $L2X $L2Y $LONLAT ${DIRRIVOUT}/${PRJ}${RUN}${YEARMIN}0000${SUF} $FRIVMOU eq 9 temp${SUF}
htmask $L $XY $L2X $L2Y $LONLAT ${DIRENVOUT}/${PRJ}${RUN}${YEARMIN}0000${SUF} $FRIVMOU eq 9 temp${SUF}
############################################################
# Job (Draw)
############################################################
CPT=../../cpt/envtyp.cpt
EPS=temp.envtyp.eps
PNG=temp.envtyp.png

htdraw $L $XY $L2X $L2Y $LONLAT ${DIRENVTYP}/$PRJ${RUN}${YEARMIN}0000${SUF} $CPT $EPS
htconv $EPS $PNG rot
echo $PNG 

CPT=../../cpt/Diskgs.cpt
EPS=temp.envout.eps
PNG=temp.envout.png

htdraw $L $XY $L2X $L2Y $LONLAT ${DIRENVOUT}/$PRJ${RUN}${YEARMIN}0000${SUF} $CPT $EPS
htconv $EPS $PNG rot
echo $PNG 
