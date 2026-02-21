# BMAD Parallel Agents - Export Package Index

**⚠️ BMAD v4.x Compatible** | *A v6.x version will be implemented later*

## 🎯 Start Here

If you're new to this export package, **read the files in this order:**

1. **OVERVIEW.txt** ← Start here for a visual overview
2. **QUICKSTART.md** ← 3-step setup guide
3. **README-export.md** ← Complete documentation

---

## 📁 Files in This Package

### 🚀 Getting Started Documentation

| File | Purpose | When to Read |
|------|---------|--------------|
| **OVERVIEW.txt** | Visual overview with ASCII art | First! Quick understanding of what you have |
| **QUICKSTART.md** | 3-step setup guide | When ready to deploy (5 min read) |
| **INDEX.md** | This file - navigation guide | When you need to find something |

### 📖 Complete Documentation

| File | Purpose | When to Read |
|------|---------|--------------|
| **README-export.md** | Complete usage guide | For detailed instructions on hosting & sharing |
| **SUMMARY.md** | Creation summary & verification | To understand what was built and why |

### 🔧 Installation & Testing

| File | Type | Purpose |
|------|------|---------|
| **install-bmad-parallel.sh** | Bash Script (executable) | Production installer for end users |
| **test-install.sh** | Bash Script (executable) | Local testing before deployment |

### 🤖 Custom Agent Files

| File | Size | Agent Role |
|------|------|------------|
| **architect.md** | 5.8K | System architect with frontend/backend sharding |
| **pm.md** | 5.1K | Product manager with parallel story generation |
| **po.md** | 5.5K | Product owner with parallel story support |
| **developer-front.md** | 7.3K | Frontend developer with contract-based mocks |
| **developer-back.md** | 7.2K | Backend developer with API-first approach |

---

## 🎓 Usage Scenarios

### Scenario 1: First Time Setup
**Goal:** Deploy this package to GitHub and start sharing

**Read:**
1. OVERVIEW.txt (2 min)
2. QUICKSTART.md (5 min)
3. Follow the 3 steps in QUICKSTART.md

**You'll be done in:** ~15 minutes

---

### Scenario 2: Understanding What Was Created
**Goal:** Understand what's in this package and why

**Read:**
1. OVERVIEW.txt
2. SUMMARY.md
3. Browse the custom agent .md files

**You'll understand:** All modifications for parallel development

---

### Scenario 3: Hosting Options & Detailed Setup
**Goal:** Explore different hosting options (GitHub vs Gist)

**Read:**
1. README-export.md (complete guide)
2. Section: "How to Host These Files"
3. Section: "How to Use the Installation Script"

**You'll know:** All hosting and usage options

---

### Scenario 4: Testing Before Deployment
**Goal:** Verify the installation works locally before sharing

**Do:**
1. Read QUICKSTART.md (testing section)
2. Run: `./test-install.sh`
3. Verify output
4. Clean up: `rm -rf test-project`

**You'll confirm:** Installation script works correctly

---

### Scenario 5: Sharing with Your Team
**Goal:** Get the installation command to share

**Do:**
1. Host on GitHub (see QUICKSTART.md)
2. Update URLs in `install-bmad-parallel.sh`
3. Get the one-liner from QUICKSTART.md
4. Share with team

**Your team gets:** One command to install everything

---

### Scenario 6: Customizing the Agents
**Goal:** Modify agents for your specific needs

**Do:**
1. Edit the agent .md files (architect.md, pm.md, etc.)
2. Commit and push to your repository
3. Users re-run installation to get updates

**Result:** Updated agents available to all users

---

## 🔍 Quick Reference

### Requirements
```
Total package: ~52KB
- Agent files: 36.9K (5 files)
- Scripts: 9.9K (2 files)  
- Docs: 18.0K (4 files)

Compatible with: BMAD v4.x
Note: v6.x version coming later
```
- **Bash shell** (macOS/Linux/WSL)
- **curl** or **wget**
- **Git** (for hosting on GitHub)
- **Write permissions** (in target projects)

### Key URLs to Update

After creating your GitHub repository, update these:

**In `install-bmad-parallel.sh` (line 20):**
```bash
RAW_REPO_URL="https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/bmad-parallel-export"
```

**In `README-export.md` (examples throughout):**
Replace `YOUR_USER` and `YOUR_REPO` with your GitHub info.

---

## 📞 Quick Answers

### Q: How do I deploy this?
**A:** Read QUICKSTART.md and follow the 3 steps.

### Q: What makes these agents "parallel"?
**A:** See OVERVIEW.txt section "KEY MODIFICATIONS FOR PARALLEL DEVELOPMENT"

### Q: Can I test before deploying?
**A:** Yes! Run `./test-install.sh`

### Q: How do users install in their projects?
**A:** One command: `bash <(curl -fsSL YOUR_URL/install-bmad-parallel.sh)`

### Q: Are my original files safe?
**A:** Yes! Files were copied (not moved). See SUMMARY.md verification section.

### Q: Can I use GitHub Gist instead of a repo?
**A:** Yes! See README-export.md "Option 2: GitHub Gist"

### Q: How do I update agents later?
**A:** Edit files, commit, push. Users re-run installer.

---

## 🎯 Common Tasks

### Deploy to GitHub
```bash
cd bmad-parallel-export
git init
git add .
git commit -m "Add BMAD parallel agents"
git remote add origin https://github.com/marlonvidal/bmad-parallelization-agents.git
git push -u origin main
```

### Test Locally
```bash
cd bmad-parallel-export
./test-install.sh
```

### Update URLs in Script
```bash
# Already configured - no changes needed!
RAW_REPO_URL="https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export"
```

### Share Installation Command
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export/install-bmad-parallel.sh)
```

---

## 🎊 Summary

You have a **complete, production-ready export system** that:

✓ Packages 5 custom agents for parallel Frontend/Backend development  
✓ Provides one-command installation  
✓ Includes automatic backup and safety features  
✓ Works with any BMAD project structure  
✓ Is fully documented and tested  
✓ Can be hosted on GitHub or Gist  
✓ Is ready to share with your team or the community  

**Next step:** Read QUICKSTART.md and deploy!

---

**Made with ❤️ for parallel development with BMAD**
