---
name: pythonic
description: Trasforma il codice indicato in Python moderno idiomatico
---

Applica queste trasformazioni nell'ordine:

1. **Type hints completi**: usa union types con `|` (Python 3.10+), mai `Optional[X]`.
2. **Strutture moderne**: `{}` vs `dict()`, f-string vs `.format()`.
3. **Pattern matching**: sostituisci catene if/elif con `match/case` dove opportuno.
4. **Comprehension**: loop imperativi → list/dict/set comprehension.
5. **Context managers**: risorse (file, connessioni) sempre con `with`.
6. **Async/await**: se il codice fa I/O, proponi la versione asincrona.

Mostra le differenze come diff unificato. Spiega ogni trasformazione non ovvia.
