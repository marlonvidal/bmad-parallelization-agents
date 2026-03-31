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

Six files are placed into your project's `bmad-create-epics-and-stories` workflow:

| File | Target Path | What Changes |
|------|-------------|--------------|
| `step-02-design-epics.md` | `.../steps/` | Epics are classified with an **Implementation Domain** (`Full-Stack`, `Backend-Only`, `Frontend-Only`, `Non-Technical`) |
| `step-03-create-stories.md` | `.../steps/` | Full-Stack epics automatically produce **paired BE/FE stories** instead of vertical slices |
| `step-04-final-validation.md` | `.../steps/` | Validation + optional **`[J] Sync to Jira`** at the end of the workflow |
| `epics-template.md` | `.../templates/` | Story blocks include `Story Domain`, `Paired Story`, `Data Contract`, and `Blocking Dependencies` fields |
| `jira-utils.md` | `.../ ` | Jira MCP patterns reference used by step-04 |
| `JIRA-SETUP.md` | `.../` | One-time Jira MCP setup guide |

All files install into: `_bmad/bmm/3-solutioning/bmad-create-epics-and-stories/`

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

### Step 4 — Final Validation (new)
- Validates FR coverage, story quality, dependency ordering, and parallel pair correctness
- Adds an optional **`[J] Sync to Jira`** menu item at the end
- Selecting `[J]` syncs all approved epics and stories to Jira (see below)

---

## Optional: Jira Integration

Jira sync is **disabled by default** and has no effect if not configured. It requires a Jira MCP server to be set up in Cursor.

### How It Works

At the end of Step 4, the workflow presents:

```
[J] Sync to Jira (optional)   [C] Complete Workflow
```

When `[J]` is selected:
1. Checks `~/.cursor/mcp.json` for a configured Jira MCP server
2. Reads your Jira config from `_bmad/bmm/config.yaml` (or prompts if missing)
3. Parses the approved `epics.md` and creates Jira Epics and Stories
4. Parallel BE/FE pairs are synced as separate Jira Stories with Data Contract and Paired Story fields in their descriptions
5. Saves a mapping file at `{output_folder}/jira-mapping.yaml`
6. Displays a summary table with clickable Jira links

### Jira Config (add to `_bmad/bmm/config.yaml`)

```yaml
jira:
  enabled: auto-detect
  projectKey: PROJ         # your Jira project key
  baseUrl: https://your-company.atlassian.net
  mappingFile: "{output_folder}/jira-mapping.yaml"
  issueTypes:
    epic: Epic
    story: Story
  defaultAssignee: null
  labels: []
```

### Setup Guide

Full setup instructions (API token, MCP server install, Cursor config):

```
_bmad/bmm/3-solutioning/bmad-create-epics-and-stories/JIRA-SETUP.md
```

This file is installed by the installer. Setup takes about 15-20 minutes (one-time).

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
_bmad/bmm/3-solutioning/bmad-create-epics-and-stories/.backup-YYYYMMDD-HHMMSS/
```

Copy the backed-up files back to `steps/` and `templates/` to restore originals.

---

## See Also

- [v4 distribution](../v4/) — Agent-level parallel approach for BMAD v4
- [BMAD v6 docs](https://docs.bmad-method.org)
