---
name: using-superpowers
description: Use when starting any conversation - establishes how to find and use skills, requiring skill activation before ANY response including clarifying questions
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, skip this skill.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST activate the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. This is not optional. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

## Instruction Priority

Superpowers skills override default system prompt behavior, but **user instructions always take precedence**:

1. **User's explicit instructions** (AGENTS.md, direct requests) — highest priority
2. **Superpowers skills** — override default system behavior where they conflict
3. **Default system prompt** — lowest priority

If AGENTS.md says "don't use TDD" and a skill says "always use TDD," follow the user's instructions. The user is in control.

## How to Access Skills in IBM Bob

Skills activate in **Advanced mode**. Bob will suggest relevant skills automatically based on your task description.

**To activate a skill:**
- Switch to the corresponding mode (e.g., switch to "Test-Driven Development" mode)
- Use the slash command (e.g., `/tdd`)
- Accept Bob's skill suggestion when prompted
- Enable **Settings → Auto-Approve → Skills** to skip the approval prompt

**Available skills and their commands:**

| Skill | Command | When to use |
|---|---|---|
| `using-superpowers` | `/superpowers` | Starting any conversation |
| `brainstorming` | `/brainstorm` | Before any new feature or modification |
| `test-driven-development` | `/tdd` | Implementing features or bug fixes |
| `systematic-debugging` | `/debug` | Any bug, failure, or unexpected behavior |
| `writing-plans` | `/write-plan` | Planning a multi-step task |
| `executing-plans` | `/execute-plan` | Executing a written plan |
| `requesting-code-review` | `/review` | Completing tasks, before merging |
| `receiving-code-review` | `/receive-review` | Processing review feedback |
| `subagent-driven-development` | `/subagent` | Executing plans with per-task agents |
| `dispatching-parallel-agents` | `/dispatch` | 2+ independent tasks in parallel |
| `using-git-worktrees` | `/worktree` | Isolating feature work |
| `finishing-a-development-branch` | `/finish` | Completing a development branch |
| `verification-before-completion` | `/verify` | Before claiming work is done |
| `writing-skills` | `/write-skill` | Creating or editing skills |

# Using Skills

## The Rule

**Activate the relevant skill BEFORE any response or action.** Even a 1% chance a skill might apply means you should activate it. If an activated skill turns out to be wrong for the situation, you don't need to use it.

```dot
digraph skill_flow {
    "User message received" [shape=doublecircle];
    "About to plan implementation?" [shape=doublecircle];
    "Already brainstormed?" [shape=diamond];
    "Activate brainstorming skill" [shape=box];
    "Might any skill apply?" [shape=diamond];
    "Switch to skill mode or accept Bob suggestion" [shape=box];
    "Announce: 'Using [skill] to [purpose]'" [shape=box];
    "Has checklist?" [shape=diamond];
    "Create a markdown checklist per item" [shape=box];
    "Follow skill exactly" [shape=box];
    "Respond (including clarifications)" [shape=doublecircle];

    "About to plan implementation?" -> "Already brainstormed?";
    "Already brainstormed?" -> "Activate brainstorming skill" [label="no"];
    "Already brainstormed?" -> "Might any skill apply?" [label="yes"];
    "Activate brainstorming skill" -> "Might any skill apply?";

    "User message received" -> "Might any skill apply?";
    "Might any skill apply?" -> "Switch to skill mode or accept Bob suggestion" [label="yes, even 1%"];
    "Might any skill apply?" -> "Respond (including clarifications)" [label="definitely not"];
    "Switch to skill mode or accept Bob suggestion" -> "Announce: 'Using [skill] to [purpose]'";
    "Announce: 'Using [skill] to [purpose]'" -> "Has checklist?";
    "Has checklist?" -> "Create a markdown checklist per item" [label="yes"];
    "Has checklist?" -> "Follow skill exactly" [label="no"];
    "Create a markdown checklist per item" -> "Follow skill exactly";
}
```

## Red Flags

These thoughts mean STOP—you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can check git/files quickly" | Files lack conversation context. Check for skills. |
| "Let me gather information first" | Skills tell you HOW to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept ≠ using the skill. Invoke it. |

## Skill Priority

When multiple skills could apply, use this order:

1. **Process skills first** (brainstorming, debugging) — determine HOW to approach the task
2. **Implementation skills second** — guide execution

"Let's build X" → brainstorming first, then implementation skills.
"Fix this bug" → debugging first, then domain-specific skills.

## Skill Types

**Rigid** (TDD, debugging): Follow exactly. Don't adapt away discipline.

**Flexible** (patterns): Adapt principles to context.

The skill itself tells you which.

## User Instructions

Instructions say WHAT, not HOW. "Add X" or "Fix Y" doesn't mean skip workflows.
