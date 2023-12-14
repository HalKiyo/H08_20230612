"""
wsi_lst.npy will be saved in the same directory
"""

import os
import numpy as np

#---------------------------------------------------------------------------------------------------------------
# PATH
#---------------------------------------------------------------------------------------------------------------
def l_coordinate_to_tuple(lcoordinate, a=2160, b=4320):
    lat_l = a - ((lcoordinate - 1) // b)
    lon_l = (lcoordinate) % b - 1
    return (lat_l, lon_l)

#---------------------------------------------------------------------------------------------------------------
# PATH
#---------------------------------------------------------------------------------------------------------------
root_dir = "/home/kajiyama/H08/H08_20230612"
# lonlat data
file_path = f"{root_dir}/map/dat/cty_lst_/city_list03.txt"
# city mask data
cmsk_path = f"{root_dir}/map/dat/cty_msk_"
# riv data
rivnum_path = f"{root_dir}/map/out/riv_num_/rivnum.CAMA.gl5"
rivara_path = f"{root_dir}/map/out/riv_ara_/rivara.CAMA.gl5"
rivnxl_path = f"{root_dir}/map/out/riv_nxl_/rivnxl.CAMA.gl5"

#---------------------------------------------------------------------------------------------------------------
# Initialization
#---------------------------------------------------------------------------------------------------------------
main_city_list_4 = ["London", "Tokyo", "Paris", "LosAngeles-LongBeach-SantaAna"]
remove_grid = 7
loop_num = 900 # number of the city
width = 1
a = 2160
b = 4320

#---------------------------------------------------------------------------------------------------------------
# Input Data
#---------------------------------------------------------------------------------------------------------------
# city_list.txtを開いてデータを読み取る
with open(file_path, "r") as input_file:
    lines = input_file.readlines() 

# 新しいデータをcityrange_list.txtに書き込む
city_path = f"{root_dir}/map/dat/cty_lst_/cityrange_list_temp.txt"
with open(city_path, "w") as output_file:
    for line in lines:
        parts = line.split()  # 各行をスペースで分割
        col3 = float(parts[2])
        col4 = float(parts[3])
        # widthを使用して新しいデータを計算
        new_col1 = col3 - width
        new_col2 = col3 + width
        new_col3 = col4 - width
        new_col4 = col4 + width
        # 新しいデータを行に追加
        new_line = f"{line.strip()} {new_col1} {new_col2} {new_col3} {new_col4} \n"
        output_file.write(new_line)

#---------------------------------------------------------------------------------------------------------------
# load city information 
#---------------------------------------------------------------------------------------------------------------

# open city information text
with open(city_path, 'r') as file:
    all_lines = file.readlines()

#---------------------------------------------------------------------------------------------------------------
# city loop start 
#---------------------------------------------------------------------------------------------------------------

# city loop
for idx, line in enumerate(all_lines[:loop_num]):  # loop_numまでの行のみを処理
    line = line.strip()
    if not line:
        break
    parts = line.split()
    #city_num = parts[0].zfill(3)
    city_num = parts[0]
    city_num = int(city_num)
    city = parts[5].replace("\"", "").replace("?", "").replace("/", "")
    lonmin = float(parts[6])
    lonmax = float(parts[7])
    latmin = float(parts[8])
    latmax = float(parts[9])

    print(f"city_num {city_num}")
    print(city)

#---------------------------------------------------------------------------------------------------------------
#   Get Lon Lat 
#---------------------------------------------------------------------------------------------------------------

    ### Define the latitudes and longitudes
    # West from UK is negative 0 <= lon <= -180
    # East from UK is positive 0 <= lon <= 180
    # small value to larger value (34-36, 138-140)
    lat = np.linspace(-90, 90, a+1)
    lon = np.linspace(-180, 180, b+1)

    ### Calculate the indices corresponding to the desired latitudes and longitudes
    lat_start, lat_end = np.searchsorted(lat, [latmin, latmax])
    lon_start, lon_end = np.searchsorted(lon, [lonmin, lonmax])

    # adjust to 0.25 grid (lonlat)
    if lat_start%3 == 0:
        lat_start = lat_start
    elif lat_start%3 == 1:
        lat_start -= 1
    elif lat_start%3 == 2:
        lat_start += 1
    # lon
    if lon_start%3 == 0:
        lon_start = lon_start
    elif lon_start%3 == 1:
        lon_start -= 1
    elif lon_start%3 == 2:
        lon_start += 1
    # 24 grid x 24 grid
    width_grid = width * 12 * 2
    lat_end = lat_start + width_grid
    lon_end = lon_start + width_grid

#---------------------------------------------------------------------------------------------------------------
#   Load city mask data (g_mask_cropped)
#---------------------------------------------------------------------------------------------------------------

    g_mask = np.fromfile(f'{cmsk_path}/city_{city_num:08d}.gl5', 'float32').reshape(a, b)
    g_mask = np.flipud(g_mask)
    g_mask = np.ma.masked_where(g_mask >= 1E20, g_mask)
    g_mask_cropped = g_mask[lat_start:lat_end, lon_start:lon_end]
    g_mask_cropped = np.flipud(g_mask_cropped)

#---------------------------------------------------------------------------------------------------------------
#   Load basin data (Rivnum_A_array)
#---------------------------------------------------------------------------------------------------------------

    g_rivnum = np.fromfile(rivnum_path, 'float32').reshape(a, b)
    g_rivnum = np.flipud(g_rivnum)
    g_rivnum = np.ma.masked_where(g_rivnum >= 1E20, g_rivnum)
    Rivnum_A_array = g_rivnum[lat_start:lat_end, lon_start:lon_end]
    Rivnum_A_array = np.flipud(Rivnum_A_array)
    Rivnum_A_array = np.ma.masked_where(~np.isfinite(Rivnum_A_array) | (Rivnum_A_array == 0), Rivnum_A_array)

#---------------------------------------------------------------------------------------------------------------
#   Load upper river catchment area (g_rivara_cropped)
#---------------------------------------------------------------------------------------------------------------

    g_rivara = np.fromfile(rivara_path, 'float32').reshape(a, b)
    g_rivara = np.flipud(g_rivara)
    g_rivara = np.ma.masked_where(g_rivara >= 1E20, g_rivara)
    g_rivara_cropped = g_rivara[lat_start:lat_end, lon_start:lon_end]
    g_rivara_cropped = np.flipud(g_rivara_cropped)
    g_rivara_cropped = np.ma.masked_where(~np.isfinite(g_rivara_cropped) | (g_rivara_cropped == 0), g_rivara_cropped)

#---------------------------------------------------------------------------------------------------------------
#   Load river's next l coordinate data (g_rivnxl_cropped)
#---------------------------------------------------------------------------------------------------------------

    g_rivnxl = np.fromfile(rivnxl_path, 'float32').reshape(a, b)
    g_rivnxl = np.flipud(g_rivnxl)
    g_rivnxl = np.ma.masked_where(g_rivnxl >= 1E20, g_rivnxl)
    g_rivnxl_cropped = g_rivnxl[lat_start:lat_end, lon_start:lon_end]
    g_rivnxl_cropped = np.flipud(g_rivnxl_cropped)
    g_rivnxl_cropped = np.ma.masked_where(~np.isfinite(g_rivnxl_cropped) | (g_rivnxl_cropped == 0), g_rivnxl_cropped)

#---------------------------------------------------------------------------------------------------------------
#   Basin data only where city mask exists (Rivnum_A_array_city)
#---------------------------------------------------------------------------------------------------------------

    Rivnum_A_array_city = np.where(g_mask_cropped == 1, Rivnum_A_array, np.nan)
    Rivnum_A_array_city = np.ma.masked_where(~np.isfinite(Rivnum_A_array_city) | (Rivnum_A_array_city == 0), Rivnum_A_array_city)

#---------------------------------------------------------------------------------------------------------------
#  　Basin over 7 grids (Rivnum_B_array)
#---------------------------------------------------------------------------------------------------------------

    # g_ara_num_croppedを構造化配列として作成
    dtype = [('rivara', 'float32'), ('rivnum', 'float32')]
    g_ara_num_cropped = np.empty(g_rivara_cropped.shape, dtype=dtype)

    # rivaraとrivnumのデータをg_ara_num_croppedに追加
    g_ara_num_cropped['rivara'] = g_rivara_cropped
    g_ara_num_cropped['rivnum'] = Rivnum_A_array

    # g_ara_num_croppedのrivnumをマスク付き配列として取得
    Rivnum_A_array_masked = np.ma.masked_array(g_ara_num_cropped['rivnum'], np.isnan(g_ara_num_cropped['rivnum']))

    # マスクされていない要素(Nanじゃない値)のユニークな値とその出現回数を取得
    unique_values, counts = np.unique(Rivnum_A_array_masked.compressed(), return_counts=True)
    value_counts_dict = dict(zip(unique_values, counts))

    # 値（個数）の多い順にソート
    # 都市マスク内の流域番号で，出現回数が多い順に並んでいるはず
    sorted_dict_by_value_descending = dict(sorted(value_counts_dict.items(), key=lambda item: item[1], reverse=True))

    # 値（個数）がremove grid以上の項目のみを持つ新しい辞書を作成
    # 流域が小さい物は削除する作業に該当
    filtered_dict_g12 = {key: value for key, value in sorted_dict_by_value_descending.items() if value >= remove_grid}

    # 空っぽのマスク配列(24x24を作る)
    Rivnum_B_array = np.ma.masked_all(Rivnum_A_array_masked.shape, dtype='float32')

    # filtered_dict_g12のキー(流域ID)に対して繰り返し処理を行い、
    # それぞれのrivnumがRivnum_A_array_maskedに存在する位置を特定します。
    for rivnum_id in filtered_dict_g12.keys():
        # 同じrivnumの位置を取得
        matching_positions = np.where(Rivnum_A_array_masked.data == rivnum_id)
        # これらの位置に新しい配列にrivnumを設定
        Rivnum_B_array[matching_positions] = rivnum_id

    # 0 or 非有限数の要素をマスクする
    # Rivnum_B_arrayは都市マスクなしのすべての流域
    Rivnum_B_array = np.ma.masked_where(~np.isfinite(Rivnum_B_array) | (Rivnum_B_array == 0), Rivnum_B_array)

#---------------------------------------------------------------------------------------------------------------
#   Basin over 7 grids within city mask (Rivnum_B_array_citymasked)
#---------------------------------------------------------------------------------------------------------------

    # Rivnum_B_arrayの値が存在しないか、値が0の場所をTrueとするマスクを作成
    invalid_mask = np.isnan(Rivnum_B_array) | (Rivnum_B_array == 0)
    # g_mask_croppedが1でない場所、または上記のマスクがTrueの場所をマスクとして指定
    cityarea_with_rivnum_b_array = np.ma.masked_where((g_mask_cropped != 1) | invalid_mask, Rivnum_B_array)

    # Rivnum_B_arrayで都市マスク内以外の値をnp.nanに変更
    Rivnum_B_array_citymasked = np.where(g_mask_cropped == 1, Rivnum_B_array, np.nan)
    # 欠損値 or 非有限数の要素をマスクする
    Rivnum_B_array_citymasked = np.ma.masked_where(~np.isfinite(Rivnum_B_array_citymasked) | (Rivnum_B_array_citymasked >= 1E20), Rivnum_B_array_citymasked)

    #二つの処理はほぼ同じであり，rivnum_B_array_citymaskedは都市マスクの外にnan値を持つ

#---------------------------------------------------------------------------------------------------------------
#   rivaraを使って河口グリッドを探索する (rivnum_max_array)
#---------------------------------------------------------------------------------------------------------------

    # g_ara_num_croppedを構造化配列として作成
    dtype = [('rivara', 'float32'), ('rivnum', 'float32')]
    g_ara_num_cropped = np.empty(g_rivara_cropped.shape, dtype=dtype)

    # rivaraとrivnumのデータをg_ara_num_croppedに追加
    g_ara_num_cropped['rivara'] = g_rivara_cropped
    g_ara_num_cropped['rivnum'] = Rivnum_B_array_citymasked

    # マスクされていない要素のユニークな値とその出現回数を取得
    # 都市マスク内の流域グリッド数で出現回数が多い物を探索している
    unique_values, counts = np.unique(cityarea_with_rivnum_b_array.compressed(), return_counts=True)
    value_counts_dict = dict(zip(unique_values, counts))

    # データ型とサイズに基づいて新しい配列を作成
    rivnum_max_array = np.ma.masked_all(g_ara_num_cropped.shape, dtype='float32')

    for rivnum_id in value_counts_dict.keys():
        # 同じrivnumの位置を取得
        matching_positions = np.where(g_ara_num_cropped['rivnum'] == rivnum_id) 
        # これらの位置におけるrivaraの最大値の位置を取得
        max_rivara_position = np.argmax(g_ara_num_cropped['rivara'][matching_positions])       
        # 最大のrivaraの位置に対応するrivnumを新しい配列に保存する
        # 河口グリッドに該当
        rivnum_max_array[matching_positions[0][max_rivara_position], matching_positions[1][max_rivara_position]] = rivnum_id

#---------------------------------------------------------------------------------------------------------------
#   riv nxtl -> lonlat coordinate array 24x24x2 (result_2424)
#---------------------------------------------------------------------------------------------------------------

    # l coordiate to lonlat coordinate
    vfunc = np.vectorize(l_coordinate_to_tuple, otypes=[tuple])
    result = np.empty(g_rivnxl_cropped.shape, dtype=tuple)
    mask = ~np.isnan(g_rivnxl_cropped)
    result[mask] = vfunc(g_rivnxl_cropped[mask])
    result_shape = (result.shape[0], result.shape[1], 2)

    result_list = []
    for row in result:
        for x, y in row:
            # width_grid = cropped scale(24x24)
            modified_x = width_grid - (x - lat_start)
            modified_y = y - lon_start
            result_list.append((modified_x, modified_y))

    result_2424 = np.array(result_list).reshape(result_shape)
    result_2424 = result_2424.astype(int)

#---------------------------------------------------------------------------------------------------------------
#   各流域の経路座標　(results_dict)
#   各経路が流域番号で格納され，1つのファイルに集約 (riv_path_array)
#---------------------------------------------------------------------------------------------------------------

    results_dict = {}
    # マスク内に存在する流域ID
    unique_ids = np.unique(rivnum_max_array.compressed())
    riv_path_array = np.ma.masked_all(rivnum_max_array.shape, dtype='float32')
    visited_coords = set()

    for uid in unique_ids:
        # 河口グリッドのインデックス
        coords_a = np.argwhere(rivnum_max_array == uid)
        riv_path_array[coords_a[0][0], coords_a[0][1]] = uid
        if coords_a.size > 0:
            target_coord = tuple(coords_a[0]) 
            path_coords = [target_coord]
            for _ in range(300):
                if target_coord in visited_coords:
                    break
                visited_coords.add(target_coord)
                # result_2424はrivnxlのlonlat表示なので，target_coordを次のセルに指し示すrivnxlのインデックスを取得
                matched_coords = np.argwhere(np.all(target_coord == result_2424, axis=2))
                if len(matched_coords) == 0:
                    break
                # マッチしたインデックスの中でrivaraが最大のものを選ぶ
                unvisited_matched = [tuple(coord) for coord in matched_coords if tuple(coord) not in visited_coords]
                if not unvisited_matched:
                    break
                # g_rivara_croppedに座標をいれて，最大最小を比べている
                rivara_values = [g_rivara_cropped[coord[0], coord[1]] for coord in unvisited_matched]
                max_index = np.argmax(rivara_values)
                best_coord = unvisited_matched[max_index]
                # 河口グリッドのファイルに経路をそれぞれ足していく
                riv_path_array[best_coord[0], best_coord[1]] = uid
                target_coord = best_coord 
                # path_coordに経路を足していく
                path_coords.append(target_coord)

            # 各流域の経路を保存
            results_dict[uid] = path_coords

#---------------------------------------------------------------------------------------------------------------
#   Explore josui grids (josui_lst)
#---------------------------------------------------------------------------------------------------------------

    # determine josui place
    josui_lst = []

    # get uid
    tmp_id_lst = list(results_dict.keys())
    print(tmp_id_lst)

    # city mask
    tmp_uid_masked = np.where(g_mask_cropped==1, riv_path_array, np.nan)

    # loop uid
    for key_num in tmp_id_lst:
        # get river path
        indices = np.argwhere(tmp_uid_masked == key_num)
        # get minmum river area
        rivara_values = [g_rivara_cropped[coord[0], coord[1]] for coord in indices]
        min_arg = np.argmin(rivara_values)
        josui = indices[min_arg]
        # add to list
        josui_lst.append(josui)

#---------------------------------------------------------------------------------------------------------------
#   Josui map 24 x 24 (josui_array)
#---------------------------------------------------------------------------------------------------------------

    # 浄水場情報を24x24のマスクファイルに保存
    josui_array = np.ma.masked_all(g_ara_num_cropped.shape, dtype='float32')

    for matching_position, uid in zip(josui_lst, tmp_id_lst):
        josui_array[matching_position[0], matching_position[1]] = uid

#---------------------------------------------------------------------------------------------------------------
#   Save file (josui_array)
#---------------------------------------------------------------------------------------------------------------
    # croppするときは必ずひっくり返す
    # 保存・描写するときにもとに戻す

    # 保存用ファイル作成
    josui_for_save = np.ma.masked_all(g_rivara.shape, dtype='float32')

    #　cropp区間の値を変換(世界地図はひっくり返っている)
    josui_for_save[lat_start:lat_end, lon_start:lon_end] = np.flipud(josui_array)

    # 浄水場を1, それ以外を0とするバイナリーファイルに変換
    josui_for_save = np.ma.filled(josui_for_save, fill_value=0)
    josui_for_save = np.where(josui_for_save > 0, 1, josui_for_save)

    # 保存するときは世界地図をひっくり返して，正しい向きにしておく
    # city purification plant
    num = idx+1 # city ID
    save_path = f'/home/kajiyama/H08/H08_20230612/map/dat/cty_prf_/city_{num:08d}.gl5'
    josui_for_save = np.flipud(josui_for_save)
    josui_for_save.astype(np.float32).tofile(save_path)
    print(f"{save_path} saved")
