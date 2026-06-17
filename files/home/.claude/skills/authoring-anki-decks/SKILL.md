---
name: authoring-anki-decks
description: Author granular Anki flashcard decks in Markdown and compile them with ankcompiler (the `ankc` CLI). Use when the user wants to turn reference material, notes, or a document into Anki cards / a study deck, or mentions ankcompiler, .apkg, spaced repetition, or memorizing something "cold." Produces atomic, one-fact-per-card decks following the minimum-information principle.
---

# Authoring Anki decks with ankcompiler

Turn source material into an atomic, high-retention Anki deck and compile it to `.apkg` with `ankc` (verified against ankc 0.2.0).

## Tooling

`ankc` is the CLI. Install once if missing: `uv tool install ankcompiler` (or `pip install ankcompiler`). Verify with `ankc --version`.

Decks live in a dedicated decks repo (one subfolder per deck). Generate a blank card stub with `ankc gen chunk`.

Commands you'll use:

- `ankc list deck` — list valid deck names. `ankc list file` — list a deck's source files.
- `ankc check [--deck NAME | --all] [--path DIR] [--depth N] [--format text|json]` — validate source **without compiling**. The real pre-build gate.
- `ankc build [--deck NAME | --all] [--path DIR (default .)] [--depth N] [--output DIR (default .)]` — compile to `.apkg`.
- `ankc uid [--path] [--depth] [--check] [--force]` — stamp a `[^uid]` into any card block lacking one. `--check` = dry run; `--force` = stamp even with uncommitted changes.
- `ankc gen chunk` — emit an empty note chunk (stub).

## Card file format (exact — small mistakes break the build)

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

Hard-won format rules (these caused real build failures):

1. **Double `---` after frontmatter.** The frontmatter's closing `---` must be immediately followed by another `---` (the first card's opening delimiter), back-to-back with no blank line between them.
2. **Each card is**: `---`, blank line, content, blank line, `---`, then the `[^uid]:` footer. Cards are separated by these `---` delimiters.
3. **`:::` separates question from answer** in Q&A cards (one line or multi-line). Use `{{c1:: ... }}` for cloze cards (no `:::`).
4. **Every card needs a unique 10-char alphanumeric uid** in a `[^uid]:` footer after the card's closing `---`. Reusing or omitting one breaks the build. Two ways to get them: (a) generate a batch and paste one under each card — `for i in $(seq 1 N); do LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 10; echo; done`; or (b) write each card with **its own closing `---` fence** (so consecutive cards are separated by two `---`, a close then an open) and run `ankc uid` to stamp the missing footers (`ankc uid --check` previews). **`ankc uid` only stamps fully-fenced cards** — a footerless card separated from its neighbor by a single bare `---` is silently merged into that neighbor and you lose cards. When in doubt, place the footers yourself.
5. **A trailing `.` sentinel is no longer required** (ankc ≥ 0.2.0 normalizes the trailing newline). Old decks that end with a lone `.` still build; you just don't need to add one.
6. Optional per-card extra tags: add `[^tag]: tagname` lines under the uid.

## Cloze and rendering rules

- `{{c1:: text}}` makes a cloze card. Cloze cards use **no `:::`**.
- Multiple deletions in one note: `{{c1::...}} {{c2::...}}` → **one note, two cards** (one per distinct `cN` index). Two spans sharing the same `cN` reveal together as a single card.
- **Never nest `{{c1::` inside another cloze.** ankc passes it through silently and Anki mishandles it at review.
- Card content renders Markdown → HTML: `**bold**`→`<strong>`, backticks→`<code>`. LaTeX math works — `$...$` compiles to MathJax `\(...\)`. Formulas can use `$...$`.

## The `:::` / cloze safety trap (read before every build)

`ankc` splits a Q&A card on the **FIRST `:::` on a line**. If a question or answer contains a **literal `:::`**, everything after it is silently swallowed and the answer is truncated. The build still **exits 0** and the uid count still matches — so this is a **false green** the count check cannot catch.

Mitigation:

1. Before building, scan: `grep -n ':::' deck.md`. Confirm each Q&A line has **exactly one** `:::` and each cloze line has **zero**. Reword any content that needs a literal `:::`.
2. **Count-match is necessary but NOT sufficient.** It cannot detect delimiter corruption. After building, spot-read a few compiled cards (or trust `ankc check`).

## Build and verify

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
3. Write cards following the format rules, material-type playbooks, and design principles.
4. Give each card a `[^uid]:` footer (paste generated uids, or fence each card and run `ankc uid`).
5. `grep -n ':::' deck.md` to catch delimiter traps. `ankc check` to validate.
6. `mkdir -p dist`, `ankc build`, then `ls ./dist/*.apkg`. Verify source note count == apkg note count. Spot-read a few cards.
7. Commit the `.md` (gitignore `dist/`/`*.apkg`). Tell the user to import the `.apkg` into Anki (File → Import).
