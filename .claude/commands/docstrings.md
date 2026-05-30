---
name: docstrings
description: Adds Google-style docstrings to public functions and classes in the file
---

Add docstrings in Google Style format to all public functions, methods and classes
(not starting with `_`) in the current or specified file.

- First line: concise description (do not repeat the function name).
- `Args:` with type and description (omit `self`/`cls`).
- `Returns:` type and description of the return value.
- `Raises:` exceptions that may be raised.
- `Example:` optional, only for non-obvious functions.

Do not modify the logic. Do not document private methods, dunder methods
or obvious properties.
