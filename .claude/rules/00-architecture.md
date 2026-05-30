# Planning Protocol

## Interview Phase (required before writing code)
Before writing a single line of code, answer these questions:

1. **Core Problem**: What is the main problem? (not the solution — the problem)
2. **Success Criteria**: Which tests must pass? What observable behavior?
3. **Non-Goals**: What should this implementation NOT touch?
4. **Impact**: Which existing files/modules will be affected?

## Verification Plan
- List implementation steps in order.
- For each step, specify how to verify it.
- Identify dependencies between steps.

## Then proceed
Only after alignment is confirmed, begin implementation.

## Dual Context Rule
For important architectural decisions: write the plan in one session,
then open a fresh session and ask for a staff engineer review without
implementation context. The fresh session has no bias and catches real gaps.
