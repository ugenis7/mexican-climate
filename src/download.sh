#!/usr/bin/env bash

curl https://smn.cna.gob.mx/es/climatologia/informacion-climatologica/normales-climatologicas-por-estado |\
	grep -o '/es/informacion-climatologica-por-estado?estado=[a-z]*' |\
	sed 's/^/https:\/\/smn.cna.gob.mx/g' |\
	xargs -n 1 curl -s |\
	grep -o '/tools/RESOURCES/normales_climatologicas_catalogo/cat_[a-z]*.html' |\
	sed 's/^/https:\/\/smn.cna.gob.mx/g' |\
	xargs -n 1 curl -s |\
	grep -o 'https://smn.conagua.gob.mx/tools/RESOURCES/Normales5110/[A-Z0-9]*.TXT' |\
	sort |\
	uniq |\
	xargs -n 1 wget --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" -P input/

echo '' > output/municipalities.csv

curl https://smn.cna.gob.mx/es/climatologia/informacion-climatologica/normales-climatologicas-por-estado |\
	grep -o '/es/informacion-climatologica-por-estado?estado=[a-z]*' |\
	sed 's/^/https:\/\/smn.cna.gob.mx/g' |\
	xargs -n 1 curl -s |\
	grep -o '/tools/RESOURCES/normales_climatologicas_catalogo/cat_[a-z]*.html' |\
	sed 's/^/https:\/\/smn.cna.gob.mx/g' |\
	xargs -n 1 curl -s |\
	tr -s '\n' ' ' |\
	sed 's/<tr/\n\n<tr/g' |\
	sed 's/<td/,<td/g' |\
	sed 's/<[^>]*>//g' |\
	sed 's/^[ ,]*//g' |\
	grep -v '^$' |\
	sed 's/[ ]*,[ ]*/,/g' |\
	grep '^[A-Z]' |\
	awk -F"," '{print $1 "," $2 "," $3}' |\
	sed 's/ ([^)]*)//g' |\
	grep -v 'NOMBRE,MUNICIPIO' |\
	sed 's/^\|$/"/g' |\
	sed 's/,/","/g' >> output/municipalities.csv
