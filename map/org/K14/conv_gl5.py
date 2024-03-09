#! bin/python 
#########################
# 2021/3 by Doi
# make gl5 file with num
# from original txt file(lon lat, num)
#
# origin=  "in__3___20000000.txt"
# orginout="out_3___20000000.txt"
#
# make ("in__3___20000000.gl5.org")
# make ("out_3___20000000.gl5.org")
# make ("in__3___20000000.gl5.txt.org")
# make ("out_3___20000000.gl5.txt.org")
#########################
#
import numpy as np 
import re
import os 

#--
nx,ny=(4320,2160)
suf=".gl5"
dx=1./12.
dy=1./12.
#---
#########################
def conv_latlon(lon,lat):
  ix=int((lon+180.-(dx/2.))*12.)
  iy=int(((90-(dy/2.))-lat)*12.)
  return ix,iy
##########################
def conv_xy(ix,iy):
  lon=(-180.+dx/2.0)+ix*dx
  lat=(90-dy/2.0)-iy*dy
  return lon,lat
#########################
binin  = np.zeros([ny,nx],np.float32)
binout = np.zeros([ny,nx],np.float32)
#--location in---
orgin="in__3___20000000.txt"
with open(orgin, "r") as f:
    lines = f.readlines()
#--
for line in lines[:-1]:
    line = list(filter(None, re.split(" ",line)))
    lon  = float(line[0])
    lat  = float(line[1])
    grid = int(line[2])
    num  = float(line[3])
    ix,iy =  conv_latlon(lon,lat)
    binin[iy,ix]=num
######
#--location in---
orgout="out_3___20000000.txt"
with open(orgout, "r") as f:
    lines = f.readlines()
#--
for line in lines[0:-1]:
    line = list(filter(None, re.split(" ",line)))
    lon  = float(line[0])
    lat  = float(line[1])
    grid = int(line[2])
    num  = float(line[3])
    ix,iy =  conv_latlon(lon,lat)
    binout[iy,ix]=num
#--save
binin.tofile("in__3___20000000.gl5.org")
binout.tofile("out_3___20000000.gl5.org")
#--
#os.system("./prog_K14_gl5 "+os.getenv("L2XHLF")+" "+os.getenv("L2YHLF")+" "+os.getenv("L2XGL5")+" "+os.getenv("L2YGL5")+" "+"out_3___20000000.hlf out_3___20000000.gl5.org")
os.system("../../pre/prog_K14_gl5 "+os.getenv("L2XHLF")+" "+os.getenv("L2YHLF")+" "+os.getenv("L2XGL5")+" "+os.getenv("L2YGL5")+" "+"out_3___20000000.hlf out_3___20000000.gl5.org")

#--
os.system("sh bin2txt.sh in__3___20000000.gl5.org in__3___20000000.gl5.txt.org")
os.system("sh bin2txt.sh out_3___20000000.gl5.org out_3___20000000.gl5.txt.org")
