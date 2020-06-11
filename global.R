################################################################################
# Entry point of the Shiny app
#
# Author: Chuan-Xing Li
# Created: 2020-05-11
################################################################################

# import libraries----------
library(sp)
library(tidyverse)
library(dygraphs)
library(xts)

library(leaflet)
library(RColorBrewer)
library(wordcloud2)
library(dplyr)
library(purrr)
library(tibble)

library(plotly)
library(shiny)
library(shinydashboard)
library(shinyBS)
library(shinyWidgets)
library(shinycssloaders)

library(visNetwork)
library(igraph)
library(ggplot2)
library(stats)
library(graphics)
library(plotly)
library(zoo)


# DATA TRANSFORMATION AND NEW VARIABLES -----------------------------------
load("data/world_spdf.rdata")

fdate = read.csv2(file="https://raw.githubusercontent.com/clisweden/coracle_data/master/fdate.csv",stringsAsFactors = F)
pmid.info.extended <- read.csv2("https://raw.githubusercontent.com/clisweden/coracle_data/master/pmid.info.extended.csv",stringsAsFactors = F)
pmid.info.extended$date<-as.Date(pmid.info.extended$date)
cnet <- read.csv2("https://raw.githubusercontent.com/clisweden/coracle_data/master/cnet.csv",stringsAsFactors = F)
pmid.mesh <- read.csv2("https://raw.githubusercontent.com/clisweden/coracle_data/master/pmid.mesh.csv",stringsAsFactors = F)
pmid.pub.type <- read.csv2("https://raw.githubusercontent.com/clisweden/coracle_data/master/pmid.pub.type.csv",stringsAsFactors = F)
relPMID <- read.csv2("https://raw.githubusercontent.com/clisweden/coracle_data/master/relPMID.csv",stringsAsFactors = F)
relMeSH <- read.csv2("https://raw.githubusercontent.com/clisweden/coracle_data/master/relMeSH.csv",stringsAsFactors = F)

pmid.info <- pmid.info.extended[pmid.info.extended$LitCovid==TRUE,]
raw.language.all <- sort(unique(pmid.info$language))
raw.country.all <- sort(unique(pmid.info$country))
raw.journal.all <- sort(as.character(unique(pmid.info$journal)))
raw.pub.type.all <- sort(as.character(unique(pmid.pub.type$value)))
raw.mesh.all <- sort(as.character(unique(pmid.mesh$value))) 

relMeSH <- subset(relMeSH,n>3)
relPMID <- subset(relPMID,N>3)
# color-----------
colorpal = c(
  "#FFFFE5",
  "#FFF7BC",
  "#FEE391",
  "#FEC44F",
  "#FE9929",
  "#EC7014",
  "#CC4C02" ,
  "#993404",
  "#662506",
  "#251e3e"
)
plotlypal <-
  c(
    brewer.pal(11, "Spectral")[1:5],
    brewer.pal(11, "BrBG")[11:7],
    brewer.pal(11, "PRGn")[1:5]
  )
plotlyf <- list(family = "Courier New, monospace",
          size = 18,
          color = "#7f7f7f")

ay <- list(
  tickfont = list(color = "rgb(0,100,0)"),
  overlaying = "y",
  side = "right",
  title = "Cumulated Publications",
  titlefont = list(
    family = "Courier New, monospace",
    size = 18,
    color = "rgb(0,100,0)"
  )
)

ayleft <- list(
  tickfont = list(color = "rgba(152, 0, 0, .8)"),
  overlaying = "yl",
  side = "left",
  title = "Daily New Publication",
  titlefont = list(
    family = "Courier New, monospace",
    size = 18,
    color = "rgba(152, 0, 0, .8)"
  )
)
