# Load packages
library(tidyverse)
library(ggplot2)
library(dplyr)
library(docopt)
library(readr)

"This script provides visualization for this report.

Usage: 04-visualization.R --data_path=<data_path> --output_path=<output_path> --model_path=<model_path> --selection_path=<selection_path> --num_path=<num_path>
" -> doc

# enter this in terminal or Makefile:
# Rscript code/04-visualization.R --data_path=data/tips.RDS --output_path=output/ --model_path=output/model.RDS --selection_path=output/selection.RDS --num_path=output/num.RDS

opt <- docopt(doc)

data_tips <- read_rds(opt$data_path)


# Main developer: Iris Caglayan
# Contributor: Wanqing Hu

# transform size into factor type for visualization
data_size_as_fac <- data_tips %>% mutate(
    day = factor(day, levels = unique(day)),
    time = as.factor(time),
    size = factor(size, levels= unique(size))
)

ggplot(data_size_as_fac, aes(x = day, y = tip, fill = time)) +
  geom_boxplot(alpha = 0.7, outlier.shape = NA) + 
  geom_jitter(aes(color = size), width = 0.2, alpha = 0.6, size = 2.5) +  # Transparent and smaller points
  scale_color_manual(values = c("1"="yellow", "2"="blue", "3"="purple", "4"= "green", "5"="pink", "6"= "brown")) +  
labs(
    title = "Time of Day, Day of the Week and Amount of Tip",
      subtitle = "Showing the Tipping Distribution per Party Size",
    x = "Day of the Week",
    y = "Tip Amount in USD",
    fill = "Meal Time",
    color = "Party Size"
  )
ggsave(paste0(opt$output_path, "fig_vis_1.png"))


# Main developer: Wanqing Hu
# Contributor: Wanqing Hu

ggplot(data_tips, aes(x = total_bill, y = tip, color = sex, size = size)) +
  geom_point(alpha = 0.7) +
  facet_wrap(~ day, nrow = 2) +
  labs(
    title = "Tip versus Total Bill by Day",
    x = "Total Bill (USD)", 
    y = "Tip (USD)"
  ) +
  theme(legend.position = "bottom")
ggsave(paste0(opt$output_path, "fig_vis_2.png"))

#load the model for post-fitting plot
tips_model <- read_rds(opt$model_path)
tips_bwd_bic <- read_rds(opt$selection_path)
n <- read_rds(opt$num_path)
# Main developer: Jiaming Chang
# Contributor: Jiaming Chang

# Extract BIC values for each step.
bic_values <- c(BIC(tips_model), tips_bwd_bic$anova$AIC + (log(n)-2)*(n-1))
plot_data <- data.frame(
  Step = 0:(length(bic_values)-1),
  BIC = bic_values
)

# Plot the steps and BIC value for stepwise selection
ggplot(plot_data, aes(x = Step, y = BIC)) +
  geom_line(color = "red", linewidth = 1) +
  geom_point(color = "black", size = 3) +
  geom_hline(yintercept = min(bic_values), linetype = "dashed", color = "blue") +
  labs(title = "Figure 1: BIC Values During Backward Selection",
       subtitle = paste("Optimal model at Step", which.min(bic_values)-1),
       x = "Step Number",
       y = "BIC") +
  theme_minimal() +
  scale_x_continuous(breaks = plot_data$Step) +
  geom_text(aes(label = round(BIC, 1)), vjust = -1)
ggsave(paste0(opt$output_path, "fig_vis_3.png"))
