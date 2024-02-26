"""
Author Doi @ 20210331
modified by Kajiyama @20230913
modified by kajiyama @20240224
+ intake point should be higher than nearest city mask grid
+ inter basin water transfer should be prepared using shumilova 2018
+ intake point should be .gl5 file for each cities

explore maximum intake point around city mask automatically
"""
import numpy as np

#################################################################################################################
# INIT
#################################################################################################################
root_dir = "/home/kajiyama/H08/H08_20230612" # @kajiyama
savefile = '/map/dat/cty_int_/city_water_intake.txt'
NAME='W5E5'
SUF = ".gl5"
dtype='float32'
year_start = 2019
year_end = 2020
sum_year = year_end - year_start
lat_num = 2160
lon_num = 4320
loop_num = 900 # city number
can_exp = 2
exp_range = 12 # grid radius of exploring square area

# runoff data
for y in range(year_start, year_end, 1):
    riv_dis_1 = np.fromfile(f'{root_dir}/riv/out/riv_out_/{NAME}LR__{y}0000{SUF}', dtype=dtype).reshape(lat_num, lon_num)
    if y == year_start:
        riv_dis = np.fromfile(f'{root_dir}/riv/out/riv_out_/{NAME}LR__{y}0000{SUF}', dtype=dtype).reshape(lat_num, lon_num)
    else:
        riv_dis = riv_dis + riv_dis_1
# average runoff
riv_dis = riv_dis/sum_year

# canal map
can_in = np.fromfile(f'{root_dir}/map/org/K14/in__3___20000000{SUF}', dtype=dtype).reshape(lat_num, lon_num)
can_out = np.fromfile(f'{root_dir}/map/org/K14/out_3___20000000{SUF}', dtype=dtype).reshape(lat_num, lon_num)

#################################################################################################################
# JOB
#################################################################################################################

# city number loop
for num in range(1, loop_num+1, 1):   ##cheak city number##
    # city center indices is sotred to x & y
    city_mask = np.fromfile(f'{root_dir}/map/dat/cty_msk_/city_{num:08}{SUF}', dtype=dtype).reshape(lat_num, lon_num)
    city_center = np.fromfile(f'{root_dir}/map/dat/cty_cnt_/city_{num:08}{SUF}', dtype=dtype).reshape(lat_num, lon_num)
    x = np.where(city_center==1)[0]
    y = np.where(city_center==1)[1]
    x = int(x[0])
    y = int(y[0])
    #print(x[0]) #651
    #print(y[0]) #3836

    # indices of city center
    indices = np.where(city_center==1)
    indices = np.array(indices)
    #print(indices) # [[651] [3826]]
    #print(indices.shape) # (2, 1)

    # what's this?
    riv = 0
    can_check = city_mask*can_out
    #print(can_check.shape) # 2160, 4320
    #print(np.sum(can_check)) # 0

    # LON LAT
    if np.sum(can_check)>0:
        canal = 'canal_yes'
        canal_num = np.unique(can_check)
        #print(canal_num) # [0. 100.]
        canal_num = [uni for uni in canal_num if uni>0]
        #print(canal_num) # [100.]
        # canal unique number loop
        for N in canal_num:
            can_ind = np.where(can_in==N)
            can_ind = np.array(can_ind)
            #print(can_ind) # [[711, 711, 717], [2529, 2541, 2547]]
            #print(can_ind.shape) # (2, 3)
            # canal grid loop
            for NN in range(can_ind.shape[1]):
                # explore grids around canal
                for p in range(-can_exp, can_exp, 1):
                    for q in range(-can_exp, can_exp, 1):
                        X = can_ind[0, NN] + p
                        Y = can_ind[1, NN] + q
                        # check whether maximum or not
                        if riv_dis[X,Y]/1000.>riv:
                            # update riv to explore maximum intake point
                            riv = riv_dis[X,Y]/1000.
                            LON = 0.08333333*Y-180+(0.0833333*0.5)
                            LAT = 90-0.08333333*X-(0.08333333*0.5)
    # if no canal
    else:
        canal = 'canal_no'
        # explore all grid
        for p in range(-exp_range, exp_range+1, 1):
            for q in range(-exp_range, exp_range+1, 1):
                X = x + p
                Y = y + q
                #print(x, y) # 651 3836
                dis = []
                # city center indices loop
                for C in range(indices.shape[1]):
                    a = np.array([int(X), int(Y)])
                    XX = indices[0, C]
                    YY = indices[1, C]
                    #print(XX, YY) # 651 3836
                    b = np.array([int(XX), int(YY)])
                    # distance between center and explored grid
                    d = a - b
                    #print(d) # [-50, -50]
                    distance = max(abs(d[0]), abs(d[1]))
                    #print(distance) # 50
                    dis.append(distance)
                if len(dis)>0:
                    if min(dis)>=0:
                        # check if maximum
                        # @ Where do humans build levees?
                        # A case study on the contiguous united states
                        if riv_dis[X,Y]/1000.>riv:
                            # update riv
                            riv = riv_dis[X,Y]/1000.
                            LON = 0.08333333*Y-180+(0.0833333*0.5)
                            LAT = 90-0.08333333*X-(0.08333333*0.5)

    # make sasve file
    ext = [int(num), float(riv), float(LON), float(LAT), canal]
    print(ext)
    if num==1:
        LIST = ext
    elif num==2:
        LIST.extend(ext)
        LIST = np.array(LIST).reshape(2, len(ext))
    else:
        list_len = LIST.shape[0]
        LIST = np.insert(LIST, list_len, ext, axis=0)

#################################################################################################################
# SAVE
#################################################################################################################

ff = open(f'{root_dir}{savefile}', 'w')

for l in range(0, loop_num, 1):
    line = LIST[l, :]
    aaa = line.tolist()
    aaa = str(aaa)
    aa1 = aaa.strip("[")
    aa2 = aa1.strip("]")
    aa2 = aa2.strip(",")
    modified = aa2.replace("'", "")
    space = modified.replace(",", " ")
    print(space)
    ff.write("\n%s"%space)
ff.close()
