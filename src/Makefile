SRC := $(shell find . -type f -name '*.md')
SOURCES := $(SRC:.md=.html)
TARGET := target
IMAGES := $(shell find ./images -type f)
TARGETS := $(patsubst ./%, ./$(TARGET)/%, $(SOURCES)) $(patsubst ./%, ./$(TARGET)/%, $(IMAGES))
PUBLISH_DIR := ../

.PHONEY: all clean

all: main-build post-build

main-build: $(TARGETS) $(IMAGES)

info: 
	@echo SRC=$(SRC)
	@echo TARGET=$(TARGET)
	@echo TARGETS=$(TARGETS)
	@echo IMAGES=$(IMAGES)

clean:
	rm $(TARGETS)

publish:
	cp -r $(TARGET)/* $(PUBLISH_DIR)

$(TARGET)/%.html: %.md 
	mkdir -p $(@D)
	pandoc --template=html.template --variable=updated:"$(shell date)" --from=markdown --to=html -H _header.html -s -o $(@) $<

$(TARGET)/images/%: images/%
	mkdir -p $(@D)
	cp $< $(@D)
