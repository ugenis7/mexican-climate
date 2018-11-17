#!/usr/bin/env bash

curl http://smn.conagua.gob.mx/es/climatologia/informacion-climatologica |\
	grep estado |\
	grep -o "'.*'" |\
	sed "s/'//g" |\
	sed 's/^/http:\/\/smn.conagua.gob.mx\/es/g' |\
	xargs -n 1 curl -s |\
	grep -o '/tools/RESOURCES/normales_climatologicas_catalogo/[a-z_]*.html' > catalogue.txt

cat catalogue.txt |\
	sed 's/^/http:\/\/smn.conagua.gob.mx/g' |\
	xargs -n 1 curl -s |\
	grep -o '/Normales5110.*TXT' |\
	sed 's/^/http:\/\/smn.conagua.gob.mx\/tools\/RESOURCES/g' |\
	xargs -n 1 wget --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" -P input/

rm catalogue.txt
