import numpy as np

def explore_citymask(index, threshold_density=1000):

    #-----------------------------------------------
    # Initialization
    #-----------------------------------------------

    # map data
    MAP='CAMA'

    # initial radius from central point
    radius = 1

    # explore grid radius
    radius_max = 12

    # shape
    lat_shape = 2160
    lon_shape = 4320

    # date type
    dtype= 'float32'

    # h08 directory
    h08dir = '/home/kajiyama/H08/H08_20230612'

    # initialize variables
    best_threshold = None
    best_coverage = float('inf')
    best_mask = None
    best_masked_pop = None

    #-----------------------------------------------
    # load true data (UN city list) unit=[1000person]
    #-----------------------------------------------

    # true population and city name
    un_pop_list = []
    name_list = []

    # load data
    inf_path = h08dir + '/map/dat/cty_lst_/city_list03.txt'
    for l in open(inf_path).readlines():
        data = l[:-1].split('	')
        un_pop_list.append(int(data[4]))
        name_list.append(data[5])

    # get true UN city population
    un_pop = un_pop_list[index-1]*1000

    # get city name
    city_name = name_list[index-1]

    #-----------------------------------------------
    #  Get area(m2)
    #-----------------------------------------------

    area = np.fromfile(h08dir + f'/map/dat/lnd_ara_/lndara.{MAP}.gl5', dtype=dtype).reshape(lat_shape, lon_shape)

    #-----------------------------------------------
    # load gwp population data
    #-----------------------------------------------

    # population data(GWP4 2000)
    gwp_pop = np.fromfile(h08dir + '/map/dat/pop_tot_/C05_a___20000000.gl5', dtype=dtype).reshape(lat_shape, lon_shape)

    # population density (person/km2)
    gwp_pop_density = (gwp_pop / (area / 10**6))

    #-----------------------------------------------
    # load city_center coordinate
    #-----------------------------------------------

    location = np.fromfile(h08dir + f'/map/dat/cty_cnt_/city_{index:08d}.gl5',dtype=dtype).reshape(lat_shape,lon_shape)
    x = np.where(location==1)[0]
    y = np.where(location==1)[1]
    x = x[0]
    y = y[0]

    #-----------------------------------------------
    # check city center
    #-----------------------------------------------

    # original city center
    org_cnt = gwp_pop[x, y]

    # search radius
    circle = 3

    # if there is larger grid, center grid is replaced
    for a in range(x-circle, x+circle+1):
        for b in range(y-circle, y+circle+1):
            candidate = gwp_pop[a, b]
            if candidate >= org_cnt:
                org_cnt = candidate
                x = a
                y = b
                print('city center is replaced')

    #-----------------------------------------------
    #  Make save array
    #-----------------------------------------------

    # mask array for saving
    mask = np.zeros((lat_shape,lon_shape),dtype=dtype)
    mask[x,y] = 1

    # copy file of mask array
    f_mask = np.zeros((lat_shape,lon_shape),dtype=dtype)

    #-----------------------------------------------
    #  Make explore array
    #-----------------------------------------------

    # explore file
    search_1 = np.zeros((lat_shape,lon_shape),dtype=dtype)
    search_1[x,y] = 1
    search_2 = np.zeros((lat_shape,lon_shape),dtype=dtype)
    search_2[x,y] = 1

    #-----------------------------------------------
    #  Count total target search grids
    #-----------------------------------------------

    # number of grids for search in initial stage
    for a in range(x-1, x+2):
        for b in range(y-1, y+2):
            search_2[a,b] = 1
    search_total_num = np.sum(search_2-search_1)

    #-----------------------------------------------
    #  Explore start
    #-----------------------------------------------

    new_mask_added = True
    coverage_flag = True
    print(f'processing the city {city_name}...')

    while new_mask_added:
        new_mask_added = False
        for a in range(max(0, x - radius_max), min(x + radius_max + 1, lat_shape)):
            for b in range(max(0, y - radius_max), min(y + radius_max + 1, lon_shape)):
                if mask[a, b] == 1:

                    # explore surrounded 8 grids
                    for dx, dy in [(-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, 1)]:
                        if coverage_flag is True:
                            i, j = a + dx, b + dy
                            # not explored yet
                            if mask[i, j] == 0:
                                # within grid range
                                if 0 <= i < lat_shape and 0<= j < 4320:
                                    # over threshold
                                    if gwp_pop_density[i, j] > threshold_density:
                                        mask[i, j] = 1
                                        new_mask_added = True

                            # evaluate coverage
                            gwp_masked_pop = np.sum(mask * gwp_pop)
                            coverage = float(gwp_masked_pop / un_pop)

                            # stop exploring
                            if coverage >= 1.0:
                                new_mask_added = False
                                coverage_flag = False

    #-----------------------------------------------
    #  update variables
    #-----------------------------------------------

    # judge
    judge_value = abs(1 - coverage)
    best_value = abs(1 - best_coverage)

    # update
    if judge_value < best_value:
        best_threshold = threshold_density
        best_coverage = coverage
        best_mask = mask
        best_masked_pop = gwp_masked_pop
        grid_num = np.sum(best_mask)

    #-----------------------------------------------
    # Output result
    #-----------------------------------------------

    print(f"cityindex {index}\n" \
          f"threshold {best_threshold}\n" \
          f"explored_pop {best_masked_pop}\n" \
          f"true_pop {un_pop}\n" \
          f"coverage {best_coverage}\n" \
          f"city_mask {grid_num}\n" \
          f"{city_name}\n")

    return city_name, best_mask, grid_num, best_coverage, best_threshold


def thres_loop(index):

    #------------------------------------------------
    # Initialization
    #------------------------------------------------

    # affordable coverage error
    error_rate = 0.05

    # population density threshold candidate
    threshold_lst = np.arange(100, 10000, 100)

    # shape
    lat_shape = 2160
    lon_shape = 4320

    # date type
    dtype= 'float32'

    # h08 directory
    h08dir = '/home/kajiyama/H08/H08_20230612'

    # empty list
    mask_lst = []
    grid_lst = []
    coverage_lst = []
    threshold_density_lst = []

    #------------------------------------------------
    # threshold loop
    #------------------------------------------------

    threshold_added = True

    for i in threshold_lst:
        if threshold_added is True:

            print(f"threshold {i}")
            city_name, mask, grid_num, coverage, threshold_density = explore_citymask(index, i)
            mask_lst.append(mask)
            grid_lst.append(grid_num)
            coverage_lst.append(coverage)
            threshold_density_lst.append(threshold_density)

            if np.abs(1 - coverage) > error_rate:
                threshold_added = False

    #------------------------------------------------
    # Threshold loop
    #------------------------------------------------

    low_errors =  [index for index, value in enumerate(coverage_lst) if np.abs(1-value) < error_rate]
    if not low_errors:
        low_errors = [index for index, value in enumerate(coverage_lst)]
    grid_array = np.array(grid_lst)[low_errors]
    mask_array = np.array(mask_lst)[low_errors]
    coverage_array = np.array(coverage_lst)[low_errors]
    threshold_density_array = np.array(threshold_density_lst)[low_errors]

    #------------------------------------------------
    # Minumim grid_num
    #------------------------------------------------

    best_index = np.argmin(grid_array)
    best_grid = grid_array[best_index]
    best_mask = mask_array[best_index]
    best_coverage = coverage_array[best_index]
    best_threshold = threshold_density_array[best_index]

    print('#########################################')
    print('#########################################')
    print(best_threshold, best_grid, best_coverage)
    print('#########################################')
    print('#########################################\n')

    #------------------------------------------------
    # SAVE FILE
    #------------------------------------------------

    maskpath = h08dir + f'/map/dat/cty_msk_/txt/city_{index}.txt'

    ff = open(maskpath,'w')
    for l in range(0, lat_shape):
        line = best_mask[l,:]
        aaa = line.tolist()
        aaa = str(aaa)
        aa1 = aaa.strip("[")
        aa2 = aa1.strip("]")
        aa2 = aa2.strip(",")
        ff.write("\n%s"%aa2)
    ff.close()

    resultpath = h08dir + f'/map/dat/result_citymask.txt'

    if index == 1:
        with open(resultpath, 'w') as file:
            file.write(f"{city_name}, {best_threshold}, {best_coverage}, {best_grid}\n")
    else:
        with open(resultpath, 'a') as file:
            file.write(f"{city_name}, {best_threshold}, {best_coverage}, {best_grid}\n")


def main():
    for index in range(800, 901):
        thres_loop(index)


if __name__ == '__main__':
    main()
