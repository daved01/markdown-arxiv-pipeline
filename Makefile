# --- CONFIGURATION ---
# Directories
CONTENT_DIR = content
TEMPLATE_DIR = templates
STYLE_DIR = styles
OUTPUT_DIR = $(CONTENT_DIR)

# Files
# Automatically detect the first .md file in content/ as the input
INPUT_FILE := $(firstword $(wildcard $(CONTENT_DIR)/*.md))
# Default output filename (same as input, but pdf). Can be overridden via CLI.
# Usage: make name=my_custom_name
ifdef name
	OUTPUT_FILENAME = $(name).pdf
else
	OUTPUT_FILENAME = $(notdir $(INPUT_FILE:.md=.pdf))
endif

OUTPUT_PATH = $(OUTPUT_DIR)/$(OUTPUT_FILENAME)

# Resources
TEMPLATE = $(TEMPLATE_DIR)/arxiv_template.tex
CSL = $(STYLE_DIR)/ieee.csl
BIB = $(CONTENT_DIR)/references.bib

# Pandoc Flags
# --resource-path: Tells pandoc where to look for images/bib referenced in the MD
FLAGS = --citeproc \
		--csl=$(CSL) \
		--template=$(TEMPLATE) \
		--pdf-engine=pdflatex \
		-M link-citations=true \
		--resource-path=$(CONTENT_DIR)

# --- TARGETS ---

.PHONY: all clean open help

# Default target: Build the PDF
all: $(OUTPUT_PATH)

$(OUTPUT_PATH): $(INPUT_FILE) $(TEMPLATE) $(CSL)
	@echo "Building $(OUTPUT_FILENAME) from $(INPUT_FILE)..."
	pandoc $(INPUT_FILE) $(FLAGS) -o $(OUTPUT_PATH)
	@echo "✅ Success! Output saved to: $(OUTPUT_PATH)"

# Clean up generated PDFs
clean:
	rm -f $(CONTENT_DIR)/*.pdf
	@echo "Cleaned up PDFs."

# Helper to build and immediately open the file (Mac only)
open: all
	open $(OUTPUT_PATH)

help:
	@echo "Markdown-to-PDF Pipeline"
	@echo "------------------------"
	@echo "Usage:"
	@echo "  make          -> Builds the PDF from the .md file in content/"
	@echo "  make name=xyz -> Builds 'xyz.pdf'"
	@echo "  make open     -> Builds and opens the PDF (macOS)"
	@echo "  make clean    -> Removes generated PDFs"