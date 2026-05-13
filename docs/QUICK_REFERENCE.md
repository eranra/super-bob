# SuperBob Quick Reference

**One-page cheat sheet for disciplined AI-assisted development**

---

## The 4 Core Principles

1. **Test First, Always** - Write failing tests before implementation (RED-GREEN-REFACTOR)
2. **Evidence Before Claims** - Never claim "done" without proof (passing tests, diffs, output)
3. **Root Cause Investigation** - No guessing; trace bugs to their source systematically
4. **Two-Stage Review** - Spec compliance first, then code quality

---

## Quick Start

```bash
# Install SuperBob
./install.sh

# Restart IBM Bob to load modes

# Start with a plan
/write-plan "Add user authentication"

# Execute with TDD
/tdd "Implement login endpoint"

# Request review
/review

# Finish and merge
/finish
```

---

## Slash Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/tdd` | Test-driven development | Any feature or bugfix |
| `/write-plan` | Create implementation plan | Multi-step tasks |
| `/execute-plan` | Execute existing plan | After plan approval |
| `/debug` | Systematic debugging | Any bug or test failure |
| `/brainstorm` | Design exploration | Before implementation |
| `/review` | Request code review | Before merging |
| `/finish` | Complete and merge | After review passes |

---

## Mode Selection Cheat Sheet

**Need to write code?** → Use `/tdd` (test-driven-development mode)

**Need to fix a bug?** → Use `/debug` (systematic-debugging mode)

**Need to plan work?** → Use `/write-plan` (writing-plans mode)

**Need to explore design?** → Use `/brainstorm` (brainstorming mode)

**Need code review?** → Use `/review` (requesting-code-review mode)

**Ready to merge?** → Use `/finish` (finishing-a-development-branch mode)

**Complex multi-step project?** → Use orchestrator mode

**Just have questions?** → Use ask mode

---

## TDD Cycle (RED-GREEN-REFACTOR)

```
1. RED: Write failing test
   ├─ Test must fail for the right reason
   ├─ Verify test output shows expected failure
   └─ Never skip this step

2. GREEN: Make test pass
   ├─ Write minimal code to pass
   ├─ Run test to verify it passes
   └─ Show passing test output

3. REFACTOR: Improve code
   ├─ Clean up implementation
   ├─ Tests still pass
   └─ Commit changes
```

**Anti-patterns to avoid:**
- ❌ Writing code before tests
- ❌ Claiming tests pass without output
- ❌ Skipping RED phase
- ❌ Writing multiple tests at once

---

## Debugging Framework

```
1. REPRODUCE
   ├─ Create minimal failing test
   ├─ Verify failure is consistent
   └─ Document exact error

2. ISOLATE
   ├─ Binary search the problem space
   ├─ Add logging/instrumentation
   └─ Narrow to specific component

3. TRACE
   ├─ Follow execution path backward
   ├─ Check assumptions at each step
   └─ Find where behavior diverges

4. FIX
   ├─ Write test for bug
   ├─ Implement fix
   └─ Verify all tests pass

5. PREVENT
   ├─ Add regression test
   ├─ Document root cause
   └─ Consider similar bugs
```

**Never:**
- ❌ Guess at solutions
- ❌ Make multiple changes at once
- ❌ Skip reproduction step
- ❌ Fix without understanding root cause

---

## Common Patterns

### Feature Implementation
```
1. /brainstorm "Design approach"
2. /write-plan "Break into tasks"
3. /tdd "Implement task 1"
4. /tdd "Implement task 2"
5. /review "Check work"
6. /finish "Merge to main"
```

### Bug Fix
```
1. /debug "Investigate issue"
2. Write failing test
3. /tdd "Fix with test"
4. /review "Verify fix"
5. /finish "Merge fix"
```

### Design Session
```
1. /brainstorm "Explore options"
2. Document decision
3. /write-plan "Implementation steps"
4. Execute plan with /tdd
```

---

## Red Flags (Stop and Fix)

**During Development:**
- 🚩 "Tests probably pass" (without running them)
- 🚩 "Should work" (without verification)
- 🚩 "Quick fix" (without tests)
- 🚩 Writing code before tests
- 🚩 Multiple changes without testing

**During Review:**
- 🚩 No tests for new code
- 🚩 Tests added after implementation
- 🚩 Incomplete test coverage
- 🚩 No verification output shown
- 🚩 "Trust me" without evidence

**During Debugging:**
- 🚩 Guessing at solutions
- 🚩 Changing multiple things at once
- 🚩 No reproduction case
- 🚩 Fixing symptoms, not root cause

---

## Troubleshooting

### "Bob won't follow TDD"
- Check you're using `/tdd` command
- Verify test-driven-development mode is active
- Review mode's "When to Use" section

### "Tests aren't running"
- Check test framework is installed
- Verify test file naming conventions
- Run tests manually to debug

### "Mode keeps switching"
- Some modes auto-switch (by design)
- Check mode's composition rules
- Use explicit mode commands

### "Review rejected my PR"
- Check all quality gates passed
- Verify evidence provided for claims
- Review CONTRIBUTING.md requirements

### "Can't find documentation"
- README.md - Workflows and getting started
- ARCHITECTURE.md - System design
- TESTING.md - Testing methodology
- examples/ - Real-world usage

---

## Quality Gates (Always Enforced)

1. **Auto-review after TDD** - Every TDD session triggers review
2. **Evidence before claims** - Must show proof (tests, diffs, output)
3. **TDD for all code** - No implementation without tests first
4. **Root cause investigation** - No guessing in debugging
5. **Two-stage review** - Spec compliance, then code quality

---

## Model Selection

**Use expensive models (Claude 3.5 Sonnet) for:**
- Complex debugging
- Architecture decisions
- Code review
- Planning

**Use cheap models (Claude 3.5 Haiku) for:**
- Simple edits
- Documentation
- Routine tasks
- Following plans

**Switch models mid-task if:**
- Stuck on complex problem
- Need deeper analysis
- Cost is becoming concern

---

## Next Steps

1. **Read the workflows** - README.md has 5 recommended workflows
2. **Try an example** - docs/examples/ has real-world scenarios
3. **Understand quality gates** - docs/ARCHITECTURE.md explains enforcement
4. **Learn testing** - docs/TESTING.md covers methodology
5. **Contribute** - CONTRIBUTING.md has PR requirements

---

**Remember: Discipline beats cleverness. Follow the process, trust the gates.**