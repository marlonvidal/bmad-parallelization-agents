# BMAD Parallel Agents - Installation Repository

> **Inject parallel Frontend/Backend development capabilities into any BMAD project with one command**

**⚠️ BMAD v4.x Compatible** | *A v6.x version will be implemented later*

## 🚀 Quick Install

Install these custom BMAD agents in your project:

```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export/install-bmad-parallel.sh?$(date +%s)")
```

> **Note:** The `?$(date +%s)` parameter ensures you always get the latest version by bypassing any caches.

This will install 5 customized BMAD agents that enable **parallel Frontend/Backend development**.

---

## 📦 What Gets Installed

| Agent | Purpose |
|-------|---------|
| `architect.md` | System architect with layer-based frontend/backend sharding |
| `pm.md` | Product manager that generates parallel frontend/backend stories **+ Epic Dependency Tracking** |
| `po.md` | Product owner with parallel story support **+ Dependency Validation** |
| `developer-front.md` | Frontend developer that works with contract-based mocks |
| `developer-back.md` | Backend developer with API-first implementation |

**Enhanced Templates (overrides `.bmad-core/templates/`):**
- `prd-tmpl.yaml` - **NEW: Epic Dependency Graph section**
- `story-tmpl.yaml` - **NEW: Standardized Dependency Format**

**Enhanced Tasks (overrides `.bmad-core/tasks/`):**
- `validate-dependencies.md` - **NEW: Validate circular dependencies**
- `create-dependency-map.md` - **NEW: Generate visual Mermaid diagrams**

---

## 🎯 Key Benefits

✅ **Parallel Development** - Frontend & Backend teams work simultaneously without blockers  
✅ **Contract-Based Development** - Frontend uses mocks based on API contracts  
✅ **Independent Stories** - Backend stories (API/DB) and Frontend stories (UI/UX) are separate  
✅ **Zero Wait Time** - Frontend doesn't wait for backend completion  
✅ **Epic Dependency Tracking** - Visual graphs showing which epics can run in parallel  
✅ **Dependency Validation** - Automated checks for circular dependencies  
✅ **Standardized Format** - Clear `[Epic.Story] (Domain): Reason` dependency notation  
✅ **One-Command Install** - No manual file management

---

## 🆕 What's New in v2.1

### Epic Dependency Graph
A new section in PRDs that explicitly documents which epics can run in parallel:

| Epic | Prerequisite Epics | Can Parallel With | Rationale |
|------|-------------------|------------------|-----------|
| Epic 1 | None | All (once contracts defined) | Foundation setup |
| Epic 2 | Epic 1 | Epic 3, 4 | Requires auth; independent domain |
| Epic 3 | Epic 1 | Epic 2, 4 | Independent feature domain |

### Standardized Dependency Format
Enhanced story dependencies with clear, parseable format:

```markdown
- **Blocking Dependencies**: 
  - Frontend: None (uses mocked auth from contract)
  - Backend: 1.4 (Backend): Requires authentication middleware
```

### New PM/PO Commands
- `*validate-dependencies` - Check for circular dependencies
- `*create-dependency-map` - Generate visual Mermaid diagrams

---

## 📖 How It Works

### Traditional BMAD (Vertical Slices)
- Stories are end-to-end (frontend depends on backend)
- Frontend team waits for backend APIs
- Sequential development causes delays

### BMAD Parallel Agents (Horizontal Slices)
- **Backend stories**: Implement APIs and database only
- **Frontend stories**: Implement UI/UX with mocked data
- Teams work simultaneously using architect-defined API contracts
- Integration happens after both sides are complete

---

## 🛠️ Installation Details

The installation script automatically:

1. Detects your BMAD directory (`.bmad-core/agents/` or `.bmad/agents/`)
2. Creates the directory if it doesn't exist
3. Backs up any existing agent files (timestamped)
4. Downloads and installs all 5 custom agents
5. Reports success with a summary

**Safe to re-run** - It's idempotent and creates backups.

---

## 📋 Repository Structure

This repository serves as a **distribution point** for the custom BMAD agents:

```
bmad-parallelization-agents/
├── README.md                    ← You are here
├── .bmad-core/                  ← Reference BMAD configuration
│   └── agents/                  ← Original custom agents (source)
├── .cursor/                     ← Cursor IDE configuration
└── bmad-parallel-export/        ← Distribution package
    ├── README.md                ← Package documentation
    ├── install-bmad-parallel.sh ← Installation script
    ├── architect.md             ← Custom agents (copied for distribution)
    ├── pm.md
    ├── po.md
    ├── developer-front.md
    └── developer-back.md
```

---

---

## 📚 Documentation

For developers wanting to understand the implementation details, check the source files:
- Agent definitions: `.bmad-core/agents/*.md`
- Enhanced templates: `.bmad-core/templates/*.yaml`
- Validation tasks: `.bmad-core/tasks/*.md`

---

## 🧪 Test Before Using

Want to test locally before installing in your actual project?

```bash
cd bmad-parallel-export
./test-install.sh
```

This creates a test project and verifies the installation works correctly.

---

## 🔄 Updating

If you pull updates to this repository, just re-run the installation command in your project:

```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export/install-bmad-parallel.sh?$(date +%s)")
```

Your existing agents will be backed up automatically.

---

## 💡 Example Workflow

### 1. Architect Creates Architecture
- Defines API contracts upfront
- Shards architecture into `-frontend.md` and `-backend.md` files

### 2. PM/PO Creates Parallel Stories
- **Backend Story**: "Implement User Authentication API and Database Schema"
- **Frontend Story**: "Build Login UI with Mocked Auth Service"

### 3. Teams Work in Parallel
- **Backend Developer**: Implements API endpoints and database exactly per contract
- **Frontend Developer**: Builds UI using contract-based mocks
- No waiting, no blockers

### 4. Integration
- Backend completes API
- Frontend swaps mocks for real API calls
- Integration is smooth because contracts were followed

---

## 🆘 Support

- **Installation Issues**: See [README-export.md](bmad-parallel-export/README-export.md)
- **Understanding the Agents**: See [OVERVIEW.txt](bmad-parallel-export/OVERVIEW.txt)
- **Quick Setup**: See [QUICKSTART.md](bmad-parallel-export/QUICKSTART.md)

---

## 📝 Requirements

- **BMAD v4.x** - This patch is compatible with BMAD version 4.x
- **Bash shell** (macOS, Linux, or Windows WSL/Git Bash)
- **curl** or **wget** (one of them)
- **Existing BMAD project** (or will create `.bmad-core/` structure)

> **Note**: A version compatible with BMAD v6.x is planned for future implementation.

---

## 🎊 Get Started

Install in your BMAD project now:

```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export/install-bmad-parallel.sh?$(date +%s)")
```

---

**Made with ❤️ for parallel development with BMAD**
