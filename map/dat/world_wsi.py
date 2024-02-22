import numpy as np

def load(name):
    h08dir = '/home/kajiyama/H08/H08_20230612'
    shape = (2160, 4320)
    dtype = 'float32'
    maskpath = h08dir + '/map/dat/lnd_msk_/lndmsk.CAMA.gl5'

    file = h08dir + name
    data = np.fromfile(file, dtype=dtype)
    lonlat = data.reshape(shape)
    mask = np.fromfile(maskpath, dtype=dtype)
    mask = mask.reshape(shape)
    lonlat = np.ma.masked_where(mask==0, lonlat)
    lonlat = np.ma.masked_where(lonlat>=1e20, lonlat)

    return lonlat

def calc_wsi(index):
    filename = 'W5E5LECD20190000'
    city_mask = load(f'/map/dat/cty_msk_/city_{index:08d}.gl5')
    josui = load(f'/map/dat/cty_prf_/city_{index:08d}.gl5')
    rivout = load(f'/riv/out/riv_out_/{filename}.gl5')
    demagr = load(f'/lnd/out/DemAgr__/{filename}.gl5')
    demind = load(f'/map/dat/dem_ind_/AQUASTAT20000000.gl5')
    demdom = load(f'/map/dat/dem_dom_/AQUASTAT20000000.gl5')

    riv_josui = rivout*josui
    demagr_masked = np.where(city_mask == 1, demagr, np.nan)
    demind_masked = np.where(city_mask == 1, demind, np.nan)
    demdom_masked = np.where(city_mask == 1, demdom, np.nan)

    demagr_tot = np.nansum(demagr_masked)
    demind_tot = np.nansum(demind_masked)
    demdom_tot = np.nansum(demdom_masked)
    riv_total = np.nansum(riv_josui)
    wsi = (demagr_tot + demind_tot + demdom_tot) / (riv_total)

    return wsi

def main():
    total_city_num = 900

    wsi_lst = []
    for i in range(total_city_num):
        city_index = i + 1
        wsi = calc_wsi(city_index)
        wsi_lst.append(wsi)
        print(city_index, wsi)

    np.save('./wsi_lst_/wsi_lst.npy', wsi_lst)


if __name__ == '__main__':
    main()
