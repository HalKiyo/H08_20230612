source ~/.bashrc
#!/bin/sh
############################################################
#to  prepare
#
############################################################
# settings
############################################################
LGL5="9331200"
ARGGL5="9331200 4320 2160 ../../map/dat/l2x_l2y_/l2x.gl5.txt ../../map/dat/l2x_l2y_/l2y.gl5.txt -180 180 -90 90"
MAP=.CAMA
SUF=.gl5
############################################################
# in
############################################################
   AAI=../../map/dat/aai_____/GMIA5___20050000${SUF} # area actually irrig
   AEI=../../map/dat/aei_____/GMIA5___20050000${SUF} # area equipped for irrig
  AEIS=../../map/dat/aeis____/GMIA5___20050000${SUF} # area irrigated with sw
  AEIG=../../map/dat/aeig____/GMIA5___20050000${SUF} # area irrigated with gw
#
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
############################################################
# out
############################################################
DIRAAIS=../../map/dat/aais____    # area actually irrig with sw
DIRAAIG=../../map/dat/aaig____    # area actually irrig with gw 
DIRFRCAEIG=../../map/dat/aeigfrc_ # area equipped for irrigation fraction gw
 DIRFRCAAI=../../map/dat/aai_frc_ # area equipped for irrigation fraction
#
   AAIS=${DIRAAIS}/GMIA5___20050000${SUF}
   AAIG=${DIRAAIG}/GMIA5___20050000${SUF}
 FRCAAI=${DIRFRCAAI}/GMIA5___20050000${SUF} 
FRCAEIG=${DIRFRCAEIG}/GMIA5___20050000${SUF} 
 FIGFRCAAI=${DIRFRCAAI}/GMIA5___20050000.png
FIGFRCAEIG=${DIRFRCAEIG}/GMIA5___20050000.png
#
AAIM=../../map/dat/aai_____/GMIA5___20050000${SUF} # masked
AEIM=../../map/dat/aei_____/GMIA5___20050000${SUF} # masked
FRCAEIGM=${DIRFRCAEIG}/GMIA5___20050000${SUF}      # masked
#
LOG=temp.log
############################################################
# macro
############################################################
CPT=temp.cpt
EPS=temp.eps

############################################################
# job
############################################################
if [ !  -f $DIRFRCAEIG ]; then
  mkdir -p $DIRFRCAEIG
fi
if [ !  -f $DIRFRCAAI ]; then
  mkdir -p $DIRFRCAAI
fi
if [ !  -f $DIRAAIG ]; then
  mkdir -p $DIRAAIG
fi
if [ !  -f $DIRAAIS ]; then
  mkdir -p $DIRAAIS
fi

# debug
DIRVAR=~/H08/H08_20230612/map/dat/aeigfrc_
maxgl5 ${DIRVAR}/GMIA5___20050000.gl5
# debug

#
htmath ${LGL5} div $AEIG $AEI $FRCAEIG
htmaskrplc ${ARGGL5} $FRCAEIG $FRCAEIG eq 1.0E20 0 $FRCAEIG > $LOG
htmath ${LGL5} div $AAI  $AEI $FRCAAI
htmath ${LGL5} mul $AEIG $FRCAAI $AAIG
htmath ${LGL5} mul $AEIS $FRCAAI $AAIS

# debug
DIRVAR=~/H08/H08_20230612/map/dat/aeigfrc_
maxgl5 ${DIRVAR}/GMIA5___20050000.gl5
# debug
#
htmaskrplc ${ARGGL5} $FRCAEIG $LNDMSK eq 0 0 $FRCAEIGM >> $LOG
htmaskrplc ${ARGGL5} $AEI     $LNDMSK eq 0 0 $AEIM     >> $LOG
htmaskrplc ${ARGGL5} $AAI     $LNDMSK eq 0 0 $AAIM     >> $LOG

# debug
DIRVAR=~/H08/H08_20230612/map/dat/aeigfrc_
maxgl5 ${DIRVAR}/GMIA5___20050000.gl5
# debug
############################################################
# draw
############################################################
gmt makecpt -T0/1/0.1 -Z > $CPT
htdraw ${ARGGL5} $FRCAEIG $CPT $EPS
htconv $EPS    $FIGFRCAEIG rot
echo Fig: $FIGFRCAEIG
htdraw ${ARGGL5} $FRCAAI $CPT $EPS
htconv $EPS    $FIGFRCAAI rot
echo Fig: $FIGFRCAAI
echo Log: $LOG

