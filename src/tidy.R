library(tidyverse)

db <- read_csv("output/smn-raw-data.csv", col_names = FALSE) %>%
	rename(code = X1,
	       locality = X2,
	       value = X3,
	       variable = X4) %>%
	mutate(variable = if_else(variable == "precipitation\n",
				  "precipitation", variable))

head(db)
tail(db)

count(db, variable)

db %>%
	group_by(variable) %>%
	summarise(mn = mean(value), sd = sd(value))

db %>%
	filter(variable == "precipitation") %>%
	ggplot() +
	geom_density(aes(value))

db %>%
	filter(variable == "precipitation") %>%
	ggplot() +
	geom_histogram(aes(value))

db %>%
	mutate(state = str_sub(code, 1, 5)) %>%
	group_by(state, variable) %>%
	summarise(mn = mean(value)) %>%
	arrange(desc(mn))
