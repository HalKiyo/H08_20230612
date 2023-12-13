import numpy as np

def explore_citymask(index, threshold_density=1000):
    # index=23: Jakarta

    #-----------------------------------------------
    # Initialization
    #-----------------------------------------------

    # map data
    MAP='CAMA'

    # initial radius from central point
    radius = 1

    # explore grid radius
    radius_max = 12

    #-----------------------------------------------
    # load true data (UN city list)
    #-----------------------------------------------

    pop_list = []
    name_list = []
    inf_path = '/home/kajiyama/H08/H08_20230612/map/dat/cty_lst_/city_list03.txt'
    for l in open(inf_path).readlines():
        data = l[:-1].split('	')
        pop_list.append(int(data[4]))
        name_list.append(data[5])

    #-----------------------------------------------
    # load population and ared data
    #-----------------------------------------------

    # population data(GWP4 2000)
    pop = np.fromfile('/home/kajiyama/H08/H08_20230612/map/dat/pop_tot_/C05_a___20000000.gl5', 'float32').reshape(2160, 4320)
    area = np.fromfile(f'/home/kajiyama/H08/H08_20230612/map/dat/lnd_ara_/lndara.{MAP}.gl5', 'float32').reshape(2160, 4320)

    #-----------------------------------------------
    # load city_center coordinate
    #-----------------------------------------------

    location = np.fromfile(f'/home/kajiyama/H08/H08_20230612/map/dat/cty_cnt_/city_{index:08d}.gl5','float32').reshape(2160,4320)
    x = np.where(location==1)[0]
    y = np.where(location==1)[1]
    x = x[0]
    y = y[0]

    #-----------------------------------------------
    # check if city center is right
    #-----------------------------------------------
    org_cnt = pop[x, y]
    circle=3
    for a in range(x-circle, x+circle+1):
        for b in range(y-circle, y+circle+1):
            candidate = pop[a, b]
            if candidate >= org_cnt:
                org_cnt = candidate
                x = a
                y = b

    #-----------------------------------------------
    #  Get city population and city name
    #-----------------------------------------------

    pop_city = pop_list[index-1]*1000
    city_name = name_list[index-1]

    #-----------------------------------------------
    #  Get area(km2) and population per grid
    #-----------------------------------------------

    A = area[x,y]/1000./1000.
    threshold = threshold_density * A

    #-----------------------------------------------
    #  Make save array
    #-----------------------------------------------

    # mask array for saving
    mask = np.zeros((2160,4320),'float32')
    mask[x,y] = 1

    # copy file of mask array
    f_mask = np.zeros((2160,4320),'float32')

    #-----------------------------------------------
    #  Make explore array
    #-----------------------------------------------

    # explore file
    search_1 = np.zeros((2160,4320),'float32')
    search_1[x,y] = 1
    search_2 = np.zeros((2160,4320),'float32')
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

    while search_total_num>0 and radius<radius_max:
        print(f"################## radius = {radius} ##################")
        for a in range(2160):
            for b in range(4320):
                if search_2[a,b]==1:
                    if pop[a,b]>threshold and radius<radius_max:
                        # explore match grid
                        if mask[a-1,b-1]==1 or mask[a,b-1]==1 or mask[a+1,b-1]==1 or mask[a-1,b]==1 or mask[a+1,b]==1 or mask[a-1,b+1]==1 or mask[a,b+1]==1 or mask[a+1,b+1]==1:
                            mask[a,b] = 1

                        # evaluate coverage
                        mp = mask*pop
                        pop_mask = np.sum(mp)
                        coverage = float(pop_mask/pop_city)

                        # stop exploring
                        if coverage >= 1.0:
                            radius = radius_max


        # update radius
        radius += 1

        # update search_1
        search_1 = np.copy(search_2)

        # search area with updated radius
        for c in range(x-radius, x+radius+1):
            for d in range(y-radius, y+radius+1):
                search_2[c,d] = 1

        # diffirence between previous radius and updated radius
        search_2 = search_2-search_1

        # increament in masks
        search_total_num = np.sum(mask-f_mask)

        # update mask copy
        f_mask = np.copy(mask)

    #-----------------------------------------------
    # Output result
    #-----------------------------------------------

    grid_num = np.sum(mask)
    city_A = mask*A
    city_area = np.sum(city_A)

    print(f"cityindex {index}\n" \
          f"threshold {threshold}\n" \
          f"explored_pop {pop_mask}\n" \
          f"true_pop {pop_city}\n" \
          f"coverage {coverage}\n" \
          f"city_mask {grid_num}\n" \
          f"city_area {city_area}\n" \
          f"{city_name}\n")

    return city_name, mask, grid_num, coverage, threshold_density


def thres_loop(index):

    #------------------------------------------------
    # Initialization
    #------------------------------------------------

    error_rate = 0.01
    threshold_lst = np.arange(100, 2000, 100)
    mask_lst = []
    grid_lst = []
    coverage_lst = []
    threshold_density_lst = []

    #------------------------------------------------
    # threshold loop
    #------------------------------------------------

    for i in threshold_lst:
        print(f"threshold {i}")
        city_name, mask, grid_num, coverage, threshold_density = explore_citymask(index, i)
        mask_lst.append(mask)
        grid_lst.append(grid_num)
        coverage_lst.append(coverage)
        threshold_density_lst.append(threshold_density)

    #------------------------------------------------
    # Threshold loop
    #------------------------------------------------

    low_errors =  [index for index, value in enumerate(coverage_lst) if np.abs(1-value) < error_rate]
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

    print(best_threshold, best_grid, best_coverage)

    #------------------------------------------------
    # SAVE FILE
    #------------------------------------------------

    maskpath = f'/home/kajiyama/H08/H08_20230612/map/dat/cty_msk_/txt/city_{index}.txt'

    ff = open(maskpath,'w')
    for l in range(0,2160):
        line = best_mask[l,:]
        aaa = line.tolist()
        aaa = str(aaa)
        aa1 = aaa.strip("[")
        aa2 = aa1.strip("]")
        aa2 = aa2.strip(",")
        ff.write("\n%s"%aa2)
    ff.close()

    resultpath = f'/home/kajiyama/H08/H08_20230612/map/dat/result_citymask.txt'

    with open(resultpath, 'w') as file:
        file.write(f"{city_name}, {best_threshold}, {best_coverage}, {best_grid}\n")


def main():
    for index in range(1, 901):
        thres_loop(index)


if __name__ == '__main__':
    main()
