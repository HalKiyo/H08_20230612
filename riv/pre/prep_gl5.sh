#!/bin/sh
############################################################
#to   prepare temporary parameter and initial file 
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
# Geography (Edit here if you change spatial domain/resolution)
############################################################
L=9331200
XY="4320 2160"
L2X=../../map/dat/l2x_l2y_/l2x.gl5.txt
L2Y=../../map/dat/l2x_l2y_/l2y.gl5.txt
LONLAT="-180 180 -90 90"
SUF=.gl5
MAP=.WFDEI
############################################################
# Settings (Edit here if you change settings)
############################################################
V_RIVSTO=0.0                           # River storage initial value
V_MEDRAT=1.4                           # Meandaring ratio
V_FLWVEL=0.5                           # Flow velocity
############################################################
# Input (Do not edit here basically)
############################################################
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
############################################################
# Job
############################################################
JOBS="RIVSTO MEDRAT FLWVEL"
for JOB in $JOBS; do
  if [ $JOB = RIVSTO ]; then
    VAL=$V_RIVSTO 
    DIR=../../riv/ini
    FILE=${DIR}/uniform.${VAL}${SUF}
  elif [ $JOB = MEDRAT ]; then
    VAL=$V_MEDRAT 
    DIR=../../riv/dat
    FILE=${DIR}/uniform.${VAL}${SUF}
  elif [ $JOB = FLWVEL ]; then
    VAL=$V_FLWVEL 
    DIR=../../riv/dat
    FILE=${DIR}/uniform.${VAL}${SUF}
  fi
  if [ ! -d $DIR ]; then
    mkdir $DIR
  fi
  htcreate $L $VAL $FILE
  htmask   $L $XY $L2X $L2Y $LONLAT $FILE $LNDMSK eq 1 $FILE
done
