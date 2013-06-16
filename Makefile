TITLE = Was sind eigentlich Daten? Von Information zum Dokument.
AUTHOR = Jakob Voß
BIBLIOGRAPHY = bibliography.bib
# CSL style for HTML
CSL=chicago-author-date-de.csl
# biblatex style for LaTeX
BIBSTYLE=authoryear

include makedoc/Makefile

bibliography.csv: paper.md
	@egrep -o '@[A-Za-z]+[0-9]+[a-z]*' $< | sort | uniq > $@

.PHONY: bib

bib: bibliography.csv
	./getbib.pl voj < $< > bibliography.bib

