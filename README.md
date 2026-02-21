# BMAD Parallel Agents - Installation Repository

> **Inject parallel Frontend/Backend development capabilities into any BMAD project with one command**

## 🚀 Quick Install

Install these custom BMAD agents in your project:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export/install-bmad-parallel.sh)
```

This will install 5 customized BMAD agents that enable **parallel Frontend/Backend development**.

---

## 📦 What Gets Installed

| Agent | Purpose |
|-------|---------|
| `architect.md` | System architect with layer-based frontend/backend sharding |
| `pm.md` | Product manager that generates parallel frontend/backend stories |
| `po.md` | Product owner with parallel story support |
| `developer-front.md` | Frontend developer that works with contract-based mocks |
| `developer-back.md` | Backend developer with API-first implementation |

---

## 🎯 Key Benefits

✅ **Parallel Development** - Frontend & Backend teams work simultaneously without blockers  
✅ **Contract-Based Development** - Frontend uses mocks based on API contracts  
✅ **Independent Stories** - Backend stories (API/DB) and Frontend stories (UI/UX) are separate  
✅ **Zero Wait Time** - Frontend doesn't wait for backend completion  
✅ **One-Command Install** - No manual file management  

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

## 📚 Documentation

Complete documentation is available in the `bmad-parallel-export/` directory:

- **[README.md](bmad-parallel-export/README.md)** - Main package documentation
- **[QUICKSTART.md](bmad-parallel-export/QUICKSTART.md)** - Quick setup guide
- **[INDEX.md](bmad-parallel-export/INDEX.md)** - Navigation guide
- **[OVERVIEW.txt](bmad-parallel-export/OVERVIEW.txt)** - Visual overview

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
bash <(curl -fsSL https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export/install-bmad-parallel.sh)
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

- **Bash shell** (macOS, Linux, or Windows WSL/Git Bash)
- **curl** or **wget** (one of them)
- **Existing BMAD project** (or will create `.bmad-core/` structure)

---

## 🎊 Get Started

Install in your BMAD project now:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export/install-bmad-parallel.sh)
```

---

**Made with ❤️ for parallel development with BMAD**
