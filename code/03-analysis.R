# Load packages
library(tidyverse)
library(ggplot2)
library(dplyr)
library(docopt)
library(readr)
library(MASS)


"This script provides analysis for this report.

Usage: 03-analysis.R --data_path=<data_path> --model_path=<model_path> --selection_path=<selection_path> --summary_path=<summary_path> --num_path=<num_path>
" -> doc

# enter this in terminal or Makefile:
# Rscript code/03-analysis.R --data_path=data/tips.RDS \
# --model_path=output/model.RDS --selection_path=output/selection.RDS \
# --summary_path=output/summary.RDS --num_path=output/num.RDS

opt <- docopt(doc)

data_tips <- read_rds(opt$data_path)

# Main developer: Jia Xin Tan
# Contributor: Jiaming Chang

# set up random see
set.seed(120)

# tidy the data: change the data type from strings to factors
tips_tidied <- data_tips |> 
    mutate(sex = factor(sex),
           smoker = factor(ifelse(smoker == "Yes", "Smoker", "Non-smoker")),
           day = factor(day),
           time = factor(time), 
           size = factor(size))


# Main developer: Jia Xin Tan
# Contributor: Jiaming Chang

# Data splitting process: 
# 70% of the data is splitted from the whole dataset, stored as `tips_train`, and used for backward selection process.
# the other 30% of dataset is stored as `tips_select` for evaluation.
tips_sample <- 
    tips_tidied |>
    mutate(id = row_number())

tips_train <- tips_sample |> 
    slice_sample(prop = 0.7, replace = FALSE)

tips_select <- tips_sample |>
    anti_join(tips_train, by = "id")

tips_train <- tips_train |> 
    dplyr::select(- "id")

tips_select <- tips_select |>
    dplyr::select(- "id")


# Main developer: Jia Xin Tan
# Contributor: Jiaming Chang

# Backward selection process, the metric is BIC
tips_model <- lm(tip ~ ., data = tips_train)
write_rds(tips_model, opt$model_path)
n <- nrow(tips_train)
write_rds(n, opt$num_path)
# Run stepwise selection with BIC (k = log(n))
tips_bwd_bic <- stepAIC(tips_model, 
                       direction = "backward",
                       k = log(n), 
                       trace = 2)   # Set to 2 for detailed output
write_rds(tips_bwd_bic, opt$selection_path)


# Main developer: Jia Xin Tan
# Contributor: Jiaming Chang

# Evaluate the model with the 30% of original dataset
tips_select_bwd <- lm(tip ~ total_bill, tips_select)

# print out information for this evaluation
tips_eval <- summary(tips_select_bwd)
write_rds(tips_eval, opt$summary_path)



