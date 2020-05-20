# LIST OF REQUIRED PACKAGES -----------------------------------------------

required_packages <- c(
  "sp",
  "tidyverse",
  "dygraphs",
  "xts",
  "leaflet",
  "RColorBrewer",
  "wordcloud2",
  "dplyr",
  "purrr",
  "tibble",
  "plotly",
  "shiny",
  "shinydashboard",
  "shinyBS",
  "shinyWidgets",
  "shinycssloaders",
  "visNetwork",
  "igraph",
  "ggplot2",
  "stats",
  "graphics",
  "plotly",
  "zoo"
)


# install missing packages

new.packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]

if (length(new.packages)) {
  install.packages(new.packages)
}

rm(new.packages)