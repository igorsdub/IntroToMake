# Makefile for analysis report
#

ALL_CSV = $(wildcard data/*.csv)
DATA = $(filter-out $(wildcard data/input_file_*.csv),$(ALL_CSV))
HISTOGRAMS = $(patsubst %,output/histogram_%.png,$(GENRES))
QQPLOTS = $(patsubst %,output/qqplot_%.png,$(GENRES))

GENRES = $(patsubst data/%.csv,%,$(DATA))
SCRIPTS = histogram qqplot

.PHONY: all clean

all: output/report.pdf

# Canned recipe to run a script on a data file
define run-script-on-data
output/$(1)_$(2).png: data/$(2).csv scripts/generate_$(1).py
	python scripts/generate_$(1).py -i $$< -o $$@
endef

# Create all targets with a double loop
$(foreach genre,$(GENRES),\
	$(foreach script,$(SCRIPTS),\
		$(eval $(call run-script-on-data,$(script),$(genre)))\
	)\
)

output/report.pdf: report/report.tex output/figure_1.png output/figure_2.png $(HISTOGRAMS) $(QQPLOTS)
	tectonic --outdir output report/report.tex

dag:
	mkdir -p tmp/
	make -Bnd -f Makefile | make2graph | dot -Tpdf -o tmp/dag.pdf

clean:
	rm -f output/report.pdf
	rm -f $(HISTOGRAMS) $(QQPLOTS)
	rm -f tmp/dag.pdf
