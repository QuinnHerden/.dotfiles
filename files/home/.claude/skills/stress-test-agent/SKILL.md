---
name: stress-test-agent
description: Use when validating or hardening a Claude Code subagent (anything in ~/.claude/agents/). Exercises the agent on realistic and adversarial tasks, then runs an independent adversarial judge that audits the output for fabrication, depth gaps, boundary errors, cardinal-rule adherence, and Reference-Library fidelity. Returns per-task scores and a ship / tweak / rework verdict. Invoke after creating or editing an agent, before trusting it in production, or when asked to "stress test" / "test" an agent.
---

# Stress-test an agent

The pattern: **give the agent a real task, then send an adversarial judge.** Two phases — Exercise, then Judge. The judge is a *separate* agent with no stake in the output, told to default to flagging.

This is for evaluating an agent's *spec* (its prompt), not for doing the agent's actual job. The goal is to find where the agent fabricates, stays shallow, crosses its boundaries, or drifts from its rules — and to fix the spec only when there's a real defect.

## Step 1 — Read the target

Read the agent file in `~/.claude/agents/<name>.md`. Note:

- The **named frameworks** it claims to own (these are what you check for fabrication).
- Its **boundaries / handoffs** (which work it must defer to other agents).
- Any **cardinal rule** or owned-behavior it states (e.g. process-analyst's "not all inefficiency is waste").
- Its **Reference Library** pointers, if it's a hybrid agent. Read those extraction docs too — they are ground truth for the fabrication check.

## Step 2 — Design tasks

Write 2-4 realistic tasks in the agent's domain. Make them *concrete* (real numbers, a real-sounding scenario), not abstract prompts. Include, deliberately:

- At least one **boundary trap** — a task that tempts the agent to do another agent's job (e.g. ask a process-analyst to "design the data warehouse and pick the cloud"). A good agent refuses and delegates.
- At least one **cardinal-rule temptation** — a task that rewards the naive move the agent's rule exists to prevent (e.g. "just delete this slow approval step").
- Tasks that should force it to reach for its named frameworks / Reference Library, so you can check it uses them precisely (not a folk version).

## Step 3 — Exercise

Run the agent on each task using the Agent tool with `subagent_type: <the agent's name>`. Run independent tasks in parallel (one message, multiple tool calls). Keep each task prompt self-contained.

## Step 4 — Adversarial judge

Spawn a separate judge (a `general-purpose` agent, or the relevant specialist if domain expertise helps). Give it: the agent's spec, its Reference Library docs (have the judge read them), and the agent's output(s). Tell it to be skeptical and **default to flagging**. The rubric:

1. **Fabrication / inaccuracy** — any named framework, law, citation, or specific that is invented, misstated, or misattributed versus what the sources actually say. Check hard against the Reference Library docs.
2. **Framework fidelity** — does it apply the framework the way the source defines it, or a folk version?
3. **Depth gaps** — generic advice where a named owned framework should have been applied with precision.
4. **Boundary errors** — did the agent's job that belongs to another agent, OR over-deferred work it actually owns.
5. **Cardinal-rule adherence** — did it correctly honor its core rule under pressure, without either ignoring it OR over-applying it (e.g. relabeling genuine waste as "intentional" to avoid cutting it)?
6. **Reference-Library use** (hybrid agents) — did it reach for the right doc for the right problem, with no cross-contamination?

Ask the judge for: a per-task score (1-10), specific quoted findings under each rubric heading, and an overall **ship / tweak / rework** verdict with any concrete edits to the agent `.md`.

## Step 5 — Verdict and surgical fixes

Apply the judge's tweaks **only when they are real spec defects** — wording the prompt should carry permanently:

- Canonical-form errors in the spec (e.g. stating a framework's steps wrong), factual errors, missing boundary language, a missing Reference Library.

Do **not** edit the spec for **single-run slips** — a one-off reasoning miss in one output that the spec already guards against. Those are noise; the judge will usually mark them "ship." Over-tweaking the prompt to chase every single-run nit bloats it and chases ghosts.

Keep fixes surgical (one-line canonicalizations, a pointer, a boundary clause). Re-read the file before editing. If the agent is hybrid and the gap is "no Reference Library / unbacked frameworks," the fix is to digest a real source and wire a pointer — never fabricate an extraction.

## Scaling to many agents

To test several agents at once, fan out with a Workflow: a pipeline where each agent is exercised and then judged as soon as its output lands (don't barrier the whole exercise phase before judging). Use a structured-output schema for the judge so verdicts come back machine-readable (score, fabrications[], depth_gaps[], boundary_errors[], tweaks[], verdict). Scale the rigor to the ask: a quick check is one task + one judge; "thoroughly audit" warrants more tasks, multiple judges per finding, and a synthesis pass.

## Output

Report: per-agent score(s), the ship/tweak/rework verdict, the real fixes applied (and why they were spec defects, not slips), and any deferred follow-ups (e.g. "needs a source digested to back framework X"). Be terse; lead with the verdict.
