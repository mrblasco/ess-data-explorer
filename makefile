
all: ESS-variables-rounds.html

%.Rmd : %.R
	Rscript -e 'knitr::spin("$<", knit = FALSE)'

%.html : %.Rmd 
	Rscript -e 'rmarkdown::render("$<")'

view: 
	open ESS-variables-rounds.html

update: 
	cp ESS-variables-rounds.html docs/index.html
	open docs/index.html