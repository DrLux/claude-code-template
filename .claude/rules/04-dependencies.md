# Dependencies

## Package Manager
`uv` for environment and dependencies. All Python commands via `uv run`.
If you find `requirements.txt` or `Pipfile`, propose migration to `pyproject.toml` with `uv`.

Before declaring code ready, run `uv run ruff check` and verify there are no errors.

## Standard Toolchain
- Linting: `ruff` (unified format + lint)
- Type checking: `mypy` with `typeshed`, `strict = true`
- Testing: `pytest` + `pytest-asyncio`
- Build: `uv`, `Makefile` for complex commands
- Node: `pnpm`
- Docker for infrastructure services

## Adding Dependencies
```bash
uv add <package>           # runtime
uv add --dev <package>     # development only
```
No direct `pip install` — it breaks the lock file.

## Forbidden Dependencies
- `requests` → use `httpx` (async-native)
- built-in `json` for validation → use `pydantic`
- `argparse` for CLI → use `typer`
- raw `logging` → use the project logger (`src/core/log.py`)

## pyproject.toml
Configure mypy, ruff and pytest in `pyproject.toml`:
```toml
[tool.mypy]
python_version = "3.12"
strict = true
ignore_missing_imports = true

[tool.ruff]
line-length = 100
target-version = "py312"
```
