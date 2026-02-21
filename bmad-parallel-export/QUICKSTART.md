# 🚀 Quick Start Guide - BMAD Parallel Agents Export

## 📦 What You Have

You now have a complete **BMAD Parallel Agents Export System** in the `bmad-parallel-export/` directory!

---

## ⚡ Quick Start (3 Steps)

### Step 1: Host Your Files on GitHub

```bash
# Navigate to the export directory
cd bmad-parallel-export

# Initialize git (if not already a repo)
git init

# Add all files
git add .

# Commit
git commit -m "Add BMAD parallel agents export system"

# Create a repository on GitHub, then:
git branch -M main
git remote add origin https://github.com/marlonvidal/bmad-parallelization-agents.git
git push -u origin main
```

### Step 2: URLs Already Configured

The installation script is already configured with the correct URLs:

```bash
RAW_REPO_URL="https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export"
```

**No changes needed!** The script is ready to use.

### Step 3: Share the Installation Command

Share this one-liner with anyone who wants to use your parallel agents:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export/install-bmad-parallel.sh)
```

---

## 📋 Files in the Export Package

| File | Purpose |
|------|---------|
| `architect.md` | Architect agent with layer-based sharding |
| `pm.md` | Product Manager with parallel story generation |
| `po.md` | Product Owner with parallel story support |
| `developer-front.md` | Frontend-only developer with mocks |
| `developer-back.md` | Backend-only developer with APIs |
| `install-bmad-parallel.sh` | Automated installation script |
| `test-install.sh` | Local testing script |
| `README-export.md` | Complete documentation |
| `SUMMARY.md` | Creation summary |
| `QUICKSTART.md` | This file |

---

## 🧪 Test Locally First (Optional)

Before pushing to GitHub, test the installation locally:

```bash
cd bmad-parallel-export
./test-install.sh
```

This will:
- Create a test project
- Simulate the installation process
- Verify all files are copied correctly
- Show backup functionality

Clean up after testing:
```bash
rm -rf test-project
```

---

## 🎯 How Others Will Use It

### In a New Project

Someone working on a new project can install your parallel agents with one command:

```bash
# Navigate to their project
cd /path/to/their/project

# Run the installation
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/bmad-parallel-export/install-bmad-parallel.sh)
```

### What Happens Automatically

The script will:
1. ✅ Detect if they have `.bmad-core/agents/` or `.bmad/agents/`
2. ✅ Create the directory if it doesn't exist
3. ✅ Backup any existing agent files
4. ✅ Download and install all 5 custom agents
5. ✅ Report success with a summary

---

## 🔄 Updating Agents Later

If you improve the agents:

1. Update the `.md` files in `bmad-parallel-export/`
2. Commit and push to GitHub
3. Users re-run the installation command to get updates

---

## 📚 Documentation

For complete documentation, see:
- **`README-export.md`** - Full usage guide, hosting options, and detailed instructions
- **`SUMMARY.md`** - What was created and why
- **`QUICKSTART.md`** - This file (quick reference)

---

## ✨ Key Features

| Feature | Benefit |
|---------|---------|
| **One-Command Install** | No manual file management |
| **Auto-Backup** | Timestamped backups prevent data loss |
| **Auto-Detection** | Works with `.bmad-core/` or `.bmad/` |
| **Safe to Re-run** | Idempotent (can run multiple times) |
| **Cross-Platform** | macOS, Linux, Windows (WSL/Git Bash) |
| **No Dependencies** | Only needs bash + curl/wget |

---

## 🎊 You're All Set!

Your BMAD parallel agents are now:
- ✅ Packaged and ready to share
- ✅ Documented comprehensively
- ✅ Testable locally
- ✅ Easy to install anywhere
- ✅ Version controlled
- ✅ Automatically backed up on install

---

## 💡 Alternative: Use GitHub Gist

If you prefer not to create a full repository:

1. Go to https://gist.github.com/
2. Add all files from `bmad-parallel-export/`
3. Make it public
4. Update `install-bmad-parallel.sh` with Gist raw URLs
5. Share the Gist installation URL

See `README-export.md` for detailed Gist instructions.

---

## 🆘 Need Help?

- **Installation Issues**: Check `README-export.md` for troubleshooting
- **Testing**: Run `./test-install.sh` to verify locally
- **Customization**: Edit the agent `.md` files and re-commit

---

**Happy parallel developing! 🚀**
