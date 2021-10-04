#1/bin/bash
FILE=~/confex/$1_cr.txt
if ! test -f "$FILE"; then
	echo This file does not yet exist. Do you want to create a new one?
	read -p "(yes or no):" yesorno
	case $yesorno in
		y|Y|yes|Yes|YES) nvim ~/confex/$1_cr.txt ;;
		n|N|no|No|NO) exit ;;
		*) echo "Assuming that's a 'no.'" && exit ;;
	esac
else
	nvim ~/confex/code_review/$1_cr.txt
fi
