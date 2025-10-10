# Makefile for analysis report

.PHONY: all clean dag

all: results/report.pdf

figures/figure_1.pdf: data/input_file_1.csv scripts/generate_histogram.py
	python scripts/generate_histogram.py -i data/input_file_1.csv -o figures/figure_1.pdf

figures/figure_2.pdf: data/input_file_2.csv scripts/generate_histogram.py
	python scripts/generate_histogram.py -i data/input_file_2.csv -o figures/figure_2.pdf

results/report.pdf: report/report.tex figures/figure_1.pdf figures/figure_2.pdf
	tectonic --outdir results report/report.tex

dag:
	mkdir -p tmp/
	make -Bnd -f Makefile | make2graph | dot -Tpdf -o tmp/dag.pdf

clean:
	rm -f results/report.pdf
	rm -f figures/figure_*.pdf
	rm -f tmp/dag.pdf