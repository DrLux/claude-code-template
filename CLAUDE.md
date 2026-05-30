# Project: [NOME PROGETTO]

## Stack Tecnico
- Runtime: Python 3.12, uv
- Framework: [es. FastAPI]
- Database: [es. PostgreSQL via asyncpg]
- Testing: pytest + pytest-asyncio

## Workflow
- Usa sempre `uv run` per eseguire comandi Python nel virtualenv.
- Esegui `uv run ruff check` prima di dichiarare il codice pronto.
- Non modificare `src/core/config.py` senza leggere prima ARCHITECT.md.
- Non committare direttamente: usa `/commit`.

## Entry Points
- `src/main.py` — bootstrap
- `Makefile` — comandi di sviluppo
- `pyproject.toml` — dipendenze e config tool

## Invarianti Architetturali
1. [regola che non si rompe mai]
2. [altra invariante]

## Riferimento Architetturale
Per la mappa completa: `ARCHITECT.md`

## Gotchas
<!-- Sezione popolata automaticamente da Claude quando commette errori -->
<!-- Non modificare manualmente: Claude la aggiorna con la regola di auto-apprendimento -->

## Risorse
See @README.md for project overview.
