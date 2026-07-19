---
name: using-superpowers
description: Use when starting a task. Check for a relevant installed skill before responding, asking clarifying questions, or taking action.
---

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, invoke it first to check.

If a skill applies to the task, use it.
</EXTREMELY-IMPORTANT>

## How to Access Skills

Use your agent platform's supported skill mechanism. In Codex, invoke a skill explicitly with `$skill-name`, or allow Codex to select it from its description. In other environments, follow that platform's skill-loading documentation.

Do not manually reimplement a relevant skill's workflow instead of invoking it.

## Using Skills

### The Rule

Check for relevant or requested skills before any response or action. If an invoked skill turns out not to apply, continue without it.

```dot
digraph skill_flow {
    "User message received" [shape=doublecircle];
    "Might any skill apply?" [shape=diamond];
    "Invoke the skill" [shape=box];
    "Announce the skill and purpose" [shape=box];
    "Does it have a checklist?" [shape=diamond];
    "Create a task list when supported" [shape=box];
    "Follow the skill" [shape=box];
    "Respond" [shape=doublecircle];

    "User message received" -> "Might any skill apply?";
    "Might any skill apply?" -> "Invoke the skill" [label="yes, even 1%"];
    "Might any skill apply?" -> "Respond" [label="definitely not"];
    "Invoke the skill" -> "Announce the skill and purpose";
    "Announce the skill and purpose" -> "Does it have a checklist?";
    "Does it have a checklist?" -> "Create a task list when supported" [label="yes"];
    "Does it have a checklist?" -> "Follow the skill" [label="no"];
    "Create a task list when supported" -> "Follow the skill";
}
```

## Red Flags

These thoughts mean stop and check for a skill:

| Thought | Reality |
|---|---|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes before clarifying questions. |
| "Let me explore the codebase first" | Skills tell you how to explore. Check first. |
| "I can check files quickly" | Skills provide workflow context. Check first. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Load the current version. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |

## Skill Priority

When multiple skills could apply, use this order:

1. **Process skills first** (for example, brainstorming or debugging) - these determine how to approach the work
2. **Implementation skills second** - these guide execution

"Let's build X" -> brainstorming first, then an implementation skill.

## Skill Types

**Rigid** skills (for example, TDD or debugging) require their workflow to be followed exactly.

**Flexible** skills provide patterns to adapt to the task.

## User Instructions

User instructions define what to do, not whether to skip applicable workflows.
