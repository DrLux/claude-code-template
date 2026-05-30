# Code Style

## Python Version
Python 3.12 with `uv`. Syntax 3.10+: `match/case`, union types with `|`, `TypeAlias`, `ParamSpec`.
Follow PEP 8 as the base standard for naming, indentation, and code organization.

## Type Hints
- Strict PEP 484/585/604. Never `Any` without a justifying comment.
- `Optional[X]` → `X | None`. `Union[A, B]` → `A | B`.
- pydantic v2 for data parsing and validation — never `dataclass` + manual validation.

## Async
All I/O is `async/await`. Exceptions must be explicitly motivated.

## Structures
- Prefer declarative over imperative.
- Immutability where possible; state mutation explicit and motivated.
- A class only if persistent internal state exists; otherwise pure functions and typed modules.
- `{}` vs `dict()`, f-string vs `.format()`.
- Comprehensions over imperative loops.
- Context managers for every resource (files, connections).

## Naming
- Snake case for functions and variables, PascalCase for classes.
- Descriptive names: `user_id` not `uid`, `create_invoice` not `make_inv`.
- `_` prefix for private, `__` for name-mangled.

## Comments
Zero comments for self-explanatory code. Comment only the non-obvious WHY:
hidden constraints, subtle invariants, workarounds for specific bugs.
