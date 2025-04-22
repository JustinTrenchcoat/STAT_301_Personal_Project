.PHONY: all clean report

all: 
	make clean
	make index.html

report:
	make index.html

index.html:	data/tips.RDS \
			output/table.RDS \
			output/model.RDS \
			output/selection.RDS \
			output/summary.RDS \
			output/fig_vis_1.png \
			output/fig_vis_2.png \
			output/fig_vis_3.png \
			reports/group4_report.html \
			reports/group4_report.pdf 
			quarto render reports/group4_report.qmd
			cp reports/group4_report.html docs/index.html

# 01-load.R
data/tips.RDS: code/01-load.R
	Rscript code/01-load.R \
	--url_path=https://raw.githubusercontent.com/JustinTrenchcoat/STAT_301_Personal_Project/refs/heads/main/tips.csv \
	--output_path=data/tips.RDS


# 02-EDA.R
output/table.RDS: code/02-EDA.R
	Rscript code/02-EDA.R --data_path=data/tips.RDS --output_path=output/table.RDS

		
# 03-analysis.R
output/model.RDS output/selection.RDS output/summary.RDS output/num.RDS: code/03-analysis.R
	Rscript code/03-analysis.R \
	--data_path=data/tips.RDS \
	--model_path=output/model.RDS \
	--selection_path=output/selection.RDS \
	--summary_path=output/summary.RDS \
	--num_path=output/num.RDS


# 04-visualization.R
output/fig_vis_1.png output/fig_vis_2.png output/fig_vis_3.png: code/04-visualization.R
	Rscript code/04-visualization.R \
	--data_path=data/tips.RDS \
	--output_path=output/ \
	--model_path=output/model.RDS \
	--selection_path=output/selection.RDS \
	--num_path=output/num.RDS

#we ignore validation part first		
# 05-data-validation.R
# output/DVC.html: code/05-data-validation.R
# 	Rscript code/05-data-validation.R --file_path=data/cleaned/not_valid.RDS --report_path=output/


# render quarto report in HTML and PDF
reports/group4_report.html: output reports/group4_report.qmd
	quarto render reports/group4_report.qmd --to html

reports/group4_report.pdf: output reports/group4_report.qmd
	quarto render reports/group4_report.qmd --to pdf
	
# test the functions, and yes this is a Mickey Mouse Clubhouse reference
# test:
# 	@echo "Running tests on surprise tools that will help us later!"	
# 	Rscript -e 'testthat::test_dir("tests/testthat")'
# 	@echo "Functions check complete!"

# clean
clean: 
		rm -rf data/*
		rm -rf output/*
		rm -rf docs/*
		rm -rf reports/group4_report.html \
				reports/group4_report.pdf
		rm *.pdf