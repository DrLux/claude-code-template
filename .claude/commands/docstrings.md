---
name: docstrings
description: Aggiunge docstring Google-style a funzioni e classi pubbliche del file
---

Aggiungi docstring in formato Google Style a tutte le funzioni, metodi e classi
pubbliche (non inizianti con `_`) nel file corrente o specificato.

- Prima riga: descrizione concisa (non ripetere il nome della funzione).
- `Args:` con tipo e descrizione (ometti `self`/`cls`).
- `Returns:` tipo e descrizione del valore di ritorno.
- `Raises:` eccezioni che possono essere sollevate.
- `Example:` opzionale, solo per funzioni non ovvie.

Non modificare la logica. Non documentare metodi privati, dunder methods
o proprietà ovvie.
