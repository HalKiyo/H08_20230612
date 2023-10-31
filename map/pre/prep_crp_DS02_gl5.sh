#!/bin/sh
############################################################
#to   prepare Doell and Siebert 2002 irrigation map
#by   2010/09/30, hanasaki, NIES: H08ver1.0
#
# Source:
#
# Doll, P., and S. Siebert (2002),
# Global modeling of irrigation water requirements,
# Water Resour. Res., 38(4). 1037, doi:10.1029/2001WR000355
#
############################################################
# Geography (Edit here, but ONLY one degree global OR half degree global)
############################################################
L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.hlf
MAP=.WFDEI #land mask for hlf
MAP1=.CAMA
############################################################
# Setting (Do not edit here unless you are an expert)
############################################################
PRJ=DS02
RUN=____
YEAR=0000
############################################################
# Input (Do not edit here unless you are an expert)
############################################################
IRGARAORG=../../map/org/DS02/irgara.DS02${SUF}       # Irrigated area
IRGEFFORG=../../map/org/DS02/irgeff.DS02${SUF}       # Irrigated efficiency
CRPINTORG=../../map/org/DS02/crpint.DS02${SUF}       # Crop intensity
#
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}     # land mask
LNDMSKGL5=../../map/dat/lnd_msk_/lndmsk${MAP1}.gl5 #${SUF}     # land mask gl5

############################################################
# Output (Do not edit here unless you are an expert)
############################################################
DIRIRGARA=../../map/dat/irg_ara_            # irrigated area
DIRIRGEFF=../../map/dat/irg_eff_            # irrigation efficiency
DIRCRPINT=../../map/dat/crp_int_            # crop intensity
#
IRGARA=${DIRIRGARA}/${PRJ}${RUN}${YEAR}0000${SUF}
IRGEFF=${DIRIRGEFF}/${PRJ}${RUN}${YEAR}0000${SUF}
CRPINT=${DIRCRPINT}/${PRJ}${RUN}${YEAR}0000${SUF}
#
IRGARAGL5=${DIRIRGARA}/${PRJ}${RUN}${YEAR}0000.gl5 #${SUF}
IRGEFFGL5=${DIRIRGEFF}/${PRJ}${RUN}${YEAR}0000.gl5 #${SUF}
CRPINTGL5=${DIRCRPINT}/${PRJ}${RUN}${YEAR}0000.gl5 #${SUF}
############################################################
# Job (prepare directory)
############################################################
if [ !  -f $DIRIRGARA    ]; then  mkdir -p $DIRIRGARA; fi
if [ !  -f $DIRIRGEFF    ]; then  mkdir -p $DIRIRGEFF; fi
if [ !  -f $DIRCRPINT    ]; then  mkdir -p $DIRCRPINT; fi
############################################################
# Job (original --> hformat)
# - irrigated area
# - crop intensity
# - irrigated efficiency
############################################################
htformat $ARG asciiu binary $IRGARAORG.txt $IRGARAORG
echo Irrigated area: `htstat $ARG sum $IRGARAORG`
#
htformat $ARG asciiu binary $CRPINTORG.txt $CRPINTORG
echo Crop intensity: `htstat $ARG sum $CRPINTORG`
#
htformat $ARG asciiu binary $IRGEFFORG.txt $IRGEFFORG
echo Irrigated efficiency: `htstat $ARG sum $IRGEFFORG`
############################################################
# Job (reshape original data)
# - irrigated area
# - crop intensity
# - irrigated efficiency
############################################################
htmask $ARG $IRGARAORG $LNDMSK eq 1 $IRGARA  > /dev/null
echo Irrigated area: `htstat $ARG sum $IRGARA`
#
htmask $ARG $CRPINTORG $LNDMSK eq 1 $CRPINT > /dev/null
echo Crop intensity: `htstat $ARG sum $CRPINT`
#
htmask $ARG $IRGEFFORG $LNDMSK eq 1 $IRGEFF > /dev/null
echo Irrigated efficiency: `htstat $ARG sum $IRGEFF`
############################################################ gl5 @menaka
prog_hlf2gl5 $L2X $L2Y $L2XGL5 $L2YGL5 $IRGARA $IRGARAGL5
htmath $LGL5 div $IRGARAGL5 36 $IRGARAGL5 # divid by 36 grid uniform distribution  
prog_hlf2gl5 $L2X $L2Y $L2XGL5 $L2YGL5 $IRGEFF $IRGEFFGL5
prog_hlf2gl5 $L2X $L2Y $L2XGL5 $L2YGL5 $CRPINT $CRPINTGL5
############################################################
htmask $ARGGL5 $IRGARAGL5 $LNDMSKGL5 eq 1  $IRGARAGL5  > /dev/null
echo Irrigated area: `htstat $ARGGL5 sum $IRGARAGL5`
#
htmask $ARGGL5 $CRPINTGL5 $LNDMSKGL5 eq 1 $CRPINTGL5 > /dev/null
echo Crop intensity: `htstat $ARGGL5 sum $CRPINTGL5`
#
htmask $ARGGL5 $IRGEFFGL5 $LNDMSKGL5 eq 1 $IRGEFFGL5 > /dev/null
echo Irrigated efficiency: `htstat $ARGGL5 sum $IRGEFFGL5`
