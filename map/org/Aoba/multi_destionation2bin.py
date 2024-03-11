import numpy as np

state='destination'

nx=4320
ny=2160
n0ord=2


aq1 = np.fromfile('../../map/dat/city_water_map/explicit_city_%s1.gl5'%(state),'float32').reshape(ny,nx)
aq2 = np.fromfile('../../map/dat/city_water_map/explicit_city_%s2.gl5'%(state),'float32').reshape(ny,nx)
#aq3 = np.fromfile('../../map/org/Existing/existing_%s_3.gl5'%(state),'float32').reshape(ny,nx)
#aq4 = np.fromfile('../../map/org/Existing/existing_%s_4.gl5'%(state),'float32').reshape(ny,nx)


can = np.full((n0ord,ny,nx),1e+20)

for a in range(ny):
    for b in range(nx):
        if aq1[a,b] > 0:
            print(aq1[a,b])
            can[0,a,b] = aq1[a,b]		
        if aq2[a,b] > 0:
            print(aq2[a,b])
            can[1,a,b] = aq2[a,b]
#		if aq3[a,b] > 0:
#			print(aq3[a,b])
#			can[2,a,b] = aq3[a,b]
#		if aq4[a,b] > 0:
#			print(aq4[a,b])
#			can[3,a,b] = aq4[a,b]

can.astype(np.float32).tofile(f'../../map/org/Existing/explicit_{state}.bin')
