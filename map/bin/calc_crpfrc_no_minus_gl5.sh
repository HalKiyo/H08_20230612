#!/bin/sh
############################################################
#to   prepare mosaic fraction by crop land use
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=$LGL5 #259200
XY=$XYGL5 #"720 360"
L2X=$L2XGL5 #../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=$L2YGL5 #../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.gl5 #.hlf
MAP=.CAMA #.WATCH
############################################################
# Basic setting (Edit here if you wish)
############################################################
OPT="double"     # double or single
PRJRUNOUT=S05_____
############################################################
# Input (Edit here if you wish)
############################################################
IRGARA=../../map/dat/irg_ara_/S05_____20000000${SUF}  # Irrigated area
LNDARA=../../map/dat/lnd_ara_/lndara${MAP}${SUF}     # land area
############################################################
# Output (Edit here if you wish)
############################################################
DIRIRGARADBL=../../map/out/irg_arad          # irrigated area for double crop
DIRIRGARASGL=../../map/out/irg_aras          # irrigated area for single crop
   DIRRFDARA=../../map/out/rfd_ara_          # rainfed cropland area 
   DIRNONARA=../../map/out/non_ara_          # non cropland area
DIRIRGFRCDBL=../../map/out/irg_frcd          # land area fraction for d crop
DIRIRGFRCSGL=../../map/out/irg_frcs          # land area fraction for s crop
   DIRRFDFRC=../../map/out/rfd_frc_          # land area fraction rainfed
   DIRNONFRC=../../map/out/non_frc_          # land area fraction non crop
#
IRGARADBL=${DIRIRGARADBL}/${PRJRUNOUT}20000000${SUF}
IRGARASGL=${DIRIRGARASGL}/${PRJRUNOUT}20000000${SUF}
   RFDARA=${DIRRFDARA}/${PRJRUNOUT}20000000${SUF}
   NONARA=${DIRNONARA}/${PRJRUNOUT}20000000${SUF}
IRGFRCDBL=${DIRIRGFRCDBL}/${PRJRUNOUT}20000000${SUF}
IRGFRCSGL=${DIRIRGFRCSGL}/${PRJRUNOUT}20000000${SUF}
   RFDFRC=${DIRRFDFRC}/${PRJRUNOUT}20000000${SUF}
   NONFRC=${DIRNONFRC}/${PRJRUNOUT}20000000${SUF}
#
LOG=temp.log
############################################################
# Job (prepare directory)
############################################################
if [ !  -f $DIRIRGFRCDBL ]; then  mkdir -p $DIRIRGFRCDBL; fi
if [ !  -f $DIRIRGFRCSGL ]; then  mkdir -p $DIRIRGFRCSGL; fi
if [ !  -f $DIRRFDFRC    ]; then  mkdir -p $DIRRFDFRC; fi
if [ !  -f $DIRNONFRC    ]; then  mkdir -p $DIRNONFRC; fi
############################################################
# Job (area & fraction for standard double crops)
############################################################
if [ $OPT = "double" ]; then
# fraction of irrigation single
  htmath $L div $IRGARASGL $LNDARA $IRGFRCSGL
  echo Irrig area fraction max single: `htstat $ARG max $IRGFRCSGL` >> $LOG
  echo Irrig area fraction min single: `htstat $ARG min $IRGFRCSGL` >> $LOG
# fraction of irrigation double
  htmath $L div $IRGARADBL $LNDARA $IRGFRCDBL
  echo Irrig area fraction max double: `htstat $ARG max $IRGFRCDBL` >> $LOG
  echo Irrig area fraction min double: `htstat $ARG min $IRGFRCDBL` >> $LOG
# fraction of rainfed
  htmath $L div $RFDARA    $LNDARA $RFDFRC
  echo Rainfed area fraction max: `htstat $ARG max $RFDFRC`  >> $LOG
  echo Rainfed area fraction min: `htstat $ARG min $RFDFRC`  >> $LOG
# fraction of non-cropland
  htmath $L div $NONARA   $LNDARA $NONFRC
  htmask $ARG $NONFRC $LNDMSK eq 1 $NONFRC   > /dev/null
  echo Non-crop area fraction max: `htstat $ARG max $NONFRC` >> $LOG
  echo Non-crop area fraction min: `htstat $ARG min $NONFRC` >> $LOG
fi
