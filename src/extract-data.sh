#!/usr/bin/env bash

for f in "$@"
do
	ESTACION=$(echo $(basename "${f/-utf8.txt}" | sed 's/normal//g' ));

	cat $f |
		grep 'ESTACION\|TEMPERATURA MAXIMA' -A 1 |\
		grep 'ESTACION\|NORMAL' |\
		sed 's/\s*LATITUD.*//g' |\
		sed 's/(.*//g' |\
		sed 's/^ESTACION: /#JUMPLINE#/g' |\
		tr '\n' ' ' |\
		tr -s ' ' ' ' |\
		sed 's/ $//g' |\
		sed 's/ NORMAL.* /,/g' |\
		sed 's/ ,/,/g' |\
		sed 's/$/,max-temperature/g' |\
		sed 's/#JUMPLINE#/\n/g' |\
		sed 's/^[0-9]* /&,/g' |\
		sed 's/ ,/,/g' |\
		sed 's/^/"/g' |\
		sed 's/,/","/g'

	cat $f |
		grep 'ESTACION\|PRECIPITACION' -A 1 |\
		grep 'ESTACION\|NORMAL' |\
		sed 's/\s*LATITUD.*//g' |\
		sed 's/(.*//g' |\
		sed 's/^ESTACION: /#JUMPLINE#/g' |\
		tr '\n' ' ' |\
		tr -s ' ' ' ' |\
		sed 's/ $//g' |\
		sed 's/ NORMAL.* /,/g' |\
		sed 's/ ,/,/g' |\
		sed 's/$/,precipitation"/g' |\
		sed 's/#JUMPLINE#/\n/g' |\
		sed 's/^[0-9]* /&,/g' |\
		sed 's/ ,/,/g' |\
		sed 's/^/"/g' |\
		sed 's/,/","/g'

done
