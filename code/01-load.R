library(docopt)
library(readr)

"This script loads restaurant data from internet, and saves it to the 'data' folder

Usage: 01-load.R --url_path=<url_path> --output_path=<output_path>
" -> doc

# enter this in terminal or Makefile:
# Rscript code/01-load.R --url_path=https://raw.githubusercontent.com/JustinTrenchcoat/STAT_301_Personal_Project/refs/heads/main/tips.csv --output_path=data/tips.RDS

opt <- docopt(doc)

# read data into R
url <- opt$url_path
data_tips <- read.csv(url(url), header = TRUE)
write_rds(data_tips, opt$output_path)