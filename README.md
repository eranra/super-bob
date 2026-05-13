# SuperBob

Rigorous development discipline for [IBM Bob](https://bob.ibm.com/docs/ide).

21 skill-modes that enforce test-driven development, systematic debugging, and
automatic code review for the IBM Bob VS Code extension.

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

### What gets installed

| Source | Destination |
|---|---|
| `custom_modes.yaml` | `~/.bob/settings/custom_modes.yaml` |
| `commands/*.md` (7 files) | `~/.bob/commands/` |
| `rules/superbob-workspace.md` | `~/.bob/settings/rules/` |

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

## The 4 Principles

These are non-negotiable. SuperBob enforces them structurally:

1. **No code without a failing test first** — write the test, watch it fail, then implement
2. **No completion claims without fresh verification** — evidence before assertions
3. **Root cause investigation before fixes** — understand the problem before patching
4. **Review early and often** — automatic code review after task completion

---

## All 21 Modes

| Mode | When to use |
|---|---|
| `using-superpowers` | Start of any task — select the right skill |
| `test-driven-development` | Implementing any feature or bugfix |
| `testing-anti-patterns` | Reviewing or writing tests |
| `verification-before-completion` | Before claiming work is done |
| `condition-based-waiting` | Async operations, polling, event-driven flows |
| `defense-in-depth` | Error handling, validation, security layers |
| `receiving-code-review` | Processing code review feedback |
| `requesting-code-review` | Before merging — rigorous review |
| `systematic-debugging` | Any bug, test failure, unexpected behavior |
| `root-cause-tracing` | When a bug's origin is unclear |
| `dispatching-parallel-agents` | 2+ independent tasks that can run concurrently |
| `brainstorming` | Before any creative work |
| `writing-plans` | Multi-step tasks, before touching code |
| `executing-plans` | Executing a written plan |
| `subagent-driven-development` | Plans with independent tasks via subagents |
| `using-git-worktrees` | Feature work needing isolation |
| `finishing-a-development-branch` | Implementation complete, ready to integrate |
| `writing-skills` | Creating or editing Bob skill/mode definitions |
| `testing-skills-with-subagents` | Validating a new or modified skill works correctly |
| `sharing-skills` | Contributing a skill improvement upstream |
| `code-reviewer` | Structured review of completed work |

---

## Philosophy

Discipline over convenience. Violations become structurally difficult rather than relying on willpower.

> "If you didn't watch the test fail, you don't know if it tests the right thing."

---

## License

MPL-2.0
