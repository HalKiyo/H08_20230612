import numpy as np

def load(name):
    lnddir = '/home/kajiyama/H08/H08_20230612/'
    file = lnddir + name
    data = np.fromfile(file, dtype='float32')
    return data

def save_bin(data, name):
    lnddir = '/home/kajiyama/H08/H08_20230612/'
    file = lnddir + name
    data.astype(np.float32).tofile(file)

def main():
    dbl = load(name='map/out/irg_arad/S05_____20000000.gl5')
    sgl = load(name='map/out/irg_aras/S05_____20000000.gl5')
    rfd = load(name='map/out/rfd_ara_/S05_____20000000.gl5')
    non = load(name='map/out/non_ara_/S05_____20000000.gl5')

    for i, value in enumerate(non):
        if value < 0:
            ab = np.abs(value)
            if dbl[i] > ab:
                dbl[i] = dbl[i] - ab
            elif sgl[i] > ab:
                sgl[i] = sgl[i] - ab
            elif rfd[i] > ab:
                rfd[i] = rfd[i] - ab
            non[i] = non[i] + ab

    save_bin(dbl, name='map/out/irg_arad/S05_____20000000.gl5')
    save_bin(sgl, name='map/out/irg_aras/S05_____20000000.gl5')
    save_bin(rfd, name='map/out/rfd_ara_/S05_____20000000.gl5')
    save_bin(non, name='map/out/non_ara_/S05_____20000000.gl5')

if __name__ == '__main__':
    main()
