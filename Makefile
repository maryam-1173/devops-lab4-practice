# Makefile.starter — skeleton for Lab 02, Task 4 (ASSESSED).
#
# Rename this to  Makefile  and complete every TODO.
# Requirements are listed in Section 4.1 of the lab manual.
#
#     cp Makefile.starter Makefile
#     nano Makefile
#
# EVERY recipe line below must start with a real TAB, not spaces.
# Check yours with:  cat -A Makefile     (a tab shows as ^I)

SRC_DIR := src
OUT_DIR := out

SOURCES := $(wildcard $(SRC_DIR)/*.txt)
OUTPUTS := $(patsubst $(SRC_DIR)/%.txt,$(OUT_DIR)/%.txt,$(SOURCES))

.PHONY: all check build test clean ci

all: test

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

$(OUT_DIR)/%.txt: $(SRC_DIR)/%.txt | $(OUT_DIR)
	@echo "  BUILD $< -> $@"
	@tr '[:lower:]' '[:upper:]' < $< > $@

check:
	@if [ ! -d "$(SRC_DIR)" ]; then \
		echo "ERROR: source directory '$(SRC_DIR)' does not exist"; \
		exit 2; \
	elif [ -z "$(SOURCES)" ]; then \
		echo "ERROR: no .txt files found in '$(SRC_DIR)'"; \
		exit 2; \
	else \
		echo "CHECK PASSED: $(words $(SOURCES)) source file(s) found"; \
	fi

build: $(OUTPUTS)

test: build
	@if grep -l '[a-z]' $(OUTPUTS) >/dev/null 2>&1; then \
		echo "TEST FAILED: lowercase characters remain"; \
		exit 1; \
	fi
	@echo "TEST PASSED"

clean:
	@rm -rf $(OUT_DIR)
	@echo "CLEAN: removed $(OUT_DIR)"

ci:
	@$(MAKE) clean
	@$(MAKE) check
	@$(MAKE) test

count: build  ## report source files and built words
	@ls -1 $(SRC_DIR)/*.txt | wc -l
	@wc -w $(OUTPUTS) | tail -1
# count: see section 5 of the README
# OUTPUTS is set by the wildcard above
# run 'make help' for all targets
