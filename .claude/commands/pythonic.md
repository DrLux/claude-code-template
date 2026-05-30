---
name: pythonic
description: Transforms the indicated code into modern idiomatic Python
---

Apply these transformations in order:

1. **Complete type hints**: use union types with `|` (Python 3.10+), never `Optional[X]`.
2. **Modern structures**: `{}` vs `dict()`, f-string vs `.format()`.
3. **Pattern matching**: replace if/elif chains with `match/case` where appropriate.
4. **Comprehensions**: imperative loops → list/dict/set comprehension.
5. **Context managers**: resources (files, connections) always with `with`.
6. **Async/await**: if the code does I/O, propose the async version.

Show differences as a unified diff. Explain each non-obvious transformation.
