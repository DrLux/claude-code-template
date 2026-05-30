---
name: commit
description: Genera un commit message semantico dal diff e chiede conferma prima di eseguire.
             Usa quando l'utente vuole committare, preparare un commit, o vedere le modifiche staged.
disable-model-invocation: true
allowed-tools: Bash
---

Analizza l'output di `git diff --staged` (o `git diff HEAD` se nulla è in staging).

1. Identifica i cambiamenti logici raggruppandoli per tipo:
   - Nuove funzionalità (feat)
   - Bug fix (fix)
   - Refactoring (refactor)
   - Test (test)
   - Documentazione (docs)

2. Genera un commit message in formato Conventional Commits:
   `<type>(<scope>): <description>`
   Se i cambiamenti sono eterogenei, proponi commit multipli atomici.

3. Mostra il messaggio proposto e il diff rilevante, poi chiedi:
   "Vuoi procedere con questo commit? [s/N] — oppure modifica il messaggio:"

4. Esegui `git commit` SOLO dopo conferma esplicita.

Non eseguire mai `git push` in autonomia.
