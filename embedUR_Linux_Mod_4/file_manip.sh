#!/bin/bash

substr=("frame.time" "wlan.fc.type" "wlan.fc.subtype")
>op_mod4.txt
while IFS= read -r line
do
    for ((i=0; i<3; i++))
    do
        if [[ "$line" == *\"${substr[i]}\"* ]]; then
   		echo "$line" >> op_mod4.txt
		break
	fi
    done
done < "$1"

