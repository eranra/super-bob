# SuperBob Development Methodology

**THIS WORKSPACE ENFORCES SUPERBOB DISCIPLINE - NO EXCEPTIONS**

These rules apply to ALL work in this workspace, regardless of mode.
Violating these rules is not acceptable. They exist to prevent bugs and maintain quality.

---

## Use SuperBob Skill-Modes

For serious work, you MUST use SuperBob skill-modes. Start with:
- **using-superpowers** - Entry point that selects the right skill

Or use slash commands for quick access:
- `/tdd` - Test-driven development
- `/debug` - Systematic debugging
- `/brainstorm` - Design refinement
- `/write-plan` - Create implementation plan
- `/execute-plan` - Execute plan with TDD
- `/review` - Request code review

Or select directly from 14 skill-modes:
- **test-driven-development** - RED-GREEN-REFACTOR cycle
- **systematic-debugging** - 4-phase root-cause investigation
- **brainstorming** - Socratic design refinement
- **writing-plans** - Comprehensive implementation plans
- **executing-plans** - Batch execution with review checkpoints
- **requesting-code-review** - Perform rigorous code review
- **receiving-code-review** - Process review feedback
- And 14 more specialized skills...

**Do NOT bypass SuperBob modes for convenience.**

Only use other modes for:
- ⚠️ Trivial one-off tasks explicitly marked as experimental
- ⚠️ User explicitly requests different mode
- ⚠️ Quick questions that don't involve code changes

When in doubt, use a skill-mode. They exist for a reason.

---

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

## If You're Bypassing SuperBob Modes

**Stop and ask:**
- Why am I not using a SuperBob mode?
- Is this serious work? (If yes → use SuperBob mode)
- Am I bypassing for convenience? (If yes → stop, use proper mode)

The discipline exists to catch bugs early, maintain quality, and ensure
rigorous development. Bypassing defeats the purpose.

---

**When you start a session, select the appropriate SuperBob skill-mode:**
- using-superpowers for automatic skill selection
- brainstorming for design refinement
- writing-plans for implementation planning
- test-driven-development for feature implementation
- systematic-debugging for investigating bugs
- requesting-code-review for code review only
- Or use slash commands: /tdd, /debug, /brainstorm, /write-plan, /execute-plan
