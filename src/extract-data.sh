#!/usr/bin/env bash

for f in "$@"
do
	cat $f |
		sed 's/,//g' |\
		sed 's/NORMAL DEL DESIERTO/Normal del desierto/g' |\
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
		sed 's/,//g' |\
		sed 's/NORMAL DEL DESIERTO/Normal del desierto/g' |\
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
		sed 's/$/,precipitation/g' |\
		sed 's/#JUMPLINE#/\n/g' |\
		sed 's/^[0-9]* /&,/g' |\
		sed 's/ ,/,/g' |\
		sed 's/^/"/g' |\
		sed 's/,/","/g'
done
