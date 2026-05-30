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
`/commit` che presenta il diff e chiede conferma umana.

## Branch naming
- Feature: `feat/<short-description>`
- Bug fix: `fix/<short-description>`
- Refactoring: `refactor/<short-description>`
- Release: `release/<version>`

## Worktrees per sessioni parallele
```bash
git worktree add ../project-feat-auth feat/auth
git worktree add ../project-feat-billing feat/billing
```
Ogni sessione Claude lavora nel proprio worktree isolato.
