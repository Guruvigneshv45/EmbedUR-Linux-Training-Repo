#!/bin/bash

echo
echo "BACKUP MANAGER"
echo "____________________"

sdir="$1"
ddir="$2"
ft="$3"


echo "CHECK DETAILS"
echo "____________________"
echo "SOURCE DIR = $sdir"
echo "DESTINATION DIR = $ddir"
echo "FILE TYPE = $ft"
echo


declare -A FILE_SIZE
shopt -s nullglob
for a in "$sdir"/*."$ft"
do
    fname=$(basename "$a")
    size=$(stat -c %s "$a")
    FILE_SIZE["$fname"]="$size"
done
shopt -u nullglob

echo
if [ "${#FILE_SIZE[@]}" -eq 0 ]; then
    echo "NO FILE WITH THE GIVEN EXTENSION .$ft IS FOUND. Exiting..."
    exit
else
	echo "SOURCE_DIR CHECK SUCCEDED"
fi

export BACKUP_COUNT="${#FILE_SIZE[@]}"
echo "NUMBER OF FILES CAPTURED IN THE GIVEN FORMAT : $BACKUP_COUNT"

echo
echo "FILE REPORT"
echo "____________________"

for fname in "${!FILE_SIZE[@]}"
do
    echo "$fname (SIZE : ${FILE_SIZE[$fname]} BYTES)"
done
echo
if [ -d "$ddir" ]; then
    echo "BACKUP_DIRECTORY EXISTS "$ddir""
else
    echo "BACKUP_DIRECTORY NOT FOUND, CREATING $ddir"
    mkdir -p "$ddir"
    if [ $? -ne 0 ]; then
        echo "BACKUP_DIRECTORY CREATION FAILED. Exiting..."
        exit 1
    fi
fi
echo
backup_files=0
total_size=0
backup_files=0
total_size=0

for filename in "${!FILE_SIZE[@]}"
do
    sourcev="$sdir/$filename"
    backupv="$ddir/$filename"

    if [ ! -e "$backupv" ]; then
        cp "$sourcev" "$backupv"
        if [ $? -eq 0 ]; then
            ((backup_files++))
            ((total_size += FILE_SIZE["$filename"]))
            echo "NEW FILE CREATED AND BACKUP SUCCESS"
        fi

    elif [ "$sourcev" -nt "$backupv" ]; then
        cp "$sourcev" "$backupv"
        if [ $? -eq 0 ]; then
            ((backup_files++))
            ((total_size += FILE_SIZE["$filename"]))
            echo "NEW CHANGES FOUND..."
            echo "BACKUP SUCCESS OVERWRITTEN ON OLD BACKUP FILE"
        fi

    else
        echo "FILE $filename IS UP-TO-DATE"
    fi
done

echo
echo "PATH TO THE BACKUP DIRECTORY : $ddir"
echo "OUTPUT REPORT PROCESSING ON $ddir/backup_report.log"

echo "$(date)" >> "$ddir/backup_report.log"
echo "TOTAL FILES PROCESSED : $backup_files" >> "$ddir/backup_report.log"
echo "TOTAL FILE SIZE PROCESSED : $total_size" >> "$ddir/backup_report.log"
echo "PATH TO THE BACKUP DIRECTORY : $ddir" >> "$ddir/backup_report.log"

echo "REPORT SAVED, BACKUPS COMPLETED"
echo



