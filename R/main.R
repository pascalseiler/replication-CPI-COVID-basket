rm(list=ls())

# libraries
library(tidyverse)
library(here)
library(openxlsx)
library(gridExtra)
library(lubridate)
library(Hmisc)
library(MMWRweek)

# paths
i_am("R/main.R")
R.path = paste0(here("R"), "/")
fig.path = paste0(here("figs"), "/")
data.path = paste0(here("data"), "/")
output.path = paste0(here("output"), "/")

Sys.setlocale(category = "LC_ALL", locale = "english")
AspectRatio <- 16/9

# load data
source(here("R/get_CPI_data_agg.R"))
source(here("R/get_CPI_data_HG.R"))
source(here("R/get_CPI_data_IP.R"))
source(here("R/get_debitcard_data.R"))

# calculate COVID weights and inflation
source(here("R/calc_COVID_weights.R"))
source(here("R/calc_COVID_inflation.R"))

# produce main results
source(here("R/figure_1.R"))
source(here("R/figure_2.R"))

source(here("R/table_2.R"))
source(here("R/table_3.R"))
