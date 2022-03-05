
all: ESS-variables-rounds.html

%.Rmd : %.R
	Rscript -e 'knitr::spin("$<", knit = FALSE)'

%.html : %.Rmd 
	Rscript -e 'rmarkdown::render("$<")'

view: 
	open ESS-variables-rounds.html