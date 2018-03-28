# Script header ################################################

library(googledrive)
drive_auth()

library(dplyr)
library(data.table)
library(readr)
library(stringr)

source("./scripts/template_fxns.R") # RStudio
# source("./template_fxns.R") # Jupyter

## data://
datapath.id <- as_id("13LmePIfxYAjTfZmY2ES-k0LXb5HOEpJx")

## proxy data://
proxydata.path <- file.path(".", "Data") # For RStudio
# proxydata.path <- file.path("..", "Data") # For Jupyter

#************************************************************************#

# Ingested ####

ingest.id <- as_id("1uYSaJ9au_biJDUngWmcU23qltWR5Jenv")
ingest.file <- "dl00_cleaned hh ingest.RData"
ingest.filepath <- file.path(proxydata.path, ingest.file)
drive_download(ingest.id, path = ingest.filepath, overwrite = TRUE)

load(ingest.filepath)

n_distinct(bskt.df$household_key) # 2500
sum(unique(bskt.df$household_key) %in% unique(hh.df$household_key)) # 801
sum(unique(hh.df$household_key) %in% unique(bskt.df$household_key)) # 801
# All households in hh_demographic in transaction_data but not vice versa
