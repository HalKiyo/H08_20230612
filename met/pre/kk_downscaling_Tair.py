from netCDF4 import Dataset
from numpy import *
import numpy as np
import sys
import os
from datetime import date
#------------------------------------

GCM = 'W5E5____'
yr_start = 2019
yr_end   = 2019
yr_END   = yr_end + 1
#total_RAIN = 0
num_yr   = yr_end - yr_start +1
#grid num. of gtopo30
# 20/12 ==> 300/180

#hlf = np.fromfile('../../map/dat/elevtn__/ETOP01.hlf','float32').reshape(360,720)
hlf = np.fromfile('/home/kajiyama/H08/H08_20230612/map/dat/elv_min_/ETOPO1__00000000.hlf','float32').reshape(360,720)
#gl5 = np.zeros((2160,4320),dtype='float32')
gl5 = np.fromfile('/home/kajiyama/H08/H08_20230612/map/dat/elv_min_/ETOPO1__00000000.gl5','float32')
#print gl5.shape

#for a in range(0,360):
# for b in range (0,720):
#  for x in range(0,6):
#   for y in range(0,6):
#    IDX = a*6+x
#    IDY = b*6+y
#    gl5[IDX,IDY] = hlf[a,b]

#--------------------------
#  Target elevation
#g0=fromfile(gl5,'float32')
g1=gl5

LL=9331200
x=4320
y=2160
#------------------------------
#  Previous elevation
#G0=fromfile(hlf,'float32')
G2=hlf
a=720
b=360

#--------------------------
name=str("_hlf")
b_name=str("_gl5")
suf=str(".hlf")  #input suf
#-------------------------
ELV=[]
for i in range(b):
    elv=[]
    for j in range(a):
        ff=G2[i,j]
        elv.append(ff)
        elv.append(ff)
        elv.append(ff)
        elv.append(ff)
        elv.append(ff)
        elv.append(ff)
    ELV.extend(elv)
    ELV.extend(elv)
    ELV.extend(elv)
    ELV.extend(elv)
    ELV.extend(elv)
    ELV.extend(elv)

#######################################################################
# job start
#######################################################################
for j in range(yr_start,yr_END):
    if (j % 4) == 0:
        if j == 2100:
            t_data = 365    ###2100
            mon_str=[1,31,28,31,30,31,30,31,31,30,31,30,31]  #2100
        else:
            t_data = 366
            mon_str=[1,31,29,31,30,31,30,31,31,30,31,30,31]
    else:
        t_data = 365
        mon_str=[1,31,28,31,30,31,30,31,31,30,31,30,31]

    for m in range(1,13):
        num=mon_str[m]
        if ( m == 0 ):
            time = "%04d%02d00"%(j,m)
            pr_name = "/home/kajiyama/H08/H08_20230612/met/dat/Tair____/"+GCM+time+suf  
            nc = fromfile(pr_name,'float32')
            nc1= nc.reshape(b,a)  
            NC = []
            for tt in range(b):
                nc0=[]
                for tt1 in range(a):
                    temp=nc1[tt,tt1]
                    nc0.append(temp)
                    nc0.append(temp)
                    nc0.append(temp)
                    nc0.append(temp)
                    nc0.append(temp)
                    nc0.append(temp)
                NC.extend(nc0)
                NC.extend(nc0)
                NC.extend(nc0)
                NC.extend(nc0)
                NC.extend(nc0)
                NC.extend(nc0)

            fname="/home/kajiyama/H08/H08_20230612/met/org/W5E5v2/daily/tas/" \
                  f"tas{j}{m:02}{day:02}{b_name}.txt"
            fil=open(fname,'w')
            for n in range(LL):
                tp0=NC[n]
                tp1=tp0-0.0065*(g1[n]-ELV[n])
                tp2=str(tp1)
                fil.write(tp2)
                fil.write(",")
                fil.write(" ")
                NN=n+1
                if (NN % x) == 0:
                    fil.write("\n")
            fil.close()

        else:
            for i in range(1,num+1):
                day=i
                print('%d/%d/%d'%(j,m,day))
                time = "%04d%02d%02d"%(j,m,day) 
                pr_name = "/home/kajiyama/H08/H08_20230612/met/dat/Tair____/"+GCM+time+suf 
                nc = fromfile(pr_name,'float32')  
                nc1= nc.reshape(b,a)  
                NC = []
                for tt in range(b):
                    nc0=[]
                    for tt1 in range(a):
                        temp=nc1[tt,tt1]
                        nc0.append(temp)
                        nc0.append(temp)
                        nc0.append(temp)
                        nc0.append(temp)
                        nc0.append(temp)
                        nc0.append(temp)
                    NC.extend(nc0)
                    NC.extend(nc0)
                    NC.extend(nc0)
                    NC.extend(nc0)
                    NC.extend(nc0)
                    NC.extend(nc0)

                fname="/home/kajiyama/H08/H08_20230612/met/org/W5E5v2/daily/tas/" \
                      f"tas{j}{m:02}{day:02}{b_name}.txt"
                fil=open(fname,'w')
                for n in range(LL):
                    tp0=NC[n]
                    tp1=tp0-0.0065*(g1[n]-ELV[n])
                    tp2=str(tp1)
                    fil.write(tp2)
                    fil.write(",")
                    fil.write(" ")
                    NN=n+1 
                    if (NN % x) == 0:
                        fil.write("\n")

                fil.close()
print('---------------------------')

