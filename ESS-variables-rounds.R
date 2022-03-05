
#+ setup, include = FALSE
knitr::opts_chunk$set(warnings = FALSE, message = FALSE, echo = FALSE)
library(essurvey)
library(dplyr)
library(tidyr)
library(stringr)
library(htmltools)
library(htmlwidgets)
library(reactable)

#+ data, include = FALSE, cache = TRUE
ess <- 
	essurvey::import_country(c("Poland")
		, rounds = 1:9
		, format = "spss"
		, ess_email = 'mrblasco@gmail.com')

#+ manipulate, include = FALSE
get_label <- function(x) {
	if (is.null(attributes(x))) return("")
	attributes(x)$label 
}

paste_collapse <- function(x) {
	paste(sort(unique(x)), collapse = "|")
}

# Extract label and type and reshape 
ess_labels <- 
	ess %>% 
	lapply(function(x) {
		x %>% 
		dplyr::summarize_all(list(typeof, get_label)) %>% 
		tidyr::pivot_longer(everything()) %>% 
		tidyr::separate(name, into = c("name", "func")) %>%
		tidyr::pivot_wider(names_from = func)
})


# Summarize variables by type and label
ess_table <-
	ess_labels  %>%
	dplyr::bind_rows(.id = 'round') %>%
	dplyr::group_by(name) %>%
	dplyr::summarize(
		round = paste(round, collapse = "|")
		, type = paste_collapse(fn1)
		, label = paste_collapse(fn2)
		)
		
# 
ess_table_react <-
	ess_table %>% 
	rename(Rounds = round, Variable = name, Type = type, Question = label) %>% 
    reactable(.
      , pagination = TRUE
      , showSortIcon = FALSE,
      , highlight = TRUE,
      , compact = TRUE,
      , defaultSorted = "Variable",
      , defaultSortOrder = "asc"
      , search = TRUE
      , filter = TRUE
      , columns = list (
		Rounds = colDef(maxWidth = 100, align = "center")
		, Type = colDef(maxWidth = 100, align = "center")
		, Variable = colDef(maxWidth = 100, align = "left")
		, Question = colDef(align = "left")
      	)
      )


#+ table
div(class = "ess-table",
    div(class = "title"
    	, h2("European Social Survey (ESS) Dataset Explorer")
    	, "Variable names and definitions from every ESS from the first to nineth round"
    	)
    , ess_table_react
	, tags$span(style = "color:#777"
	    , "Note: Variable = variable code name in the data." 
    	, div("Table created by: Andrea Blasco @mrblasco  •  Data: http://www.europeansocialsurvey.org")
	)
)






