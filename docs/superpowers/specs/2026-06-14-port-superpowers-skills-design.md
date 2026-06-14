# Design: Port obra/superpowers Skills to super-bob

**Date:** 2026-06-14  
**Status:** Approved  
**Upstream source:** `/home/eranra/go/src/github.com/obra/superpowers` (v5.1.0)

## Problem

super-bob currently implements superpowers methodology by embedding full skill content inside `custom_modes.yaml` roleDefinitions. This approach has three problems:

1. Content drifts from upstream as skills evolve — maintenance requires 4 Python scripts
2. IBM Bob natively supports SKILL.md files (same format as upstream), making the fat-mode approach redundant
3. 7 of the 14 upstream skills have no slash command entry point in super-bob

## Goal

Port all 14 upstream skills into Bob's native SKILL.md format, slim the modes down to thin wrappers, add missing slash commands, and replace the Python maintenance scripts with a single shell sync script.

## Approach

Approach 2 (Bob-adapted copy): copy skills from upstream, apply targeted adaptations where Claude Code-specific tool names appear, and manually rewrite the 3 most Claude Code-specific skills for Bob.

## Repository Structure

```
super-bob/
├── skills/                              ← NEW
│   ├── brainstorming/SKILL.md
│   ├── dispatching-parallel-agents/SKILL.md
│   ├── executing-plans/SKILL.md
│   ├── finishing-a-development-branch/SKILL.md
│   ├── receiving-code-review/SKILL.md
│   ├── requesting-code-review/SKILL.md
│   ├── subagent-driven-development/SKILL.md
│   ├── systematic-debugging/SKILL.md
│   ├── test-driven-development/SKILL.md
│   ├── using-git-worktrees/SKILL.md
│   ├── using-superpowers/SKILL.md
│   ├── verification-before-completion/SKILL.md
│   ├── writing-plans/SKILL.md
│   └── writing-skills/SKILL.md
├── commands/                            ← 7 existing + 7 new slash commands
├── rules/                               ← UNCHANGED
│   └── superbob-workspace.md
├── custom_modes.yaml                    ← 14 thin wrappers (was 21 fat modes)
├── install.sh                           ← updated to install skills
├── sync-from-upstream.sh               ← NEW: replaces 4 Python scripts
└── docs/
```

**Deleted:** `update_modes.py`, `update_all_modes.py`, `update_tdd_mode.py`, `fix_remaining_modes.py`

## Skills: Adaptation Strategy

### 8 skills copied verbatim

No Claude Code-specific tool references; content applies directly to Bob:

- `brainstorming`
- `dispatching-parallel-agents`
- `receiving-code-review`
- `requesting-code-review`
- `systematic-debugging`
- `test-driven-development`
- `verification-before-completion`
- `writing-skills`

### 3 skills with minor TodoWrite patch

`TodoWrite` references replaced with "maintain a markdown checklist" / "track progress with checkboxes in the plan file":

- `executing-plans`
- `subagent-driven-development`
- `writing-plans`

The `sync-from-upstream.sh` script applies this patch automatically via `sed`.

### 3 skills manually rewritten for Bob

These live only in super-bob and are skipped by the sync script:

**`using-superpowers`**  
Upstream version bootstraps Claude Code by instructing the model to call the `Skill` tool. Bob auto-discovers skills in Advanced mode — no `Skill` tool exists. Rewrite as a reference card: lists all 14 skills with their trigger conditions and instructs Bob that when a task matches a skill's description it should activate that skill before responding. Session-start hook behaviour is replaced by Bob's built-in skill auto-discovery.

**`using-git-worktrees`**  
Upstream uses `EnterWorktree`/`ExitWorktree` native Claude Code tools. Bob has no such tools. Rewrite to use git CLI commands throughout: `git worktree add .claude/worktrees/<name> -b <branch>`, `git worktree remove`, `git worktree list`. Workflow logic (isolation, cleanup, verification) is preserved.

**`finishing-a-development-branch`**  
Upstream includes worktree cleanup steps using `ExitWorktree`. Remove those steps. Keep the full git/PR decision tree (merge locally, push PR, keep branch, discard) — Bob can run terminal commands for all of those.

## Modes: Thin Wrappers

`custom_modes.yaml` is reduced from 21 fat modes to 14 thin modes — one per skill.

Each mode:
- Sets a one-sentence persona/context in `roleDefinition`
- Instructs Bob to activate the corresponding skill
- Includes `skill` in `groups` so skills are available

The 7 extra Bob-specific modes dropped: `testing-anti-patterns`, `root-cause-tracing`, `condition-based-waiting`, `defense-in-depth`, `code-reviewer`, `testing-skills-with-subagents`, `sharing-skills`.

Example thin mode:

```yaml
- slug: test-driven-development
  name: Test-Driven Development
  roleDefinition: |
    You are a disciplined software engineer.
    Activate the test-driven-development skill and follow it exactly.
  whenToUse: Use when implementing any feature or bug fix.
  groups:
    - read
    - edit
    - command
    - skill
```

## Slash Commands

All 14 skills get a slash command. 7 exist already; 7 are new.

| Command | Skill | Status |
|---|---|---|
| `/brainstorm` | `brainstorming` | existing |
| `/debug` | `systematic-debugging` | existing |
| `/execute-plan` | `executing-plans` | existing |
| `/finish` | `finishing-a-development-branch` | existing |
| `/review` | `requesting-code-review` | existing |
| `/tdd` | `test-driven-development` | existing |
| `/write-plan` | `writing-plans` | existing |
| `/dispatch` | `dispatching-parallel-agents` | new |
| `/receive-review` | `receiving-code-review` | new |
| `/subagent` | `subagent-driven-development` | new |
| `/worktree` | `using-git-worktrees` | new |
| `/superpowers` | `using-superpowers` | new |
| `/verify` | `verification-before-completion` | new |
| `/write-skill` | `writing-skills` | new |

## Install Script

`install.sh` gains a skills installation step:

```bash
# Install skills to ~/.bob/skills/
for skill_dir in skills/*/; do
    skill_name=$(basename "$skill_dir")
    mkdir -p ~/.bob/skills/"$skill_name"
    cp "$skill_dir/SKILL.md" ~/.bob/skills/"$skill_name"/SKILL.md
done
```

The existing commands, modes, and rules installation steps are unchanged. The `--update` flag already handles overwrites and covers skills automatically.

## Sync Script

`sync-from-upstream.sh` replaces the 4 Python scripts. It:

1. Copies the 8 verbatim skills from upstream
2. Copies + patches the 3 TodoWrite skills via `sed`
3. Skips the 3 manually-rewritten skills and prints a reminder to review upstream changes to them manually
4. Runs `git diff --stat` to show what changed

The 3 manually-rewritten skills are never overwritten by the sync script.

## What Does Not Change

- `rules/superbob-workspace.md` — unchanged
- The 7 existing slash commands — unchanged (content and filenames)
- `docs/` structure — unchanged
- `tests/test_install.sh` — will need updates to cover skills, but that is out of scope for this design

## Out of Scope

- Updating `tests/test_install.sh` to cover skills installation (existing tests must still pass; they just won't exercise the new skills step)
- Adding supporting files (checklists, templates) alongside SKILL.md files
- Publishing to a Bob plugin marketplace
