# Dove va cosa — Guida ai file del template

Ogni file di questo template ha uno **scope preciso**: chi lo legge, quando, e con quale
autorità. Mettere qualcosa nel posto sbagliato non rompe nulla subito, ma crea rumore
nei token, aspettative sbagliate o informazioni che non raggiungono chi deve leggerle.

---

## `templates/global-memory.md` → copiare in `~/.claude/memory.md`

**Scope**: globale, personale, si applica a TUTTI i progetti sulla macchina.

**Cosa va qui**: identità del developer come interlocutore di Claude.
- Come vuoi che Claude comunichi con te (livello di spiegazione, tono)
- Regola di auto-apprendimento (aggiorna Gotchas quando sbaglia)
- Principi di filosofia tecnica high-level (dichiarativo > imperativo, SOLID)
- Formato atteso per output specifici (bug fix, verifica)

**Cosa NON va qui**: toolchain specifica, sintassi Python, librerie preferite.
Quelle vanno nelle rules perché cambiano per progetto e devono essere condivise
col team. La memory è personale — un collega con lo stesso repo potrebbe avere
preferenze diverse nel suo `~/.claude/memory.md`.

**Perché non nel repo**: contiene preferenze personali. Una volta personalizzato
non ha senso committarlo — appartiene alla macchina, non al codice.

---

## `CLAUDE.md`

**Scope**: progetto, condiviso col team, caricato automaticamente a ogni sessione.

**Cosa va qui**: solo ciò che è sempre rilevante e project-specific.
- Stack tecnico del progetto (Python 3.12, FastAPI, PostgreSQL — non generico)
- Invarianti architetturali che non si rompono mai
- Entry point critici e file da non toccare senza leggere prima X
- La sezione `## Gotchas` — popolata automaticamente da Claude quando sbaglia

**Test per ogni riga**: "Se rimuovo questa riga, Claude commetterebbe un errore
su questo progetto specifico?" Se no, taglia. Tienilo sotto 1500 token.

**Cosa NON va qui**: regole di stile, toolchain, convenzioni git. Quelle vanno
nelle rules — il CLAUDE.md le importa implicitamente perché le rules vengono
caricate automaticamente. Duplicarle nel CLAUDE.md è rumore che consuma token
senza aggiungere informazione.

---

## `CLAUDE.local.md`

**Scope**: progetto, personale, gitignored — non viene mai committato.

**Cosa va qui**: il tuo layer privato sopra il CLAUDE.md condiviso.
- PR feedback ricevuto dai reviewer (convertito in regole operative)
- Abitudini personali da correggere
- Note temporanee su decisioni in corso

**Esempio di uso corretto**:
```
- [2026-03-18] I test per nuovi endpoint devono includere il caso auth-failure.
- Non lasciare `TODO:` senza ticket reference.
```

**Cosa NON va qui**: decisioni architetturali condivise, convenzioni del team,
qualsiasi cosa utile anche agli altri. Quelle vanno in CLAUDE.md o nelle rules.

**Manutenzione**: pruna ogni 4-6 settimane. Quello che è diventato automatico
non serve più tenerlo qui.

---

## `.claudememory`

**Scope**: progetto, dinamico, gitignored — non viene committato.

**Cosa va qui**: stato corrente del progetto aggiornato a ogni sessione via `/memory-update`.
- Decisioni tecniche recenti (con data)
- TODO aperti e TODO completati
- Feature in sviluppo e relativo branch
- Debito tecnico noto

**Perché non in CLAUDE.md**: il CLAUDE.md è statico e condiviso. `.claudememory`
è dinamico — cambia ogni giorno. Mischiare stato dinamico e contratto statico
rende il CLAUDE.md rumoroso e difficile da mantenere sotto i 1500 token.

**Caricamento**: non viene caricato nativamente da Claude Code. L'hook `SessionStart`
lo inietta nel contesto all'avvio della sessione (`session-start.sh`).

---

## `ARCHITECT.md`

**Scope**: progetto, condiviso, generato automaticamente.

**Cosa va qui**: mappa architetturale live del progetto.
- Architettura di alto livello con motivazioni
- Flussi di dati critici
- Pattern identificati e perché
- Debito tecnico e coupling problematico

**Chi lo scrive**: Claude tramite il comando `/architect`. Non modificare manualmente.
L'hook `Stop` lo aggiorna chirurgicamente a fine sessione se qualcosa di strutturale
è cambiato.

**Perché esiste separato da CLAUDE.md**: il CLAUDE.md deve restare corto e sempre
rilevante. L'architettura è densa e cambia — tenerla separata permette di fare
`@ARCHITECT.md` nel CLAUDE.md senza appesantire il token budget di default.

---

## `.claude/rules/*.md`

**Scope**: progetto, condiviso col team, caricato automaticamente per categoria.

**Cosa va qui**: regole tematiche specifiche del progetto.
- `00-architecture.md` — planning protocol, invarianti architetturali
- `01-code-style.md` — type hints, naming, strutture Python
- `02-testing.md` — strategia test, coverage, naming dei test
- `03-git.md` — conventional commits, branch naming, no direct push
- `04-dependencies.md` — toolchain, librerie approvate/vietate

**Cosa NON va qui**: cose che valgono solo per te (→ CLAUDE.local.md) o cose
che valgono su tutti i tuoi progetti (→ ~/.claude/memory.md). Le rules sono
contratto di progetto: se un nuovo engineer clona il repo, deve trovarci le
convenzioni del team, non le tue preferenze personali.

**Path-gating**: una rule può essere attivata solo per certi percorsi con il
frontmatter `path: db/migrations/**`. Usalo per regole molto specifiche che
non devono inquinare ogni sessione.

---

## `.claude/settings.json`

**Scope**: progetto, condiviso col team.

**Cosa va qui**: solo la configurazione degli hook — quale script eseguire,
su quale evento, con quale timeout.

**Cosa NON va qui**: logica degli hook. Quella sta negli script `.sh` in `hooks/`.
Il `settings.json` è solo il punto di aggancio: evento → script.

**Override personale**: se vuoi disabilitare un hook localmente senza committarlo,
crea `.claude/settings.local.json` (gitignored). Ha precedenza su `settings.json`.

---

## `.claude/hooks/*.sh`

**Scope**: progetto, condiviso, eseguiti automaticamente dal sistema — Claude non
può ignorarli o reinterpretarli.

**Cosa va qui**: automazioni deterministiche che devono sempre accadere.
- `session-start.sh` — carica `.claudememory` all'avvio
- `pre-tool-security.sh` — blocca comandi distruttivi prima di eseguirli
- `post-tool-lint.sh` — ruff + mypy su ogni file Python scritto
- `post-batch-check.sh` — mypy cross-file dopo un batch di scritture
- `stop-quality-gate.sh` — pytest prima che Claude concluda la sessione

**Cosa NON va qui**: logica che richiede giudizio (aggiornamento architetturale,
refactoring stilistico). Quella va nei comandi on-demand. Gli hook sono per
cose che devono accadere sempre, senza eccezioni, senza chiedere.

**Regola anti-loop**: ogni hook `Stop` che usa `exit 2` deve controllare
`stop_hook_active` all'inizio, altrimenti Claude entra in loop infinito.

---

## `.claude/skills/*/SKILL.md`

**Scope**: progetto (o globale se in `~/.claude/skills/`), on-demand.

**Cosa va qui**: comandi che hanno side effect o che vuoi attivare solo
su invocazione esplicita, mai per inferenza del modello.
- `/commit` — ha `disable-model-invocation: true`: Claude non lo esegue mai
  da solo, solo se lo digiti tu
- `/summarize-changes` — inietta l'output di `git diff` nel contesto via `!`

**Differenza da commands**: le skills supportano frontmatter avanzato
(`disable-model-invocation`, `allowed-tools`, `agent`) e possono avere
file di supporto nella stessa cartella (template, esempi). Il corpo viene
caricato solo quando invocato — non consuma token a ogni sessione.

**Cosa NON va qui**: automazioni che devono sempre accadere (→ hooks) o
preferenze globali del developer (→ ~/.claude/memory.md).

---

## `.claude/commands/*.md`

**Scope**: progetto, on-demand, struttura più semplice delle skills.

**Cosa va qui**: comandi on-demand senza side effect critici o con side effect
accettabili per inferenza del modello.
- `/architect` — riscansiona il repo e rigenera ARCHITECT.md
- `/pythonic` — refactoring idiomatico Python
- `/docstrings` — aggiunge docstring Google-style
- `/memory-update` — aggiorna `.claudememory` a fine sessione

**Differenza da skills**: file singolo, nessun frontmatter avanzato, nessun
file di supporto. Caricati completamente a session start (consumano più token).
Usa skills quando il comando è complesso, ha side effect forti, o vuoi garantire
che non parta mai per inferenza.

---

## `.claude/agents/*.md`

**Scope**: progetto, on-demand, sottoprocesso con contesto separato.

**Cosa va qui**: task specializzati che non devono "inquinare" la sessione
principale con ricerche massive o analisi su decine di file.
- `code-reviewer.md` — revisione read-only, model: opus, verdict SHIP/FIX/REWORK
- `test-writer.md` — genera test pytest async, model: sonnet

**Perché un agente e non un comando**: un agente può leggere cinquanta file
senza riempire il contesto principale. Ha il suo contesto isolato — un reviewer
che non ha visto l'implementazione non ha bias verso di essa.

**`isolation: worktree`**: opzione frontmatter che fa girare l'agente nel proprio
git worktree. Fondamentale per agenti che fanno migrazioni massive o analisi
che potrebbero modificare file — non interferisce con il lavoro nella sessione principale.
