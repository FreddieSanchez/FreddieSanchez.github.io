SRC = $(shell find . -type f -name '*.md')

.PHONEY: all clean

all: $(SRC:.md=.html)

clean:
		rm -f $(SRC:.md=.html)

%.html: %.md
	pandoc --template=html.template --variable=updated:"$(shell date)" --from=markdown --to=html -H _header.html -s -o $(@) $<
