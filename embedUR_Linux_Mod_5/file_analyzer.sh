#!/bin/bash

FOUND_GLOBAL=0

rec_filesearch()
{
	dir="$1"
	keyword="$2"
	error_flag=0
	echo "PROCESSING RECURSIVE SEARCH TO FIND $keyword in $dir"
	for i in "$dir"/*;
	do
	#	echo "PROCESSING RECURSIVE SEARCH TO FIND $keyword in $dir"
		if [[ -f "$i" ]];then
		#	echo "IN FILE $i"
			grep -E "$keyword" "$i"
			if [[ "$?" -eq 0 ]];then
			#	echo "----------------------------------"
				FOUND_GLOBAL=1
				echo "KEYWORD FINDING SUCCESS"
				echo "PATH : $i"
				echo "----------------------------------"
				echo
			fi
		elif [[ -d "$i" ]];then
		#	echo "IN SUBDIR $i"
			rec_filesearch "$i" "$keyword"
		elif [[ -s "$i" ]];then
			echo "ENTERED AN EMPTY FILE:$i"
		fi
	done
}

logger(){
	echo -e "$(date)""\n$1\n" >> errors.log
}

here_doc()
{
	cat <<EOF
MENU USING HERE DOCUMENT
-------------------------------
In Script : $0
-------------------------------
Operations allowed :
-d <dir_name> for directory
-f <file_name> for file
-k <keyword> for Keyword Search
--help Display Help Menu
EOF
}

here_str()
{
	echo "----------------------------------------------------------"
	echo "IN HERE_STR FN WITH INPUT FILE "$1" AND KEYWORD "$2""
	if [[ ! -f "$1" ]];then
		logger "File not found in here_str:$1"
		exit 1
	else
		grep -E "$2" <<<"$(cat "$1")"
		if [[ "$?" -ne 0 ]];then
			logger "KEYWORD $2 IS NOT AVAILABLE IN $1 (FROM HERE_STR)"
		fi
	fi
	echo "---------------------------------------------------------"
}

validate_ipkeyword()
{
	if [[ ! "$1" =~ ^[[:alnum:]]+$ ]];then
		logger "Improper Keyword Entry : "$1""
		exit 1
	fi
}

if [[ "$1" == "--help" ]];then
	here_doc
	exit 0
fi

while getopts ":d:f:k:" opt;
do
	case "$opt" in
		d)direc=$OPTARG;;
		f)fle=$OPTARG;;
		k)keyw=$OPTARG;;
		?)logger "INVALID OPTION ENTERED IN GETOPTS $OPTARG"; exit 1;;
		:)logger "NO ARG FOR GETOPTS $OPTARG"; exit 1;;
	esac
done

echo "SCRIPT: $0"
echo "TOTAL ARGS : $#"
echo "ARGS ENTERED : $@"
echo

if [[ -z "$keyw" ]];then
	logger "KEYWORD NOT PROVIDED"
	exit 1
fi

validate_ipkeyword "$keyw"

if [[ -n "$direc" ]];then
	rec_filesearch "$direc" "$keyw"
	if [[ "$FOUND_GLOBAL" -eq 0 ]]; then
		logger "Keyword $keyw not found in Recursive search"
	fi
elif [[ -n "$fle" ]];then
	here_str "$fle" "$keyw"
else
	logger "NO VALID INPUT PROVIDED"
	here_doc
	exit 1
fi

#validate_ipkeyword "@#123"
#rec_filesearch "dir1" "File"
#here_str "dir1/dir2/orgfile.txt" "File"

