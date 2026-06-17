---
name: authoring-anki-decks
description: Author granular Anki flashcard decks in Markdown and compile them with ankcompiler (the `ankc` CLI). Use when the user wants to turn reference material, notes, or a document into Anki cards / a study deck, or mentions ankcompiler, .apkg, spaced repetition, or memorizing something "cold." Produces atomic, one-fact-per-card decks following the minimum-information principle.
---

# Authoring Anki decks with ankcompiler

Turn source material into an atomic, high-retention Anki deck and compile it to `.apkg` with `ankc` (ankc ≥ 0.3.0). The draft workflow below (`ankc uid --fix`) requires ankc ≥ 0.3.0.

## Tooling

`ankc` is the CLI. Install once if missing: `uv tool install ankcompiler` (or `pip install ankcompiler`). Verify with `ankc --version`.

Decks live in a dedicated decks repo (one subfolder per deck). Generate a blank card stub with `ankc gen chunk`.

Commands you'll use:

- `ankc list deck` — list valid deck names. `ankc list file` — list a deck's source files.
- `ankc check [--deck NAME | --all] [--path DIR] [--depth N] [--format text|json]` — validate source **without compiling**. The real pre-build gate.
- `ankc build [--deck NAME | --all] [--path DIR (default .)] [--depth N] [--output DIR (default .)]` — compile to `.apkg`.
- `ankc uid [--fix] [--path] [--depth] [--check] [--force]` — `--fix` repairs a **draft** (single-`---`-separated cards): rewrites each card into canonical form and stamps a fresh uid wherever one is missing. Without `--fix` it's **append-only**: stamps missing uids in already-well-formed blocks, never restructures. `--check` = dry run (writes nothing); `--force` = run even with uncommitted changes.
- `ankc gen chunk` — emit an empty note chunk (stub).

## Card file format — write a draft, let `--fix` canonicalize it

You don't hand-write the fiddly canonical format. **Write a draft**, then run `ankc uid --fix` to expand it into the buildable canonical form.

### Draft (what you write)

Cards separated by a **single `---`**, no uids needed. The first card sits directly after the frontmatter — the frontmatter's closing `---` is its opening delimiter, so no extra `---`.

```
---
deck: Deck Name
tags:
  - tag1
---
Question text ::: Answer text
---
{{c1:: cloze-deleted text}} in a sentence
```

### Canonical (what `ankc uid --fix` produces / what the compiler needs)

```
---
deck: Deck Name
tags:
  - tag1
---
---

Question text ::: Answer text

---
[^uid]: aB3xK9m2Qr

---

{{c1:: cloze-deleted text}} in a sentence

---
[^uid]: Zk7pLm4Nv2
```

`ankc uid --fix` does the expansion: each draft card becomes `---` / blank / body / blank / `---` / `[^uid]` footer, with a fresh 10-char uid stamped wherever missing. It **only restructures genuine decks** (frontmatter with a `deck:` key); a non-deck `.md` or an already-canonical deck gets safe **append-only** stamping instead — prose is never turned into cards. It preserves existing `[^uid]`/`[^tag]`/`[^type]` footnotes, drops and regenerates a malformed uid, peels a footnote glued directly under an answer (no blank line) back out, and drops the obsolete trailing `.` sentinel. It's gated: `--check` previews and writes nothing, it refuses files with uncommitted git changes unless `--force`, writes atomically, and skips symlinks and CRLF files.

Format rules:

1. **Draft separator is a single `---`** between cards; the first card follows the frontmatter directly. `--fix` turns this into the canonical fenced form above.
2. **Each canonical card is**: `---`, blank line, content, blank line, `---`, then the `[^uid]:` footer.
3. **`:::` separates question from answer** in Q&A cards (one line or multi-line). Use `{{c1:: ... }}` for cloze cards (no `:::`).
4. **Every card needs a unique 10-char alphanumeric uid** in a `[^uid]:` footer. `ankc uid --fix` stamps these for you on a draft. For an **already-canonical** deck, plain `ankc uid` (append-only) stamps any missing uids without restructuring (`ankc uid --check` previews).
5. **A trailing `.` sentinel is no longer required.** Old decks that end with a lone `.` still build; you don't need to add one, and `--fix` removes it.
6. Optional per-card extra tags: add `[^tag]: tagname` lines under the uid. `--fix` preserves them.

## Cloze and rendering rules

- `{{c1:: text}}` makes a cloze card. Cloze cards use **no `:::`**.
- Multiple deletions in one note: `{{c1::...}} {{c2::...}}` → **one note, two cards** (one per distinct `cN` index). Two spans sharing the same `cN` reveal together as a single card.
- **Never nest `{{c1::` inside another cloze.** ankc passes it through silently and Anki mishandles it at review.
- Card content renders Markdown → HTML: `**bold**`→`<strong>`, backticks→`<code>`. LaTeX math works — `$...$` compiles to MathJax `\(...\)`. Formulas can use `$...$`.

## The `:::` / cloze safety trap (read before every build)

`ankc` splits a Q&A card on the **FIRST `:::` on a line**. If a question or answer contains a **literal `:::`**, everything after it is silently swallowed and the answer is truncated. The build still **exits 0** and the uid count still matches — so this is a **false green** the count check cannot catch. `ankc uid --fix` does **not** rescue this — a literal `:::` inside content still needs rewording.

Mitigation:

1. Before building, scan: `grep -n ':::' deck.md`. Confirm each Q&A line has **exactly one** `:::` and each cloze line has **zero**. Reword any content that needs a literal `:::`.
2. **Count-match is necessary but NOT sufficient.** It cannot detect delimiter corruption. After building, spot-read a few compiled cards (or trust `ankc check`).

## Build and verify

Validation is **strict** in 0.3.0: card-bearing text (a `:::` or a `{{cN::}}` cloze) sitting **outside** a well-formed block is now an **ERROR** that aborts the build, not a silently dropped card. So `ankc check` / `ankc build` now catch two cards sharing a single `---`, an unterminated block, or an un-fixed draft — a merged/dropped card fails loud. The remedy is `ankc uid --fix`. (Prose without card syntax is still intentionally ignored.)

`ankc build` is **silent on success** (exit 0, no stdout). A wrong `--deck` name, wrong path, or no match **also exits 0 with no package** — so never treat exit 0 as proof. Always assert the output file exists.

```bash
ankc check --deck "Deck Name"          # validate source first — the real gate
mkdir -p dist                          # ankc does NOT create --output; missing dir => FileNotFoundError
ankc build --deck "Deck Name" --depth 2 --output ./dist
ls ./dist/*.apkg                       # assert the package actually got written
```

`--depth` default is **ALL subdirectories**. `--depth N` *restricts* the search to N levels — only set it to limit a wide tree, never to "reach deeper."

Verify the note count survived:

```bash
grep -c '\[\^uid\]:' path/to/deck.md   # counts NOTES, not cards
```

This counts **notes**. A cloze note with N deletions = 1 note but N cards, so this number will **not** equal Anki's card count — don't expect it to. To count package notes, use Python stdlib (the `sqlite3` binary is often not installed, so don't depend on it):

```bash
python3 -c "import zipfile,sqlite3,tempfile,os,glob; \
z=zipfile.ZipFile(glob.glob('dist/*.apkg')[0]); d=tempfile.mkdtemp(); z.extract('collection.anki2',d); \
print(sqlite3.connect(os.path.join(d,'collection.anki2')).execute('select count(*) from notes').fetchone()[0])"
```

Source note count and package note count must match. `.apkg` output should be gitignored.

## Card-design principles (grounded)

The format rules below are not style — they are consequences of how memory works. Sources (read for the full models):

- `~/.claude/knowledge/extractions/a-mind-for-numbers.md`
- `~/.claude/knowledge/extractions/design-for-how-people-learn.md`
- `~/.claude/knowledge/extractions/art-of-explanation.md`

- **The testing effect is the whole mechanism** (*a-mind-for-numbers* §9, "testing as the primary learning activity"). A card exists to force *retrieval*. If a card doesn't make the learner pull the answer from memory, it does nothing. Every rule below serves this.
- **Recognition ≠ recall ≠ mastery** (*a-mind-for-numbers* "illusions of competence"; *design-for-how-people-learn* recall-vs-recognition). This is the design north star. It is *why* there are no yes/no questions (recognition + a 50% guess) and *why* answers stay short and specific (the front must trigger genuine recall).
- **Interference between confusable items** (*a-mind-for-numbers* — a main cause of forgetting). Cuts two ways: (a) add explicit **disambiguation cards** for close cousins ("NRR vs GRR — key difference?"); (b) **don't create overlapping cards** that compete — e.g. a card for a formula component that's already visible on the whole-formula card just induces interference.
- **Visual / metaphor / analogy encoding** (*a-mind-for-numbers* §7). For an abstract or sticky fact, make the answer a **vivid image or analogy** rather than a dry restatement (f = ma → "a Flying Mule being Accelerated"). It hooks the high-capacity visuospatial system.
- **Knowledge gap vs. skill gap** (*design-for-how-people-learn* §1). Flashcards close **knowledge** gaps. They cannot drill a **skill** that needs practice. If proficiency requires doing, not recalling, scope it out of the deck honestly rather than faking it with cards.
- **Curse of knowledge — lower the cost of understanding** (*art-of-explanation*). The front must be answerable by the *learner*, without the author's surrounding context. Generalize the "no extra context on the front" rule: if a card only makes sense to someone who already read the source paragraph, it's broken.

## The atomic-card playbook

Follow the **minimum information principle**: one retrievable fact per card. A card you can't cleanly grade "right/wrong" is too big — split it. Spaced repetition reschedules a card on its hardest sub-fact, so fat cards waste reviews.

Core rules:

- **One fact per card.** If the answer contains "and" joining two facts, split it.
- **Acronyms get two cards**, one each direction (acronym → expansion, expansion → acronym). ankc has no auto-reverse note type, so write both.
- **No yes/no questions** (50% guess rate, tests recognition not recall). Rewrite as "what / which / how."
- **Keep answers short** (≤ ~15 words). Specific, unambiguous question; the back is a complete standalone answer.
- **Disambiguate confusable items** with explicit contrast cards. Interference is the main cause of forgetting in a dense deck.
- **No source attribution or extra context on the front** unless that's the fact being tested.

## Material-type playbooks

Match the card pattern to the kind of source. The default below is the definitional case; the others handle structures the default can't express.

**Definitional reference (metrics, terms, concepts).** Repeatable per-item set: acronym↔expansion (2 cards), one-sentence definition, formula, key exclusion/boundary, why-it-matters/threshold, benchmark, and a disambiguation card for any close cousin. Don't force all of these — generate only the ones carrying real, distinct knowledge.

**Narrative / conceptual prose.** Card the **claim**, the **mechanism**, and the **contrasts** separately. A 3-way gradient (e.g. recognition → recall → mastery) cannot be captured by a single "X vs Y — key difference?" card — use **chained pairwise contrasts** (recognition vs recall, recall vs mastery) or a **cloze over the distinction**.

**Negation facts** ("X cannot Y", "X alone is not enough"). The no-yes/no rule needs a rewrite, not a question. Convert "Is X true? No" into "What is true of X instead?", or cloze the negated word. Example: *"Recognition `{{c1::is not}}` the same as recall."* — or — *"Recognition vs recall — what does recognition fail to prove?"*

**Ordered / process knowledge.** The one **exception to "avoid enumerations."** Don't make one card per item or a single fat list card. Instead cloze over the ordered steps (`First {{c1::load}}, then {{c2::release}}...`) or chain first-step → next-step cards.

**Formulas.** Keep "whole formula + hard parts" — **but** only decompose genuinely non-derivable parts. A component already visible in the whole-formula card is redundant and competes with it (interference). Decompose the threshold meaning or the excluded term, not the obvious numerator.

## Workflow summary

1. Read the source; list the atomic facts worth knowing cold. Cut anything that's a skill, not knowledge.
2. Decide deck name + tags. Create `anki-decks/<deck-slug>/<deck-slug>.md`.
3. Write cards as a **draft** — single `---` separators, first card right after the frontmatter, no uids — following the material-type playbooks and design principles.
4. `ankc uid --fix` to expand the draft into canonical form and stamp uids (`ankc uid --check` to preview first). For an already-canonical deck, plain `ankc uid` just stamps missing uids.
5. `grep -n ':::' deck.md` to catch literal-`:::` traps (`--fix` won't fix these). `ankc check` to validate — it now ERRORs on any card text left outside a block.
6. `mkdir -p dist`, `ankc build`, then `ls ./dist/*.apkg`. Verify source note count == apkg note count. Spot-read a few cards.
7. Commit the `.md` (gitignore `dist/`/`*.apkg`). Tell the user to import the `.apkg` into Anki (File → Import).
