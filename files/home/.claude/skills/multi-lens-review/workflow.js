export const meta = {
  name: 'multi-lens-review',
  description: 'Multi-agent review: a scout maps the subject, expert lenses assess in parallel, a synthesizer reconciles, an adversarial critic stress-tests the verdict',
  phases: [
    { title: 'Scout', detail: 'map the subject into a shared base' },
    { title: 'Assess', detail: 'expert lenses assess in parallel' },
    { title: 'Synthesize', detail: 'reconcile into one verdict' },
    { title: 'Critique', detail: 'adversarial stress-test of the verdict' },
  ],
}

// args (from the Workflow `args` input):
//   subject   : string  - what is being reviewed
//   dimension : string  - what it is reviewed FOR (cohesion | quality | risk | readiness | soundness). Default: cohesion
//   context   : string  - the framing + where the source material is and how to read it (paths, repos, "run gh ...", docs to read)
//   lenses    : [{ key, agentType, focus }] - the expert lenses. agentType is a subagent type (e.g. data-engineer, system-architect, ux-designer, business-mentor, security-analyst, process-analyst). 3-5 is the sweet spot. Pick for genuine perspective diversity.
const a = args || {}
const SUBJECT = a.subject || 'the subject under review'
const DIMENSION = a.dimension || 'cohesion'
const LENSES = (Array.isArray(a.lenses) && a.lenses.length) ? a.lenses : [
  { key: 'architecture', agentType: 'system-architect', focus: 'Overall structure and whether the parts cohere into one whole.' },
  { key: 'product-strategy', agentType: 'business-mentor', focus: 'Whether it is a coherent, well-scoped bet for its stage.' },
]
const CTX = `Assess ${SUBJECT} for ${DIMENSION}.\n\n${a.context || ''}`

const SCOUT = { type:'object', additionalProperties:false, required:['overview','keyAspects','inFlightOrRoadmap','tensions','sources'], properties:{
  overview:{type:'string'}, keyAspects:{type:'array',items:{type:'string'}}, inFlightOrRoadmap:{type:'string'},
  tensions:{type:'array',items:{type:'string'}}, sources:{type:'array',items:{type:'string'}} } }
const LENS = { type:'object', additionalProperties:false, required:['lens','score','strengths','issues','risks','recommendations'], properties:{
  lens:{type:'string'}, score:{type:'number'}, strengths:{type:'array',items:{type:'string'}},
  issues:{type:'array',items:{type:'object',additionalProperties:false,required:['issue','severity','why'],properties:{issue:{type:'string'},severity:{type:'string'},why:{type:'string'}}}},
  risks:{type:'array',items:{type:'string'}}, recommendations:{type:'array',items:{type:'string'}} } }
const SYNTH = { type:'object', additionalProperties:false, required:['overallScore','verdict','narrative','topIssues','recommendation'], properties:{
  overallScore:{type:'number'}, verdict:{type:'string'}, narrative:{type:'string'}, topIssues:{type:'array',items:{type:'string'}}, recommendation:{type:'string'} } }
const CRIT = { type:'object', additionalProperties:false, required:['overstated','strongestCounterCase','blindSpots','adjustedVerdict'], properties:{
  overstated:{type:'boolean'}, strongestCounterCase:{type:'string'}, blindSpots:{type:'array',items:{type:'string'}}, adjustedVerdict:{type:'string'} } }

phase('Scout')
const scout = await agent(`${CTX}

You are the SCOUT. Inspect the subject thoroughly (read the cited files/repos, fetch the cited state) and produce a shared map for the assessor agents: an overview, the key aspects/components, any in-flight state or roadmap, and the key tensions. Be concrete and cite sources. Downstream agents rely on this so they need not re-read everything.`,
  { label:'scout', phase:'Scout', schema: SCOUT })
const map = JSON.stringify(scout)

phase('Assess')
const verdicts = (await parallel(LENSES.map(l => () =>
  agent(`${CTX}

Shared scout map (JSON):
${map}

Your lens: ${l.key}. ${l.focus}

Return a verdict from this lens: a 1-10 score (10 = excellent on this dimension), strengths, issues (each with severity high/medium/low and why), risks, and concrete recommendations. Ground every point in the actual evidence; read the source material yourself where the scout map is thin.`,
    { label:`lens:${l.key}`, phase:'Assess', agentType:l.agentType, schema: LENS })
))).filter(Boolean)

phase('Synthesize')
const synth = await agent(`${CTX}

The expert lens verdicts (JSON):
${JSON.stringify(verdicts)}

Synthesize ONE assessment. Reconcile agreement and tension across lenses (note where lenses diverge and why). Give: overallScore (1-10), a one-line verdict, a narrative (the story: where it hangs together and where it does not), the topIssues that matter most across lenses, and a single clear recommendation.`,
  { label:'synthesize', phase:'Synthesize', schema: SYNTH })

phase('Critique')
const crit = await agent(`${CTX}

A synthesized assessment (JSON):
${JSON.stringify(synth)}

The underlying lens verdicts (JSON):
${JSON.stringify(verdicts)}

You are an adversarial critic. Try to REFUTE the synthesis. Is its verdict overstated or understated? What is the strongest counter-case? What did all the lenses miss (blind spots)? Verify the load-bearing claims against the source where you can. Give an adjustedVerdict if warranted. Default to skepticism.`,
  { label:'critique', phase:'Critique', schema: CRIT })

return { verdicts, synthesis: synth, critique: crit }
