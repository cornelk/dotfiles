#!/usr/bin/env bash

for name_file in /sys/class/hwmon/hwmon*/name; do
    [[ -r "$name_file" ]] || continue
    [[ "$(cat "$name_file")" == "k10temp" ]] || continue

    input_file="${name_file%/name}/temp1_input"
    [[ -r "$input_file" ]] || continue

    temp_millic=$(cat "$input_file")
    printf 'TEMP %dC\n' "$(( (temp_millic + 500) / 1000 ))"
    exit 0
done

printf 'TEMP N/A\n'
