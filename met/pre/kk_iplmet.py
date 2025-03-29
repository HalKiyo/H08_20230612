import os
import numpy as np
from scipy.interpolate import RegularGridInterpolator
import multiprocessing as mp
import time

# --- Global Settings ---
p0mis = 1.0e20  # Value for missing data
NUM_PROCESSES = 20  # Manually specify the number of CPU cores to use

# --- Directory and File Settings ---
PRJ = "W5E5"
RUN = "____"
DIRS = [
    "PSurf___",
    "Rainf___",
    "Snowf___",
    "Wind____",
    "LWdown__",
    "Qair____",
    "SWdown__",
    "Tair____",
]
YEARMIN = 1980
YEARMAX = 2018
MONTHS = [f"{m:02d}" for m in range(1, 13)]  # 01 to 12
WORK_DIR = "/home/kajiyama/H08/H08_20230612/met/dat"

# --- 30-minute resolution grid ---
lon_30min = np.linspace(-180, 180, 720)  # Longitude: 0.5-degree intervals
lat_30min = np.linspace(-90, 90, 360)    # Latitude: 0.5-degree intervals

# --- 5-minute resolution grid ---
lon_5min = np.linspace(-180, 180, 4320)  # Longitude: 5-minute intervals
lat_5min = np.linspace(-90, 90, 2160)    # Latitude: 5-minute intervals

# --- Read binary files ---
def read_binary(filename, shape):
    """Read binary file and reshape to float32"""
    return np.fromfile(filename, dtype=np.float32).reshape(shape)

# --- Write binary files ---
def write_binary(filename, data):
    """Write data to binary file in float32 format"""
    data.astype(np.float32).tofile(filename)

# --- Global interpolation function ---
def interpolate_row(lat):
    """Interpolate one row (latitude)"""
    lon_mesh = lon_5min
    points = np.column_stack((np.full(len(lon_mesh), lat), lon_mesh))
    data_interp_row = interp_func(points)
    data_interp_row = np.where(np.isnan(data_interp_row), p0mis, data_interp_row)
    return data_interp_row

# --- Prepare interpolation ---
def prepare_interpolation(input_file, output_file):
    """Read binary file, perform interpolation, and write to a new file"""
    global interp_func  # Declare as a global variable

    # --- Read the binary file ---
    if not os.path.exists(input_file):
        print(f"Warning: File not found: {input_file}")
        return
    
    print(f"Processing: {input_file}")
    data_30min = read_binary(input_file, (360, 720))

    # --- Mask missing values ---
    data_masked = np.ma.masked_equal(data_30min, p0mis)

    # --- Create interpolation function ---
    interp_func = RegularGridInterpolator(
        (lat_30min, lon_30min), data_masked.filled(np.nan),
        method='linear', bounds_error=False, fill_value=np.nan
    )

    # --- Parallel interpolation ---
    def parallel_interpolation():
        """Main function for parallel interpolation"""
        # Create multiprocessing pool
        with mp.Pool(processes=NUM_PROCESSES) as pool:
            # Apply interpolation to each row of lat_5min
            results = pool.map(interpolate_row, lat_5min)

        # Convert interpolation results to a 2D array
        data_5min = np.array(results)
        return data_5min

    # --- Execute interpolation ---
    data_5min = parallel_interpolation()

    # --- Write interpolation results to binary file ---
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    write_binary(output_file, data_5min)
    print(f"Saved: {output_file}")

# --- Main loop to process all variables and all date combinations ---
def process_all_variables():
    """Process all variables for each year, month, and day"""
    for DIR in DIRS:
        for YEAR in range(YEARMIN, YEARMAX + 1):
            for MON in MONTHS:
                # Get the number of days in the month (simple logic for non-leap years)
                DAYMAX = 30 if MON in ["04", "06", "09", "11"] else 31
                if MON == "02":
                    DAYMAX = 29 if (YEAR % 4 == 0 and (YEAR % 100 != 0 or YEAR % 400 == 0)) else 28
                
                for DAY in range(1, DAYMAX + 1):
                    DAY = f"{DAY:02d}"  # Format day as 01, 02, ...
                    VARMET = f"{DIR}/{PRJ}{RUN}{YEAR}{MON}{DAY}"
                    input_file = f"{WORK_DIR}/{VARMET}.hlf"
                    output_file = f"{WORK_DIR}/{VARMET}.gl5"

                    # Perform interpolation if file exists
                    prepare_interpolation(input_file, output_file)

# --- Main Execution ---
if __name__ == "__main__":
    process_all_variables()
