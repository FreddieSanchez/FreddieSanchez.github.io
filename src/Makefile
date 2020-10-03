SRC := $(shell find . -type f -name '*.md')
SOURCES := $(SRC:.md=.html)
TARGET := target
IMAGES := $(shell find ./images -type f)
TEMPLATES := _header.html html.template
STATIC := ./site.webmanifest
TARGETS := $(patsubst ./%, ./$(TARGET)/%, $(SOURCES)) $(patsubst ./%, ./$(TARGET)/%, $(IMAGES)) $(patsubst ./%, ./$(TARGET)/%, $(STATIC))
PUBLISH_DIR := ../

.PHONEY: all clean

all: main-build

main-build: $(TARGETS) $(IMAGES)

info: 
	@echo SRC=$(SRC)
	@echo TARGET=$(TARGET)
	@echo TARGETS=$(TARGETS)
	@echo IMAGES=$(IMAGES)
	@echo TEMPLATES=$(TEMPLATES)

clean:
	rm $(TARGETS)

publish:
	cp -r $(TARGET)/* $(PUBLISH_DIR)

$(TARGET)/%.html: $(TEMPLATES)
	mkdir -p $(@D)
	pandoc --template=templates/html.template --variable=updated:"$(shell date)" --from=markdown --to=html -H templates/_header.html -s -o $(@) $(*D)/$(addsuffix .md, $(*F))

$(TARGET)/%.html: %.md 
	mkdir -p $(@D)
	pandoc --template=templates/html.template --variable=updated:"$(shell date)" --from=markdown --to=html -H templates/_header.html -s -o $(@) $<

$(TARGET)/images/%: images/%
	mkdir -p $(@D)
	cp $< $(@D)

$(TARGET)/%: $(STATIC)
	cp $< $(@D)