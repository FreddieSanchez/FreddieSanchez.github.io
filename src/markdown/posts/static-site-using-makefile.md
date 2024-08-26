% GitHub Pages Static Site using Markdown, Pandoc, and Makefile

I wanted to create a lean, flexible, and efficient workflow using mostly text based tools to generating a static website hosted on GitHub Pages. When I began looking how other people handled their static websites, I saw many frameworks/programs out there that did basically exactly what I wanted to do -- [Hugo], [Jekyll]. Honestly, these just seemed too complex, and what is the fun in not building something yourself. 


***Markdown***

It's widely used and [simple to learn]. I wanted each file to only be concerned with it's own specific content -- [separation of concerns]. The presentation and the formatting on the page should be handled separately, so that the content or the presentation can change independently of each other. Markdown makes it easy to write content, more importantly easy to read. It also allows me to use a simple text editor [neovim] to write the content. And best of all, it's easily converted to HTML (or PDF, etc).

***Pandoc***

Pandoc is awesome. The universal markup converter. 

> Pandoc is a Haskell library for converting from one markup format to another, and a command-line tool that uses this library.

It supports templating, and a wide range of formats. It's the bridge from the Markdown files to final HTML.

***Makefile***

Coming from a background in C programming this felt like a trip back in time.  Makefiles are efficient, language agnostic, and highly configurable for the exact needs of the project. You don't have to make it complicated if you don't want to.

---

### Project Layout

I setup my proect similar to how I setup my scala projects. I created a `src` folder for all my "source files" (markdown, assets, templates, etc). 

```
src
├── assets
│   ├── images
│   │   ├── logo.jpg
│   │   ├── favicon.ico
│   └── style
│       └── style.css
├── markdown
│   ├── index.md
│   ├── posts
│   │   ├── post-topic-1.md
│   │   ├── post-topic-2.md
│   │   ├── post-topic-3.md
│   │   ├── post-topic-4.md
│   │   ├── post-folder
│   │   │   ├── post-folder-topic-1.md
│   │   │   ├── post-folder-topic-2.md
│   │   │   ├── post-folder-topic-3.md
│   ├── posts.md
├── site.webmanifest
└── templates
    ├── _footer.html
    ├── _header.html
    ├── html.template
    └── _navigation.html

```

I then have a `target` directory in the root folder of my project where the `.md` files are converted to `.html` and served. 

### Makefile

The beauty of using a Makefile is that files that aren't changed aren't rebuilt. Additionally, you can force file to be rebuilt if it a dependency is has changed, but the file itself hasn't.

For example: 

1. Run `make clean all` ## removes the target and rebuilds all files.
2. Update `index.md`
3. Run `make` ## only `index.html` is created.

If I make updating a template a dependency to the markdown files, then when those are updated, any files that depend on them will be rebuilt.

1. Run `make clean all` ## removes the target and rebuilds all files.
2. Update `templates/_header.html`
3. Run `make` ## all markdown files are rebuilt that depend on that header file.


Let's first start off by setting up some variables:
```
# Variables
SHELL := /bin/bash
SOURCE_DIR := src
MARKDOWN_DIR := $(SOURCE_DIR)/markdown
ASSETS_DIR := $(SOURCE_DIR)/assets
TEMPLATES_DIR := $(SOURCE_DIR)/templates
TARGET_DIR := target
DEPLOY_DIR := docs
```

These variables mimic my [project layout].

Next let's define more variables that represent our source files.

```
# Find all markdown files
MARKDOWN_FILES := $(shell find $(MARKDOWN_DIR) -type f -name '*.md')
# Generate target HTML files paths
TARGET_HTML_FILES := $(patsubst $(MARKDOWN_DIR)/%.md,$(TARGET_DIR)/%.html,$(MARKDOWN_FILES))
# Find all assets
ASSETS_FILES:= $(shell find $(ASSETS_DIR) -type f)
# Generate target image files paths
TARGET_ASSETS_FILES := $(patsubst $(SOURCE_DIR)/%,$(TARGET_DIR)/%,$(ASSETS_FILES))
# Find all template files
TEMPLATE_FILES := $(shell find $(TEMPLATES_DIR) -type f)
```

The `TARGET_HTML_FILES` and the `TARGET_ASSETS_FILES` will represent our dependencies for our main project.

Next, is the pandoc command to use a stylesheet, HTML template, a header, a footer, and a naviation to convert our Markdown files to HTML.

```
# Pandoc command
PANDOC := pandoc --from=markdown --to=html \
	--template=$(TEMPLATES_DIR)/html.template \
	--css=/assets/style/style.css  \
	--include-in-header=$(TEMPLATES_DIR)/_header.html \
	--include-after-body=$(TEMPLATES_DIR)/_footer.html \
	--include-before-body=$(TEMPLATES_DIR)/_navigation.html \
	--standalone
```

Next comes the main build with the target assets and HTML files.

```
# Default target
all: $(TARGET_ASSETS_FILES) $(TARGET_HTML_FILES) 
.PHONY: all
```

This Makefile rule looks for any dependencies in the target directly that end in `.html`. These have 3 dependencies, the original markdown files, the template files, and the asset files. The `| $(TARGET_DIR)` is a pre-requisite for the dependencies. The directory in the target is created, and the pandoc command above is run.

```
# Rule to create HTML files, make sure the target directory is created first.
$(TARGET_DIR)/%.html: $(MARKDOWN_DIR)/%.md $(TEMPLATE_FILES) $(ASSETS_FILES) | $(TARGET_DIR)
	@# Create the subdirectory if needed
	@echo $<
	@mkdir -p $(@D)
	@$(PANDOC) -o $@ $<
```

This Makefile rule looks for any dependencies in the target assets directory. There's a single dependency that matches any file in the source assests directory. Again, the `TARGET_DIR` is a pre-requisite. The directory is created, and the file is copied.


```
# Rule to copy assets files, make sure the target directory is created first.
$(TARGET_DIR)/assets/%: $(ASSETS_DIR)/% | $(TARGET_DIR)
	@# Create the subdirectory if needed
	@mkdir -p $(@D)
	@cp $< $@
```

Finally the `TARGET_DIR` rule. This ensures the directory is created
```
# Create target directory
$(TARGET_DIR):
	mkdir -p $@
```

Additionally, I added some helpful rules to `run`, `deploy`, `info`, and `clean`.

```
deploy: 
	@# Remove 
	@rm -fr $(DEPLOY_DIR)
	@mkdir -p $(DEPLOY_DIR)
	@cp -r $(TARGET_DIR)/* $(DEPLOY_DIR)
.PHONY: deploy
	


# Help command
help:
	@echo "Available commands:"
	@echo "  make all    - Build the entire project (default)"
	@echo "  make clean  - Remove the target directory"
	@echo "  make help   - Display this help message"
.PHONY: help

info: 
	@echo $(SOURCE_DIR)
	@echo MARKDOWN_FILES=$(MARKDOWN_FILES)
	@echo TARGET_HTML_FILES=$(TARGET_HTML_FILES)
	@echo TEMPLATE_FILES=$(TEMPLATE_FILES)
	@echo ASSETS_FILES=$(ASSETS_FILES)
	@echo TARGET_ASSETS_FILES=$(TARGET_ASSETS_FILES)
.PHONY: info

clean:
	@echo "cleaning project"
	@rm -rf $(TARGET_DIR)
.PHONY: clean
```

_2024-Aug-25_

[project layout]: #Project Layout
[neovim]:https://neovim.io/
[Pandoc]: https://pandoc.org/
[separation of concerns]: https://en.wikipedia.org/wiki/Separation_of_concerns
[simple to learn]: https://www.markdownguide.org/basic-syntax/
[Hugo]: https://gohugo.io/
[Jekyll]: https://jekyllrb.com/
