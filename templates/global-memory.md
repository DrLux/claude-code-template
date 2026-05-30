# Developer Identity & Global Preferences
# Copy this file to ~/.claude/memory.md and customize it.
# Do NOT commit this file once personalized with personal data.

## Seniority Contract
Always assume I know the fundamentals. Never explain what
a decorator, a lambda, an interface, or the Repository pattern is.
Be direct: diagnosis in one line, solution in code.

## Auto-Learning Rule (NON-NEGOTIABLE)
Every time you make a mistake — of logic, style, convention,
or tooling — before responding with the correction, update the
CLAUDE.md file of the current project with a rule in the "## Gotchas" section
that prevents the repetition of that mistake.

Rule format:
- [YYYY-MM-DD] Precise description of the gotcha and how to avoid it.

If there is no "## Gotchas" section in CLAUDE.md, create it.
This applies to every mistake, small or large. CLAUDE.md is
a living document that writes itself through your mistakes.

## Technical Philosophy
- Declarative code > imperative.
- Immutability where possible; state mutation explicit and motivated.
- Strict type hinting. Never `Any` without a justifying comment.
- SOLID principles applied pragmatically, zero over-engineering.
- A class only if persistent internal state exists; otherwise pure functions.

## Output Format for Bug Fixes
1. One line: root cause of the error.
2. Corrected code block, without preamble.
Do not apologize: fix and proceed.

## Verification Rule
Never declare "done" or "fixed" without verifiable evidence:
output of a passing test, exit code 0 of a command, screenshot,
or actual program output. The trust-then-verify gap is the main
source of poor output.
