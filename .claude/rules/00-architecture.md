# Planning Protocol

## Interview Phase (required before writing code)
Before writing a single line of code, answer these questions:

1. **Core Problem**: What is the main problem? (not the solution — the problem)
2. **Success Criteria**: Which tests must pass? What observable behavior?
3. **Non-Goals**: What should this implementation NOT touch?
4. **Impact**: Which existing files/modules will be affected?
5. **Logging Strategy**: Which events must be logged? At which level (DEBUG/INFO/WARNING/ERROR)? What context must each log entry carry to reconstruct the bug without a debugger?

## Logging Requirement

Every feature must include structured logging sufficient to reconstruct what happened when a bug occurs — without a debugger, without reproducing the issue.

**Mandatory log points:**
- Function entry/exit for non-trivial logic (DEBUG level)
- Every state transition and key decision point (DEBUG/INFO)
- All external I/O: HTTP calls, DB queries, filesystem ops (INFO + outcome)
- Every recoverable anomaly with full context (WARNING)
- Every failure with inputs, state, and stack trace (ERROR)

**Each log entry must carry:**
- Timestamp (ISO 8601)
- Correlation/trace ID (propagated across async boundaries)
- Function or module name
- Relevant input values (sanitized — no secrets/PII)
- Outcome or error message

**When planning a feature:** identify the log points as part of the implementation steps, not as a post-hoc addition. If a step can fail silently, it needs a log.

Use the project logger (`src/core/log.py`). Never use `print()` or raw `logging.getLogger()`.

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
