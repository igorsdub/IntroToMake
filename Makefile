# Makefile for analysis report
#

ALL_CSV = $(wildcard data/*.csv)
DATA = $(filter-out $(wildcard data/input_file_*.csv),$(ALL_CSV))
HISTOGRAMS = $(patsubst %,figures/histogram_%.pdf,$(GENRES))
QQPLOTS = $(patsubst %,figures/qqplot_%.pdf,$(GENRES))

GENRES = $(patsubst data/%.csv,%,$(DATA))
SCRIPTS = histogram qqplot

.PHONY: all clean

all: results/report.pdf

# Canned recipe to run a script on a data file
define run-script-on-data
figures/$(1)_$(2).pdf: data/$(2).csv scripts/generate_$(1).py
	python scripts/generate_$(1).py -i $$< -o $$@
endef

# Create all targets with a double loop
$(foreach genre,$(GENRES),\
	$(foreach script,$(SCRIPTS),\
		$(eval $(call run-script-on-data,$(script),$(genre)))\
	)\
)

results/report.pdf: report/report.tex figures/figure_1.pdf figures/figure_2.pdf $(HISTOGRAMS) $(QQPLOTS)
	tectonic --outdir results report/report.tex

dag:
	mkdir -p tmp/
	make -Bnd -f Makefile | make2graph | dot -Tpdf -o tmp/dag.pdf

clean:
	rm -f results/report.pdf
	rm -f $(HISTOGRAMS) $(QQPLOTS)
	rm -f tmp/dag.pdf
