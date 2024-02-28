import numpy as np
import matplotlib.pyplot as plt

def explore_citymask(index):

    #-----------------------------------------------
    # Initialization
    #-----------------------------------------------

    # map data
    MAP='CAMA'

    # explore grid radius
    radius_max = 12

    # search radius (1grid in 0.5degree)
    circle = 3

    # lower limitation of population density
    # if lowlim>=1e-9, tokyo mask looks like doi & kato's result
    lowlim = 100

    # initial grid threshold
    threshold = 100

    # shape
    lat_shape = 2160
    lon_shape = 4320

    # date type
    dtype= 'float32'

    # h08 directory
    h08dir = '/home/kajiyama/H08/H08_20230612'

    # initialize variables
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

    area_path = f'{h08dir}/map/dat/lnd_ara_/lndara.{MAP}.gl5'
    area = np.fromfile(area_path, dtype=dtype).reshape(lat_shape, lon_shape)

    #-----------------------------------------------
    # load gwp population data
    #-----------------------------------------------

    # population data(GWP4 2000)
    pop_path = f'{h08dir}/map/dat/pop_tot_/C05_a___20000000.gl5'
    gwp_pop = np.fromfile(pop_path, dtype=dtype).reshape(lat_shape, lon_shape)

    # population density (person/km2)
    gwp_pop_density = (gwp_pop / (area / 10**6))

    #-----------------------------------------------
    # load city_center coordinate
    #-----------------------------------------------

    center_path = f'{h08dir}/map/dat/cty_cnt_/city_{index:08d}.gl5'
    location = np.fromfile(center_path, dtype=dtype).reshape(lat_shape,lon_shape)
    x = np.where(location==1)[0]
    y = np.where(location==1)[1]
    x = x[0]
    y = y[0]

    #-----------------------------------------------
    # check city center
    #-----------------------------------------------

    # original city center
    org_cnt = gwp_pop[x, y]

    # number of replacement
    replaced_num = 0
    print(f"cityindex {index}")
    print(f'original center [x, y] = [{x, y}]')

    # if there is larger grid, center grid is replaced
    for a in range(x-circle, x+circle+1):
        for b in range(y-circle, y+circle+1):
            candidate = gwp_pop[a, b]
            if candidate >= org_cnt:
                org_cnt = candidate
                x = a
                y = b
                replaced_num += 1
    print(f'replaced center [x, y] = [{x, y}]')

    #-----------------------------------------------
    #  Initialization of mask array
    #-----------------------------------------------

    # mask array for saving
    mask = np.zeros((lat_shape,lon_shape), dtype=dtype)
    mask[x, y] = 1

    #-----------------------------------------------
    # overwrite city center file if changed
    #-----------------------------------------------

    new_center_path = f'{h08dir}/map/dat/cty_cnt_/modified/city_{index:08d}.gl5'
    mask.astype(np.float32).tofile(new_center_path)

    #-----------------------------------------------
    #  Explore start
    #-----------------------------------------------

    # stop flag
    new_mask_added = True
    coverage_flag = True

    # city center
    best_mask = mask
    grid_num = np.sum(best_mask)
    best_masked_pop = np.sum(gwp_pop*mask)
    best_coverage = float(best_masked_pop / un_pop)

    # initial grid threshold
    if gwp_pop_density[x, y] <= threshold:
        print("/// stop ///")
        print("/// stop ///")
        print("/// stop ///")
        print("/// stop ///")
        print(f"initial density {gwp_pop_density[x, y]} less than threshold {threshold}")
        print("/// stop ///")
        print("/// stop ///")
        print("/// stop ///")
        print("/// stop ///")
        new_maske_added = False
        coverage_flag = False

    # loop start
    while new_mask_added:

        ### make search list
        search_lst = []
        new_mask_added = False
        for a in range(max(0, x - radius_max), min(x + radius_max + 1, lat_shape)):
            for b in range(max(0, y - radius_max), min(y + radius_max + 1, lon_shape)):
                if mask[a, b] == 1:
                    # explore surrounded 8 grids
                    for dx, dy in [(-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, 1)]:
                        i, j = a + dx, b + dy
                        # not explored yet
                        if mask[i, j] == 0:
                            # within grid range
                            if 0 <= i < lat_shape and 0<= j < lon_shape:
                                search_lst.append([gwp_pop_density[i, j], i, j])
                                # if gwp_pop is used, there is bug due to ocean land ara data

        ### add searched grid
        # empty check
        if not search_lst:
            new_mask_added = False
            coverage_flag = False
        # get largest grid
        else:
            sorted_search = sorted(search_lst, key=lambda x: x[0], reverse=True)
            largest = sorted_search[0]
            # if largest grid value is too small, stop exploring
            if gwp_pop_density[largest[1], largest[2]] <= lowlim:
                print("/// stop ///")
                print("/// stop ///")
                print("/// stop ///")
                print("/// stop ///")
                print(f"largest density {gwp_pop_density[largest[1], largest[2]]} smaller than lowlim {lowlim}")
                print("/// stop ///")
                print("/// stop ///")
                print("/// stop ///")
                print("/// stop ///")
                new_mask_added = False
                coverage_flag = False


        # stop flag
        if coverage_flag is True:
                mask[largest[1], largest[2]] = 1
                new_mask_added = True

                # evaluate coverage
                gwp_masked_pop = np.sum(mask * gwp_pop)
                coverage = float(gwp_masked_pop / un_pop)

                # stop exploring
                if coverage >= 1.0:
                    new_mask_added = False
                    coverage_flag = False

                # judge
                judge_value = abs(1 - coverage)
                best_value = abs(1 - best_coverage)

                # update
                if judge_value < best_value:
                    best_coverage = coverage
                    best_mask = mask
                    best_masked_pop = gwp_masked_pop
                    grid_num = np.sum(best_mask)

    #-----------------------------------------------
    # Output result
    #-----------------------------------------------

    print(
          f"explored_pop {best_masked_pop}\n" \
          f"true_pop {un_pop}\n" \
          f"coverage {best_coverage}\n" \
          f"city_mask {grid_num}\n" \
          f"{city_name}\n"
          )
    print('#########################################')
    print('#########################################\n')

    #------------------------------------------------
    # SAVE FILE
    #------------------------------------------------

    # text file save (depricated)
    #maskpath_txt = h08dir + f'/map/dat/cty_msk_/txt/city_{index}.txt'

    #ff = open(maskpath_txt,'w')
    #for l in range(0, lat_shape):
    #    line = best_mask[l,:]
    #    aaa = line.tolist()
    #    aaa = str(aaa)
    #    aa1 = aaa.strip("[")
    #    aa2 = aa1.strip("]")
    #    aa2 = aa2.strip(",")
    #    ff.write("\n%s"%aa2)
    #ff.close()

    # result path save
    resultpath = h08dir + f'/map/dat/cty_lst_/result_citymask.txt'

    if index == 1:
        with open(resultpath, 'w') as file:
            file.write(f"{index}| {city_name}| {best_masked_pop}| {un_pop}| {best_coverage}| {grid_num}\n")
    else:
        with open(resultpath, 'a') as file:
            file.write(f"{index}| {city_name}| {best_masked_pop}| {un_pop}| {best_coverage}| {grid_num}\n")

    # binary file saved (latest version)
    maskpath_bin = h08dir + f'/map/dat/cty_msk_/city_{index:08}.txt'
    best_mask.astype(np.float32).tofile(maskpath_bin)


def summarize():
    # shape
    lat_shape = 2160
    lon_shape = 4320

    # date type
    dtype= 'float32'

    # homedir
    h08dir = '/home/kajiyama/H08/H08_20230612'

    # savefilename
    summary_path = f"{h08dir}/map/dat/cty_msk_/city_00000000.gl5"

    # make save array
    summary = np.empty((lat_shape, lon_shape))

    for index in range(1, 901):
        mask_name = f"{h08dir}/map/dat/cty_msk_/city_{index:08}.gl5"
        tmp = np.fromfile(mask_name, dtype=dtype).reshape(lat_shape, lon_shape)
        summary[tmp == 1] = 1

    # save file
    summary.astype(np.float32).tofile(summary_path)
    print(f'{summary_path} is saved')

    return summary


def main():
    # first round
    #for index in range(1, 901):
    #    explore_citymask(index)

    ## second round
    summary = summarize()

    # debug
    plt.imshow(summary)
    plt.show()



if __name__ == '__main__':
    main()
