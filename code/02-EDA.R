# Load packages
library(docopt)
library(tibble)
library(tidyverse)
library(dplyr)
library(readr)
library(stat301Proj)

"This script reads restaurant data from folder, runs some EDA on it.

Usage: 02-EDA.R --data_path=<data_path>  --output_path=<output_path>
" -> doc

# enter this in terminal or Makefile:
# Rscript code/02-EDA.R --data_path=data/tips.RDS --output_path=output/table.RDS

opt <- docopt(doc)

data_tips <- read_rds(opt$data_path)

summary_table <- summaryTable(data_tips)

# # convert character variables into factors
# data_tips$sex <- as.factor(data_tips$sex)
# data_tips$smoker <- as.factor(data_tips$smoker)
# data_tips$day <- as.factor(data_tips$day)
# data_tips$time <- as.factor(data_tips$time)

# summary_table <- tibble(
#   variable = names(data_tips),
#   type = sapply(data_tips, function(x) class(x)[1]),
#   n_levels = sapply(data_tips, function(x) if(is.factor(x)) nlevels(x) else NA),
#   have_NA = sapply(data_tips, function(x) any(is.na(x)))
# )
write_rds(summary_table, opt$output_path)