# Enhance SuperBob with Superpowers Patterns Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use [executing-plans] mode to implement this plan task-by-task.

**Goal:** Enhance super-bob by adopting proven verification patterns, quality gates, and documentation from the superpowers project to prevent common mistakes and maintain discipline.

**Architecture:** Update existing 21 skill-modes in custom_modes.yaml, enhance documentation in docs/, improve contributor guidelines in CONTRIBUTING.md, and add comprehensive testing methodology documentation.

**Tech Stack:** YAML (mode definitions), Markdown (documentation), Bash (installation scripts)

---

## Overview of Enhancements

This plan implements 12 major enhancements to super-bob:

1. **Stricter verification patterns** - Evidence-before-claims enforcement
2. **Two-stage review process** - Spec compliance + code quality
3. **Rationalization prevention** - Tables to catch common excuses
4. **Clear mode selection** - Unambiguous "when to use" criteria
5. **Model selection guidance** - Cost optimization strategies
6. **Testing methodology** - Comprehensive testing documentation
7. **Stricter PR requirements** - Quality gates for contributions
8. **Workflow documentation** - Clear paths from idea to production
9. **Quality gates** - Structural enforcement mechanisms
10. **Real-world examples** - Practical usage scenarios
11. **Installation verification** - Ensure correct setup
12. **Quick reference** - One-page cheat sheet

---

## Task 1: Enhance verification-before-completion Mode

**Goal:** Add stricter red flags and evidence requirements from superpowers

**Files:**
- Modify: `custom_modes.yaml:verification-before-completion` section

**Steps:**

1. Locate mode definition:
   ```bash
   grep -n "slug: verification-before-completion" custom_modes.yaml
   ```

2. Read current mode (use line range from grep)

3. Add comprehensive red flags table:
   ```markdown
   ## Red Flags - Evidence Required
   
   | Claim | Required Evidence |
   |-------|------------------|
   | "Tests pass" | `npm test` output from THIS run |
   | "I fixed it" | Verification command output |
   | "It works now" | Run it and show output |
   | "Build succeeds" | `npm run build` output |
   | "Linter passes" | `npm run lint` output |
   | "I verified it" | Show what you ran and output |
   ```

4. Add evidence-before-claims section:
   ```markdown
   ## Evidence Requirements (Non-Negotiable)
   
   BEFORE claiming completion, you MUST show:
   - Fresh command output (not cached)
   - Actual terminal output (copy-paste)
   - All verification steps documented
   - No "I verified it" without proof
   ```

5. Apply changes with apply_diff

6. Verify YAML syntax:
   ```bash
   python3 -c "import yaml; yaml.safe_load(open('custom_modes.yaml'))"
   ```

7. Commit:
   ```bash
   git add custom_modes.yaml
   git commit -m "Enhance verification-before-completion with stricter red flags"
   ```

---

## Task 2: Add Two-Stage Review to subagent-driven-development

**Goal:** Implement spec compliance + code quality review stages

**Files:**
- Modify: `custom_modes.yaml:subagent-driven-development` section

**Steps:**

1. Locate mode definition

2. Add two-stage review pattern:
   ```markdown
   ## Two-Stage Review Pattern
   
   After each task:
   
   ### Stage 1: Spec Compliance
   - Does implementation match plan?
   - Are requirements met?
   - Any gaps or deviations?
   
   ### Stage 2: Code Quality
   - Tests comprehensive?
   - Code maintainable?
   - Security issues?
   - Follows patterns?
   ```

3. Add review checkpoint enforcement

4. Apply changes with apply_diff

5. Verify YAML syntax

6. Commit changes

---

## Task 3: Add Rationalization Prevention Tables

**Goal:** Add tables to catch common excuses in TDD, debugging, and brainstorming modes

**Files:**
- Modify: `custom_modes.yaml` (3 modes)

**Steps:**

1. Add to test-driven-development:
   ```markdown
   ## Rationalization Prevention
   
   | Thought | Reality | Action |
   |---------|---------|--------|
   | "This is simple, skip TDD" | Simple becomes complex | Write test first |
   | "Just this once" | Once becomes always | Follow discipline |
   | "I'll add tests later" | Later never comes | Test now |
   ```

2. Add to systematic-debugging:
   ```markdown
   | Thought | Reality | Action |
   |---------|---------|--------|
   | "I know what's wrong" | Assumptions cause bugs | Investigate first |
   | "Quick fix" | Creates tech debt | Find root cause |
   ```

3. Add to brainstorming:
   ```markdown
   | Thought | Reality | Action |
   |---------|---------|--------|
   | "Skip design, start coding" | Creates mess | Design first |
   | "Figure it out as I go" | Leads to rewrites | Plan approach |
   ```

4. Apply all changes

5. Verify YAML syntax

6. Commit changes

---

## Task 4: Enhance "When to Use" Criteria

**Goal:** Make mode selection unambiguous for all 21 modes

**Files:**
- Modify: `custom_modes.yaml` (all modes)

**Steps:**

1. Create template:
   ```markdown
   ## When to Use
   
   **Always use when:**
   - [Specific trigger 1]
   - [Specific trigger 2]
   
   **Never use when:**
   - [Anti-pattern 1]
   - [Anti-pattern 2]
   
   **If unsure:**
   - [Default guidance]
   ```

2. Apply to each mode with mode-specific criteria

3. Verify YAML syntax

4. Commit changes

---

## Task 5: Add Model Selection Guidance

**Goal:** Help users optimize costs while maintaining quality

**Files:**
- Modify: `docs/ARCHITECTURE.md`

**Steps:**

1. Add section after "Technical Details":
   ```markdown
   ## Model Selection Guidance
   
   ### Expensive Models (GPT-4, Claude Opus)
   - Architectural decisions
   - Security reviews
   - Complex debugging
   - Design refinement
   
   ### Cheap Models (GPT-3.5, Claude Haiku)
   - Executing plans
   - Implementing specs
   - Running tests
   - Simple refactoring
   ```

2. Insert using insert_content

3. Verify markdown formatting

4. Commit changes

---

## Task 6: Create Testing Methodology Documentation

**Goal:** Comprehensive guide for testing SuperBob modes

**Files:**
- Create: `docs/TESTING.md`

**Steps:**

1. Create file with sections:
   - Manual testing process
   - Mode interaction testing
   - Red-green-refactor validation
   - Anti-rationalization testing
   - Subagent testing approach
   - Regression testing checklist

2. Write comprehensive content (~400 lines)

3. Verify file created

4. Commit changes

---

## Task 7: Enhance CONTRIBUTING.md with PR Requirements

**Goal:** Add strict quality gates for all contributions

**Files:**
- Modify: `CONTRIBUTING.md`

**Steps:**

1. Add after "Pull Request Process":
   ```markdown
   ## Pull Request Quality Gates
   
   Every PR MUST include:
   - Evidence of testing
   - Evidence of verification
   - Code review compliance
   - Documentation updates
   - Discipline enforcement
   ```

2. Add reviewer checklist

3. Add red flags section

4. Add good/bad PR examples

5. Insert using insert_content

6. Verify markdown formatting

7. Commit changes

---

## Task 8: Enhance README.md with Workflows

**Goal:** Document 5 recommended workflows with decision tree

**Files:**
- Modify: `README.md`

**Steps:**

1. Add after "The 4 Principles":
   - Workflow 1: Feature Implementation (Full Cycle)
   - Workflow 2: Quick Feature (Direct TDD)
   - Workflow 3: Bug Investigation
   - Workflow 4: Design Exploration
   - Workflow 5: Code Review Only

2. Add decision tree for workflow selection

3. Add anti-patterns to avoid

4. Insert using insert_content

5. Verify markdown formatting

6. Commit changes

---

## Task 9: Add Quality Gates Documentation

**Goal:** Document structural enforcement mechanisms

**Files:**
- Modify: `docs/ARCHITECTURE.md`

**Steps:**

1. Add section on quality gates:
   - Structural vs behavioral enforcement
   - All 5 quality gates in SuperBob
   - Comparison with superpowers
   - Red flag detection
   - Effectiveness metrics

2. Insert using insert_content

3. Verify markdown formatting

4. Commit changes

---

## Task 10: Create Real-World Examples

**Goal:** Provide practical usage scenarios

**Files:**
- Create: `docs/examples/feature-implementation.md`
- Create: `docs/examples/bug-fix.md`
- Create: `docs/examples/design-session.md`

**Steps:**

1. Create examples directory

2. Write feature implementation example (auth system)

3. Write bug fix example (systematic debugging)

4. Write design session example (brainstorming)

5. Verify files created

6. Commit changes

---

## Task 11: Update Installation Script

**Goal:** Add verification to ensure correct installation

**Files:**
- Modify: `install.sh`

**Steps:**

1. Add verification after installation:
   - Check custom_modes.yaml exists and valid
   - Check all 7 commands installed
   - Check workspace rules installed

2. Add clear next steps

3. Apply changes with apply_diff

4. Test with --dry-run

5. Commit changes

---

## Task 12: Create Quick Reference Card

**Goal:** One-page cheat sheet for SuperBob

**Files:**
- Create: `docs/QUICK_REFERENCE.md`

**Steps:**

1. Create file with sections:
   - The 4 Principles
   - Quick start
   - Slash commands
   - Mode selection cheat sheet
   - TDD cycle
   - Debugging framework
   - Common patterns
   - Red flags
   - Troubleshooting

2. Keep to one page (~200 lines)

3. Verify file created

4. Commit changes

---

## Execution Strategy

**Recommended approach:**

1. Execute tasks sequentially (1-12)
2. Use [test-driven-development] for any code changes
3. Use [verification-before-completion] before marking tasks done
4. Commit after each task completes
5. Run full verification after all tasks complete

**Verification after completion:**

```bash
# Verify YAML syntax
python3 -c "import yaml; yaml.safe_load(open('custom_modes.yaml'))"

# Verify all docs exist
ls -lh docs/TESTING.md docs/QUICK_REFERENCE.md docs/examples/

# Verify markdown formatting
for file in docs/*.md; do
  echo "Checking $file..."
  grep -n "^#" "$file" | head -5
done

# Test installation script
./install.sh --dry-run
```

**Success criteria:**

- All 12 tasks completed
- All files committed
- YAML syntax valid
- Documentation complete
- Examples provided
- Installation verified

---

## Summary

This plan enhances super-bob with proven patterns from superpowers:

✅ Stricter verification (evidence-before-claims)
✅ Two-stage review (spec + quality)
✅ Rationalization prevention (catch excuses)
✅ Clear mode selection (unambiguous criteria)
✅ Model selection guidance (cost optimization)
✅ Testing methodology (comprehensive guide)
✅ Stricter PR requirements (quality gates)
✅ Workflow documentation (5 workflows + decision tree)
✅ Quality gates (structural enforcement)
✅ Real-world examples (practical scenarios)
✅ Installation verification (ensure correct setup)
✅ Quick reference (one-page cheat sheet)

**Estimated effort:** 6-8 hours total (30-45 min per task)

**Impact:** Significantly improved discipline enforcement and contributor experience