# Variables
SHELL := /bin/bash
SOURCE_DIR := src
MARKDOWN_DIR := $(SOURCE_DIR)/markdown
POSTS_DIR := $(SOURCE_DIR)/markdown/posts
ASSETS_DIR := $(SOURCE_DIR)/assets
STATIC_DIR := $(SOURCE_DIR)/static
TEMPLATES_DIR := $(SOURCE_DIR)/templates
TARGET_DIR := target
DEPLOY_DIR := docs


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

STATIC_FILES:= $(shell find $(STATIC_DIR) -type f)
TARGET_STATIC_FILES := $(patsubst $(STATIC_DIR)/%,$(TARGET_DIR)/%,$(STATIC_FILES))
POST_MARKDOWN_FILES := $(shell find $(POSTS_DIR) -type f)


# Pandoc command
PANDOC := pandoc --from=markdown --to=html \
	--template=$(TEMPLATES_DIR)/html.template \
	--css=/assets/style/style.css  \
	--css=/assets/style/syntax.css  \
	--include-in-header=$(TEMPLATES_DIR)/_header.html \
	--include-after-body=$(TEMPLATES_DIR)/_footer.html \
	--include-before-body=$(TEMPLATES_DIR)/_navigation.html \
	--standalone

# Default target
all: posts $(TARGET_STATIC_FILES) $(TARGET_ASSETS_FILES) $(TARGET_HTML_FILES) 
.PHONY: all

# Deploy the changes from the `/target` directory
deploy: all
	@# Remove 
	@rm -fr $(DEPLOY_DIR)
	@mkdir -p $(DEPLOY_DIR)
	@cp -r $(TARGET_DIR)/* $(DEPLOY_DIR)
.PHONY: deploy
	

# Deploy the changes from the `/target` directory
run: all
	@xdg-open http://127.0.0.1:8000/index.html
	cd $(TARGET_DIR); python3 -m http.server;
.PHONY: run


# Help command
help:
	@echo "Available commands:"
	@echo "  make all    - Build the entire project (default)"
	@echo "  make clean  - Remove the target directory"
	@echo "  make run    - Opens the site from the staging directory in a browser"
	@echo "  make deploy - Deploy the files from the staging directory (/target) to the deployment directory (/docs)"
	@echo "  make help   - Display this help message"
.PHONY: help

info: 
	@echo $(SOURCE_DIR)
	@echo MARKDOWN_FILES=$(MARKDOWN_FILES)
	@echo TARGET_HTML_FILES=$(TARGET_HTML_FILES)
	@echo TEMPLATE_FILES=$(TEMPLATE_FILES)
	@echo ASSETS_FILES=$(ASSETS_FILES)
	@echo TARGET_ASSETS_FILES=$(TARGET_ASSETS_FILES)
	@echo TARGET_STATIC_FILES=$(TARGET_STATIC_FILES)
	@echo STATIC_FILES=$(STATIC_FILES)
.PHONY: info

clean:
	@echo "cleaning project"
	@rm -rf $(TARGET_DIR)
.PHONY: clean

posts:
	echo "making posts"
	scripts/makePosts.sh
.PHONY: posts

# Rule to create HTML files, make sure the target directory is created first.
$(TARGET_DIR)/%.html: $(MARKDOWN_DIR)/%.md $(TEMPLATE_FILES) | $(TARGET_DIR)
	@# Create the subdirectory if needed
	@echo $<
	@mkdir -p $(@D)
	@$(PANDOC) -o $@ $<

# Rule to copy assets files, make sure the target directory is created first.
$(TARGET_DIR)/assets/%: $(ASSETS_DIR)/% | $(TARGET_DIR)
	@# Create the subdirectory if needed
	@echo $<
	@mkdir -p $(@D)
	@cp $< $@

# Rule to copy static files, make sure the target directory is created first.
$(TARGET_DIR)/%: $(STATIC_DIR)/% | $(TARGET_DIR)
	@# Create the subdirectory if needed
	@echo $<
	@mkdir -p $(@D)
	@cp $< $@

# Create target directory
$(TARGET_DIR):
	mkdir -p $@

# Build command (same as all)
build: all
