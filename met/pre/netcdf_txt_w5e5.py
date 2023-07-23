import os
import netCDF4
import numpy as np
import calendar
import datetime

def main():
    # init
    start_lst = [1979, 1981, 1991, 2001, 2011]
    end_lst = [1980, 1990, 2000, 2010, 2019]
    var_lst = ['tas','huss','pr','prsn','ps','rlds','rsds','sfcWind']

    # filename loop
    for var in var_lst:
        savedir = f"/home/kajiyama/H08/H08_20230612/met/org/W5E5v2/daily/{var}"
        os.makedirs(savedir, exist_ok=True)
        # start year loop
        for yr_start, yr_end in zip(start_lst, end_lst):
            # year loop
            for year in range(yr_start, yr_end+1):
                loadfile = f"/work/common/H08/met_data/W5E5v2.0_Lang_2021/" \
                           f"{var}_W5E5v2.0_{yr_start}0101-{yr_end}1231.nc"
                nc = netCDF4.Dataset(loadfile,'r','float32')
                arr = nc.variables[f"{var}"][:]
                arr = np.array(arr)

                if calendar.isleap(year) is True:
                    days_sum = 366
                    mon_str=[31,60,91,121,152,182,213,244,274,305,335,366]
                else:
                    days_sum = 365
                    mon_str=[31,59,90,120,151,181,212,243,273,304,334,365]

                # day loop
                for days in range(days_sum):
                    start_date = datetime.date(year, 1, 1)
                    target_date = start_date + datetime.timedelta(days)
                    month = target_date.month
                    day_of_mon = target_date.day
                    savefile = f"{savedir}/{var}{year}{month:02}{day_of_mon:02}.txt"

                    # create text file
                    mp = arr[days, :, :]
                    creat_text(savefile, mp)
                    print(savefile)

def creat_text(name, mp):
    ff = open(name, 'w')
    for lat in range(360):
        row = mp[lat, :]
        # ndarrayをpython配列に変換.　次元はそのまま保存される
        aaa=row.tolist()
        # 文字列に変換
        aaa=str(aaa)
        # 不要な文字・記号を削除
        aa1 = aaa.strip("[")
        aa2 = aa1.strip("]")
        aa3 = aa2.strip(",")
        ff.write("\n%s" % aa3)
    ff.close()

if __name__ == '__main__':
    main()
