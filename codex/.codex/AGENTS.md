# Personal Development Guidelines

## Working Style

- Explain context and reasoning before jumping into code
- When reviewing PRs, use structured tables for comments and update as we iterate
- Ask clarifying questions rather than making assumptions
- Discuss each item individually when working through a list

## Git & Repo Structure

## Available MCP Tools

- You have access to ALL of the following tools via MCP. Never say "I don't have access" — use ToolSearch to load any of these:

## Code Analysis And Verification Guidelines

### Always Verify Before Implementing

- **NEVER** guess file contents, structure, or method signatures
- **ALWAYS** read actual file contents for verification
- Before calling any method or function, verify that it exists in the target file or class

### Documentation And Best Practices Lookup

## Code Quality Standards

### Architecture Principles

Write modular code that follows **SOLID principles**:

- **S**ingle Responsibility: each class or function has one reason to change
- **O**pen-Closed: open to extension, closed to modification
- **L**iskov Substitution: subtypes must be substitutable for base types
- **I**nterface Segregation: clients should not depend on unused interfaces
- **D**ependency Inversion: depend on abstractions, not concretions

### Abstractions

- Prefer small composable helpers over duplicated branching logic
- Preserve existing local patterns before introducing a new abstraction
- Introduce a new abstraction only when the boundary is already clear or multiple concrete call sites need it
- Avoid speculative abstractions that only serve one path today

### Code Clarity

- Prioritize clear and self-documenting code
- Preserve builder patterns, mock reuse, and consistent naming conventions
- Test values should match their source equivalents — don't invent new test data when existing values exist

### Comments

- Write comments for business rules, invariants, partner quirks, non-obvious constraints, and workarounds
- Do not remove existing comments unless they are incorrect, obsolete, or you are explicitly changing the documented behavior
- Keep comments short and factual
- Prefer comments that explain why the code exists or why a choice was made
- Add brief comments for short-circuit branches when they help reviewers understand why the early return or guard exists
- Do not add comments that merely restate the code
- Do not comment obvious control flow, variable assignments, or code that is already self-explanatory
- When porting code (e.g. v1 → v2), maintain comment parity with the original

## Testing Requirements

Every behavior change must include tests. Use judgement: config changes, typo fixes, and one-line tweaks don't need dedicated tests.

### Test Coverage

- Update existing tests for modified behavior
- Add new tests for positive paths, negative paths, and relevant edge cases
- For bug fixes, write a regression test that reproduces the issue

### Test-First Discipline

1. Identify the relevant existing tests before modifying code.
2. If no tests exist, create them.
3. Run the existing tests first when practical.
4. Write the new tests for your change.
5. Run all relevant tests and confirm they pass.

## Quality Checklist

Before completion, confirm:

1. Tests exist for behavior changes.
2. Relevant tests pass.
3. Formatting, linting, and type checks have been run on modified files.
4. The change matches the original request.

## Command Reference

| Task               | Command                                    |
| ------------------ | ------------------------------------------ |