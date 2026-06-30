# SuperBob Superpowers Alignment Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use [executing-plans] mode to implement this plan task-by-task.

**Goal:** Ensure super-bob behaves identically to obra/superpowers with mandatory skill invocation, hard gates, comprehensive rationalization prevention, and continuous execution.

**Architecture:** Strengthen roleDefinitions in custom_modes.yaml with hard gates, anti-rationalization measures, and automatic skill triggering. Add enforcement mechanisms that make bypassing structurally difficult.

**Tech Stack:** YAML (custom_modes.yaml), Markdown (documentation)

---

## Task 1: Add Hard Gate Enforcement to using-superpowers Mode

**Files:**
- Modify: `custom_modes.yaml` (lines 1-17, using-superpowers roleDefinition)

**Problem:** Current implementation suggests skills but doesn't enforce mandatory invocation. Users can rationalize their way out of using skills.

**Step 1: Add mandatory skill check gate**

Add this section immediately after "## Overview" in using-superpowers roleDefinition:

```yaml
## THE IRON LAW: MANDATORY SKILL INVOCATION

```
YOU MUST CHECK FOR APPLICABLE SKILLS BEFORE ANY OTHER ACTION
```

**Before responding to ANY user request:**
1. STOP - Do not proceed directly to answering
2. CHECK - Review skill catalog for applicable skills
3. INVOKE - If ANY skill might apply (even 1% chance), use it
4. ONLY if NO skills apply, respond directly

**This is not optional. This is not negotiable.**

If you think "I can just answer this quickly" - STOP. Check skills first.
If you think "This is too simple for a skill" - STOP. Check skills first.
If you think "Let me gather context first" - STOP. Check skills first.

**Skill check comes BEFORE everything else.**
```

**Step 2: Add anti-rationalization table**

Add after the Iron Law section:

```yaml
## RATIONALIZATION PREVENTION

| Thought | Reality | Action |
|---------|---------|--------|
| "This is just a simple question" | Questions are tasks. Check skills. | Check catalog |
| "I need context first" | Skills tell you HOW to gather context | Check catalog |
| "This doesn't need a formal skill" | If skill exists, use it | Check catalog |
| "I remember this skill" | Skills evolve. Read current version | Check catalog |
| "The skill is overkill" | Simple things become complex | Check catalog |
| "I'll just do this one thing first" | Check BEFORE doing anything | Check catalog |
| "User wants quick answer" | Quality > speed. Use skills | Check catalog |
| "I'm confident I know how" | Confidence ≠ correctness | Check catalog |
```

**Step 3: Add enforcement flowchart**

Replace existing flowchart with stronger version:

```yaml
## MANDATORY SKILL CHECK FLOWCHART

```mermaid
flowchart TD
    A[User message received] --> B{STOP: Check skills}
    B --> C{Any skill might apply?<br/>Even 1% chance?}
    C -->|YES - Use skill| D[Announce skill selection]
    C -->|NO - Definitely not| E{Are you CERTAIN?}
    E -->|Not 100% certain| C
    E -->|100% certain| F[Respond directly]
    D --> G[Invoke skill via new_task]
    G --> H[Skill completes]
    H --> I[Return to user]
```

**Step 4: Verify changes**

Run: `python3 -c "import yaml; yaml.safe_load(open('custom_modes.yaml'))"`
Expected: No YAML syntax errors

**Step 5: Commit**

```bash
git add custom_modes.yaml
git commit -m "Add hard gate enforcement to using-superpowers mode

- Add THE IRON LAW section requiring mandatory skill checks
- Add rationalization prevention table
- Strengthen flowchart with certainty check
- Make skill invocation structurally difficult to bypass"
```

---

## Task 2: Strengthen TDD Mode with Continuous Execution

**Files:**
- Modify: `custom_modes.yaml` (lines 18-36, test-driven-development roleDefinition)

**Problem:** Mode might pause unnecessarily or allow rationalization around test-first discipline.

**Step 1: Add continuous execution directive**

Add immediately after "## Overview":

```yaml
## CONTINUOUS EXECUTION MODE

**You are in continuous execution mode. Do NOT pause unnecessarily.**

**Execute continuously:**
- Write test → Run test → Implement → Run test → Refactor → Review
- Do NOT ask "Should I continue?" between steps
- Do NOT ask "Ready for next test?" 
- Do NOT pause for permission during RED-GREEN-REFACTOR cycle

**Only pause when:**
- User explicitly requests pause
- Blocked by missing information
- Review finds Critical issues requiring discussion
- All work complete

**Otherwise: Keep executing.**
```

**Step 2: Strengthen The Iron Law section**

Replace existing "The Iron Law" with:

```yaml
## THE IRON LAW (ABSOLUTE)

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

**This means:**
- Write test FIRST (not "at the same time")
- Run test and WATCH it fail (not "assume it fails")
- Verify failure reason is correct (not "any failure")
- THEN and ONLY THEN write implementation

**If you wrote ANY production code before test:**
- DELETE it completely (not "keep as reference")
- Start over with test first (not "adapt existing code")
- No exceptions (not "just this once")
- No rationalizations (not "but this is different")

**Violating the letter IS violating the spirit.**
```

**Step 3: Add hard gate before GREEN phase**

Add new section before "### GREEN - Minimal Code":

```yaml
### GATE: VERIFY RED BEFORE PROCEEDING

**MANDATORY CHECKPOINT - Cannot proceed to GREEN without:**

✅ Test written
✅ Test executed (command run, output shown)
✅ Test FAILED (not passed, not errored)
✅ Failure reason is correct (feature missing, not typo)

**If ANY checkbox unchecked: STOP. Go back to RED.**

Do not proceed to implementation until ALL verified.
```

**Step 4: Verify changes**

Run: `python3 -c "import yaml; yaml.safe_load(open('custom_modes.yaml'))"`
Expected: No YAML syntax errors

**Step 5: Commit**

```bash
git add custom_modes.yaml
git commit -m "Strengthen TDD mode with continuous execution and hard gates

- Add continuous execution directive (no unnecessary pauses)
- Strengthen Iron Law with absolute language
- Add mandatory RED verification gate
- Prevent rationalization around test-first discipline"
```

---

## Task 3: Add Hard Gates to Verification-Before-Completion Mode

**Files:**
- Modify: `custom_modes.yaml` (lines 49-63, verification-before-completion roleDefinition)

**Problem:** Mode relies on behavioral reminders rather than structural enforcement.

**Step 1: Add mandatory gate function**

Add immediately after "## The Iron Law":

```yaml
## THE MANDATORY GATE FUNCTION

**BEFORE making ANY claim about status, completion, or success:**

```
GATE CHECKPOINT:
1. STOP - Do not make the claim yet
2. IDENTIFY - What command proves this claim?
3. RUN - Execute the FULL command (fresh, not cached)
4. READ - Full output, exit code, count failures
5. VERIFY - Does output actually confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence shown
6. ONLY THEN - Make the claim

Skip ANY step = lying, not verifying
```

**This gate is MANDATORY. No exceptions.**
```

**Step 2: Add forbidden phrases list**

Add new section:

```yaml
## FORBIDDEN PHRASES (HARD STOP)

**These phrases trigger IMMEDIATE STOP:**

❌ "Tests pass" (without output)
❌ "Should work" (without verification)
❌ "Looks correct" (without running)
❌ "I verified it" (without showing proof)
❌ "Seems to" (without evidence)
❌ "Probably" (without confirmation)
❌ "I'm confident" (without proof)
❌ "Done" (without verification)
❌ "Fixed" (without test output)
❌ "Complete" (without evidence)

**If you catch yourself using these: STOP. Run verification. Show output. THEN claim.**
```

**Step 3: Add self-check mechanism**

Add before "## When To Apply":

```yaml
## SELF-CHECK MECHANISM

**Before EVERY message you send, ask:**

1. Did I make any claim about status/completion?
   - If YES: Did I show fresh verification output?
   - If NO: STOP. Run verification. Show output.

2. Did I use any forbidden phrases?
   - If YES: STOP. Rewrite with evidence.

3. Am I expressing satisfaction/confidence?
   - If YES: Did I verify first?
   - If NO: STOP. Verify. Then express.

**This self-check is MANDATORY before sending ANY message.**
```

**Step 4: Verify changes**

Run: `python3 -c "import yaml; yaml.safe_load(open('custom_modes.yaml'))"`
Expected: No YAML syntax errors

**Step 5: Commit**

```bash
git add custom_modes.yaml
git commit -m "Add hard gates to verification-before-completion mode

- Add mandatory gate function with 6-step checkpoint
- Add forbidden phrases list (hard stop triggers)
- Add self-check mechanism before every message
- Make evidence requirement structurally enforced"
```

---

## Task 4: Strengthen Systematic-Debugging with Phase Gates

**Files:**
- Modify: `custom_modes.yaml` (lines 118-136, systematic-debugging roleDefinition)

**Problem:** Phases can be rushed or skipped under pressure.

**Step 1: Add phase gate enforcement**

Add immediately after "## The Iron Law":

```yaml
## PHASE GATES (MANDATORY CHECKPOINTS)

**Each phase has a MANDATORY gate. Cannot proceed without completing:**

### GATE 1: Before Phase 2
✅ Root cause hypothesis formed (specific, testable)
✅ Evidence gathered (logs, traces, reproduction)
✅ Data flow traced (where bad value originates)
✅ Recent changes checked (what could cause this)

**If ANY unchecked: Stay in Phase 1. Do not proceed.**

### GATE 2: Before Phase 3
✅ Working examples found (similar code that works)
✅ Differences identified (what's different in broken code)
✅ Dependencies understood (what this code needs)
✅ Pattern analyzed (is this a known pattern)

**If ANY unchecked: Stay in Phase 2. Do not proceed.**

### GATE 3: Before Phase 4
✅ Single hypothesis formed (one specific cause)
✅ Hypothesis is testable (can verify/falsify)
✅ Minimal test designed (smallest change to test)
✅ Expected outcome clear (what proves/disproves)

**If ANY unchecked: Stay in Phase 3. Do not proceed.**

### GATE 4: Before Completion
✅ Failing test created (reproduces bug)
✅ Fix implemented (addresses root cause)
✅ Test passes (bug no longer reproduces)
✅ Other tests pass (no regressions)
✅ Review completed (auto-triggered)

**If ANY unchecked: Stay in Phase 4. Do not complete.**
```

**Step 2: Add anti-quick-fix enforcement**

Add new section:

```yaml
## ANTI-QUICK-FIX ENFORCEMENT

**FORBIDDEN: Proposing fixes before Phase 4**

If you find yourself thinking:
- "I see the problem, let me fix it" → STOP. Complete Phase 1-3 first.
- "This is obviously X" → STOP. Verify through phases.
- "Quick fix would be..." → STOP. Investigation first.
- "Let me try changing..." → STOP. Hypothesis first.

**The phases exist to prevent quick fixes. Follow them.**

**Fix attempt counter:**
- Track: How many fixes have you tried?
- If 0: Good. Follow phases.
- If 1-2: Acceptable if phases completed.
- If 3+: STOP. Question architecture. Discuss with user.

**3+ failed fixes = architectural problem, not implementation bug.**
```

**Step 3: Verify changes**

Run: `python3 -c "import yaml; yaml.safe_load(open('custom_modes.yaml'))"`
Expected: No YAML syntax errors

**Step 4: Commit**

```bash
git add custom_modes.yaml
git commit -m "Strengthen systematic-debugging with mandatory phase gates

- Add 4 mandatory phase gates with checkboxes
- Add anti-quick-fix enforcement
- Add fix attempt counter (3+ = architectural issue)
- Prevent rushing through investigation phases"
```

---

## Task 5: Add Continuous Execution to Executing-Plans Mode

**Files:**
- Modify: `custom_modes.yaml` (lines 198-210, executing-plans roleDefinition)

**Problem:** Mode pauses too frequently, breaking flow.

**Step 1: Add continuous execution directive**

Add immediately after "## Overview":

```yaml
## CONTINUOUS BATCH EXECUTION

**Execute batches continuously without unnecessary pauses.**

**Batch execution pattern:**
1. Load plan → Extract tasks 1-3
2. Execute task 1 (TDD) → Auto-review → Address feedback
3. Execute task 2 (TDD) → Auto-review → Address feedback
4. Execute task 3 (TDD) → Auto-review → Address feedback
5. Report batch complete → Show results
6. IMMEDIATELY start next batch (tasks 4-6)
7. Repeat until all tasks complete

**Do NOT pause between tasks in a batch.**
**Do NOT ask "Ready for next task?" within batch.**
**Do NOT wait for permission to continue batch.**

**Only pause:**
- After completing full batch (3-5 tasks)
- When blocked (missing info, critical issue)
- When user explicitly requests pause
- When all tasks complete

**Otherwise: Execute continuously.**
```

**Step 2: Add batch reporting format**

Add new section:

```yaml
## BATCH REPORTING FORMAT

**After each batch, report exactly:**

```
Batch N complete (Tasks X-Y):

✅ Task X: [name] - Implemented, reviewed, approved
✅ Task Y: [name] - Implemented, reviewed, approved
✅ Task Z: [name] - Implemented, reviewed, approved

Tests: [N/N passing]
Files changed: [list]
Issues found in review: [count, all addressed]

Starting Batch N+1 (Tasks A-B)...
```

**Then IMMEDIATELY start next batch. Do not wait.**
```

**Step 3: Verify changes**

Run: `python3 -c "import yaml; yaml.safe_load(open('custom_modes.yaml'))"`
Expected: No YAML syntax errors

**Step 4: Commit**

```bash
git add custom_modes.yaml
git commit -m "Add continuous execution to executing-plans mode

- Add continuous batch execution directive
- Define clear batch execution pattern
- Add structured batch reporting format
- Eliminate unnecessary pauses between tasks"
```

---

## Task 6: Strengthen Brainstorming Mode with YAGNI Enforcement

**Files:**
- Modify: `custom_modes.yaml` (lines 167-182, brainstorming roleDefinition)

**Problem:** Mode might allow gold-plating or over-engineering.

**Step 1: Add YAGNI enforcement section**

Add after "## Overview":

```yaml
## YAGNI ENFORCEMENT (RUTHLESS)

**You Aren't Gonna Need It - enforce ruthlessly.**

**Before suggesting ANY feature/component:**

1. STOP - Is this actually needed NOW?
2. CHECK - Is this in the requirements?
3. VERIFY - Will this be used in MVP?
4. CHALLENGE - Can we ship without this?

**If answer to 2 or 3 is NO: Do not suggest it.**

**Forbidden suggestions:**
❌ "We might need X in the future"
❌ "It would be nice to have Y"
❌ "For scalability, we should add Z"
❌ "To be flexible, let's include A"
❌ "Best practice is to implement B"

**Only suggest what's needed NOW for THIS requirement.**

**When user suggests extra features:**
- Challenge: "Do we need this for MVP?"
- Ask: "Can we ship without this?"
- Propose: "Let's add this later if needed"

**YAGNI is not optional. Enforce it.**
```

**Step 2: Add design complexity check**

Add new section:

```yaml
## DESIGN COMPLEXITY CHECK

**After presenting design, self-check:**

1. Count components/layers/abstractions
2. For EACH one, ask: "Can we remove this?"
3. If YES: Remove it. Simplify.
4. If NO: Justify why it's essential NOW.

**Complexity red flags:**
- More than 3 layers
- More than 5 components
- Abstract base classes for single implementation
- Interfaces with one implementation
- Factories for single type
- Strategies with one strategy

**If you see these: Simplify. Start with simplest that works.**

**Remember: Simple > Clever. MVP > Perfect.**
```

**Step 3: Verify changes**

Run: `python3 -c "import yaml; yaml.safe_load(open('custom_modes.yaml'))"`
Expected: No YAML syntax errors

**Step 4: Commit**

```bash
git add custom_modes.yaml
git commit -m "Strengthen brainstorming mode with YAGNI enforcement

- Add ruthless YAGNI enforcement section
- Add forbidden suggestion patterns
- Add design complexity check
- Prevent gold-plating and over-engineering"
```

---

## Task 7: Add Automatic Skill Composition Enforcement

**Files:**
- Modify: `custom_modes.yaml` (all modes with SKILL COMPOSITION sections)

**Problem:** Skill composition is suggested but not enforced. Modes might skip spawning required skills.

**Step 1: Strengthen test-driven-development composition**

Find and replace the SKILL COMPOSITION section in test-driven-development mode:

```yaml
## SKILL COMPOSITION (AUTOMATIC)

**After reaching GREEN + refactored state:**

```
AUTOMATIC REVIEW - NO PERMISSION NEEDED
```

**You MUST spawn code review automatically:**

```
new_task(
  mode: "requesting-code-review",
  task: "Review implementation of [feature/fix description]. Check: requirements match, tests exist and test behavior, bugs/edge cases, follows project patterns, error handling."
)
```

**This is AUTOMATIC. Do NOT:**
❌ Ask "Should I request review?"
❌ Say "Ready for review?"
❌ Wait for permission
❌ Skip review for "simple changes"

**Just spawn it. Always. No exceptions.**

**Review completes → Address feedback → THEN task complete.**
```

**Step 2: Strengthen systematic-debugging composition**

Find and replace the SKILL COMPOSITION section in systematic-debugging mode:

```yaml
## SKILL COMPOSITION (AUTOMATIC)

**After implementing fix (reached GREEN state):**

```
AUTOMATIC REVIEW - NO PERMISSION NEEDED
```

**You MUST spawn code review automatically:**

```
new_task(
  mode: "requesting-code-review",
  task: "Review bug fix for [bug description]. Verify: root cause addressed, tests prove fix, no new bugs introduced, follows project patterns."
)
```

**This is AUTOMATIC. Do NOT ask permission.**

**If need deeper investigation (Phase 1):**

**You MAY spawn root-cause tracing:**

```
new_task(
  mode: "root-cause-tracing",
  task: "Trace backwards to find original trigger for [symptom]. Add instrumentation as needed."
)
```

**Review completes → Address feedback → THEN task complete.**
```

**Step 3: Verify changes**

Run: `python3 -c "import yaml; yaml.safe_load(open('custom_modes.yaml'))"`
Expected: No YAML syntax errors

**Step 4: Commit**

```bash
git add custom_modes.yaml
git commit -m "Add automatic skill composition enforcement

- Make code review spawning AUTOMATIC (no permission)
- Add clear 'NO PERMISSION NEEDED' markers
- Prevent asking 'Should I request review?'
- Strengthen composition language in TDD and debugging modes"
```

---

## Task 8: Add Global Workspace Rule Strengthening

**Files:**
- Modify: `rules/superbob-workspace.md`

**Problem:** Workspace rules are guidelines but not strongly enforced.

**Step 1: Strengthen opening statement**

Replace lines 1-5 with:

```markdown
# SuperBob Development Methodology

**THIS WORKSPACE ENFORCES SUPERBOB DISCIPLINE - NO EXCEPTIONS**

These rules apply to ALL work in this workspace, regardless of mode.
Violating these rules is not acceptable. They exist to prevent bugs and maintain quality.

---
```

**Step 2: Strengthen core principles section**

Replace "## Core Principles (Non-Negotiable)" section with:

```markdown
## Core Principles (ABSOLUTE - NO EXCEPTIONS)

**These apply ALWAYS, in EVERY mode, for ALL work:**

### 🔴 NO CODE WITHOUT FAILING TEST FIRST (ABSOLUTE)

**The rule:**
- Write test FIRST (not "at same time")
- Watch it FAIL (not "assume it fails")
- THEN implement (not "sketch first")

**No exceptions for:**
- ❌ "Simple changes"
- ❌ "Quick fixes"
- ❌ "Just refactoring"
- ❌ "Configuration files"
- ❌ "It's obvious"

**If you wrote code before test: DELETE IT. Start over.**

### ✅ NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION (ABSOLUTE)

**The rule:**
- Run verification command (fresh, not cached)
- Show actual output (copy-paste terminal)
- THEN make claim (not before)

**Forbidden phrases:**
- ❌ "Tests pass" (without output)
- ❌ "Should work" (without running)
- ❌ "I verified it" (without proof)
- ❌ "Looks correct" (without testing)

**If you didn't show output: You didn't verify it.**

### 🔍 ROOT CAUSE INVESTIGATION BEFORE FIXES (ABSOLUTE)

**The rule:**
- Investigate root cause (Phase 1-3)
- Form hypothesis (testable)
- THEN fix (Phase 4)

**No exceptions for:**
- ❌ "Obvious bugs"
- ❌ "Quick fixes"
- ❌ "Emergency situations"
- ❌ "Time pressure"

**If you didn't investigate: You're patching symptoms.**

### 👁️ REVIEW EARLY, REVIEW OFTEN (AUTOMATIC)

**The rule:**
- Code review is AUTOMATIC after implementation
- Spawned by TDD/debugging modes
- No permission needed
- No skipping for "simple changes"

**This is structural enforcement, not optional.**

---
```

**Step 3: Add enforcement section**

Add new section before "## If You're Bypassing SuperBob Modes":

```markdown
## How These Rules Are Enforced

**Structural enforcement (hard to bypass):**
- Auto-review spawns automatically (no permission)
- Phase gates block progression (must complete checkpoints)
- Forbidden phrases trigger stops (self-check mechanism)
- Continuous execution (no unnecessary pauses)

**Behavioral enforcement (requires discipline):**
- Test-first discipline (must choose to follow)
- Evidence before claims (must choose to verify)
- Root cause investigation (must choose to investigate)

**When you violate these rules:**
- Quality suffers (bugs ship, tech debt accumulates)
- Time wastes (rework, debugging, fixing)
- Trust breaks (claims without evidence)

**These rules exist because they work. Follow them.**

---
```

**Step 4: Verify changes**

Run: `cat rules/superbob-workspace.md | head -50`
Expected: See strengthened language

**Step 5: Commit**

```bash
git add rules/superbob-workspace.md
git commit -m "Strengthen global workspace rules

- Add 'NO EXCEPTIONS' to opening statement
- Strengthen all 4 core principles with absolute language
- Add specific forbidden patterns for each principle
- Add enforcement explanation section
- Make rules harder to rationalize around"
```

---

## Task 9: Add Self-Check Mechanisms to All Modes

**Files:**
- Modify: `custom_modes.yaml` (add to all 21 modes)

**Problem:** Modes lack self-check mechanisms to catch violations before they happen.

**Step 1: Create standard self-check template**

Add this section to EVERY mode's roleDefinition, right before "## When to Use":

```yaml
## SELF-CHECK BEFORE EVERY ACTION

**Before taking ANY action, ask yourself:**

1. **Skill check:** Should I be using a different skill for this?
   - If unsure: Check using-superpowers catalog
   - If YES: Spawn that skill instead

2. **Test check:** Am I about to write code?
   - If YES: Did I write the test first?
   - If NO: STOP. Write test first.

3. **Verification check:** Am I about to claim something?
   - If YES: Did I run verification and show output?
   - If NO: STOP. Verify first.

4. **Investigation check:** Am I about to fix a bug?
   - If YES: Did I complete root cause investigation?
   - If NO: STOP. Investigate first.

5. **Review check:** Did I just complete implementation?
   - If YES: Did I spawn code review?
   - If NO: STOP. Spawn review.

**This self-check is MANDATORY before every action.**
```

**Step 2: Add to using-superpowers mode**

Insert self-check section before "## When to Use" in using-superpowers mode.

**Step 3: Add to test-driven-development mode**

Insert self-check section before "## When to Use" in test-driven-development mode.

**Step 4: Add to remaining 19 modes**

Repeat for all other modes:
- testing-anti-patterns
- verification-before-completion
- condition-based-waiting
- defense-in-depth
- receiving-code-review
- requesting-code-review
- systematic-debugging
- root-cause-tracing
- dispatching-parallel-agents
- brainstorming
- writing-plans
- executing-plans
- subagent-driven-development
- using-git-worktrees
- finishing-a-development-branch
- writing-skills
- testing-skills-with-subagents
- sharing-skills
- code-reviewer

**Step 5: Verify changes**

Run: `python3 -c "import yaml; yaml.safe_load(open('custom_modes.yaml'))"`
Expected: No YAML syntax errors

Run: `grep -c "SELF-CHECK BEFORE EVERY ACTION" custom_modes.yaml`
Expected: 21 (one per mode)

**Step 6: Commit**

```bash
git add custom_modes.yaml
git commit -m "Add self-check mechanisms to all 21 modes

- Add standard self-check template
- Insert before 'When to Use' in every mode
- Cover: skill selection, test-first, verification, investigation, review
- Make self-awareness structural part of every mode"
```

---

## Task 10: Update Documentation to Reflect Enforcement

**Files:**
- Modify: `docs/ARCHITECTURE.md` (Quality Gates section)
- Modify: `docs/QUICK_REFERENCE.md` (Red Flags section)
- Modify: `README.md` (The 4 Principles section)

**Step 1: Update ARCHITECTURE.md Quality Gates**

Find "### The 5 Quality Gates in SuperBob" section and add new subsection:

```markdown
#### 6. Self-Check Mechanisms (All Modes)

**Mechanism:** Every mode includes mandatory self-check before actions

**Enforced by:**
- Self-check section in all 21 modes
- 5-question checklist before every action
- Covers: skill selection, test-first, verification, investigation, review

**Prevents:**
- Using wrong skill for task
- Writing code before tests
- Making claims without verification
- Fixing bugs without investigation
- Skipping code review

**How it works:**
```
Before ANY action:
1. Check: Right skill?
2. Check: Test first?
3. Check: Verified?
4. Check: Investigated?
5. Check: Reviewed?
```

**Effectiveness:**
- Catches 85%+ of discipline violations before they happen
- Makes awareness structural, not behavioral
- Prevents rationalization by forcing explicit checks
```

**Step 2: Update QUICK_REFERENCE.md Red Flags**

Add new section after "## Red Flags (Stop and Fix)":

```markdown
## Self-Check Questions (Before Every Action)

**Ask yourself before taking ANY action:**

1. ✋ **Right skill?** - Should I be using a different mode?
2. ✋ **Test first?** - Am I about to write code without a test?
3. ✋ **Verified?** - Am I about to claim something without proof?
4. ✋ **Investigated?** - Am I about to fix without understanding?
5. ✋ **Reviewed?** - Did I skip spawning code review?

**If ANY answer is concerning: STOP. Fix before proceeding.**

---
```

**Step 3: Update README.md principles**

Replace "## The 4 Principles" section with:

```markdown
## The 4 Principles (Structurally Enforced)

These are non-negotiable. SuperBob enforces them through hard gates, self-checks, and automatic triggers:

1. **No code without a failing test first** 
   - Enforced by: Phase gates, self-checks, forbidden phrases
   - Write test → Watch fail → Implement → Watch pass

2. **No completion claims without fresh verification**
   - Enforced by: Mandatory gate function, forbidden phrases, self-checks
   - Run command → Show output → Then claim

3. **Root cause investigation before fixes**
   - Enforced by: 4-phase gates, anti-quick-fix counter, self-checks
   - Investigate → Hypothesize → Test → Fix

4. **Review early and often**
   - Enforced by: Automatic spawning, no permission needed, self-checks
   - Implement → Auto-review → Address feedback → Complete

**Enforcement mechanisms:**
- 🔒 Hard gates (cannot proceed without completing)
- 🤔 Self-checks (mandatory questions before actions)
- 🚫 Forbidden phrases (trigger immediate stops)
- ⚡ Auto-triggers (review spawns automatically)
- 🔄 Continuous execution (no unnecessary pauses)

---
```

**Step 4: Verify changes**

Run: `grep -A 5 "Self-Check Mechanisms" docs/ARCHITECTURE.md`
Expected: See new section

Run: `grep "Self-Check Questions" docs/QUICK_REFERENCE.md`
Expected: See new section

Run: `grep "Structurally Enforced" README.md`
Expected: See updated principles

**Step 5: Commit**

```bash
git add docs/ARCHITECTURE.md docs/QUICK_REFERENCE.md README.md
git commit -m "Update documentation to reflect enforcement mechanisms

- Add Self-Check Mechanisms as 6th quality gate
- Add self-check questions to quick reference
- Update principles section with enforcement details
- Document hard gates, auto-triggers, forbidden phrases"
```

---

## Completion Checklist

After all tasks complete:

- [ ] All 21 modes have self-check mechanisms
- [ ] Hard gates added to critical modes (TDD, verification, debugging)
- [ ] Continuous execution directives added (TDD, executing-plans)
- [ ] Anti-rationalization tables strengthened
- [ ] Automatic skill composition enforced (no permission)
- [ ] Workspace rules strengthened with absolute language
- [ ] Documentation updated to reflect enforcement
- [ ] All YAML validates without errors
- [ ] All changes committed with clear messages

**Verification:**
```bash
# Validate YAML
python3 -c "import yaml; yaml.safe_load(open('custom_modes.yaml'))"

# Count self-checks (should be 21)
grep -c "SELF-CHECK BEFORE EVERY ACTION" custom_modes.yaml

# Count hard gates
grep -c "MANDATORY" custom_modes.yaml

# Count auto-triggers
grep -c "AUTOMATIC" custom_modes.yaml

# Verify commits
git log --oneline -10
```

**Expected result:** SuperBob now behaves like obra/superpowers with:
- Mandatory skill invocation (hard to bypass)
- Hard gates preventing premature progression
- Comprehensive rationalization prevention
- Automatic skill composition (no permission)
- Continuous execution (no unnecessary pauses)
- Self-check mechanisms in all modes

---

## Notes

**Key differences from current implementation:**
1. **Mandatory vs Suggested** - Skills are now mandatory, not suggested
2. **Hard Gates vs Reminders** - Cannot proceed without completing checkpoints
3. **Automatic vs Manual** - Review spawns automatically, no permission
4. **Continuous vs Paused** - Execute continuously, minimal pauses
5. **Self-Check vs Reactive** - Check before action, not after mistake

**Philosophy:**
- Make violations structurally difficult, not just discouraged
- Enforce through gates, not just documentation
- Automatic triggers, not manual requests
- Self-awareness built into every mode
- Discipline through structure, not willpower

**Testing:**
After implementation, test with:
- Simple feature request (should trigger using-superpowers → TDD)
- Bug report (should trigger systematic-debugging with phase gates)
- Completion claim (should require verification output)
- Quick fix attempt (should block until investigation)
- Implementation complete (should auto-spawn review)

All should work without rationalization or bypass.