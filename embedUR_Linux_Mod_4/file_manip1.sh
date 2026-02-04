#!/bin/bash

grep -E '"frame.time"|"wlan.fc.type"|"wlan.fc.subtype"' "$1"

