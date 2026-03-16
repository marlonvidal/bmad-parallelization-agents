# BMAD Parallel Agents — v6

> **Status: Coming Soon** — Implementation is planned once BMAD v6 is stable.

This folder will contain the distribution package for the BMAD v6 version of the parallel Frontend/Backend agents.

---

## BMAD v6 Folder Conventions

Per the [official upgrade guide](https://docs.bmad-method.org/how-to/upgrade-to-v6/), v6 uses a unified `_bmad/` structure:

| Artifact | v6 Target Path |
|---|---|
| Custom agents | `_bmad/_config/agents/` |
| Module config | `_bmad/_config/config.yaml` |
| Output / planning docs | `_bmad-output/planning-artifacts/` |
| Framework core | `_bmad/core/` |
| BMad Method module | `_bmad/bmm/` |

The v6 install script in this folder will target `_bmad/_config/agents/` for all custom parallel agent overrides.

---

## Planned Install Command

```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/v6/install.sh?$(date +%s)")
```

---

## Prerequisites (v6)

- BMAD v6 installed (`_bmad/` folder present in project)
- Node.js 20+
- Bash shell (macOS, Linux, or Windows WSL/Git Bash)
- `curl` or `wget`

---

## See Also

- [v4 distribution](../v4/) — Current stable release for BMAD v4
- [BMAD v6 upgrade guide](https://docs.bmad-method.org/how-to/upgrade-to-v6/)
