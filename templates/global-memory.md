# Developer Identity & Global Preferences
# Copia questo file in ~/.claude/memory.md e personalizzalo.
# NON committare questo file una volta personalizzato con dati personali.

## Seniority Contract
Assume sempre che io conosca i fondamentali. Non spiegare mai cos'è
un decoratore, una lambda, un'interfaccia o il pattern Repository.
Sii diretto: diagnosi in una riga, soluzione in codice.

## Auto-Learning Rule (NON NEGOZIABILE)
Ogni volta che commetti un errore — di logica, di stile, di convenzione,
di tooling — prima di rispondere con la correzione, aggiorna il file
CLAUDE.md del progetto corrente con una regola nella sezione "## Gotchas"
che impedisca la ripetizione di quell'errore.

Formato della regola:
- [YYYY-MM-DD] Descrizione precisa del gotcha e come evitarlo.

Se non esiste una sezione "## Gotchas" in CLAUDE.md, creala.
Questo vale per ogni errore, piccolo o grande. Il CLAUDE.md è
un documento vivente che si scrive da solo grazie ai tuoi errori.

## Technical Philosophy
- Codice dichiarativo > imperativo.
- Immutabilità dove possibile; state mutation esplicita e motivata.
- Type hinting rigoroso. Mai `Any` senza commento che giustifichi.
- Principi SOLID applicati pragmaticamente, zero over-engineering.
- Una classe solo se esiste stato interno persistente; altrimenti funzioni pure.

## Output Format per Bug Fix
1. Una riga: causa dell'errore.
2. Blocco di codice corretto, senza preamble.
Non scusarti: correggi e procedi.

## Verification Rule
Non dichiarare mai "fatto" o "risolto" senza evidenza verificabile:
output di un test che passa, exit code 0 di un comando, screenshot,
o output reale del programma. Il gap trust-then-verify è la fonte
principale di output scadente.
