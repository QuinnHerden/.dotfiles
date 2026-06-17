---
name: extracting-book-knowledge
description: Digest a book or document (epub, PDF, or a collection of media) into an 80/20 framework knowledge doc, ready to saturate into agents. Use when the user wants to extract/digest a book, author, or PDF/epub into a knowledge file, mentions the ~/repos/education library, the "20/80" of a book, or building/feeding the .claude/knowledge base.
---

# Extracting book knowledge (the 80/20 pipeline)

Turn a source (book, PDF, epub, or a media collection) into a tight knowledge doc that captures the ~20% of frameworks worth ~80% of the value, then optionally saturate it into agents.

## Where things live

- Sources: usually `~/repos/education/` (one folder per author/topic), but a path can be given.
- Output: one doc per atomic unit at `~/.dotfiles/files/home/.claude/knowledge/extractions/<slug>.md` (runtime: `~/.claude/knowledge/extractions/`).
- `<slug>`: lowercase-kebab, recognizable (`clean-code`, `traffic-secrets`, `data-warehouse-toolkit`).

## Step 1 — Define atomic units

An atomic unit = one coherent thing: a single book, or a tight collection (a set of companion checklists, a slide deck). One unit → one extraction file. Skip pure boilerplate (templates, contracts, sample artifacts, asset files). It is fine NOT to capture everything; that is the point.

## Step 2 — Get the text (by source type)

- **epub (preferred when available — cleaner than the PDF):** it is a zip. `epub="$(find "<book dir>" -name '*.epub' -print -quit)"; unzip -o "$epub" -d /tmp/ext_<slug>` then read the `.xhtml`/`.html` files (usually under `OEBPS/`) IN ORDER. Read enough to capture the FULL structure (all parts, not just early chapters).
- **PDF:** there is no `pdftotext`/`mutool` installed, but `uv` is. Try `uv run --with pypdf python -c "import sys,pypdf; r=pypdf.PdfReader(sys.argv[1]); [print(p.extract_text()) for p in r.pages]" "<pdf>" > /tmp/<slug>.txt` then read the txt. If it yields little text (scanned/figure-heavy), use the Read tool on the PDF with the `pages` parameter and page through all of it.
- **Images/slides:** Read each image with the Read tool (vision) and interpret the diagrams.

## Step 3 — Extract (model + faithfulness)

Use **Sonnet** for the extraction agent. (A/B tested: Sonnet matched Opus on faithfulness and beat Haiku, which dropped operational detail and invented specifics.) Rules for the extractor:

- Capture the ~20% of frameworks that drive ~80% of the value. Omit anecdotes, filler, repetition.
- Be FAITHFUL: extract what is actually in the source, using the author's own names for things. Do NOT invent statistics, rules, or numbers not in the text.

## Step 4 — The output format (exact)

```
---
title: <Book Title>
author: <Author>
source: <relative path under the source library>
type: book            # book | playbook | handbook | course-module | guide | visual | research-synthesis
tags: [4-8 lowercase-kebab tags]
---

<one-line thesis>

## The 20% (Core Frameworks)
The key models, named as the author names them, each with a crisp explanation + its mechanics/levers.

## Actionable Steps / Checklists
The concrete how-to, in a usable order.

## Notable Mental Models & Distinctions
Sharp ideas, heuristics, reframes worth keeping.
```

(Do NOT add a "where this could saturate" / agent-recommendation section. Saturation is decided separately in Step 7, not stored in the doc.)

Keep it tight and high-signal — readable in ~5 minutes and applyable. Do not pad.

## Step 5 — Run it (one unit vs a batch)

- **One or a few:** spawn a Sonnet agent per unit (the `general-purpose` agent), each doing Step 2–4 and writing its own file. For 2-3, run them in parallel in one message; background them (`run_in_background`) if the user is feeding a stream.
- **A large batch (many books):** use a **Workflow** — one Sonnet agent per unit, fanned out (`parallel`), capped ~12 concurrent. Pass each unit's source dir and slug; have each agent locate its epub/pdf, extract, and write. Return a `{ok, failed}` manifest.

Reusable per-agent prompt: instruct the agent to (1) get the text per Step 2 for its source type, (2) extract per Steps 3–4, (3) WRITE to `~/.dotfiles/files/home/.claude/knowledge/extractions/<slug>.md` (note: the dotfiles path, not `~/.claude`), and (4) return a one-line confirmation with the slug + chosen tags.

## Step 6 — Verify

After the run, confirm files on disk: `ls ~/.dotfiles/files/home/.claude/knowledge/extractions/`. Note: this is zsh — it does not word-split unquoted vars, so verify with `echo "$LIST" | tr ' ' '\n' | while read s; do [ -f "$s.md" ] || echo missing $s; done`, not `for s in $LIST`. Spot-check one or two docs for fidelity (real frameworks, no fabrication, undersized files flag a failed read).

## Step 7 — Saturate (separate, on request)

Extractions are raw material. To put them to work, fold them into agents using the **hybrid pattern**: compressed, named frameworks inline in the agent prompt + a `## Reference Library` pointer to the canonical `~/.claude/knowledge/extractions/<slug>.md` doc(s). Keep boundaries between sibling agents. This is a distinct step — do it when asked, not automatically.

## Deployment

`knowledge/` is wired into home-manager and auto-linked on rebuild/restart, so new files appear at `~/.claude/knowledge/`. Commit to your dotfiles repo to sync across machines/containers.
