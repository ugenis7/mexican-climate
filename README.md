# This script downloads and pre-formats climatic data from Mexico

The municipality names come from: https://www.inegi.org.mx/app/ageeml/ which is 
in UTF-16, and was converted to UTF-8 with the following command in bash

```bash
iconv -f utf-16 -t  utf8//TRANSLIT input/CATUN_MUNICIPIO.csv > 
input/municipality_codes.csv
```
