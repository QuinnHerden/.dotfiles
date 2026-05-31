---
name: authoring-anki-decks
description: Author granular Anki flashcard decks in Markdown and compile them with ankcompiler (the `ankc` CLI). Use when the user wants to turn reference material, notes, or a document into Anki cards / a study deck, or mentions ankcompiler, .apkg, spaced repetition, or memorizing something "cold." Produces atomic, one-fact-per-card decks following the minimum-information principle.
---

# Authoring Anki decks with ankcompiler

Turn source material into an atomic, high-retention Anki deck and compile it to `.apkg` with `ankc`.

## Tooling

`ankc` is the CLI. Install once if missing: `uv tool install ankcompiler` (or `pip install ankcompiler`). Verify with `ankc --version`.

Decks live in the user's `anki-decks` repo (one subfolder per deck). Generate a blank card stub with `ankc gen chunk` (it emits a fresh 10-char uid).

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

.
```

Hard-won format rules (these caused real build failures):

1. **Double `---` after frontmatter.** The frontmatter's closing `---` must be immediately followed by another `---` (the first card's opening delimiter), back-to-back with no blank line between them.
2. **Each card is**: `---`, blank line, content, blank line, `---`, then the `[^uid]:` footer. Cards are separated by these `---` delimiters.
3. **`:::` separates question from answer** in Q&A cards (one line or multi-line). Use `{{c1:: ... }}` for cloze cards (no `:::`).
4. **Every card needs a unique 10-char alphanumeric uid** in a `[^uid]:` footer. Reusing or omitting one breaks the build. Generate a batch with: `for i in $(seq 1 N); do LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 10; echo; done`
5. **End the file with a blank line then a lone `.`** after the last card's uid. python-frontmatter strips the trailing newline, and without this sentinel the *last* card's uid fails to parse (`No guid found in note meta chunk`).
6. Optional per-card extra tags: add `[^tag]: tagname` lines under the uid.

## Build and verify

```bash
mkdir -p dist
ankc build --deck "Deck Name" --depth 2 --output ./dist
```

`--depth` must be high enough to reach the deck file in subfolders (default 0 = cwd only). Always verify the card count survived:

```bash
grep -c '\[\^uid\]:' path/to/deck.md   # uids in source
# then count notes in the .apkg (unzip, sqlite: select count(*) from notes)
```

The two numbers must match. `.apkg` output should be gitignored.

## The atomic-card playbook (how to choose what each card tests)

Follow the **minimum information principle**: one retrievable fact per card. A card you can't cleanly grade "right/wrong" is too big — split it. Spaced repetition reschedules a card on its hardest sub-fact, so fat cards waste reviews.

Concrete rules:

- **One fact per card.** If the answer contains "and" joining two facts, split it.
- **Acronyms get two cards**, one each direction (acronym → expansion, expansion → acronym). ankcompiler has no auto-reverse note type, so write both.
- **Formulas**: a card for the whole formula, plus separate cards for the hard parts (what's in the numerator, what's excluded, what a threshold signals).
- **Avoid enumerations.** "Name the 5 components" is unrateable; make one card per component (and optionally one for the count).
- **No yes/no questions** (50% guess rate, no recall). Rewrite as "what / which / how."
- **Disambiguate confusable items** with explicit contrast cards (e.g. "NRR vs GRR — key difference?"). Interference between similar items is the main cause of forgetting in a dense deck.
- **Keep answers short** (≤ ~15 words). Specific, unambiguous questions; the back is a complete standalone answer.
- **No source attribution or extra context on the front** unless that's the fact being tested.

For a definitional reference (metrics, terms, concepts), a good repeatable per-item card set is: acronym↔expansion (2 cards), one-sentence definition, formula, key exclusion/boundary, why-it-matters/threshold, benchmark, and a disambiguation card for any close cousin. Don't force all of these — generate the ones that carry real, distinct knowledge. Don't try to stuff every sentence of the source into cards; capture what must be known cold.

## Workflow summary

1. Read the source material; list the atomic facts worth knowing cold.
2. Decide deck name + tags. Create `anki-decks/<deck-slug>/<deck-slug>.md`.
3. Generate enough uids up front.
4. Write cards following the format rules and the atomic playbook.
5. `ankc build`, then verify source uid count == apkg note count.
6. Commit the `.md` (gitignore `dist/`/`*.apkg`). Tell the user to `ankc build` and import the `.apkg` into Anki (File → Import).
