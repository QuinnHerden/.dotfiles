---
name: multi-lens-review
description: Run a rigorous multi-agent review of a substantial subject (a product, codebase, design, roadmap, plan, repo, or strategy) across several expert perspectives, then synthesize and adversarially stress-test the verdict. Use when the user wants a thorough assessment/audit/cohesion-or-quality review and a single-lens take would be too shallow ("assess X for cohesion", "review the roadmap", "is this design sound", "audit this across perspectives"). Spawns expert-lens subagents plus an adversarial critic, so it is multi-agent orchestration.
---

# Multi-lens review

A managed multi-agent assessment. The pattern, in four phases:

**Scout -> Assess (parallel expert lenses) -> Synthesize -> Adversarial critique.**

- **Scout** maps the subject once into a shared base, so each lens does not re-read everything.
- **Assess** runs several expert subagents in parallel, each judging one lens (one perspective) and returning a scored, evidence-grounded verdict.
- **Synthesize** reconciles the lenses into one verdict, noting where they diverge.
- **Critique** is an adversarial agent that tries to refute the synthesis and verifies the load-bearing claims. This is the quality lever: in practice it catches the synthesis overreaching or inheriting errors. Do not skip it.

It is implemented as a workflow at `workflow.js` in this skill's directory, parameterized via `args`.

## When to use

- The subject is substantial and genuinely multi-faceted (it has a domain model AND a UX AND a strategy, etc.).
- The user wants confidence, not a quick opinion: a cohesion read, a design review, a roadmap audit, a readiness or risk assessment.

## When not to use

- A narrow, single-perspective question (just answer it, or use one subagent).
- A trivial subject. The orchestration is many agents and many tokens; reserve it for things that earn it.

## How to run it

1. **Scope it.** Settle four things (ask the user only if genuinely ambiguous):
   - **subject**: what is being reviewed, in one phrase.
   - **dimension**: what it is reviewed FOR (cohesion, quality, risk, readiness, soundness). Default: cohesion.
   - **context**: the framing plus exactly where the source material is and how to read it (file paths, repos, `gh issue list ...` for an in-flight roadmap, which docs to read). The agents are only as good as this.
   - **lenses**: 3-5 expert perspectives, each `{ key, agentType, focus }`. Pick `agentType`s for genuine perspective diversity from the domain (e.g. `data-engineer` for a data model, `system-architect` for structure, `ux-designer` for an interface, `business-mentor` for strategy/scope, `security-analyst` for trust surface, `process-analyst` for a workflow). Three identical lenses waste the run; diversity is the point.

2. **Invoke the workflow** (this is the explicit opt-in for multi-agent orchestration, since a skill is calling it):

   ```
   Workflow({
     scriptPath: "~/.claude/skills/multi-lens-review/workflow.js",
     args: {
       subject: "Motifs, a workflow + knowledge engine",
       dimension: "cohesion",
       context: "Code + docs at /home/dev/repos/motifs: read README, ROADMAP, docs/. Roadmap-in-flight: `gh issue list --repo SculptedSystems/motifs --state open`. Strategic frame: ...",
       lenses: [
         { key: "domain-data-model", agentType: "data-engineer", focus: "..." },
         { key: "architecture-roadmap", agentType: "system-architect", focus: "..." },
         { key: "ux-interaction", agentType: "ux-designer", focus: "..." },
         { key: "product-strategy", agentType: "business-mentor", focus: "..." }
       ]
     }
   })
   ```

   It runs in the background and returns `{ verdicts, synthesis, critique }`. The result can be large; extract the synthesis + critique + each lens score rather than reading the whole blob into context.

3. **Relay AND weigh in.** Do not just paste the agents' output. Lead with the synthesized verdict (corrected by the critique), then add your own take, integrating context the agents did not have. The agents produce signal; you own the conclusion.

## Notes

- Pick lenses that can actually disagree; the value is in the spread, not in consensus.
- The scout + the critic are what make this better than a flat fan-out: shared grounding in, adversarial check out.
- Scale the lens count to the subject. Two for a small thing, five for a big one. More than five rarely adds signal.
