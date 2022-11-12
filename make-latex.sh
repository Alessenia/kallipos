#!/bin/sh
#assemble and preprocess all the sources files
if [ ! -d "./latex" ]; then
  mkdir ./latex
fi

RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${RED}Assembling and preprocessing all the sources files${NC}"
echo " Converting text/pre.txt to latex/pre.tex"

pandoc text/pre.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/pre.tex
echo " Converting text/intro.txt to latex/intro.tex"
pandoc text/intro.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/intro.tex

for filename in text/ch*.txt; do
   [ -e "$filename" ] || continue
echo " Converting $filename to latex/$(basename "$filename" .txt).tex"
pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --lua-filter=footnote.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --wrap=none --to latex > latex/"$(basename "$filename" .txt).tex" 
done

echo " Converting text/epi.txt to latex/epi.tex"
pandoc text/epi.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/epi.tex

for filename in text/apx*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --to latex > latex/"$(basename "$filename" .txt).tex"
done

echo
echo -e "${RED}Merging all the latex files into latex/book.tex${NC}"
pandoc -s latex/*.tex -o book.tex
echo 

echo -e "${RED}Converting latex/book.tex to book.pdf${NC}"
pandoc -N --quiet --variable "geometry=margin=1.2in" --variable mainfont="stepgreek" --variable sansfont="stepgreek" --variable monofont="stepgreek" --variable fontsize=12pt --variable version=2.0 book.tex  --pdf-engine=xelatex --toc -o book/book.pdf
echo 

echo -e "${RED}Removing book.tex${NC}"
echo 



