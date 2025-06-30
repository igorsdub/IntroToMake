# Makefile for analysis report
#

ALL_CSV = $(wildcard data/*.csv) # All CSV files in the data directory
INPUT_CSV = $(wildcard data/input_file_*.csv) # CSV files that start with "input_file_"
DATA = $(filter-out $(INPUT_CSV),$(ALL_CSV)) # Filter out input files. Leaves only genre-specific data files.
FIGURES = $(patsubst data/%.csv,output/figure_%.png,$(DATA)) # Substitute data file name to figure files 

.PHONY: all clean

all: output/report.pdf

$(FIGURES): output/figure_%.png: data/%.csv scripts/generate_histogram.py
	python scripts/generate_histogram.py -i $< -o $@

output/report.pdf: report/report.tex $(FIGURES)
	cd report/ && pdflatex report.tex && mv report.pdf ../$@

clean:
	rm -f output/report.pdf
	rm -f $(FIGURES)