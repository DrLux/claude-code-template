# Claude Code Template

Template per progetti Python senior con Claude Code configurato deterministicamente.
Implementa il sistema a tre piani: advisory (CLAUDE.md + rules), deterministico (hooks),
e on-demand (skills + commands + agents).

## Creare un nuovo progetto da questo template

**Modo rapido (1 comando):**
```bash
gh repo create mio-nuovo-progetto --template DrLux/claude-code-template --private --clone
cd mio-nuovo-progetto
```

**Da GitHub:** clicca "Use this template" su [github.com/DrLux/claude-code-template](https://github.com/DrLux/claude-code-template), poi clona il repo creato.

Entrambi i metodi creano un repo con **history pulita**, senza commit del template.

**Dopo la creazione:**
```bash
# 1. Personalizza CLAUDE.md con stack e invarianti del tuo progetto
# (sostituisci tutti i placeholder [NOME PROGETTO], [es. FastAPI], etc.)

# 2. Inizializza il contesto di progetto
touch .claudememory       # verrà popolato da /memory-update
touch CLAUDE.local.md     # note personali e PR feedback — mai committare

# 3. Prima sessione: genera la mappa architetturale
/architect
```

**Una tantum per macchina** (developer identity globale):
```bash
cp templates/global-memory.md ~/.claude/memory.md
# Edita ~/.claude/memory.md per adattarlo al tuo profilo
```

## Come usare questo template (setup manuale)

```bash
# 1. Clona il template nella directory del nuovo progetto
git clone https://github.com/DrLux/claude-code-template.git mio-progetto
cd mio-progetto

# 2. Rimuovi la history del template e inizializza il tuo repo
rm -rf .git
git init

# 3. Personalizza CLAUDE.md con stack e invarianti del tuo progetto
# (sostituisci tutti i placeholder [NOME PROGETTO], [es. FastAPI], etc.)

# 4. Copia il developer identity globale (una tantum per macchina)
cp templates/global-memory.md ~/.claude/memory.md
# Edita ~/.claude/memory.md per adattarlo al tuo profilo

# 5. Inizializza il contesto di progetto
touch .claudememory       # verrà popolato da /memory-update
touch CLAUDE.local.md     # note personali e PR feedback — mai committare

# 6. Prima sessione: genera la mappa architetturale
/architect
```

## Struttura

```
.
├── .claude/
│   ├── settings.json           — configurazione hook
│   ├── hooks/                  — script deterministici (linting, test, sicurezza)
│   ├── skills/                 — comandi con side effect (commit)
│   ├── commands/               — comandi on-demand (architect, pythonic, docstrings)
│   ├── rules/                  — regole tematiche caricate automaticamente
│   └── agents/                 — sottoprocessi specializzati (reviewer, test-writer)
├── templates/
│   └── global-memory.md        — template per ~/.claude/memory.md (globale, non committare)
├── CLAUDE.md                   — manifesto di progetto (committato, condiviso col team)
├── CLAUDE.local.md             — note personali (gitignored)
├── ARCHITECT.md                — mappa architetturale (generata da /architect)
└── .claudememory               — stato dinamico del progetto (gitignored)
```

## Piano di controllo

| Piano | File | Comportamento |
|---|---|---|
| Advisory | `CLAUDE.md`, `.claude/rules/` | Claude lo legge e interpreta |
| Deterministico | `.claude/hooks/` | Eseguito automaticamente, non aggirabile |
| On-demand | `.claude/skills/`, `.claude/commands/` | Attivato solo su invocazione esplicita |

## Comandi disponibili

| Comando | Funzione |
|---|---|
| `/commit` | Commit assistito con conferma umana (non fa mai push) |
| `/architect` | Riscansiona il repo e rigenera `ARCHITECT.md` |
| `/pythonic` | Refactoring idiomatico Python 3.10+ |
| `/docstrings` | Aggiunge Google-style docstrings alle API pubbliche |
| `/memory-update` | Aggiorna `.claudememory` con lo stato della sessione |

## Hooks attivi

| Hook | Trigger | Azione |
|---|---|---|
| `SessionStart` | Avvio sessione | Carica `.claudememory` + git log |
| `PreToolUse` | Ogni comando Bash | Blocca pattern distruttivi |
| `PostToolUse` | Scrittura file `.py` | `ruff --fix` + `mypy` |
| `PostToolBatch` | Fine batch di scritture | `mypy` cross-file |
| `Stop` | Fine sessione | `pytest` + aggiornamento `ARCHITECT.md` |

## Setup developer identity globale

Copia `templates/global-memory.md` in `~/.claude/memory.md` e personalizza:
- **Seniority Contract**: adatta al tuo livello e dominio
- **Technical Philosophy**: riflette le tue preferenze
- **Toolchain Standard**: modifica se usi stack diversi
