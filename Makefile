SRC = $(shell find . -type f -name '*.md')
POSTS = $(shell find posts -type f -name '*.md' | xargs -I {} sh -c 'echo -n "`head -n 1 {}`_"; echo  \{}' | sort --field-separator=- -k1 -k2M -k3 -r | cut -d_ -f2-)
MAKE_POSTS = ./scripts/makePost.sh

.PHONEY: all clean

all: main-build post-build

main-build: $(SRC:.md=.html)

clean:
		rm -f $(SRC:.md=.html)

posts/%.html: posts/%.md
	pandoc --template=html.template --variable=updated:"$(shell date)" --from=markdown --to=html -H _header.html -s -o $(@) $<

%.html: %.md
	pandoc --template=html.template --variable=updated:"$(shell date)" --from=markdown --to=html -H _header.html -s -o $(@) $<

post-build:
	rm -f posts.md
	echo "%Posts\n" > posts.md
	for post in $(POSTS); do $(MAKE_POSTS) $$post posts.md; done
	pandoc --template=html.template --variable=updated:"$(shell date)" --from=markdown --to=html -H _header.html -s -o posts.html posts.md
