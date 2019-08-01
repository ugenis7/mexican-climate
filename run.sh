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
	src/extract-data.sh output/utf8/${f} >> output/temp-and-precip.csv
done

# Finally, create another table with the location of the climatic stations
# cat output/utf8/normal*-utf8.txt |\
	# grep 'ESTACION' |\
	# tr -s ' ' ' ' |\
	# sed 's/,//g' |\
	# sed 's/ESTACION: \| LATITUD: \| LONGITUD: \|ALTURA: /,/g' |\
	# grep -v '^$' |\
	# sed "s/\°\|'/,/g" |\
	# sed 's/\" [NW]*\.//g' |\
	# sed 's/ MSNM\.//g' |\
	# sed 's/^,//g' |\
	# sed 's/^[0-9]*/&,/g' |\
	# sed 's/, \| ,/,/g' |\
	# sed 's/^000//g' >> output/estaciones.csv
