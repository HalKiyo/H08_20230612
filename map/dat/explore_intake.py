"""
Author Doi @ 20210331
modified by Kajiyama @20230913
modified by kajiyama @20240224
+ inter basin water transfer should be prepared using shumilova 2018
+ intake point should be .gl5 file for each cities

explore maximum intake point around city mask automatically
"""
import numpy as np

#################################################################################################################
# INIT
#################################################################################################################

root_dir = '/home/kajiyama/H08/H08_20230612' # @kajiyama
savefile = 'map/dat/cty_int_/city_water_intake.txt'

NAME= 'W5E5'
MAP= '.CAMA'
SUF = '.gl5'
dtype= 'float32'
year_start = 2019
year_end = 2020
lat_num = 2160
lon_num = 4320
loop_num = 900 # total city number (1-900)
can_exp = 2    # grid radius for canal grid modification exploring
exp_range = 12 # grid radius of exploring square area

# river discharge data
for y in range(year_start, year_end, 1):

    dis_path = f"{root_dir}/riv/out/riv_out_/{NAME}LR__{y}0000{SUF}"
    riv_dis_tmp = np.fromfile(dis_path, dtype=dtype).reshape(lat_num, lon_num)

    if y == year_start:
        riv_dis = riv_dis_tmp
    else:
        riv_dis = riv_dis + riv_dis_tmp

# annual average discharge
riv_dis = riv_dis/(year_end - year_start)

# canal map
can_in_path = f"{root_dir}/map/org/K14/in__3___20000000{SUF}"
can_in = np.fromfile(can_in_path, dtype=dtype).reshape(lat_num, lon_num)
can_out_path = f"{root_dir}/map/org/K14/out_3___20000000{SUF}"
can_out = np.fromfile(can_out_path, dtype=dtype).reshape(lat_num, lon_num)

# elevation map
elv_path = f"{root_dir}/map/dat/elv_min_/elevtn{MAP}{SUF}"
elv = np.fromfile(elv_path, dtype=dtype).reshape(lat_num, lon_num)

# water shed number map
rivnum_path = f"{root_dir}/map/out/riv_num_/rivnum{MAP}{SUF}"
rivnum = np.fromfile(rivnum_path, dtype=dtype).reshape(lat_num, lon_num)

#################################################################################################################
# JOB
#################################################################################################################

# city number loop
for city_num in range(1, loop_num+1, 1):   ##cheak city number##

    # city mask data
    msk_path = f"{root_dir}/map/dat/cty_msk_/city_{city_num:08}{SUF}"
    city_mask = np.fromfile(msk_path, dtype=dtype).reshape(lat_num, lon_num)

    # maximum elevation within city mask
    elv_max = max(elv[city_mask == 1])
    #print(elv_max) # 278.7

    # purification plant location
    prf_path = f"{root_dir}/map/dat/cty_prf_/city_{city_num:08}{SUF}"
    intake = np.fromfile(prf_path, dtype=dtype).reshape(lat_num, lon_num)

    # intake water basin
    cty_rivnum = np.unique(rivnum[intake == 1])
    cty_rivnum = [rnu for rnu in cty_rivnum if rnu > 0]
    #print(cty_rivnum) # [848.0, 2718.0, 4850.0, 6065.0]

    # city center data
    cnt_path = f"{root_dir}/map/dat/cty_cnt_/modified/city_{city_num:08}{SUF}"
    city_center = np.fromfile(cnt_path, dtype=dtype).reshape(lat_num, lon_num)

    # indices of city center
    indices = np.where(city_center==1) # tuple
    x = int(indices[0])
    y = int(indices[1])
    #print(x) #651
    #print(y) #3836

    # init maximum river discharge
    riv_max = 0

    # canal_out within city mask
    can_check = city_mask*can_out
    #print(np.sum(can_check)) # 0

    # if canal exists
    if np.sum(can_check)>0:
        canal = 'canal_yes'

        # canal number
        canal_unq = np.unique(can_check)
        canal_lst = [uni for uni in canal_unq if uni>0]
        #print(canal_lst) # [100.]

        # canal unique number loop
        for canal_num in canal_lst:
            # indices of canal in
            can_ind = np.where(can_in==canal_num) # tuple
            can_ind = np.array(can_ind)
            #print(can_ind) # [[711, 711, 717], [2529, 2541, 2547]]
            #print(can_ind.shape) # (2, 3)

            # canal grid loop
            for C in range(can_ind.shape[1]):
                # explore grids around canal
                for p in range(-can_exp, can_exp):
                    for q in range(-can_exp, can_exp):
                        X = can_ind[0, C] + p
                        Y = can_ind[1, C] + q
                        # maximum or not check
                        if riv_dis[X,Y]/1000. > riv_max:
                            # update riv_max to explore maximum intake point
                            riv_max = riv_dis[X,Y]/1000.
                            # LON LAT
                            LON = 0.08333333*Y-180+(0.0833333*0.5)
                            LAT = 90-0.08333333*X-(0.08333333*0.5)

    # if no canal
    else:
        canal = 'canal_no'

        # explore grids
        for p in range(-exp_range, exp_range+1, 1):
            for q in range(-exp_range, exp_range+1, 1):

                # explored grid indices from city center
                X = x + p
                Y = y + q
                #print(x, y) # 651 3836

                # out of city mask
                if city_mask[X, Y] != 1:

                    # intake point shoud be higher than city's maximum elevation
                    if elv[X, Y] > elv_max:

                        # river num (watershed) is not overlapped with that of inner city
                        if rivnum[X, Y] not in cty_rivnum:

                            # check if maximum
                            if riv_dis[X,Y]/1000.>riv_max:
                                print(riv_dis[X, Y], elv[X, Y], rivnum[X, Y])
                                # update riv
                                riv_max = riv_dis[X,Y]/1000.
                                LON = 0.08333333*Y-180+(0.0833333*0.5)
                                LAT = 90-0.08333333*X-(0.08333333*0.5)

    exit()

    # make save file
    ext = [int(city_num), float(riv_max), float(LON), float(LAT), canal]
    print(ext)
    if city_num==1:
        LIST = ext
    elif city_num==2:
        LIST.extend(ext)
        LIST = np.array(LIST).reshape(2, len(ext))
    else:
        list_len = LIST.shape[0]
        LIST = np.insert(LIST, list_len, ext, axis=0)

#################################################################################################################
# SAVE
#################################################################################################################

ff = open(f"{root_dir}{savefile}", 'w')

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
