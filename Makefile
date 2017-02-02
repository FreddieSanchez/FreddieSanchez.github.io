SRC = $(shell find . -type f -name '*.md')

.PHONEY: all clean

all: $(SRC:.md=.html)

clean:
		rm -f $(SRC:.md=.html)

%.html: %.md
		pandoc -f markdown -t html -H _header.html -s -o $(@) $<
