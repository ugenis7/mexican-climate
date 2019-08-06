# This script generates a tidy version of the database including INEGI's cvegeo
# code, SMN's, code and SMN's data on precipitation and max-temperature

# Initial loading
library(tidyverse)

smn <- read_csv("output/municipalities.csv", col_names = FALSE) %>%
	rename(station = X1,
	       municipality = X2,
	       code = X3) %>%
mutate(state = str_sub(code, 1, 2))

inegi <- read_csv("input/municipality_codes.csv") %>%
	mutate(cvegeo = str_c(cve_ent, cve_mun)) %>%
	select(cvegeo, cve_ent, cve_mun, nom_ent, nom_mun)

db <- read_csv("output/smn-raw-data.csv", col_names = FALSE) %>%
	rename(code = X1,
	       locality = X2,
	       value = X3,
	       variable = X4) %>%
	mutate(variable = if_else(variable == "precipitation\n",
				  "precipitation", variable),
	       code = str_sub(code, 4, -1))

# Find the easiest matches between the two databases (most of them, actually)
matched <- tibble(code = NA, municipality = NA, cvegeo = NA, nom_mun = NA)

for(i in 1:32){
	if(i < 10) i = paste0("0", i)
	i <- as.character(i)

	a <- filter(smn, state == i) %>%
		select(code, municipality) %>%
		mutate(municipality = str_to_lower(municipality))

	b <- filter(inegi, cve_ent == i) %>%
		select(cvegeo, nom_mun) %>%
		mutate(nom_mun = str_to_lower(nom_mun),
		       nom_mun = str_replace(nom_mun, "á", "a"),
		       nom_mun = str_replace(nom_mun, "á", "a"), # This encoding is dif
		       nom_mun = str_replace(nom_mun, "é", "e"),
		       nom_mun = str_replace(nom_mun, "í", "i"),
		       nom_mun = str_replace(nom_mun, "ó", "o"),
		       nom_mun = str_replace(nom_mun, "ú", "u"))

		x <- match(a$municipality, b$nom_mun)

		matched <- bind_rows(matched, a %>% cbind(b[x, ]))
}

# These are the municipalities that have different names in the two databases. 
# Mostly, their differences come from SMN's names being shortened versions
codes <- matched %>%
	select(-nom_mun) %>%
	mutate(cvegeo = if_else(municipality == "batopilas", "08008", cvegeo),
	       cvegeo = if_else(municipality == "bellavista", "07011", cvegeo),
	       cvegeo = if_else(municipality == "doctor belisario dominguez",
				"08022", cvegeo),
	       cvegeo = if_else(municipality == "silao", "11037", cvegeo),
	       cvegeo = if_else(municipality == "maravatio", "11036", cvegeo),
	       cvegeo = if_else(municipality == "acambay", "15001", cvegeo),
	       cvegeo = if_else(municipality == "jonacatepec", "17013", cvegeo),
	       cvegeo = if_else(municipality == "tlaltizapan", "17024", cvegeo),
	       cvegeo = if_else(municipality == "zacualpan", "17032", cvegeo),
	       cvegeo = if_else(municipality == "san pedro mixtepec -dto. 22 -",
				"20318", cvegeo),
	       cvegeo = if_else(municipality == "san pedro mixtepec -dto. 26 -",
				"20319", cvegeo),
	       cvegeo = if_else(municipality == "tezoatlan de segura y luna",
				"20549", cvegeo),
	       cvegeo = if_else(municipality == "villa de tututepec de melchor ocampo",
				"20334", cvegeo),
	       cvegeo = if_else(municipality == "san pedro totolapa", "20333",
				cvegeo),
	       cvegeo = if_else(municipality == "santa maria del rio", "24032",
				cvegeo),
	       cvegeo = if_else(municipality == "altzayanca", "29004", cvegeo),
	       cvegeo = if_else(municipality ==
				"zitlaltepec de trinidad sanchez santos",
				"29037", cvegeo),
	       cvegeo = if_else(municipality == "medellin", "30104",
				cvegeo)) %>%
	filter(complete.cases(.)) %>%
	filter(!str_sub(municipality, 1, 7) == "insular")

# Final join of the databases
final <- left_join(db, codes) %>%
	unique() %>%
	select(cvegeo, code, variable, value) %>%
	filter(complete.cases(.)) %>%
	arrange(cvegeo)
