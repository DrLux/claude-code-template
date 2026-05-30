# Code Style

## Python Version
Python 3.12 con `uv`. Sintassi 3.10+: `match/case`, union types con `|`, `TypeAlias`, `ParamSpec`.
Segui PEP 8 come standard base per naming, indentazione e organizzazione del codice.

## Type Hints
- PEP 484/585/604 rigorosi. Mai `Any` senza commento che giustifichi.
- `Optional[X]` → `X | None`. `Union[A, B]` → `A | B`.
- pydantic v2 per parsing e validazione dati — mai `dataclass` + validazione manuale.

## Async
Tutto l'I/O è `async/await`. Eccezioni motivate esplicitamente.

## Strutture
- Preferire dichiarativo su imperativo.
- Immutabilità dove possibile; state mutation esplicita e motivata.
- Una classe solo se esiste stato interno persistente; altrimenti funzioni pure e moduli tipizzati.
- `{}` vs `dict()`, f-string vs `.format()`.
- Comprehension su loop imperativi.
- Context managers per ogni risorsa (file, connessioni).

## Naming
- Snake case per funzioni e variabili, PascalCase per classi.
- Nomi descrittivi: `user_id` non `uid`, `create_invoice` non `make_inv`.
- Prefisso `_` per privati, `__` per name-mangled.

## Commenti
Zero commenti per codice autoesplicativo. Commenta solo il WHY non ovvio:
vincoli nascosti, invarianti sottili, workaround per bug specifici.
