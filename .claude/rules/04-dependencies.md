# Dependencies

## Package Manager
`uv` per environment e dipendenze. Tutti i comandi Python tramite `uv run`.
Se trovi `requirements.txt` o `Pipfile`, proponi migrazione a `pyproject.toml` con `uv`.

## Toolchain standard
- Linting: `ruff` (format + lint unificato)
- Type checking: `mypy` con `typeshed`, `strict = true`
- Testing: `pytest` + `pytest-asyncio`
- Build: `uv`, `Makefile` per comandi complessi
- Node: `pnpm`
- Docker per servizi infrastrutturali

## Aggiungere dipendenze
```bash
uv add <package>           # runtime
uv add --dev <package>     # development only
```
Niente `pip install` diretto — rompe il lock file.

## Dipendenze vietate
- `requests` → usa `httpx` (async-native)
- `json` built-in per validazione → usa `pydantic`
- `argparse` per CLI → usa `typer`
- `logging` raw → usa il project logger (`src/core/log.py`)

## pyproject.toml
Configura mypy, ruff e pytest in `pyproject.toml`:
```toml
[tool.mypy]
python_version = "3.12"
strict = true
ignore_missing_imports = true

[tool.ruff]
line-length = 100
target-version = "py312"
```
