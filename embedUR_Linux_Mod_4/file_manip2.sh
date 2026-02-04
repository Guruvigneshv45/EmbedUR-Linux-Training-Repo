#!/bin/bash

awk '
index($0,"frame.time") ||
index($0,"wlan.fc.type") ||
index($0,"wlan.fc.subtype")
' "$1"

