# BMAD Parallel Agents — v6

> Inject parallel Frontend/Backend story generation into any BMAD v6 project with one command.

**Compatible with: BMAD v6.x**

---

## Quick Install

```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/v6/install.sh?$(date +%s)")
```

Run from the root of your BMAD v6 project. The `?$(date +%s)` parameter bypasses caches to always fetch the latest version.

---

## What Gets Installed

Three files are placed into your project's `bmad-create-epics-and-stories` workflow:

| File | Target Path | What Changes |
|------|-------------|--------------|
| `step-02-design-epics.md` | `_bmad/bmm/workflows/3-solutioning/bmad-create-epics-and-stories/steps/` | Epics are classified with an **Implementation Domain** (`Full-Stack`, `Backend-Only`, `Frontend-Only`, `Non-Technical`) |
| `step-03-create-stories.md` | `_bmad/bmm/workflows/3-solutioning/bmad-create-epics-and-stories/steps/` | Full-Stack epics automatically produce **paired BE/FE stories** instead of vertical slices |
| `epics-template.md` | `_bmad/bmm/workflows/3-solutioning/bmad-create-epics-and-stories/templates/` | Story blocks include `Story Domain`, `Paired Story`, `Data Contract`, and `Blocking Dependencies` fields |

---

## How It Works

### Before (vertical slice)

```
Story 1.1: User Login
  As a user, I want to log in
  → Implements: frontend form + backend API + database — one story, sequential
```

### After (parallel pair)

```
Story 1.1-BE: User Login – Backend
  Story Domain: Backend
  Paired Story: 1.1-FE
  Data Contract: POST /auth/login → { token, user }
  → Implements: API endpoint + DB schema only. Defines the contract.

Story 1.1-FE: User Login – Frontend
  Story Domain: Frontend
  Paired Story: 1.1-BE
  Data Contract: POST /auth/login (mock from 1.1-BE contract)
  → Implements: login form using mocked contract. Never blocked by 1.1-BE.
```

Both stories can be worked simultaneously by independent dev agents.

---

## Workflow Change Summary

### Step 2 — Design Epics (new)
Each epic now includes an **Implementation Domain** that controls how stories are generated:

- `Full-Stack` → paired `-BE` / `-FE` stories in Step 3
- `Backend-Only` / `Frontend-Only` / `Non-Technical` → standard single stories

### Step 3 — Create Stories (new)
- Full-Stack epics: generates a **Backend story** (API + DB, outputs Data Contract) paired with a **Frontend story** (UI using mocked contract)
- Vertical-slice stories for Full-Stack features are **FORBIDDEN**
- Single-domain epics: unchanged behavior

---

## Prerequisites

- BMAD v6 installed (`_bmad/` folder present in project root)
- Bash shell (macOS, Linux, or Windows WSL/Git Bash)
- `curl` or `wget`

---

## Reverting

The installer backs up your original files with a timestamp before overwriting. To revert:

```bash
# Backup is at:
_bmad/bmm/workflows/3-solutioning/bmad-create-epics-and-stories/.backup-YYYYMMDD-HHMMSS/
```

Copy the backed-up files back to `steps/` and `templates/` to restore originals.

---

## See Also

- [v4 distribution](../v4/) — Agent-level parallel approach for BMAD v4
- [BMAD v6 docs](https://docs.bmad-method.org)
