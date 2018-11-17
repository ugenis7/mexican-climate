for var in "$@" 
do
	OUTFILE=$(echo $(basename "${var/.TXT}" | tr '[A-Z]' '[a-z]')-utf8.txt)
	iconv -f windows-1254 -t  utf8//TRANSLIT ${var} -o output/${OUTFILE};
done
