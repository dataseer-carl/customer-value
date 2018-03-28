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

# Raw ####

## _Households ####

hh.id <- as_id("1XihLIZNBOES16ukjCXRFq3kYt03IRpz9")
hh.file <- "hh_demographic.csv"
hh.filepath <- file.path(proxydata.path, hh.file)
drive_download(hh.id, path = hh.filepath, overwrite = TRUE)

hh.raw <- read_csv(
	hh.filepath,
	col_types = cols(
	  AGE_DESC = col_character(),
	  MARITAL_STATUS_CODE = col_character(),
	  INCOME_DESC = col_character(),
	  HOMEOWNER_DESC = col_character(),
	  HH_COMP_DESC = col_character(),
	  HOUSEHOLD_SIZE_DESC = col_character(),
	  KID_CATEGORY_DESC = col_character(),
	  household_key = col_character()
	)
)

hh.df <- hh.raw %>% 
	mutate(
		AGE_DESC = factor(AGE_DESC, levels = c("19-24", "25-34", "35-44", "45-54", "55-64", "65+")),
		MARITAL_STATUS = factor(
			MARITAL_STATUS_CODE, 
			levels = c("B", "A"), # "U" := NA
			labels = c("Single", "Married")
		),
		INCOME_DESC = factor(
			INCOME_DESC,
			levels = c(
				"Under 15K", "15-24K", "25-34K", "35-49K", "50-74K", "75-99K", 
				"100-124K", "125-149K", "150-174K", "175-199K", "200-249K", "250K+"
			)
		),
		Homeowner.infosrc = HOMEOWNER_DESC %>% 
			str_detect("^Probable") %>% 
			ifelse("Probable", "Certain") %>% 
			replace(HOMEOWNER_DESC == "Unknown", NA),
		HOMEOWNER_DESC = factor(
			HOMEOWNER_DESC %>% str_replace_all(c("^Probable " = "")),
			levels = c("Renter", "Homeowner")
		),
		HOUSEHOLD_SIZE_DESC = factor(
			HOUSEHOLD_SIZE_DESC,
			levels = c("1", "2", "3", "4", "5+")
		),
		KID_CATEGORY_DESC = KID_CATEGORY_DESC %>% 
			replace(
				str_detect(HH_COMP_DESC, "No Kids$|^Single"),
				"None"
			) %>% 
			str_replace_all(c("None/(?=Unknown)" = "")) %>%
			factor(levels = c("None", "1", "2", "3+"))
	) %>% 
	select(
		household_key,
		INCOME_DESC, HOMEOWNER_DESC, Homeowner.infosrc, 
		MARITAL_STATUS, HH_COMP_DESC, HOUSEHOLD_SIZE_DESC, KID_CATEGORY_DESC
	)

## _Transactions ####

trans.id <- as_id("1UNLrd6q7yqeLTwVUCNMl1trR3dvB2YR1")
trans.file <- "transaction_data.csv"
trans.filepath <- file.path(proxydata.path, trans.file)
drive_download(trans.id, path = trans.filepath, overwrite = TRUE)

trans.raw <- fread(
	trans.filepath,
	colClasses = c(
		"household_key" = "character",
		"BASKET_ID" = "character",
		"DAY" = "integer",
		"PRODUCT_ID" = "character",
		"QUANTITY" = "integer",
		"SALES_VALUE" = "numeric",
		"STORE_ID" = "character",
		"RETAIL_DISC" = "numeric",
		"TRANS_TIME" = "character",
		"WEEK_NO" = "integer",
		"COUPON_DISC" = "numeric",
		"COUPON_MATCH_DISC" = "numeric"
	)
)

bskt.df <- trans.raw[
	,
	.(
		unq.products = n_distinct(PRODUCT_ID),
		num.items = sum(QUANTITY),
		net.sales = sum(SALES_VALUE)
	),
	keyby = .(household_key, BASKET_ID, WEEK_NO, DAY, TRANS_TIME, STORE_ID)
]
bskt.df <- as.data.frame(bskt.df)

# Save ####

cache.file <- "data00u_cleaned hh ingest.RData"
cache.filepath <- file.path(proxydata.path, cache.file)
save(hh.df, bskt.df, file = cache.filepath)
drive_upload(cache.filepath, datapath.id, cache.file)
drive_sub_id(datapath.id, cache.file) # 1uYSaJ9au_biJDUngWmcU23qltWR5Jenv

bskt.file <- "data01_trans-lvl.csv"
bskt.filepath <- file.path(proxydata.path, bskt.file)
write.csv(bskt.df, bskt.filepath, row.names = FALSE)
drive_upload(bskt.filepath, datapath.id, bskt.file)
drive_sub_id(datapath.id, bskt.file) # 1FNOLwSMGjaC-4aZvj1XJ9COpxD0jKTqq
