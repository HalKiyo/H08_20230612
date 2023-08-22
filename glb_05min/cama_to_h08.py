#cama_to_h08
#lndmsk,rivnum
#====================settings==================================

import numpy as np
#import matplotlib.pyplot as plt
#import math

## Map Dimention
nx=4320
ny=2160
tag='.CAMA.gl5'
output='./'

print(len('./rivseq.bin'))
nextxy=np.fromfile('./nextxy.bin','int32'  ).reshape(2,ny,nx)
rivseq=np.fromfile('./rivseq.bin','int32'  ).reshape(ny,nx)
rivnum=np.fromfile('./basin.bin', 'int32'  ).reshape(ny,nx)
rivara=np.fromfile('./uparea.bin','float32').reshape(ny,nx)
elevtn=np.fromfile('./elevtn.bin','float32').reshape(ny,nx)
print(rivseq)

# edit your directory
#H08='/work/a03/nyoden/H08_20210301'
#H08='/home/kajiyama/H08/H08_20230612'
#=====================-calculation===============================-

rivnxl=np.zeros((ny,nx))
lndmsk=np.zeros((ny,nx))
rivmou=np.zeros((ny,nx))

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
for i in range(ny) :
    for j in range(nx) :
        if nextxy[0,i,j]==-9999:
            lndmsk[i,j]=0
        else :
            lndmsk[i,j]=1

# river mouth mask
for i in range(ny) :
    for j in range(nx) :
        if nextxy[0,i,j]==-9999:
            rivmou[i,j]=0
        elif nextxy[0,i,j]==-9:
            rivmou[i,j]=9
        else:
            rivmou[i,j]=1

# river sequence
for i in range(ny) :
    for j in range(nx) :
        if rivseq[i,j]==-9999:
            rivseq[i,j]=0

#basin to rivnum
for i in range(ny):
    for j in range(nx):
        if rivnum[i,j]<-9999:
            rivnum[i,j]=0

#uparea to rivara
for i in range(ny):
    for j in range(nx):
        if rivara[i,j]==1.e20:
            rivara[i,j]=0

#elevation data
for i in range(ny):
    for j in range(nx):
        if elevtn[i,j]==-9999:
            elevtn[i,j]=1.e20


#================write down the data========================

#rivnxl.astype(np.float32).tofile('%s/riv_nxl_/rivnxl'%output+tag)
#rivseq.astype(np.float32).tofile('%s/riv_seq_/rivseq'%output+tag)
#lndmsk.astype(np.float32).tofile(f"{H08}/map/dat/lnd_ara_/lndmsk"+tag)
#rivnum.astype(np.float32).tofile('%s/riv_num_/rivnum'%output+tag)
#rivara.astype(np.float32).tofile('%s/riv_ara_/rivara'%output+tag)
#rivmou.astype(np.float32).tofile('%s/rivmou'%output+tag)
#elevtn.astype(np.float32).tofile('%s/elevtn'%output+tag)
