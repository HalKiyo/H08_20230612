import os
import numpy as np

def main():
    # change the flag to True to overwrite
    save_flag = True

    # basic information
    h08dir = '/home/kajiyama/H08/H08_20230612'
    SUF = '.gl5'
    tag = '.ln5'
    dtype = 'float32'
    gl5shape = (2160, 4320)

    # region
    one = -3
    two = 1
    three = 50
    four = 53
    upperindex = (90 - four) * 12
    lowerindex = (90 - three) * 12
    leftindex = (180 + one) * 12
    rightindex = (180 + two) * 12
    print(f"upperindex {upperindex}, lowerindex{lowerindex}, leftindex{leftindex}, rightindex{rightindex}")

    varlist = ['LWdown__', 'PSurf___', 'Rainf___', 'SWdown__', 'Wind____', 'Prcp____', 'Qair____', 'Snowf___', 'Tair____']

    for var in varlist:
        metdir = h08dir + '/met/dat/' + var
        search_word1 = 'W5E5____2019'
        search_word2 = '.gl5'
        matching_files = find_files_with_word_in_filename(metdir, search_word1, search_word2)
        for file in matching_files:
            loadfile = file
            savefile = file.replace(SUF, tag)
            data = np.fromfile(loadfile, dtype=dtype).reshape(gl5shape)
            tokyo = data[upperindex:lowerindex, leftindex:rightindex]
            if save_flag is True:
                tokyo.astype(np.float32).tofile(savefile)
        print(f"{var} done")

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
