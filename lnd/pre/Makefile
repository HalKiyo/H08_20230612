#to     compile source code in lnd/bin
#on     2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
#	Macro (Basics)
############################################################
include   ../../adm/Mkinclude
DIRLIB  = ../../lib/
DIRRIV  = ../../riv/bin/
DIRDAM  = ../../dam/bin/
DIRCPL  = ../../cpl/bin/
OBJS    = prog_gwr_fa prog_gwr_fp prog_gwr_fr prog_gwr_ft
############################################################
#	Macro (Settings)
############################################################
.f.o:
	$(FC) -c ${FCFLAGS} $<
.F.o:
	${FC} -c ${FCFLAGS} -I${INC} $<
############################################################
#	Dependency
############################################################
TARGET7    = prog_gwr_ft
COMPONENT7 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o
TARGET6    = prog_gwr_fr
COMPONENT6 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o
TARGET5    = prog_gwr_fp
COMPONENT5 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o
TARGET4    = prog_gwr_fa
COMPONENT4 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o
############################################################
#	Compilation
############################################################
#$(TARGET1) : $(TARGET1).o $(COMPONENT1)
#	gfortran -finit-local-zero -O3 -fd-lines-as-comments -mcmodel=large -o $@ $@.o $(COMPONENT1)
#$(TARGET2) : $(TARGET2).o $(COMPONENT2)
#	gfortran -finit-local-zero -O3 -fd-lines-as-comments -mcmodel=large -o $@ $@.o $(COMPONENT2)
$(TARGET4) : $(TARGET4).o $(COMPONENT4)
	$(FC) -o $@ $@.o $(COMPONENT4)
$(TARGET5) : $(TARGET5).o $(COMPONENT5)
	$(FC) -o $@ $@.o $(COMPONENT5)
$(TARGET6) : $(TARGET6).o $(COMPONENT6)
	$(FC) -o $@ $@.o $(COMPONENT6)
$(TARGET7) : $(TARGET7).o $(COMPONENT7)
	$(FC) -o $@ $@.o $(COMPONENT7)
all : $(OBJS)
clean : 
	rm -f *.o *~ temp*

