SRC := $(shell find . -type f -name '*.md')
SOURCES := $(SRC:.md=.html)
TARGET := target
IMAGES := $(shell find ./images -type f)
TEMPLATES := $(shell find ./templates -type f)
STATIC := ./site.webmanifest
TARGETS := $(patsubst ./%, ./$(TARGET)/%, $(SOURCES)) $(patsubst ./%, ./$(TARGET)/%, $(IMAGES)) $(patsubst ./%, ./$(TARGET)/%, $(STATIC))
PUBLISH_DIR := ../

.PHONEY: all clean info

main-build: $(TARGETS) $(IMAGES)

all: main-build

info: 
	@echo SRC=$(SRC)
	@echo TARGET=$(TARGET)
	@echo TARGETS=$(TARGETS)
	@echo IMAGES=$(IMAGES)
	@echo STATIC=$(STATIC)
	@echo TEMPLATES=$(TEMPLATES)

clean:
	rm $(TARGETS)

publish: main-build |
	cp -r $(TARGET)/* $(PUBLISH_DIR)

$(TARGET)/%.html: $(TEMPLATES)
	mkdir -p $(@D)
	pandoc --template=templates/html.template --from=markdown --to=html -H templates/style.css -H templates/_header.html -A templates/_footer.html -B templates/_navigation.html -s -o $(@) $(*D)/$(addsuffix .md, $(*F))

$(TARGET)/%.html: %.md 
	mkdir -p $(@D)
	pandoc --template=templates/html.template  --from=markdown --to=html -H templates/style.css -H templates/_header.html -A templates/_footer.html -B templates/_navigation.html -s -o $(@) $<

$(TARGET)/posts/%.html: %.md 
	mkdir -p $(@D)
	pandoc --template=templates/html.template  --from=markdown --to=html -H templates/style.css -H templates/_header.html -A templates/_footer.html -B templates/_navigation.html -s -o $(@) $<

$(TARGET)/images/%: images/%
$(TARGET)/%.manifest: %.manifest.

$(TARGET)/%: %
	mkdir -p $(@D)
	cp $< $(@D)

