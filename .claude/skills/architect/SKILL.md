---
description: Holistic repo analysis and full regeneration of ARCHITECT.md. Auto-triggers on ExitPlanMode; invoke manually with /architect.
---

## Repository Snapshot

!`find . -not -path './.git/*' -not -path './node_modules/*' -not -path './.venv/*' | sort`

!`cat ARCHITECT.md 2>/dev/null || echo "(ARCHITECT.md not found)"`

## Instructions

Act as a Principal Software Architect. Analyze the repository above and regenerate ARCHITECT.md completely, covering:

1. **High-Level Architecture** — identified pattern with motivation.
2. **Semantic Module Map** — what each module represents in the domain.
3. **Critical Data Flows** — path of a request from entry point to response.
4. **Identified Design Patterns** — where and why they were applied.
5. **Key Dependencies** — strong coupling between modules, circular coupling.
6. **Technical Debt** — legacy areas, modules without tests, significant code smells.
7. **Architectural Decisions** — why certain choices were made.

If this skill was triggered by a completed plan (ExitPlanMode), also incorporate the planned changes into the architecture map — treat the approved plan as imminent reality, not speculation.

Completely overwrite ARCHITECT.md with the result.
Use Markdown sections with H2 headings. Technical, dry, precise tone. Update the "Last updated" line with today's date.
