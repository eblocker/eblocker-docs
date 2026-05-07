markdown_src := $(wildcard *.md */*.md)
html_out := $(patsubst %.md,build/%.html,$(markdown_src))

image_src := $(wildcard *.png *.svg *.pdf icapserver/diagrams/*.png)
image_dest := $(patsubst %,build/%,$(image_src))

.PHONY: html images clean

all: build html images

html: $(html_out)

images: $(image_dest)

build/%.html: %.md
	bin/md2html $< $@

build/%.png: %.png
	cp $< $@

build/%.svg: %.svg
	cp $< $@

build/%.pdf: %.pdf
	cp $< $@

build:
	mkdir build
	mkdir build/dashboard
	mkdir build/icapserver
	mkdir build/icapserver/diagrams

clean:
	rm -rf build
