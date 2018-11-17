#!/usr/bin/env bash

for f in "$@"
do
	ESTACION=$(echo $(basename "${f/-utf8.txt}" | sed 's/normal//g' ));

	cat $f | sed \
		-e 's/AÑ0S CON DATOS/años-con-datos/g' \
		-e 's/AÑO DE MAXIMA/año-de-maxima/g' \
		-e 's/AÑO DE MINIMA/año-de-minima/g' \
		-e 's/AÑOS CON DATOS/años-con-datos/g' \
		-e 's/ELEMENTOS/elementos/g' \
		-e 's/ESTACION/estacion/g' \
		-e 's/LATITUD/\nlatitud/g' \
		-e 's/LONGITUD/\nlongitud/g' \
		-e 's/ALTURA/\naltura/g' \
		-e 's/ESTADO DE/estado/g' \
		-e 's/PERIODO/\nperiodo/g' \
		-e 's/EVAPORACION TOTAL/evaporacion-total/g' \
		-e 's/FECHA MAXIMA DIARIA/fecha-maxima-diaria/g' \
		-e 's/FECHA MINIMA DIARIA/fecha-minima-diaria/g' \
		-e 's/GRANIZO/granizo/g' \
		-e 's/LLUVIA/lluvia/g' \
		-e 's/MAXIMA DIARIA/maxima-diaria/g' \
		-e 's/MAXIMA MENSUAL/maxima-mensual/g' \
		-e 's/MINIMA DIARIA/minima-diaria/g' \
		-e 's/MINIMA MENSUAL/minima-mensual/g' \
		-e 's/NIEBLA/niebla/g' \
		-e 's/NORMAL/normal/g' \
		-e 's/NUMERO DE DIAS CON/numero-de-dias-con/g' \
		-e 's/PRECIPITACION/precipitacion/g' \
		-e 's/TEMPERATURA MAXIMA/temperatura-maxima/g' \
		-e 's/TEMPERATURA MEDIA/temperatura-media/g' \
		-e 's/TEMPERATURA MINIMA/temperatura-minima/g' \
		-e 's/TORMENTA E\./tormenta-electrica/g' \
		-e 's/^[[:blank:]]*//g' \
		-e 's/,//g' |\
		grep -v '^$' |\
		tr -s ' ' ',' |\
		grep -v '^-' |\
		grep -B 1 'normal,' |\
		tr '\n' ',' |\
		sed 's/--,/\n/g' |\
		sed 's/,$//g' |\
		tr -s ',' ',' |\
		awk -v var="$ESTACION" '{ print var "," $0 }' >> output/clima.csv
done
