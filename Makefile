SRC = $(shell find . -type f -name '*.md')
POSTS = $(shell find posts -type f -name '*.md')
MAKE_POSTS = ./scripts/makePost.sh

.PHONEY: all clean

all: pre-build main-build post-build

pre-build: 
	rm -f posts.md

main-build: $(SRC:.md=.html)

clean:
		rm -f $(SRC:.md=.html)

posts/%.html: posts/%.md
	pandoc --template=html.template --variable=updated:"$(shell date)" --from=markdown --to=html -H _header.html -s -o $(@) $<

%.html: %.md
	pandoc --template=html.template --variable=updated:"$(shell date)" --from=markdown --to=html -H _header.html -s -o $(@) $<

post-build:
	echo "%Posts\n" > posts.md
	for post in $(POSTS); do $(MAKE_POSTS) $$post posts.md; done
	pandoc --template=html.template --variable=updated:"$(shell date)" --from=markdown --to=html -H _header.html -s -o posts.html posts.md
