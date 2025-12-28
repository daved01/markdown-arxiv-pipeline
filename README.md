# Markdown-to-PDF Pipeline
By [DeconvoluteAI](https://deconvoluteai.com?utm_source=github.com&utm_campaign=markdown-pipeline&utm_medium=readme)

This repository provides a lightweight workflow for converting technical Markdown files into professional, two-column arXiv-style PDFs. It uses Pandoc and LaTeX to separate your content from the formatting logic, ensuring clean and reproducible builds.

## Repository Structure

- `content/`: Stores your `.md` source files, `.bib` bibliography, and images.
- `templates/`: Stores LaTeX templates (e.g. `arxiv_template.tex`).
- `styles/`: Stores Citation Style Language files (e.g. `ieee.csl`).
- `Makefile`: Automates the build process.

## Mac Setup
### 1. Install Dependencies
Run the following in your terminal to install Pandoc and BasicTeX:

```bash
brew install pandoc
brew install --cask basictex
```

### 2. Configure Path
Ensure your shell can find the TeX binaries. Add this to your `~/.zshrc` or `~/.bash_profile`:

```bash
export PATH="/Library/TeX/texbin:$PATH"
```

Reload your shell (source `~/.zshrc`).

### 3. Install LaTeX Packages
Install the specific packages required by the template:

```bash
sudo tlmgr update --self
sudo tlmgr install geometry microtype hyperref carlisle ulem amsmath calc
```

## Usage
Create your markdown file inside the `content/` directory. For the template to function correctly, the file must begin with a `YAML` metadata block defining the title, authors, abstract, and bibliography file.

```yaml
---
title: "The Title of Your Paper"
author:
  - name: "Author Name"
    email: "email@domain.com"
abstract: |
  Your abstract text goes here.
bibliography: "references.bib"
link-citations: true
---
```

### Citations
Add citations with the name `references.bib` in `content/`, for example by exporting from Zotero. In the Markdown file you can reference these citations like this:

- Single Citation: [@reference1] renders as [1].
- Grouped Citation: [@reference1; @reference2] renders as [1, 2].

**Note:** You must use a semicolon `;` to separate multiple citations. Using a comma will result in incorrect formatting [1], [2].


### Images
Place images in `content/images/` and use standard Markdown syntax. We recommend using width=90% to nicely frame the image within the column.

```markdown
![This is the caption text.](images/figure1.png){#fig:label width=90%}
```

For large diagrams spanning the full page width, use a raw LaTeX block:

```latex
\begin{figure*}[ht]
  \centering
  \includegraphics[width=0.9\textwidth]{content/images/wide_figure.png}
  \caption{Wide caption text}
  \label{fig:wide_label}
\end{figure*}
```

### References Section
Pandoc will automatically append the bibliography to the very end of your document, but it does not generate a section header. You must manually add this header at the bottom of your Markdown file:

```markdown

# References
```

### Building the PDF
You can compile your document by running `make` from the root directory. This command automatically detects the markdown file in your content folder and produces a PDF. If you want to build and immediately preview the result, use `make open`. To save the output with a specific filename, use `make name=custom_filename`. When you are finished, `make clean` will remove any generated PDF files.


## Customization
To change the visual style of your paper, you can add new resources to the pipeline. Place any new LaTeX templates in the `templates/` directory or new `CSL` citation styles in the `styles/` directory. Once added, open the `Makefile` and update the `TEMPLATE` or `CSL` variables to point to your new files.


### Adapting for arXiv Submission

Since arXiv requires the LaTeX source code rather than a pre-compiled PDF, you will need to generate a `.tex` file for submission. You can do this by running a specific Pandoc command to output a text file instead of a PDF:

```bash
pandoc content/paper.md \
  --citeproc \
  --template=templates/arxiv_template.tex \
  --resource-path=content \
  -o submission.tex
```

Upload the resulting `submission.tex` along with your `references.bib` and any images, directly to the arXiv portal.

## Troubleshooting

If you introduce new LaTeX packages in your writing or custom templates, the build may fail if those packages are missing from your system. You can install any missing package easily by running sudo tlmgr install [package_name] in your terminal. Common dependencies include `amsmath`, `natbib`, `microtype`, and `geometry`.
