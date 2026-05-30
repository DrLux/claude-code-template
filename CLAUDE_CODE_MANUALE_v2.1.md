# 📘 CLAUDE CODE — MANUALE DI CONFIGURAZIONE DETERMINISTICA
### *Ingegneria Python Senior: setup, automazione e governance dell'agente AI*

> **Versione 2.1** — Integrazione con best practice dal team Anthropic (Boris Cherny, Cat Wu).
> Skills come struttura primaria, parallel sessions, `/goal`, `/rewind`, e loop di auto-apprendimento.

---

## MAPPA CONCETTUALE DEL SISTEMA

Prima di toccare la tastiera, comprendi il modello mentale. Il sistema ha **tre piani di controllo**:

```
┌─────────────────────────────────────────────────────────────────────┐
│  PIANO 1: ADVISORY (Claude lo legge, può interpretarlo con flessibilità) │
│                                                                       │
│   ~/.claude/memory.md        → identità globale del developer         │
│   CLAUDE.md / CLAUDE.local.md → contratto di progetto (team + personale) │
│   ARCHITECT.md               → mappa architetturale live              │
│   .claudememory              → soul del progetto (caricato via hook)  │
│   .claude/rules/*.md         → regole tematiche path-gated            │
└───────────────────────────┬─────────────────────────────────────────┘
                            │ advisory
┌───────────────────────────▼─────────────────────────────────────────┐
│  PIANO 2: DETERMINISTIC (hook — Claude NON può aggirarli)            │
│                                                                       │
│   PostToolUse  → ruff + mypy per ogni file scritto                   │
│   PostToolBatch → verifica coerenza tra file nel batch               │
│   Stop         → pytest + aggiornamento docs + commit assistito      │
│   SessionStart → idratazione contesto, caricamento .claudememory     │
│   PreToolUse   → security gate (blocco azioni distruttive)           │
└───────────────────────────┬─────────────────────────────────────────┘
                            │ deterministic
┌───────────────────────────▼─────────────────────────────────────────┐
│  PIANO 3: ON-DEMAND (skills, slash commands e agenti)                │
│                                                                       │
│   /commit      → genera commit message e chiede conferma umana       │
│   /architect   → riscansiona e rigenera ARCHITECT.md completo        │
│   /pythonic    → trasforma il codice scritto in stile idiomatico     │
│   /docstrings  → aggiunge docstring su richiesta esplicita           │
│   /goal        → imposta condizione di completamento: Claude itera   │
│                  finché la condizione non è vera                      │
└─────────────────────────────────────────────────────────────────────┘
```

**Regola fondamentale**: tutto ciò che deve *garantire* l'esecuzione (linting, testing, commit)
va negli hook. Tutto ciò che richiede *giudizio* (aggiornamento architetturale, refactoring
stilistico) va nei comandi on-demand. Il CLAUDE.md è un contratto, non una garanzia.

**Principio di auto-apprendimento** (da Boris Cherny, Anthropic): ogni volta che Claude
commette un errore, aggiungi al tuo prompt:
> *"Aggiorna CLAUDE.md in modo da non ripetere questo errore."*

Boris descrive Claude come "stranamente bravo a scrivere regole per se stesso partendo
dai propri errori." Questo habit, eseguito sistematicamente, è quello che compounds
più di qualsiasi altra pratica in questa guida. Il tuo CLAUDE.md diventa nel tempo
una lista curata di ogni gotcha del progetto — scritta da Claude stesso. La sezione
specifica è automatizzata tramite l'hook `PostToolUse` (Capitolo 4) e la regola
globale in `~/.claude/memory.md` (Capitolo 2).

---

## CAPITOLO 1 — INIZIALIZZAZIONE DELLA STRUTTURA

Ogni directory e file creato qui corrisponde a qualcosa di concreto nei capitoli successivi.
Niente scaffolding speculativo.

```bash
# 1. Git repository — prerequisito per hook, diff e commit assistito
git init

# 2. Directory Claude Code
mkdir -p .claude/hooks      # script shell eseguiti dagli hook (Cap. 4)
mkdir -p .claude/skills     # skills (nuovo standard — Cap. 3)
mkdir -p .claude/commands   # slash commands semplici /commit /architect etc. (Cap. 3)
mkdir -p .claude/rules      # istruzioni di progetto per categoria (Cap. 2)
mkdir -p .claude/agents     # agenti specializzati code-reviewer, test-writer (Cap. 5)

# 3. File radice
touch CLAUDE.md             # manifesto di progetto condiviso col team, < 1500 token (Cap. 2)
touch CLAUDE.local.md       # note personali e PR feedback — mai committato (Cap. 2)
touch ARCHITECT.md          # mappa architetturale, generata da /architect (Cap. 3)
touch .claudememory         # project soul, caricato da hook SessionStart (Cap. 2)

# 4. Configurazione hook
touch .claude/settings.json

# 5. Crea gli script hook vuoti e rendili subito eseguibili
touch .claude/hooks/session-start.sh
touch .claude/hooks/pre-tool-security.sh
touch .claude/hooks/post-tool-lint.sh
touch .claude/hooks/post-batch-check.sh
touch .claude/hooks/stop-quality-gate.sh
chmod +x .claude/hooks/*.sh

# 6. Crea le rules tematiche vuote (Cap. 2)
touch .claude/rules/00-architecture.md
touch .claude/rules/01-code-style.md
touch .claude/rules/02-testing.md
touch .claude/rules/03-git.md
touch .claude/rules/04-dependencies.md

# 7. Crea gli agenti vuoti (Cap. 5)
touch .claude/agents/code-reviewer.md
touch .claude/agents/test-writer.md

# 8. Crea i comandi vuoti (Cap. 3)
touch .claude/commands/commit.md
touch .claude/commands/architect.md
touch .claude/commands/pythonic.md
touch .claude/commands/docstrings.md
touch .claude/commands/memory-update.md

# 9. Crea skill di esempio (struttura skills — Cap. 3)
mkdir -p .claude/skills/summarize-changes

# 10. Gitignore — file personali e dinamici fuori dal repo
cat >> .gitignore << 'EOF'
.claudememory
CLAUDE.local.md
.claude/settings.local.json
EOF
```

Al termine, la struttura è:

```
.
├── .claude/
│   ├── settings.json           ← configurazione hook
│   ├── hooks/
│   │   ├── session-start.sh
│   │   ├── pre-tool-security.sh
│   │   ├── post-tool-lint.sh
│   │   ├── post-batch-check.sh
│   │   └── stop-quality-gate.sh
│   ├── skills/                 ← NUOVO: standard moderno per comandi riutilizzabili
│   │   └── summarize-changes/
│   │       └── SKILL.md
│   ├── commands/               ← comandi semplici single-file (legacy compatibili)
│   │   ├── commit.md
│   │   ├── architect.md
│   │   ├── pythonic.md
│   │   ├── docstrings.md
│   │   └── memory-update.md
│   ├── rules/
│   │   ├── 00-architecture.md
│   │   ├── 01-code-style.md
│   │   ├── 02-testing.md
│   │   ├── 03-git.md
│   │   └── 04-dependencies.md
│   └── agents/
│       ├── code-reviewer.md
│       └── test-writer.md
├── CLAUDE.md                   ← committato, condiviso col team
├── CLAUDE.local.md             ← gitignored, note personali
├── ARCHITECT.md
└── .claudememory               ← gitignored
```

### Gerarchia di precedenza dei file di configurazione

```
~/.claude/settings.json              (globale — tutti i progetti)
    └── .claude/settings.json        (progetto — committato, condiviso col team)
            └── .claude/settings.local.json  (locale — gitignored, override personali)
```

I livelli vengono *mergiati*, non sovrascritti. Le impostazioni più vicine al progetto
hanno precedenza.

---

## CAPITOLO 2 — MEMORIA MULTI-LIVELLO

La memoria in Claude Code ha cinque strati con caratteristiche molto diverse.

### 2.1 Developer Identity — `~/.claude/memory.md`

Profilo globale del developer. Si applica a **qualsiasi progetto** su questa macchina.

> ⚠️ **Contiene la regola di auto-apprendimento globale**: ogni volta che Claude sbaglia
> in qualsiasi progetto, sa già autonomamente che deve aggiornarsi. Non devi ricordarglielo.

```markdown
# Developer Identity & Global Preferences

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
- Preferisco il codice dichiarativo rispetto all'imperativo.
- Immutabilità dove possibile; state mutation esplicita e motivata.
- Type Hinting rigoroso: PEP 484/585/604. Mai `Any` senza commento.
- Principi SOLID applicati pragmaticamente, zero over-engineering.
- Una classe solo se esiste stato interno persistente; altrimenti
  funzioni pure e moduli tipizzati.

## Python Style Contract
- Python 3.10+ idiomatico: match/case, structural pattern matching,
  union types con `|`, `TypeAlias`, `ParamSpec`.
- pydantic v2 per parsing e validazione — mai dataclass + manuale.
- Tutto l'I/O è async/await. Nessuna eccezione non motivata.
- `uv` per env e dipendenze. Se trovi `requirements.txt` o `Pipfile`,
  proponi migrazione a `pyproject.toml` gestito da `uv`.

## Toolchain Standard
- Linting: `ruff` (formato + lint unificato)
- Type checking: `mypy` con `typeshed`
- Testing: `pytest` con `pytest-asyncio` per codice async
- Build: `uv`, `Makefile` per comandi complessi
- Node: `pnpm`. Docker per servizi infrastrutturali.

## Output Format per Bug Fix
1. Una riga: causa dell'errore.
2. Blocco di codice corretto, senza preamble.
Non scusarti: correggi e procedi.

## Verification Rule
Non dichiarare mai "fatto" o "risolto" senza evidenza verificabile:
output di un test che passa, exit code 0 di un comando, screenshot,
o output reale del programma. Il gap trust-then-verify è la fonte
principale di output scadente.
```

### 2.2 Project Rules — `.claude/rules/*.md` con path-gating

I file in `.claude/rules/` vengono caricati automaticamente. Ogni file può essere
**scoped a un percorso specifico** tramite glob: una rule per le migrations non deve
inquinare ogni sessione, ma attivarsi solo quando Claude lavora in quella directory.

```
.claude/rules/
├── 00-architecture.md     → pattern architetturali (sempre attiva)
├── 01-code-style.md       → convenzioni specifiche del repo (sempre attiva)
├── 02-testing.md          → strategia di test, soglie di coverage (sempre attiva)
├── 03-git.md              → convenzioni di commit e branching (sempre attiva)
├── 04-dependencies.md     → librerie approvate e vietate (sempre attiva)
├── 05-migrations.md       → path: db/migrations/** (solo quando si lavora lì)
└── 06-frontend.md         → path: src/frontend/** (solo quando si lavora lì)
```

Esempio di rule con path-gating — `.claude/rules/05-migrations.md`:

```markdown
---
path: db/migrations/**
---

# Database Migrations

## Regole
- Ogni migration deve essere reversibile: UP e DOWN obbligatori.
- Mai modificare una migration già committata su main.
- Usa nomi descrittivi: `YYYYMMDD_add_user_notifications_table.sql`.
- Ogni migration va testata su un DB di test prima del commit.

## Gotchas
- Le colonne nullable aggiunte dopo il deploy non richiedono default,
  ma quelle NOT NULL sì. Specifica sempre il default per NOT NULL.
```

Esempio — `.claude/rules/03-git.md`:

```markdown
# Git Conventions

## Commit Message Format
Usa Conventional Commits: `<type>(<scope>): <description>`
Tipi validi: feat | fix | refactor | test | docs | chore | perf

## Regole
- Mai committare direttamente su `main` o `master`.
- Ogni commit deve essere atomico: un cambiamento logico per commit.
- Non committare mai codice con test rossi.
- Il commit message deve essere in inglese.

## Quando non usare git commit automatico
Non eseguire `git commit` in autonomia. Usa sempre il comando
/commit che presenta il diff e chiede conferma umana.
```

### 2.3 Project Manifesto — `CLAUDE.md`

Questo è il documento **condiviso col team**, committato nel repo. Mantienilo sotto
i **1500 token**: deve contenere solo ciò che è sempre rilevante all'inizio di ogni
sessione.

**Tre principi dal team Anthropic:**
- Mantienilo corto. Per ogni riga chiedi: "rimuovendo questa riga Claude commetterebbe un errore?" Se no, taglia.
- Lascia che si scriva da solo: la regola di auto-apprendimento in `~/.claude/memory.md` fa sì che Claude aggiorni autonomamente la sezione `## Gotchas` ogni volta che sbaglia.
- Usa `@path` per importare file senza appesantire il token budget.

```markdown
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
See @pyproject.toml for dependencies and tool config.
```

> **Nota sull'import `@path`**: Claude Code supporta la sintassi `@path` per importare
> file esterni in CLAUDE.md. Usa questa feature per tenere il manifesto corto riferendo
> README, pyproject.toml o altri file di riferimento senza duplicarne il contenuto.

**Cascading in monorepo**: in un monorepo, sia `root/CLAUDE.md` che
`root/services/billing/CLAUDE.md` vengono caricati quando si lavora nel servizio
billing. Usa questa feature per avere convenzioni diverse per folder senza
inquinare il CLAUDE.md radice.

### 2.4 Personal Driver — `CLAUDE.local.md`

File **gitignored**, caricato automaticamente come CLAUDE.md ma mai committato.
È il tuo layer privato: due use case principali.

**Use case 1 — PR feedback come training data.**
Ogni volta che ricevi feedback da un reviewer, aggiungilo qui immediatamente.
Il tuo reviewer ti sta dando training data gratuiti: convertili in regole e lascia
che Claude le applichi automaticamente da quel momento in poi.

**Use case 2 — abitudini personali da correggere.**
Cose che sai di fare ma che vuoi smettere di fare.

```markdown
# Personal Rules — [tuo nome] (private, never commit)

## Da PR feedback

- [2026-03-12] I nuovi SQS consumer richiedono DLQ e alarms nella stessa PR.
- [2026-03-18] I test per nuovi endpoint devono includere il caso auth-failure.
- [2026-04-01] Usare named tuples invece di dict plain per return type con 3+ campi.
- [2026-04-15] Aggiornare sempre l'OpenAPI spec quando si aggiungono endpoint.

## Abitudini da correggere

- Non usare `print()` per debug: usa il project logger (`from src.core.log import logger`).
- Non lasciare `TODO:` senza ticket reference.
- Non hardcodare timeout: usa le costanti in `src/core/config.py`.
```

> **Pruna ogni 4-6 settimane.** Le cose diventate muscle memory possono essere rimosse.
> Il file deve catturare ciò che stai ancora imparando, non ciò che fai già automaticamente.

### 2.5 Project Soul — `.claudememory`

File di contesto dinamico per lo stato del progetto. Non viene caricato automaticamente:
viene iniettato nel contesto tramite l'hook `SessionStart` (Capitolo 4).

```markdown
# Project Memory — [DATA AGGIORNAMENTO]

## Decisioni Tecniche Recenti
- [YYYY-MM-DD] Migrato da X a Y perché [motivazione]

## TODO Tecnici Aperti
- [ ] Refactoring del modulo auth — priorità alta
- [ ] Aggiungere rate limiting all'endpoint /api/v1/items

## Feature in Sviluppo
- Branch: `feat/user-notifications`
- Stato: modelli completati, mancano endpoint e test

## Debito Tecnico Noto
- `src/legacy/parser.py` — nessun test, da riscrivere
```

---

## CAPITOLO 3 — SKILLS E SLASH COMMANDS

### 3.1 Skills vs Commands: la distinzione fondamentale

Claude Code supporta due meccanismi per i comandi on-demand:

| | `.claude/commands/*.md` | `.claude/skills/<name>/SKILL.md` |
|---|---|---|
| **Struttura** | Singolo file | Cartella con file multipli |
| **File di supporto** | No | Sì (template, esempi, config) |
| **Frontmatter avanzato** | No | Sì (`disable-model-invocation`, `allowed-tools`, `agent`) |
| **Caricamento** | Completo a session start | Solo frontmatter (~100 token); corpo caricato on-demand |
| **Quando usarlo** | Comandi semplici senza side effect | Qualsiasi cosa ripeti più di una volta o con side effect |

**Regola pratica**: se un comando ha side effect (deploy, commit, push, scrittura file
critici), usare una skill con `disable-model-invocation: true` nel frontmatter.
Questo garantisce che il comando si attivi **solo se digitato esplicitamente**,
mai per inferenza del modello.

### 3.2 Skills — Struttura e Frontmatter

```
.claude/skills/
├── commit/
│   └── SKILL.md                ← entry point con frontmatter
├── summarize-changes/
│   └── SKILL.md
└── go-handler/                 ← esempio con file di supporto
    ├── SKILL.md
    ├── templates/
    │   └── handler.go.tmpl
    └── examples/
        └── healthz.go
```

Frontmatter completo:

```yaml
---
name: commit
description: Genera un commit message semantico dal diff e chiede conferma prima di eseguire.
             Usa quando l'utente vuole committare, preparare un commit, o vedere le modifiche staged.
disable-model-invocation: true   # attivato SOLO se digitato esplicitamente — mai per inferenza
allowed-tools: Bash              # strumenti permessi a questa skill
---
```

Skill semplice — `summarize-changes` (globale, in `~/.claude/skills/`):

```markdown
---
description: Riassume le modifiche non committate e segnala rischi. Usa quando si chiede
             cosa è cambiato, si vuole un commit message, o si chiede di rivedere il diff.
---

## Modifiche correnti

!`git diff HEAD`

## Istruzioni

Riassumi le modifiche in 2-3 punti, poi elenca i rischi:
error handling mancante, valori hardcoded, test da aggiornare.
```

> **Nota**: le righe che iniziano con `!` eseguono un comando shell e iniettano
> l'output nel contesto al momento dell'invocazione.

### 3.3 `/commit` — Commit Assistito con Supervisione Umana

File: `.claude/skills/commit/SKILL.md`

```markdown
---
name: commit
description: Genera un commit message semantico dal diff e chiede conferma prima di eseguire.
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
```

### 3.4 `/architect` — Riscansione Architetturale

File: `.claude/commands/architect.md`

```markdown
---
name: architect
description: Analisi olistica del repo e rigenerazione completa di ARCHITECT.md
---

Agisci da Principal Software Architect. Esplora l'intera repository e analizza:

1. **Architettura di Alto Livello**: pattern identificato con motivazione.
2. **Mappa Semantica dei Moduli**: cosa rappresenta ogni modulo nel dominio.
3. **Flussi di Dati Critici**: percorso di una richiesta dall'entry point alla risposta.
4. **Design Pattern Identificati**: dove e perché sono stati applicati.
5. **Dipendenze Chiave**: coupling forte tra moduli, coupling circolare.
6. **Debito Tecnico**: aree legacy, moduli senza test, code smell significativi.
7. **Decisioni Architetturali**: perché certe scelte sono state fatte.

Sovrascrivi completamente ARCHITECT.md con il risultato.
Usa sezioni Markdown con heading H2. Tono tecnico, asciutto, preciso.
```

### 3.5 `/pythonic` — Refactoring Idiomatico

File: `.claude/commands/pythonic.md`

```markdown
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
```

### 3.6 `/docstrings` — Generazione Documentazione

File: `.claude/commands/docstrings.md`

```markdown
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
```

### 3.7 `/memory-update` — Aggiornamento Project Soul

File: `.claude/commands/memory-update.md`

```markdown
---
name: memory-update
description: Aggiorna .claudememory con le decisioni e i task completati nella sessione
---

Analizza la sessione corrente e aggiorna `.claudememory`:

1. Aggiungi in "Decisioni Tecniche Recenti" le scelte prese oggi (con data).
2. Marca come completati [x] i TODO risolti.
3. Aggiungi nuovi TODO identificati durante il lavoro.
4. Aggiorna "Feature in Sviluppo" con lo stato corrente.

Non cancellare la storia: aggiungi in cima alle sezioni.
Mantieni il file sotto 100 righe: archivia le decisioni > 30 giorni in un blocco
`## Archivio` in fondo.
```

---

## CAPITOLO 4 — HOOK: IL PIANO DETERMINISTICO

Gli hook sono l'unica parte del sistema che Claude **non può ignorare o reinterpretare**.

| Tipo | Quando usarlo |
|---|---|
| `command` | Operazioni deterministiche: linting, test, formatting, git |
| `prompt` | Decisioni che richiedono giudizio ma non accesso a file |
| `agent` | Analisi che richiedono leggere file, esplorare il repo |
| `http` | Integrazione con sistemi esterni (CI, webhook, etc.) |

### 4.1 Architettura degli Hook

```
Evento              Azione                              Tipo
────────────────────────────────────────────────────────────────
PostToolUse         ruff --fix + mypy (per file)        command
(Write|Edit|MultiEdit)

PostToolBatch       verifica import cross-file           command

Stop                pytest con guardia anti-loop         command
Stop                aggiorna ARCHITECT.md + README       agent

SessionStart        carica .claudememory nel contesto    command
PreToolUse(Bash)    blocca comandi distruttivi           command
```

### 4.2 `.claude/settings.json` — Configurazione Completa

```json
{
  "hooks": {

    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/session-start.sh",
            "timeout": 15,
            "statusMessage": "Caricamento contesto di progetto..."
          }
        ]
      }
    ],

    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/pre-tool-security.sh",
            "timeout": 10,
            "statusMessage": "Verifica sicurezza comando..."
          }
        ]
      }
    ],

    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/post-tool-lint.sh",
            "timeout": 30,
            "statusMessage": "Linting e type checking..."
          }
        ]
      }
    ],

    "PostToolBatch": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/post-batch-check.sh",
            "timeout": 20,
            "statusMessage": "Verifica coerenza batch..."
          }
        ]
      }
    ],

    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/stop-quality-gate.sh",
            "timeout": 120,
            "statusMessage": "Esecuzione test suite..."
          },
          {
            "type": "agent",
            "prompt": "Analizza `git diff HEAD --stat` e `git diff HEAD` per capire cosa è cambiato in questa sessione. Aggiorna CHIRURGICAMENTE solo le sezioni di ARCHITECT.md e README.md che riflettono questi cambiamenti. Non riscrivere l'intero file. Se nulla di strutturale è cambiato (solo bug fix o test), non toccare ARCHITECT.md. Aggiorna sempre la sezione 'Ultimo aggiornamento' con la data odierna.",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

### 4.3 Script degli Hook

#### `session-start.sh` — Context Hydrator

```bash
#!/bin/bash
# .claude/hooks/session-start.sh
# Inietta il contesto dinamico di progetto all'avvio della sessione.
# CLAUDE.md, CLAUDE.local.md e rules/ sono caricati nativamente da Claude Code.
# Qui carichiamo solo .claudememory che non ha caricamento nativo.

MEMORY_FILE="$CLAUDE_PROJECT_DIR/.claudememory"

if [ -f "$MEMORY_FILE" ]; then
  echo "=== PROJECT MEMORY (da .claudememory) ==="
  cat "$MEMORY_FILE"
  echo "========================================="
else
  echo "Nessun file .claudememory trovato."
fi

echo ""
echo "=== GIT STATUS ==="
git -C "$CLAUDE_PROJECT_DIR" log --oneline -5 2>/dev/null || echo "Nessuna commit history"
git -C "$CLAUDE_PROJECT_DIR" status --short 2>/dev/null
echo "=================="
```

#### `pre-tool-security.sh` — Security Gate

```bash
#!/bin/bash
# .claude/hooks/pre-tool-security.sh
# Blocca comandi shell potenzialmente distruttivi.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

BLOCKED_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \$HOME"
  "> /dev/sda"
  "mkfs"
  "dd if=/dev/zero"
  "chmod -R 777 /"
  "git push --force origin main"
  "git push --force origin master"
  "DROP TABLE"
  "DROP DATABASE"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qF "$pattern"; then
    jq -n \
      --arg reason "Comando bloccato dal security gate: pattern '$pattern' rilevato." \
      '{
        hookSpecificOutput: {
          hookEventName: "PreToolUse",
          permissionDecision: "deny",
          permissionDecisionReason: $reason
        }
      }'
    exit 0
  fi
done

exit 0
```

#### `post-tool-lint.sh` — Per-File Linting

```bash
#!/bin/bash
# .claude/hooks/post-tool-lint.sh
# Esegue ruff e mypy su ogni file Python scritto da Claude.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""')

if [[ "$FILE_PATH" != *.py ]]; then
  exit 0
fi

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

ERRORS=""

RUFF_OUT=$(uv run ruff check --fix "$FILE_PATH" 2>&1)
if [ $? -ne 0 ]; then
  ERRORS="$ERRORS\n[ruff] $RUFF_OUT"
fi

uv run ruff format "$FILE_PATH" 2>/dev/null

MYPY_OUT=$(uv run mypy "$FILE_PATH" --ignore-missing-imports --no-error-summary 2>&1)
if [ $? -ne 0 ]; then
  ERRORS="$ERRORS\n[mypy] $MYPY_OUT"
fi

if [ -n "$ERRORS" ]; then
  jq -n --arg ctx "$(echo -e "$ERRORS")" \
    '{
      hookSpecificOutput: {
        hookEventName: "PostToolUse",
        additionalContext: $ctx
      }
    }'
fi

exit 0
```

#### `post-batch-check.sh` — Cross-File Consistency

```bash
#!/bin/bash
# .claude/hooks/post-batch-check.sh
# Dopo un batch di scritture, verifica la coerenza degli import.

cd "$CLAUDE_PROJECT_DIR"

CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null | grep '\.py$')

if [ -z "$CHANGED_FILES" ]; then
  exit 0
fi

MYPY_OUT=$(uv run mypy src/ --ignore-missing-imports --no-error-summary 2>&1 | grep "error:" | head -20)

if [ -n "$MYPY_OUT" ]; then
  jq -n --arg ctx "Errori mypy cross-file dopo il batch:\n$MYPY_OUT" \
    '{
      hookSpecificOutput: {
        hookEventName: "PostToolBatch",
        additionalContext: $ctx
      }
    }'
fi

exit 0
```

#### `stop-quality-gate.sh` — Test Gate con Anti-Loop

```bash
#!/bin/bash
# .claude/hooks/stop-quality-gate.sh
# Esegue pytest prima che Claude concluda.
# CRITICO: controlla stop_hook_active per prevenire loop infiniti.

INPUT=$(cat)

if [ "$(echo "$INPUT" | jq -r '.stop_hook_active // false')" = "true" ]; then
  echo "Quality gate: secondo tentativo, rilascio il controllo."
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

if [ ! -d "tests" ] && ! find . -name "test_*.py" -maxdepth 3 | grep -q .; then
  exit 0
fi

echo "Esecuzione pytest..."
PYTEST_OUT=$(uv run pytest --tb=short -q 2>&1)
PYTEST_EXIT=$?

if [ $PYTEST_EXIT -ne 0 ]; then
  echo "═══════════════════════════════════════"
  echo "QUALITY GATE: TEST FALLITI"
  echo "═══════════════════════════════════════"
  echo "$PYTEST_OUT"
  echo ""
  echo "Claude deve correggere i test prima di concludere."
  echo "═══════════════════════════════════════"
  exit 2
fi

echo "✓ Tutti i test passano ($(echo "$PYTEST_OUT" | grep -oP '\d+ passed'))"
exit 0
```

### 4.4 `/goal` — Quality Gate Dichiarativo

`/goal` è il complemento dichiarativo all'hook `stop-quality-gate.sh`. Invece di
codificare la condizione di successo in uno script shell, la esprimi in linguaggio
naturale e Claude itera finché non è soddisfatta, controllando la condizione
ogni volta che tenta di fermarsi.

```bash
/goal tutti i test in tests/auth passano e il lint è pulito
```

Esempi pratici:

```bash
# Condizione su test
/goal tutti i test di integrazione in tests/api passano senza flapping per 3 run consecutivi

# Condizione su contratto API
/goal la spec OpenAPI valida e corrisponde alle response shape effettive

# Condizione su infra
/goal docker compose up gira pulito e l'healthcheck endpoint restituisce 200

# Condizione su coverage
/goal la coverage su src/billing/ è sopra l'80% e tutti i nuovi test non sono placeholder
```

**Regola**: la condizione deve essere **verificabile e deterministica** — legata a
un comando di test, un exit code, o uno stato di file. Condizioni vaghe come
"il codice è buono" non funzionano.

`/goal` si combina con:
- **Auto mode**: rimuove i prompt di conferma per non stallare su task lunghi.
- **`/focus`**: nasconde le tool call intermedie, mostra solo il risultato finale.
- **Hook Stop**: il quality gate shell viene eseguito comunque al termine.

Pattern `walk away`: brief preciso → `/goal <condizione>` → auto mode → `/focus` → esci.
Torni con la PR pronta.

---

## CAPITOLO 5 — AGENTI SPECIALIZZATI

Gli agenti sono sottoprocessi con contesto separato. Usali per task che non devono
"inquinare" la sessione principale. Un agente può leggere cinquanta file senza
riempire il tuo contesto principale.

### Frontmatter degli Agenti

```yaml
---
name: code-reviewer
description: Revisione sistematica del codice. Invocato prima dei commit importanti.
tools: Read, Grep, Bash
model: opus
isolation: worktree   # opzionale: gira nel proprio git worktree
---
```

> **`isolation: worktree`**: fondamentale per agenti che fanno analisi massive o
> migrazioni in parallelo. Ogni agente lavora nel proprio worktree isolato.

### `code-reviewer.md`

```markdown
---
name: code-reviewer
description: Revisione sistematica del codice Python. Invocato prima dei commit importanti
             o su richiesta esplicita. Tools read-only: un reviewer che modifica codice
             diventa di parte verso le sue stesse modifiche.
tools: Read, Grep, Glob, Bash
model: opus
---

Sei un Senior Python Engineer specializzato in code review.
Identifica problemi reali, non preferenze stilistiche.

## Processo

1. Esegui `git diff HEAD --stat` e `git diff HEAD`.
2. Leggi i file completi, non solo il contesto del diff.
3. Cross-check con CLAUDE.md, CLAUDE.local.md e .claude/rules/.

## Flag

**Correttezza**: off-by-one, null handling, error path, race condition.
**Sicurezza**: injection risks, auth check mancanti, secrets nel codice.
**Test mancanti** per nuova logica.
**N+1 queries**.
**Violazioni di convenzione** da CLAUDE.md o rules/.

## Non flaggare

- Preferenze di stile non nelle project rules.
- Suggerimenti di refactoring su codice funzionante.
- Qualsiasi cosa fuori da questo diff.

## Output

Raggruppa per severità (Critical / High / Medium / Low).
File + riga + problema + fix suggerito.
Concludi con un verdict: **SHIP**, **FIX FIRST**, o **REWORK**.
```

### `test-writer.md`

```markdown
---
name: test-writer
description: Genera test pytest completi per il codice indicato. Invocato quando
             viene creata una nuova funzione o modulo senza test.
tools: Read, Write, Bash
model: sonnet
---

Specializzato in test pytest per codice Python async.

## Strategia

1. **Unit test**: ogni funzione pubblica con almeno 3 casi: happy path,
   edge case, error case.
2. **Parametrize**: usa `@pytest.mark.parametrize` per varianti.
3. **Fixtures**: crea fixture in `conftest.py`, non nel file di test.
4. **Mock**: mocka solo I/O esterni (HTTP, DB, filesystem).
   Non mockare la business logic.
5. **Async**: usa `@pytest.mark.asyncio` per funzioni async.

## Naming

`test_<funzione>_<scenario>_<expected_outcome>`
Esempio: `test_create_user_with_duplicate_email_raises_conflict`

## Pattern Writer/Reviewer

Dopo aver scritto i test, invoca il code-reviewer agent per validarli:
"Use the code-reviewer subagent to check the tests I just wrote."
Il reviewer valuta in contesto fresco senza bias da implementazione.
```

---

## CAPITOLO 6 — PROTOCOLLO PLAN MODE

### Shortcut essenziali

| Azione | Come |
|---|---|
| Attivare Plan Mode (read-only) | `Shift+Tab` due volte |
| Modificare il piano nell'editor | `Ctrl+G` — apre il piano come testo puro, modificalo prima che diventi codice |
| Rewind all'ultimo checkpoint | `Esc` due volte |

### Quando attivare Plan Mode

Per qualsiasi task che coinvolge:
- Nuove funzionalità (non solo bug fix)
- Modifiche all'architettura o alle interfacce pubbliche
- Refactoring che tocca più di 2 file
- Integrazione con sistemi esterni

### Regola del doppio contesto

Per decisioni architetturali importanti: fai scrivere il piano a Claude nella sessione A,
poi apri una **sessione B fresca** e chiedi di fare da staff engineer reviewer del piano,
senza contesto da implementazione. La sessione B non ha bias e cattura gap reali.

Aggiungi questa regola in `.claude/rules/00-architecture.md`:

```markdown
# Planning Protocol

## Fase di Intervista (obbligatoria prima del codice)
Prima di scrivere una riga di codice, rispondi a queste domande:

1. **Core Problem**: Qual è il problema principale? (non la soluzione — il problema)
2. **Success Criteria**: Quali test devono passare? Quale comportamento osservabile?
3. **Non-Goals**: Cosa questa implementazione NON deve toccare?
4. **Impatto**: Quali file/moduli esistenti saranno toccati?

## Verification Plan
- Elenca i passi di implementazione in ordine.
- Per ogni passo, indica come verificarlo.
- Identifica le dipendenze tra i passi.

## Poi procedi
Solo dopo conferma sull'alignment, inizia l'implementazione.
```

---

## CAPITOLO 7 — WORKFLOW QUOTIDIANO

### Mattina: Inizializzazione

```bash
# Claude Code carica automaticamente:
# - .claude/rules/*.md (nativo, con path-gating)
# - CLAUDE.md (nativo)
# - CLAUDE.local.md (nativo, gitignored)
# - .claudememory viene iniettato dall'hook SessionStart

# Al primo avvio su un nuovo progetto:
/architect    # genera ARCHITECT.md completo
```

### Durante lo Sviluppo — Sessione Singola

```
Tu:      "Implementa la funzione X che fa Y"

Claude:  [Plan Mode — Shift+Tab×2 — esplora, poi propone piano]
Tu:      [Ctrl+G — apri il piano nell'editor, tweakalo]

Claude:  [scrive codice]
Hook:    PostToolUse → ruff + mypy su ogni file scritto
         PostToolBatch → verifica cross-file dopo ogni batch

Claude:  [vede gli errori nel contesto, corregge inline]
         [se sbaglia qualcosa: aggiorna automaticamente CLAUDE.md § Gotchas]
```

### Durante lo Sviluppo — Sessioni Parallele (unlock principale)

Il pattern di maggiore impatto secondo il team Anthropic: **3-5 sessioni Claude in
parallelo su git worktrees separati**. Non checkout multipli: worktrees, così ogni
sessione ha il proprio filesystem ma condivide la storia git.

```bash
# Setup worktrees per task paralleli
git worktree add ../myproject-feat-auth feat/auth
git worktree add ../myproject-feat-billing feat/billing
git worktree add ../myproject-review main

# Sessione A: implementa feat/auth
cd ../myproject-feat-auth && claude

# Sessione B: implementa feat/billing in parallelo
cd ../myproject-feat-billing && claude

# Sessione C: review del lavoro di A (contesto fresco, zero bias)
cd ../myproject-review && claude
# "Use the code-reviewer subagent to review the feat/auth branch."
```

**Pattern Writer/Reviewer**: la sessione di review non sa cosa ha fatto la sessione
di implementazione. Questo è il punto: valuta il codice come lo farebbe un collega
che non era presente durante lo sviluppo.

### Fine Task

```
Hook:    Stop → pytest (se fallisce → exit 2, Claude corregge)
         Stop → agent aggiorna ARCHITECT.md chirurgicamente

Tu:      /commit          (vedi diff, approvi il messaggio, confermi)
         /memory-update   (aggiorna .claudememory)
```

### Gestione del Contesto

**`/rewind` — checkpoint per ogni prompt**: quando Claude va nella direzione sbagliata,
non aggiungere "non ha funzionato, riprova" al contesto (inquina la sessione).
Usa `Esc×2` per tornare al checkpoint precedente e re-prompta con ciò che hai imparato.
I checkpoint persistono tra sessioni.

**`/compact <hint>` vs `/clear`**:
- Task nuovo, contesto irrilevante → `/clear` con un brief scritto a mano da zero.
- Task correlato dove serve ancora contesto → `/compact` con hint preciso su cosa preservare.

```bash
# Esempio hint utile
/compact Preserva: le decisioni prese, i file modificati, i comandi di test funzionanti.
```

> `/compact` è una sintesi lossy fatta dal modello. `/clear` è il tuo brief.
> La distinzione è importante: non usare `/compact` come scorciatoia per `/clear`.

### Comandi Situazionali

```bash
/pythonic         # solo quando vuoi refactoring idiomatico esplicito
/docstrings       # solo quando vuoi documentazione su moduli pubblici
/commit           # SEMPRE per committare — mai lasciare che Claude lo faccia da solo
/architect        # quando l'architettura cambia significativamente
/memory-update    # a fine sessione per mantenere .claudememory aggiornato
/goal <cond>      # per task lunghi con condizione di completamento verificabile
```

### Perché NON fare git commit automatico

Un commit automatico a ogni `Stop` significa:
- Codice committato senza revisione del diff
- Nessuna granularità atomica
- `git log` diventa rumore invece che documentazione

Lo slash command `/commit` con `disable-model-invocation: true` è la soluzione:
mostra il diff completo, propone un message semantico, chiede conferma esplicita,
non fa mai `git push` in autonomia.

---

## APPENDICE A — Troubleshooting degli Hook

### "L'hook non viene eseguito"

1. Il file `.sh` è eseguibile? (`chmod +x .claude/hooks/*.sh`)
2. La `matcher` regex corrisponde esattamente al nome del tool? (case-sensitive)
3. Il `timeout` è sufficiente?
4. Controlla stderr con `Ctrl+O` in Claude Code (toggle verbose mode).

### "Loop infinito sull'hook Stop"

Aggiungi sempre all'inizio di ogni Stop hook che usa `exit 2`:

```bash
INPUT=$(cat)
if [ "$(echo "$INPUT" | jq -r '.stop_hook_active // false')" = "true" ]; then
  exit 0
fi
```

### "mypy fallisce su dipendenze non tipizzate"

Usa `--ignore-missing-imports` negli hook. Configura in `pyproject.toml`:

```toml
[tool.mypy]
python_version = "3.12"
strict = true
ignore_missing_imports = true
```

### "PostToolUse gira troppo spesso"

```json
{
  "matcher": "Write|Edit|MultiEdit",
  "hooks": [{
    "type": "command",
    "if": "Write(*.py)|Edit(*.py)|MultiEdit(*.py)",
    "command": "bash .claude/hooks/post-tool-lint.sh"
  }]
}
```

---

## APPENDICE B — Skills Ecosystem (risorse esterne)

Se trovi che stai riscrivendo skills già esistenti, controlla prima:

**[mattpocock/skills](https://github.com/mattpocock/skills)** — Skills per ingegneri senior. Standout:
- `/grill-me`: ti intervista su un piano prima che venga scritto codice.
- `/tdd`: forza il ciclo red-green-refactor in modo stretto.
- `/diagnose`: debugging disciplinato — riproduci, minimizza, ipotizza, correggi, regressione.

Installazione: `npx skills@latest add mattpocock/skills`

**[Jeffallan/claude-skills](https://github.com/Jeffallan/claude-skills)** — 66 profili per linguaggio:
`go-pro`, `python-pro`, `typescript-pro`, `rust-engineer`, `sql-pro`, e altri.
Componibili: un task Next.js può pullare `nextjs-developer` + `typescript-pro` insieme.

**Skill ufficiali Anthropic**:
- `/code-review`: 4 agenti paralleli che auditano il diff con confidence score.
- `/batch`: fanna out una migrazione su decine di agenti paralleli, ognuno nel proprio worktree.
- `/webapp-testing`: dà a Claude controllo Playwright per testare la tua web app locale.

**[VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)** — 100+ agenti categorizzati.

> **Regola**: se fai qualcosa più di una volta al giorno, diventa una skill.
> Committare le skills nel repo significa che ogni nuovo engineer clona il repo
> e ottiene gratis le pratiche accumulate dal team.

---

*Fine del manuale. Versione 2.1 — Maggio 2026*
