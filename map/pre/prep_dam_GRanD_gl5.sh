#!/bin/sh
############################################################
#to   prepare dam data
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Setting (Edit here)
############################################################
#
#PRJ=H06_            # Project name
RUN=____            # Run name
#YEARDAM=2000        # Dams completed by this year is included.
#LST=../../map/org/H06/damlst.WFDEI.hlf.txt
#
PRJ=GRan            # Project name
RUN=D_L_            # Run name
YEARDAM=2019        # Dams completed by this year is included.
LST=../../map/org/GRanD/GRanD_L.txt
#
#PRJ=GRan            # Project name
#RUN=D_M_            # Run name
#YEARDAM=2019        # Dams completed by this year is included.
#LST=../../map/org/GRanD/GRanD_M.txt
############################################################
# Geography (Edit here if you change spatial domain/resolution)
############################################################
L=9331200
XY="4320 2160"
L2X=../../map/dat/l2x_l2y_/l2x.gl5.txt
L2Y=../../map/dat/l2x_l2y_/l2y.gl5.txt
LONLAT="-180 180 -90 90"
SUF=.gl5
ARG="$L $XY $L2X $L2Y $LONLAT"
MAP=.CAMA
LDBG=1
############################################################
# Input (Do not edit here unless you are an expert)
############################################################
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
GRDARA=../../map/dat/grd_ara_/grdara${SUF}
LOG=temp.log
############################################################
# Output (Do not edit here unless you are an expert)
############################################################
DIRDAMCAP=../../map/dat/dam_cap_
DIRDAMCAT=../../map/dat/dam_cat_
DIRDAMID_=../../map/dat/dam_id__
DIRDAMNUM=../../map/dat/dam_num_
DIRDAMPRP=../../map/dat/dam_prp_
DIRDAMSRF=../../map/dat/dam_srf_
DIRDAMYR_=../../map/dat/dam_yr__
DIRDAMAFC=../../map/dat/dam_afc_
#
DAMCAP=${DIRDAMCAP}/${PRJ}${RUN}${YEARDAM}0000${SUF}
DAMCAT=${DIRDAMCAT}/${PRJ}${RUN}${YEARDAM}0000${SUF}
DAMID_=${DIRDAMID_}/${PRJ}${RUN}${YEARDAM}0000${SUF}
DAMNUM=${DIRDAMNUM}/${PRJ}${RUN}${YEARDAM}0000${SUF}
DAMPRP=${DIRDAMPRP}/${PRJ}${RUN}${YEARDAM}0000${SUF}
DAMSRF=${DIRDAMSRF}/${PRJ}${RUN}${YEARDAM}0000${SUF}
DAMYR_=${DIRDAMYR_}/${PRJ}${RUN}${YEARDAM}0000${SUF}
DAMAFC=${DIRDAMAFC}/${PRJ}${RUN}${YEARDAM}0000${SUF}
############################################################
# Job (make directory)
############################################################
if [ ! -d $DIRDAMCAP ]; then mkdir -p $DIRDAMCAP; fi
if [ ! -d $DIRDAMCAT ]; then mkdir -p $DIRDAMCAT; fi
if [ ! -d $DIRDAMID_ ]; then mkdir -p $DIRDAMID_; fi
if [ ! -d $DIRDAMNUM ]; then mkdir -p $DIRDAMNUM; fi
if [ ! -d $DIRDAMPRP ]; then mkdir -p $DIRDAMPRP; fi
if [ ! -d $DIRDAMSRF ]; then mkdir -p $DIRDAMSRF; fi
if [ ! -d $DIRDAMYR_ ]; then mkdir -p $DIRDAMYR_; fi
if [ ! -d $DIRDAMAFC ]; then mkdir -p $DIRDAMAFC; fi
############################################################
# Job  (generate files)
############################################################
prog_damgrd $L $XY $L2X $L2Y $LONLAT $LST $DAMNUM $DAMCAP $DAMCAT $DAMID_ $DAMPRP $DAMSRF $DAMYR_ $YEARDAM $LNDMSK $LDBG         >  $LOG
#
htmath     $L div $DAMCAT $GRDARA $DAMAFC
htmaskrplc $ARG $DAMAFC $DAMAFC gt 1.0 1.0 $DAMAFC >> $LOG
#
echo Log: $LOG
