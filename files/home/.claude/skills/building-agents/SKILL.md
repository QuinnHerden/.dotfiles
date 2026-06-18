---
name: building-agents
description: Use when creating a new Claude Code subagent for a domain, or substantially reworking one. Covers the full pipeline: scope and name the agent, source authoritative material, extract it into the knowledge base, draft the agent with the hybrid pattern (compressed inline frameworks + a Reference Library), stress-test it, and ship it. Invoke when the user wants a new agent ("make an agent for X", "build a <domain> agent", "add a specialist for ...").
---

# Building an agent

The end-to-end process for adding a high-quality specialist subagent to `~/.claude/agents/`. It ties together two sibling skills: `extracting-book-knowledge` (the knowledge step) and `stress-test-agent` (the test step).

The pattern: **Scope → Source → Extract → Draft → Stress-test → Ship.** Do not skip Source/Extract. An agent grounded in real, cited source material beats one written from the model's own memory, and it is the difference between an expert agent and a plausible-sounding one.

## 1. Scope

- Define the agent's **one seam**: what it owns that no existing agent does. Read the current roster (`~/.claude/agents/`) first and avoid overlap.
- Decide **lead vs specialist**. A lead holds a high-level view and delegates depth (e.g. system-architect, business-mentor); a specialist goes deep in a single lane.
- Write the **boundaries and delegations** explicitly: which work it hands to which other agent (security controls to `security-analyst`, data architecture to `data-engineer`, documentation to `technical-writer`, etc.). The rule is "collaborate, don't absorb."
- Name it in clear kebab-case; the `description` is the routing signal, so it must say exactly when to use the agent.
- If the domain has a hard caveat (legal, medical, financial), bake it into the prompt: assistance, not a substitute for a licensed professional; flag jurisdiction- or context-dependence.

## 2. Source authoritative material

- Recommend the **canonical** texts and primary sources, not SEO results. For law and standards, use primary sources (statutes, regulators, standards bodies); for a field, use the field-defining books.
- Use the **enacted / in-force** official text, never a draft, proposal, or superseded revision; record the version and date. (A draft EU SCCs digest once produced wrong clause numbers.)
- State *why* each source is authoritative, and what you are excluding (blogs, "ultimate guides", third-party renderings of primary text). If asked to vet for authoritativeness, do it explicitly.
- The user buys or provides books (into `~/repos/education/`); free primary web sources you can fetch yourself.

## 3. Extract

- Use the `extracting-book-knowledge` skill to digest each source into the private `dotfiles-private` submodule (write under `~/.dotfiles/private/knowledge/extractions/`, per that skill's Deployment steps). Faithful 20/80, cite section/article numbers, flag retrieval gaps rather than guessing, and no "where this could saturate" section.
- **Cardinal rule: never fabricate an extraction.** If no real source exists, either digest one or mark the framework inline-only on purpose. A `Reference Library` pointer to an invented or nonexistent doc is worse than no pointer.
- Verify the load-bearing specifics yourself (the numbers and clause/section references a reader would rely on), especially for legal/technical material.
- Move consumed sources to `~/repos/education/done/`. Commit and push inside the submodule.

## 4. Draft (the hybrid pattern)

- File layout (model it on an existing agent, e.g. `~/.claude/agents/process-analyst.md`): frontmatter (`name`, and `description` = the routing trigger) -> role line -> `## Core Frameworks` (the compressed, named frameworks inline) -> the boundaries/delegations -> `## Reference Library` (the `~/.claude/knowledge/extractions/<slug>.md` pointers) -> a terse-style closing line.
- The inline frameworks carry the opinion; the library carries the detail. Keep the boundaries and delegations from step 1. House style: terse, lead with the answer, no em dashes.
- Back every inline framework with a real extraction where one exists (see the Extract cardinal rule).

## 5. Stress-test

- Run the `stress-test-agent` skill: realistic tasks plus at least one boundary trap and one cardinal-rule temptation, then an adversarial judge auditing for fabrication, depth gaps, boundary errors, cardinal-rule adherence, and Reference-Library fidelity.
- Apply only real spec-defect fixes (canonical-form errors, missing boundaries, a missing Reference Library). Ignore single-run reasoning slips.
- On a tweak or rework verdict, apply the fixes and re-run the stress-test; only a ship verdict proceeds to step 6.

## 6. Ship

- Commit via the dotfiles PR flow (branch off main; main is branch-protected). The PR carries the new agent file **and** the bumped `knowledge` submodule pointer, so the extractions it references are pinned together.
- After merge, sync the containers.

## Output

A new agent in `~/.claude/agents/`, backed by cited extractions, stress-tested to a ship/tweak/rework verdict, and merged. Report the verdict and any deferred follow-ups (for example "needs source X digested to fully back framework Y").
