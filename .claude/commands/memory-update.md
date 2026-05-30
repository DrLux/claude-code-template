---
name: memory-update
description: Updates .claudememory with decisions and tasks completed in the session
---

Analyze the current session and update `.claudememory`:

1. Add to "Recent Technical Decisions" the choices made today (with date).
2. Mark resolved TODOs as completed [x].
3. Add new TODOs identified during work.
4. Update "Features in Development" with the current status.

Do not delete history: add at the top of sections.
Keep the file under 100 lines: archive decisions > 30 days in an
`## Archive` block at the bottom.
