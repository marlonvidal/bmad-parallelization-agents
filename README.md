# BMAD Parallel Agents - Installation Repository

> **Inject parallel Frontend/Backend development capabilities into any BMAD project with one command**

---

## Choose Your Version

| Version | BMAD Compatibility | Approach | Status |
|---------|-------------------|----------|--------|
| **v6** | BMAD v6.x | Workflow-level — parallel pairing built into `bmad-create-epics-and-stories` | **Available** |
| **v4** | BMAD v4.x | Agent-level — parallel principle baked into PM/PO/Architect personas | Stable |

---

## BMAD v6 — Quick Install

```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/v6/install.sh?$(date +%s)")
```

Run from the root of your BMAD v6 project.

### What Gets Installed (v6)

Three files are placed into your `bmad-create-epics-and-stories` workflow:

| File | Target |
|------|--------|
| `step-02-design-epics.md` | `_bmad/bmm/workflows/3-solutioning/bmad-create-epics-and-stories/steps/` |
| `step-03-create-stories.md` | `_bmad/bmm/workflows/3-solutioning/bmad-create-epics-and-stories/steps/` |
| `epics-template.md` | `_bmad/bmm/workflows/3-solutioning/bmad-create-epics-and-stories/templates/` |

### How v6 Works

**Step 2 — Design Epics:** Each epic is classified with an **Implementation Domain**:
- `Full-Stack` → Step 3 will generate paired BE/FE stories
- `Backend-Only` / `Frontend-Only` / `Non-Technical` → standard single stories

**Step 3 — Create Stories:** Full-Stack epics automatically produce parallel story pairs:

```
Story 1.1-BE: User Login – Backend
  Story Domain: Backend
  Paired Story: 1.1-FE
  Data Contract: POST /auth/login → { token, user }
  → API + DB only. Defines the contract. No UI.

Story 1.1-FE: User Login – Frontend
  Story Domain: Frontend
  Paired Story: 1.1-BE
  Data Contract: POST /auth/login (mock from 1.1-BE)
  → UI form using mocked contract. Never blocked by 1.1-BE.
```

Vertical-slice stories for Full-Stack features are **FORBIDDEN**.

---

## BMAD v4 — Quick Install

```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/v4/install.sh?$(date +%s)")
```

Run from the root of your BMAD v4 project.

### What Gets Installed (v4)

| Agent | Purpose |
|-------|---------|
| `architect.md` | System architect with layer-based frontend/backend sharding |
| `pm.md` | Product manager that generates parallel frontend/backend stories + Epic Dependency Tracking |
| `po.md` | Product owner with parallel story support + Dependency Validation |
| `developer-front.md` | Frontend developer that works with contract-based mocks |
| `developer-back.md` | Backend developer with API-first implementation |

**Enhanced Templates (overrides `.bmad-core/templates/`):**
- `prd-tmpl.yaml` — Epic Dependency Graph section
- `story-tmpl.yaml` — Standardized Dependency Format

**Enhanced Tasks (overrides `.bmad-core/tasks/`):**
- `validate-dependencies.md` — Validate circular dependencies
- `create-dependency-map.md` — Generate visual Mermaid diagrams

---

## Key Benefits (Both Versions)

- **Parallel Development** — Frontend & Backend teams work simultaneously without blockers
- **Contract-Based Development** — Frontend uses mocks based on API contracts defined by Backend stories
- **Independent Stories** — Backend stories (API/DB) and Frontend stories (UI/UX) are separate work units
- **Zero Wait Time** — Frontend never waits for backend completion
- **One-Command Install** — No manual file management, automatic backup of originals

---

## v4 vs v6: Key Differences

| | v4 | v6 |
|---|---|---|
| **Where parallel logic lives** | Agent personas (`core_principles`) | Workflow step files |
| **Survives BMAD updates?** | No — agent files get overwritten | No — workflow files get overwritten (reinstall to re-apply) |
| **Requires custom agents?** | Yes — 5 custom agents | No — any agent running the workflow picks it up |
| **Granularity** | Epic + story template + agent behavior | Step-by-step workflow instructions + template |
| **Story format** | `story-tmpl.yaml` with `dependencies-parallelism` section | `epics.md` with `Story Domain`, `Paired Story`, `Data Contract`, `Blocking Dependencies` |

---

## How Parallel Development Works

### Traditional BMAD (Vertical Slices)
- Stories are end-to-end (frontend depends on backend)
- Frontend team waits for backend APIs
- Sequential development causes delays

### BMAD Parallel Agents (Horizontal Slices)
- **Backend stories**: Implement APIs and database only, define the Data Contract
- **Frontend stories**: Implement UI/UX with mocked contract-based data
- Teams work simultaneously — integration happens after both sides are complete

---

## Repository Structure

```
bmad-parallelization-agents/
├── README.md                        ← You are here
├── DEPLOYMENT-GUIDE.md              ← How to push and share
├── _bmad/                           ← Live BMAD v6 installation (reference only — do not edit)
├── .cursor/                         ← Cursor IDE configuration and skills
├── v4/                              ← BMAD v4 distribution package
│   ├── install.sh                   ← v4 installation script
│   ├── architect.md                 ← Custom agents
│   ├── pm.md
│   ├── po.md
│   ├── developer-front.md
│   ├── developer-back.md
│   ├── story-tmpl.yaml
│   └── prd-tmpl.yaml
└── v6/                              ← BMAD v6 distribution package
    ├── install.sh                   ← v6 installation script
    ├── README.md                    ← v6-specific docs
    └── workflows/
        ├── steps/
        │   ├── step-02-design-epics.md
        │   └── step-03-create-stories.md
        └── templates/
            └── epics-template.md
```

---

## Requirements

**v6:**
- BMAD v6.x installed (`_bmad/` folder with `bmm` module present)
- Bash shell (macOS, Linux, or Windows WSL/Git Bash)
- `curl` or `wget`

**v4:**
- BMAD v4.x installed (`.bmad-core/` or `.bmad/` folder present)
- Bash shell (macOS, Linux, or Windows WSL/Git Bash)
- `curl` or `wget`

---

## Updating

Re-run the install command to get the latest version. Originals are backed up automatically before each install.

---

**Made with ❤️ for parallel development with BMAD**
