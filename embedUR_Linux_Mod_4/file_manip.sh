#!/bin/bash

substr=("frame.time" "wlan.fc.type" "wlan.fc.subtype")

while IFS= read -r line
do
    for ((i=0; i<3; i++))
    do
        if [[ "$line" == *\"${substr[i]}\"* ]]; then
            key="${substr[i]}"
            value=$(echo "$line" | sed -n 's/.*: "\(.*\)".*/\1/p')  # Extract part after ":'
   
            echo ""$key": "$value""
            break
        fi
    done
done < "$1"

