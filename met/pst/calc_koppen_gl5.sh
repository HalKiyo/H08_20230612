#!/bin/sh
############################################################
#to   calculate Koppen climatic zone
#by   2010/09/30,nhanasaki, NIES: H08ver1.0
############################################################
# Edit here (basic)
############################################################
#YEAR=2019
YEAR=0000
NL=9331200
LDBG=1290187
PRJ=W5E5
RUN=____
SUF=.gl5
############################################################
# Edit here (in)
############################################################
PRCP=../../met/dat/Prcp____/${PRJ}${RUN}${SUF}MO
TAIR=../../met/dat/Tair____/${PRJ}${RUN}${SUF}MO
############################################################
# Edit here (out)
############################################################
DIRKOPPEN=../../met/out/Koppen__
DIRKOPSIM=../../met/out/Kopsim__
#
KOPPEN=$DIRKOPPEN/${PRJ}${RUN}00000000${SUF}
KOPSIM=$DIRKOPSIM/${PRJ}${RUN}00000000${SUF}
############################################################
# Make directory
############################################################
if [ !  -d $DIRKOPPEN ]; then
  mkdir -p $DIRKOPPEN
fi
if [ !  -d $DIRKOPSIM ]; then
  mkdir -p $DIRKOPSIM
fi
############################################################
#
############################################################
prog_koppen $NL $LDBG $YEAR $TAIR $PRCP $KOPPEN $KOPSIM
