SRC = $(shell find . -type f -name '*.md')
MAKE_POSTS = ./scripts/makePost.sh


.PHONEY: all clean

all: pre-build main-build

pre-build: 
	echo "" > posts.md

main-build: $(SRC:.md=.html)

clean:
		rm -f $(SRC:.md=.html)

posts/%.html: posts/%.md
	$(MAKE_POSTS) $< $(@) posts.md
	pandoc --template=html.template --variable=updated:"$(shell date)" --from=markdown --to=html -H _header.html -s -o $(@) $<

%.html: %.md
	pandoc --template=html.template --variable=updated:"$(shell date)" --from=markdown --to=html -H _header.html -s -o $(@) $<
