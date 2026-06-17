---
name: kernel-pdf
kind: skill
tags:
  - docs
profile: extended
description: Use when tasks involve reading, creating, or reviewing PDF files
  where rendering and layout matter.
license: Apache-2.0
compatibility: PDF creation, review, and rendering workflows.
metadata:
  author: Callstack
  version: "1.0"
  category: File Formats
  tags:
    - pdf
    - rendering
    - layout
    - inspection
    - poppler
when:
  - user needs to read, review, or extract text from a PDF
  - user needs to create or edit a PDF programmatically
  - user needs to verify PDF rendering or layout fidelity
  - user needs to compare PDF output against visual expectations
applicability:
  - Use for PDF generation, inspection, and formatting work
  - Use when visual fidelity matters and a plain text diff is not enough
  - Use when dedicated PDF tooling is the most direct path
termination:
  - PDF renders cleanly with no clipping or layout regressions
  - Required content is present and verified in the rendered output
  - Any extracted text matches the source or expected data
  - Output files are organized in the expected project locations
outputs:
  - Validated PDF file or PDF review notes
  - Rendered page images for visual inspection
  - Extraction or generation commands suitable for repeat use
---

# PDF Skill

## When to use

- Read or review PDF content where layout and visuals matter.
- Create PDFs programmatically with reliable formatting.
- Validate final rendering before delivery.

## Workflow

1. Prefer visual review: render PDF pages to PNGs and inspect them.
   - Use `pdftoppm` if available.
   - If unavailable, install Poppler or ask the user to review the output locally.
2. Use the simplest available PDF generation tool in the project or environment when creating new documents.
3. Use an available PDF text-extraction tool for quick checks; do not rely on it for layout fidelity.
4. After each meaningful update, re-render pages and verify alignment, spacing, and legibility.

## Temp and output conventions

- Use `tmp/pdfs/` for intermediate files; delete when done.
- Write final artifacts under `output/pdf/` when working in this repo.
- Keep filenames stable and descriptive.

## Dependencies (install if missing)

System tools (for rendering):

```
# macOS (Homebrew)
brew install poppler

# Ubuntu/Debian
sudo apt-get install -y poppler-utils
```

If installation isn't possible in this environment, tell the user which dependency is missing and how to install it locally.

## Environment

No required environment variables.

## Rendering command

```
pdftoppm -png $INPUT_PDF $OUTPUT_PREFIX
```

## Quality expectations

- Maintain polished visual design: consistent typography, spacing, margins, and section hierarchy.
- Avoid rendering issues: clipped text, overlapping elements, broken tables, black squares, or unreadable glyphs.
- Charts, tables, and images must be sharp, aligned, and clearly labeled.
- Use ASCII hyphens only. Avoid U+2011 (non-breaking hyphen) and other Unicode dashes.
- Citations and references must be human-readable; never leave tool tokens or placeholder strings.

## Final checks

- Do not deliver until the latest PNG inspection shows zero visual or formatting defects.
- Confirm headers/footers, page numbering, and section transitions look polished.
- Keep intermediate files organized or remove them after final approval.
