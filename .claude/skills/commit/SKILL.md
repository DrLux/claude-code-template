---
name: commit
description: Generates a semantic commit message from the diff and asks for confirmation before executing.
             Use when the user wants to commit, prepare a commit, or review staged changes.
disable-model-invocation: true
allowed-tools: Bash
---

Analyze the output of `git diff --staged` (or `git diff HEAD` if nothing is staged).

1. Identify logical changes grouped by type:
   - New features (feat)
   - Bug fixes (fix)
   - Refactoring (refactor)
   - Tests (test)
   - Documentation (docs)

2. Generate a commit message in Conventional Commits format:
   `<type>(<scope>): <description>`
   If changes are heterogeneous, propose multiple atomic commits.

3. Show the proposed message and relevant diff, then ask:
   "Do you want to proceed with this commit? [y/N] — or modify the message:"

4. Run `git commit` ONLY after explicit confirmation.

Never run `git push` autonomously.
