#!/usr/bin/env bash

# First step: download all the txt with long-term averages from 1951 - 2010
# src/download.sh

# Convert all the txt documents to utf-8
# for var in $(ls input)
# do
	# OUTFILE=$(echo $(basename "${var/.TXT}" | tr '[A-Z]' '[a-z]')-utf8.txt)
	# iconv -f windows-1254 -t  utf8//TRANSLIT input/${var} -o output/utf8/${OUTFILE};
# done

# Then extract only the long-term averages of all the variables 
# which are present in the converted tables
for f in $(ls output/utf8/)
do 
	src/extract-data.sh output/utf8/${f} >> output/tmp.csv
done

# When data don't exist in the original tables, the script keeps the word
# "NORMAL". Therefore, "NORMAL" means missing data, and these rows must be
# removed

grep -v '^"$\|NORMAL' output/tmp.csv > output/smn-raw-data.csv

rm output/tmp.csv
