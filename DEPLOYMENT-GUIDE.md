# Deployment Guide

Your repository is ready to push to GitHub!

---

## BMAD v4 — Agent-Level Parallel Approach

**Status: Stable**

### What It Does

Installs 5 custom agents that carry the parallel FE/BE principle as a `core_principle` in their persona, plus enhanced story and PRD templates.

### Deploy

```bash
git add .
git commit -m "Configure BMAD parallel agents for distribution"
git push origin main
```

### Install Command (share with users)

```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/v4/install.sh?$(date +%s)")
```

### Test Locally

```bash
cd v4
./test-install.sh
```

### What Gets Installed

- `{.bmad-core or .bmad}/agents/` — 5 custom agent files
- `{root}/templates/` — enhanced `prd-tmpl.yaml` and `story-tmpl.yaml`
- `{root}/tasks/` — enhanced task overrides

---

## BMAD v6 — Workflow-Level Parallel Approach

**Status: Available**

### What It Does

Overrides 3 step files inside the `bmad-create-epics-and-stories` workflow so that the epic and story creation process itself enforces parallel FE/BE pairing — no agent persona change required.

### Deploy

Same as v4 — push to GitHub:

```bash
git add .
git commit -m "Add BMAD v6 parallel workflow distribution"
git push origin main
```

### Install Command (share with users)

```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/v6/install.sh?$(date +%s)")
```

### What Gets Installed

Target path: `_bmad/bmm/workflows/3-solutioning/bmad-create-epics-and-stories/`

| File | Sub-path |
|------|----------|
| `step-02-design-epics.md` | `steps/` |
| `step-03-create-stories.md` | `steps/` |
| `epics-template.md` | `templates/` |

### Test Locally

Run from a BMAD v6 project root:

```bash
bash /path/to/this/repo/v6/install.sh
```

Or simulate via curl from a local server if needed.

---

## Repository Remote Setup (first time only)

```bash
git remote add origin https://github.com/marlonvidal/bmad-parallelization-agents.git
git branch -M main
git push -u origin main
```

---

## Documentation

- `README.md` — top-level overview with both v4 and v6 install commands
- `v4/README.md` — v4 agent details (generated during earlier session)
- `v6/README.md` — v6 workflow override details
