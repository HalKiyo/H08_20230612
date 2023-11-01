#cama_to_h08
#lndmsk,rivnum
#====================settings==================================

import numpy as np
import os
#import matplotlib.pyplot as plt
#import math

## Map Dimention
nx=4320
ny=2160
latlon=[-180, 180, -90, 90] # lonmin, lonmax, latmin, latmax
tag='.CAMA.gl5'
dir_map='../glb_05min'
dir_h08='/home/kajiyama/H08/H08_20230612'

#====================function==================================
# Function to get the longitude of the grid center
def getlon(ix):
    lon = latlon[0] + (latlon[1]-latlon[0])/nx*(ix + 0.5)
    return lon

# Function to get the latitude of the grid center
def getlat(iy):
    lat = latlon[3] - (latlon[3]-latlon[2])/ny*(iy + 0.5)
    return lat

# Function to calculate x&y coordinates
def getxyz(ix, iy):
    a = 6378137.0 # Equatorial radius
    e2 = 0.006694470 # Square of the eccentricity of the Earth ellipsoid
    lon, lat = getlon(ix), getlat(iy)
    sinlon = np.sin(lon/180*np.pi)
    sinlat = np.sin(lat/180*np.pi)
    coslon = np.cos(lon/180*np.pi)
    coslat = np.cos(lat/180*np.pi)
    n = a / np.sqrt(1.0 - e2*sinlat*sinlat) # Prime-vertical radius
    x = n*coslat * coslon
    y = n*coslat * sinlon
    z = n*(1.0-e2) * sinlat
    return x, y, z

# Function to calculate the length between two points
def getlen(ix1, ix2, iy1, iy2):
    a = 6378137.0 # Equatorial radius
    x1, y1, z1 = getxyz(ix1, iy1)
    x2, y2, z2 = getxyz(ix2, iy2)
    dirlen = np.sqrt((x2-x1)**2 + (y2-y1)**2 + (z2-z1)**2)
    rad = np.arcsin(dirlen/2.0/a)
    cirlen = 2*rad * a
    return cirlen

#=====================-calculation===============================-
# read the input map
nextxy=np.fromfile(f"{dir_map}/nextxy.bin",'int32'  ).reshape(2,ny,nx)
rivseq=np.fromfile(f"{dir_map}/rivseq.bin",'int32'  ).reshape(ny,nx)
rivnum=np.fromfile(f"{dir_map}/basin.bin", 'int32'  ).reshape(ny,nx)
rivara=np.fromfile(f"{dir_map}/uparea.bin",'float32').reshape(ny,nx)
rivnxd=np.fromfile(f"{dir_map}/nxtdst_grid.bin",'float32').reshape(ny,nx)
lndara=np.fromfile(f"{dir_map}/grdare.bin", 'float32').reshape(ny, nx)
elevtn=np.fromfile(f"{dir_map}/elevtn.bin", 'float32').reshape(ny, nx)

# create empty arrays for output
rivnxl=np.zeros((ny,nx))
#lndmsk=np.zeros((ny,nx))
#rivmou=np.zeros((ny,nx))

# River Network Map (nextxy): convert from 2D to 1D // next grid 2D = [jx,jy] --> next grid 1D = [(jy-1)*nx + jx]
for i in range(ny) :
    for j in range(nx) :
        # river mouth
        if nextxy[0,i,j]==-9:
            rivnxl[i,j]=i*nx + (j+1)
        # inland termination
        elif nextxy[0,i,j]==-10:
            rivnxl[i,j]=i*nx + (j+1)
        elif nextxy[0,i,j]>0:
            rivnxl[i,j]=(nextxy[1,i,j]-1)*nx + nextxy[0,i,j]
        else:
            rivnxl[i,j]=0

# land sea mask
lndmsk = np.where(nextxy[0] == -9999, 0, 1)
#for i in range(ny) :
#    for j in range(nx) :
#        if nextxy[0,i,j]==-9999:
#            lndmsk[i,j]=0
#        else :
#            lndmsk[i,j]=1

# river mouth mask
rivmou = np.where(nextxy[0]==-9999, 0,
                  np.where((nextxy[0]==-9) | (nextxy[0]==-10), 9, 1))
#for i in range(ny) :
#    for j in range(nx) :
#        if nextxy[0,i,j]==-9999:
#            rivmou[i,j]=0
#        elif nextxy[0,i,j]==-9:
#            rivmou[i,j]=9
#        else:
#            rivmou[i,j]=1

# river sequence
rivseq = np.where(rivseq==-9999, 0, rivseq)
#for i in range(ny) :
#    for j in range(nx) :
#        if rivseq[i,j]==-9999:
#            rivseq[i,j]=0

#basin to rivnum
rivnum = np.where(rivnum==-9999, 0, rivnum)
#for i in range(ny):
#    for j in range(nx):
#        if rivnum[i,j]<-9999:
#            rivnum[i,j]=0

#uparea to rivara
rivara = np.where(rivara==-9999.0, 1.e20, rivara)
#for i in range(ny):
#    for j in range(nx):
#        if rivara[i,j]==1.e20:
#            rivara[i,j]=0

# nextdst to rivnxd
rivnxd = np.where((rivnxd==-9999.0), 0, rivnxd)
for i in range(ny):
    for j in range(nx):
        if rivmou[i, j] == 9:
            if i == 0:
                rivnxd[i, j] = getlen(j, j, i, i+1)
            else:
                rivnxd[i, j] = getlen(j, j, i, i-1)
        elif rivnxd[i, j] == 25000.:
            if i == 0:
                rivnxd[i, j] = getlen(j, j, i, i+1)
            else:
                rivnxd[i, j] = getlen(j, j, i, i-1)

# grdare to lndara
lndara = np.where(lndara==-9999.0, 1.e20, lndara)

#elevation data
for i in range(ny):
    for j in range(nx):
        if elevtn[i,j]==-9999:
#            elevtn[i,j]=1.e20
            elevtn[i,j]=0

#================write down the data========================
rivnxl.astype(np.float32).tofile(f"{dir_h08}/map/out/riv_nxl_/rivnxl{tag}")
rivseq.astype(np.float32).tofile(f"{dir_h08}/map/out/riv_seq_/rivseq{tag}")
lndmsk.astype(np.float32).tofile(f"{dir_h08}/map/dat/lnd_msk_/lndmsk{tag}")
lndara.astype(np.float32).tofile(f"{dir_h08}/map/dat/lnd_ara_/lndara{tag}")
rivnum.astype(np.float32).tofile(f"{dir_h08}/map/out/riv_num_/rivnum{tag}")
rivara.astype(np.float32).tofile(f"{dir_h08}/map/out/riv_ara_/rivara{tag}")
rivnxd.astype(np.float32).tofile(f"{dir_h08}/map/out/riv_nxd_/rivnxd{tag}")
if not os.path.isdir(f"{dir_h08}/map/out/riv_mou_"):
    os.mkdir(f"{dir_h08}/map/out/riv_mou_")
rivmou.astype(np.float32).tofile(f"{dir_h08}/map/out/riv_mou_/rivmou{tag}")
elevtn.astype(np.float32).tofile(f"{dir_h08}/map/dat/elv_min_/elevtn{tag}")
