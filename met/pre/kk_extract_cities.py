import os
import numpy as np

def main():
    # change the flag to True to overwrite
    save_flag = True

    city_dct = {
            "capetown": {"tag": '.ct5', "one": 17, "two": 20, "three": -35, "four": -32},
            "tokyo": {"tag": '.tk5', "one": 138, "two": 141, "three": 34, "four": 38},
            "london": {"tag": '.ln5', "one": -3, "two": -1, "three": 50, "four": 53},
            "chennai": {"tag": '.cn5', "one": 78, "two": 81, "three": 11, "four": 15},
            "losangeles": {"tag": '.la5', "one": -120, "two": -116, "three": 32, "four": 36},
            "riodejaneiro": {"tag": '.rj5', "one": -24, "two": -20, "three": -47, "four": -40},
            "paris": {"tag": '.pr5', "one": 0, "two": 6, "three": 46, "four": 52},
            "bangkok": {"tag": '.bk5', "one": 98, "two": 102, "three": 13, "four": 20},
            "istanbul": {"tag": '.is5', "one": 28, "two": 34, "three": 37, "four": 42},
            "mexicocity": {"tag": '.mx5', "one": -106, "two": -97, "three": 19, "four": 24},
            "saopaulo": {"tag": '.sp5', "one": -68, "two": -39, "three": -35, "four": -14},
            "moscow": {"tag": '.mc5', "one": 32, "two": 68, "three": 32, "four": 63},
            "sydney": {"tag": '.sy5', "one": 149, "two": 152, "three": -36, "four": -32},
    }

    # basic information
    h08dir = '/home/kajiyama/H08/H08_20230612'
    dtype = 'float32'
    gl5shape = (2160, 4320)

    # city loop
    for city, values in city_dct.items():
        SUF = '.gl5'
        tag = values["tag"]
        one = values["one"]
        two = values["two"]
        three = values["three"]
        four = values["four"]

        # index
        upperindex = (90 - four) * 12
        lowerindex = (90 - three) * 12
        leftindex = (180 + one) * 12
        rightindex = (180 + two) * 12
        print(f'upperindex {upperindex}, lowerindex{lowerindex}, leftindex{leftindex}, rightindex{rightindex}')

        # year loop
        for year in range(2010, 2019):

            # var loop
            varlist = ['LWdown__', 'PSurf___', 'Rainf___', 'SWdown__', 'Wind____', 'Prcp____', 'Qair____', 'Snowf___', 'Tair____']

            for var in varlist:
                metdir = h08dir + '/met/dat/' + var
                search_word1 = f'W5E5____{year}'
                search_word2 = '.gl5'
                matching_files = find_files_with_word_in_filename(metdir, search_word1, search_word2)
                for file in matching_files:
                    loadfile = file
                    savefile = file.replace(SUF, tag)
                    data = np.fromfile(loadfile, dtype=dtype).reshape(gl5shape)
                    cropped = data[upperindex:lowerindex, leftindex:rightindex]
                    if save_flag is True:
                        cropped.astype(np.float32).tofile(savefile)
                print(f"{city} {year} {var} done")

def find_files_with_word_in_filename(directory, word1, word2):
    """
    directory_path = '/path/to/your/directory'
    search_word1 = 'target_word1'
    search_word2 = 'target_word2'
    """

    matching_files = []

    # obtain all file in the directory
    files = os.listdir(directory)

    # check each file
    for file in files:
        # files should contain both words
        if word1 in file and word2 in file:
            file_path = os.path.join(directory, file)
            matching_files.append(file_path)

    return matching_files


if __name__ == '__main__':
    main()
