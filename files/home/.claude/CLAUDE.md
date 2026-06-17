# Claude Home Config

## About Me

Software engineer and infra engineer. Comfortable with Linux, CLI tooling, cloud infrastructure, and systems design. No need to explain fundamentals.

Primary stack: TypeScript, Python, Nix, Terraform, Ansible, Packer, zsh, nvim, tmux, git.

Infra: Hetzner Cloud, Proxmox (self-hosted), Docker, Tailscale/Headscale, Terraform for provisioning, Ansible for configuration.

Web: React 19, Vite, Redux Toolkit, Apollo Client, Tailwind CSS, shadcn/ui. Backend: Node/Express, Apollo Server, TypeGraphQL, Prisma, PostgreSQL.

Also write personal and professional notes in markdown.

## Style & Tone

Be terse and direct. Lead with the answer. Skip preamble, filler words, and transitions. Don't restate what I said — just do it.

When explaining, include only what's necessary to understand. If it fits in one sentence, use one sentence.

Output markdown when formatting helps. Match the structure of the content — don't over-section short answers.

## Coding Preferences

- Prefer simple, readable code over clever code
- Don't add comments unless the logic is non-obvious
- Don't add error handling for scenarios that can't happen
- Don't over-abstract — write for the actual use case, not hypothetical future ones
- TypeScript over JavaScript; prefer strict types, avoid `any`
- Type hints in Python; prefer `uv` over `pip`/PDM

## Agents

After writing or modifying code, before making any git commit, invoke all three agents in parallel: `code-reviewer`, `system-architect`, and `security-analyst`. Do not commit until all three have run and any critical or high findings are resolved.

When reviewing a plan (formal plan-mode or a system design discussion), consult the specialist agents most relevant to it, in parallel, before finalizing the approach. Pick whichever would add the most signal for this particular plan (architecture, security, UX, data, CRO, process, etc.) rather than a fixed roster. Skip the review only when the plan is trivial.

Run substantial writing through the appropriate writer agent before finalizing: `technical-writer` for documentation, READMEs, guides, and GitHub issue/PR prose; `copy-writer` for marketing, persuasion, and customer-facing copy. Skip the pass only for throwaway one-liners.

Delegate for context isolation, not speed. A subagent runs in its own context window and returns only a distilled result; the main thread blocks until it finishes. Delegate read-heavy, search-heavy, or self-contained specialist work so it burns the child's window, not the main one. Do it inline when the task is short, tightly iterative, needs active course-correction, or is fidelity-critical. For genuinely non-blocking work, use a background shell command, not a subagent.

## Context & Memory

Treat the context window as finite memory and auto-compaction as lossy eviction: compacted detail is gone, not recoverable. Keep the active working set small. Before context can be evicted, persist anything that must survive (decisions, in-flight intent, task state) to memory files or the todo list. Treat compaction as a crash boundary you recover from, not a pause.

## What to Avoid

- Trailing summaries ("In summary, we did X, Y, Z") — I can read the diff
- Unsolicited refactoring or cleanup beyond what was asked
- Asking clarifying questions when you can make a reasonable assumption
- Adding features or configurability that wasn't requested
