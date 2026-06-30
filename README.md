# SuperBob

Rigorous development discipline for [IBM Bob](https://bob.ibm.com/docs/ide).

14 skill-modes that enforce test-driven development, systematic debugging, and
automatic code review for the IBM Bob IDE.

---

## Installation

Requires IBM Bob to be installed. Global install — modes become available in all projects.

```bash
git clone https://github.ibm.com/ERANRA/super-bob.git
cd super-bob
chmod +x install.sh
./install.sh
```

Restart IBM Bob after install.

To preview what the script will do without making changes:

```bash
./install.sh --dry-run
```

To update to the latest version (overwrites existing files):

```bash
./install.sh --update
```

**Note:** The `--update` flag will:
- Overwrite `custom_modes.yaml` (creates backup with timestamp)
- Update all slash commands in `~/.bob/commands/`
- Update workspace rules in `~/.bob/settings/rules/`

### What gets installed

| Source | Destination |
|---|---|
| `custom_modes.yaml` | `~/.bob/settings/custom_modes.yaml` |
| `commands/*.md` (14 files) | `~/.bob/commands/` |
| `rules/superbob-workspace.md` | `~/.bob/settings/rules/` |
| `skills/*/SKILL.md` (14 skills) | `~/.bob/skills/` |

---

## Usage

### Automatic skill selection

Switch to **using-superpowers** mode — Bob will select the right skill for your task.

### Slash commands

| Command | Mode | Use for |
|---|---|---|
| `/tdd` | test-driven-development | Implementing features or bugfixes |
| `/debug` | systematic-debugging | Investigating bugs |
| `/brainstorm` | brainstorming | Designing before building |
| `/write-plan` | writing-plans | Multi-step implementation planning |
| `/execute-plan` | executing-plans | Executing a written plan |
| `/review` | requesting-code-review | Code review before merging |
| `/finish` | finishing-a-development-branch | Completing a branch |

---

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


## Recommended Workflows

### Workflow Selection Decision Tree

```
Start here
    ↓
Do you have a clear design?
    ├─ No → Use Workflow 4 (Design Exploration)
    └─ Yes
        ↓
    Is it a bug or unexpected behavior?
        ├─ Yes → Use Workflow 3 (Bug Investigation)
        └─ No
            ↓
        Is it a multi-step feature?
            ├─ Yes → Use Workflow 1 (Full Cycle)
            └─ No
                ↓
            Simple single-step task?
                ├─ Yes → Use Workflow 2 (Quick Feature)
                └─ No → Use Workflow 5 (Code Review Only)
```

### Workflow 1: Feature Implementation (Full Cycle)

**When:** Multi-step feature with design needed

**Steps:**
1. `/brainstorm` - Refine design through Socratic questions
2. `/write-plan` - Create detailed implementation plan
3. `/execute-plan` - Execute plan in batches with checkpoints
4. Auto-review triggers after each task
5. `/finish` - Merge, PR, or cleanup

**Example:** "Add user authentication system"

**Time:** 2-4 hours for medium features

### Workflow 2: Quick Feature (Direct TDD)

**When:** Single-step feature, design is clear

**Steps:**
1. `/tdd` - Implement using RED-GREEN-REFACTOR
2. Auto-review triggers automatically
3. `/finish` - Complete the work

**Example:** "Add email validation to signup form"

**Time:** 15-30 minutes

### Workflow 3: Bug Investigation

**When:** Bug, test failure, or unexpected behavior

**Steps:**
1. `/debug` - Use 4-phase systematic debugging
   - Phase 1: Root cause investigation
   - Phase 2: Pattern analysis
   - Phase 3: Hypothesis testing
   - Phase 4: Implementation (with TDD)
2. Auto-review triggers after fix
3. `/finish` - Complete the work

**Example:** "Login fails with empty password"

**Time:** 30 minutes - 2 hours depending on complexity

### Workflow 4: Design Exploration

**When:** Need to explore approaches before implementing

**Steps:**
1. `/brainstorm` - Explore 2-3 approaches with trade-offs
2. Refine design incrementally
3. Write design doc to `docs/plans/`
4. Choose: Continue to Workflow 1 or stop at design

**Example:** "How should we implement caching?"

**Time:** 30 minutes - 1 hour

### Workflow 5: Code Review Only

**When:** Code already written, need review before merge

**Steps:**
1. `/review` - Rigorous code review
2. Address feedback using `/tdd`
3. Re-review if needed
4. `/finish` - Complete the work

**Example:** "Review PR before merging"

**Time:** 15-30 minutes

---

## Anti-Patterns to Avoid

**Don't:**
- ❌ Skip design for complex features (use Workflow 1, not 2)
- ❌ Skip debugging for bugs (use Workflow 3, not 2)
- ❌ Write code before tests (always TDD)
- ❌ Skip review for "simple changes" (auto-review always runs)
- ❌ Claim completion without verification (evidence required)

**Do:**
- ✅ Match workflow to task complexity
- ✅ Follow the decision tree when unsure
- ✅ Let auto-review run (don't skip)
- ✅ Provide evidence for all claims
- ✅ Investigate root causes before fixing

---

## All 14 Modes

| Mode | When to use |
|---|---|
| `using-superpowers` | Start of any task — select the right skill |
| `test-driven-development` | Implementing any feature or bugfix |
| `verification-before-completion` | Before claiming work is done |
| `receiving-code-review` | Processing code review feedback |
| `requesting-code-review` | Before merging — rigorous review |
| `systematic-debugging` | Any bug, test failure, unexpected behavior |
| `dispatching-parallel-agents` | 2+ independent tasks that can run concurrently |
| `brainstorming` | Before any creative work |
| `writing-plans` | Multi-step tasks, before touching code |
| `executing-plans` | Executing a written plan |
| `subagent-driven-development` | Plans with independent tasks via subagents |
| `using-git-worktrees` | Feature work needing isolation |
| `finishing-a-development-branch` | Implementation complete, ready to integrate |
| `writing-skills` | Creating or editing Bob skill/mode definitions |

---

## Philosophy

Discipline over convenience. Violations become structurally difficult rather than relying on willpower.

> "If you didn't watch the test fail, you don't know if it tests the right thing."

---

## License

Apache-2.0
