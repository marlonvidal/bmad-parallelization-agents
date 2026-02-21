# BMAD Parallel Agents - Export Package

> **One-command installation system for BMAD agents that support parallel Frontend/Backend development**

## 🚀 Quick Start

Want to use these agents in your project? Run this one command:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export/install-bmad-parallel.sh)
```

---

## 📦 What's Inside

This package contains **5 customized BMAD agents** that enable parallel Frontend/Backend development:

| Agent | Key Feature |
|-------|-------------|
| `architect.md` | Layer-based sharding (frontend/backend separation) |
| `pm.md` | Parallel story generation |
| `po.md` | Parallel story support |
| `developer-front.md` | Frontend-only with contract-based mocks |
| `developer-back.md` | Backend-only with API-first approach |

**Plus:** Automated installation script, testing tools, and complete documentation.

---

## 📖 Documentation

| File | Purpose | Start Here? |
|------|---------|-------------|
| **INDEX.md** | Navigation guide | ⭐ Yes - start here! |
| **OVERVIEW.txt** | Visual package overview | ⭐ Also good! |
| **QUICKSTART.md** | 3-step deployment guide | When ready to deploy |
| **README-export.md** | Complete documentation | For detailed reference |
| **SUMMARY.md** | What was created and why | For understanding |

**Not sure where to start?** Open `INDEX.md` for a complete navigation guide.

---

## ⚡ 3-Step Setup (for maintainers)

### 1. Host on GitHub

```bash
cd bmad-parallel-export
git init
git add .
git commit -m "Add BMAD parallel agents"
git remote add origin https://github.com/marlonvidal/bmad-parallelization-agents.git
git push -u origin main
```

### 2. Update URLs

The installation script is already configured for this repository:

```bash
RAW_REPO_URL="https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export"
```

### 3. Share

Share this command with users:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export/install-bmad-parallel.sh)
```

See **QUICKSTART.md** for detailed instructions.

---

## 🧪 Test Before Deploying

```bash
./test-install.sh
```

This verifies the installation works correctly on your machine before sharing with others.

---

## 🎯 Key Benefits

✅ **Parallel Development** - Frontend & Backend teams work independently  
✅ **One-Command Install** - No manual file management  
✅ **Auto-Backup** - Timestamped backups prevent data loss  
✅ **Safe to Re-run** - Idempotent installation  
✅ **Cross-Platform** - Works on macOS, Linux, Windows (WSL)  
✅ **Version Controlled** - Easy updates for all users  

---

## 📋 Files in This Package

```
bmad-parallel-export/
├── README.md                     ← You are here
├── INDEX.md                      ← Navigation guide (start here!)
├── OVERVIEW.txt                  ← Visual overview
├── QUICKSTART.md                 ← 3-step deployment
├── README-export.md              ← Complete documentation
├── SUMMARY.md                    ← Creation summary
├── install-bmad-parallel.sh      ← Installation script (executable)
├── test-install.sh               ← Testing script (executable)
└── Custom Agents (5 files)
    ├── architect.md
    ├── pm.md
    ├── po.md
    ├── developer-front.md
    └── developer-back.md
```

---

## 💡 How It Works

### For End Users (Installing)

1. User runs the one-line command in their project
2. Script auto-detects BMAD structure
3. Backs up any existing agents
4. Downloads and installs 5 custom agents
5. Done! Ready to use parallel development

### For You (Maintaining)

1. Edit agent files when needed
2. Commit and push to GitHub
3. Users re-run command to get updates
4. Old versions backed up automatically

---

## 🆘 Need Help?

- **First time here?** → Read `INDEX.md`
- **Ready to deploy?** → Read `QUICKSTART.md`
- **Need details?** → Read `README-export.md`
- **Want to test?** → Run `./test-install.sh`

---

## 🎓 What Makes These Agents "Parallel"?

Traditional BMAD creates **vertical-slice stories** where frontend depends on backend completion.

These custom agents create **horizontal-slice stories**:

- **Backend stories**: Implement APIs and database only
- **Frontend stories**: Implement UI/UX with contract-based mocks
- **Result**: Both teams work simultaneously without blockers

See `OVERVIEW.txt` for detailed explanation.

---

## 🔄 Alternative: GitHub Gist

Don't want a full repository? You can also host these files on a GitHub Gist.

See **README-export.md** section "Option 2: GitHub Gist" for instructions.

---

## ✨ Quick Facts

- **Package Size**: ~75KB total
- **Agent Files**: 5 customized markdown files
- **Scripts**: 2 (installer + tester)
- **Documentation**: 6 files (including this one)
- **Installation Time**: < 10 seconds
- **Setup Time**: ~15 minutes (first time)

---

## 🎊 Ready?

1. **New here?** → Open `INDEX.md` or `OVERVIEW.txt`
2. **Ready to deploy?** → Open `QUICKSTART.md`
3. **Want to test first?** → Run `./test-install.sh`

---

**Made with ❤️ for parallel development with BMAD**

