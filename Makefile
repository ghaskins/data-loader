# Copyright © 2020-2022 Manetu, Inc.  All rights reserved

NAME=manetu-data-loader
BINDIR ?= /usr/local/bin
OUTPUT=target/$(NAME)
SHELL=/bin/bash -o pipefail

SRCS += $(shell find src -type f)

COVERAGE_THRESHOLD = 98
COVERAGE_EXCLUSION += "manetu.data-loader.main"

all: scan bin

bin: $(OUTPUT)

scan:
	lein cljfmt check
	lein bikeshed -m 120 -n false
	#lein kibit
	lein eastwood

.PHONY: test
test:
	lein cloverage --fail-threshold $(COVERAGE_THRESHOLD) $(patsubst %,-e %, $(COVERAGE_EXCLUSION)) | perl -pe 's/\e\[?.*?[\@-~]//g'

$(OUTPUT): $(SRCS) Makefile project.clj
	@lein bin

$(PREFIX)$(BINDIR):
	mkdir -p $@

install: $(OUTPUT) $(PREFIX)$(BINDIR)
	cp $(OUTPUT) $(PREFIX)$(BINDIR)

clean:
	@echo "Cleaning up.."
	@lein clean
	-@rm -rf target
	-@rm -f *~

