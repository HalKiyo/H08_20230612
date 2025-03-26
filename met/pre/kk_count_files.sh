#!/bin/bash

# === setting === #
VARS="LWdown__ SWdown__ Prcp____ Snowf___ PSurf___ Qair____ Wind____ Tair____ Rainf___"
YEAR="2001"
START_DATE="0101"
END_DATE="1231"
PREFIX="W5E5____"
SUFFIX=".gl5"

# === main === #

for VAR in $VARS; do
    current_date="${YEAR}${START_DATE}"
    while [ "$current_date" -le "${YEAR}${END_DATE}" ]; do
        DIR="/home/kajiyama/H08/H08_20230612/met/dat/${VAR}"
        file_path="${DIR}/${PREFIX}${current_date}${SUFFIX}"
        if [ ! -f "$file_path" ]; then
            echo "Missing: $VAR $current_date"
        fi
        current_date=$(date -d "${current_date} +1 day" +%Y%m%d)
    done
done
