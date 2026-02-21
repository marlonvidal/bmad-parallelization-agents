# BMAD Parallel Agents - Export Package

This directory contains customized BMAD agents that support **parallel Frontend/Backend development**. These agents can be injected into any existing or new BMAD project.

## 📦 What's Included

This export package contains the following customized agent files:

- **`architect.md`** - Holistic system architect with frontend/backend sharding principles
- **`pm.md`** - Product manager with parallel story generation
- **`po.md`** - Product owner with parallel story support
- **`developer-front.md`** - Frontend-only developer with contract-based mocks
- **`developer-back.md`** - Backend-only developer with API-first approach
- **`install-bmad-parallel.sh`** - Automated installation script

## 🎯 Key Modifications for Parallel Development

These custom agents include the following enhancements:

### Architect (`architect.md`)
- **Layer-Based Sharding**: Explicitly divides architecture into Frontend and Backend domains
- **API-First and Upfront Contracts**: Strictly defines API contracts before implementation

### PM & PO (`pm.md`, `po.md`)
- **Story Parallelization**: Creates paired Backend stories (API/database) and Frontend stories (UI/UX with mocks) that are independent

### Developer-Front (`developer-front.md`)
- **Frontend-only scope**: Implements ONLY frontend stories and code
- **Contract-driven mocks**: Uses architect-defined API contracts to create mocks when backend isn't ready
- **Reads ONLY `-frontend.md` shards**: Ignores backend architecture/story shards

### Developer-Back (`developer-back.md`)
- **Backend-only scope**: Implements ONLY backend stories and APIs
- **API contract fidelity**: Delivers APIs exactly as architected
- **Reads ONLY `-backend.md` shards**: Ignores frontend architecture/story shards

## 🚀 How to Host These Files

You have two main options for hosting these files:

### Option 1: GitHub Repository (Recommended)

1. **Create a new GitHub repository** (or use an existing one):
   ```bash
   # Create a new repo on GitHub, then:
   git init
   git add .
   git commit -m "Add BMAD parallel agents export"
   git branch -M main
   git remote add origin https://github.com/marlonvidal/bmad-parallelization-agents.git
   git push -u origin main
   ```

2. **Get the raw URL format**:
   - Your files will be accessible at:
     ```
     https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export/FILENAME.md
     ```

3. **Installation script is already configured**:
   - The URLs are already set in `install-bmad-parallel.sh`:
     ```bash
     RAW_REPO_URL="https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export"
     ```

4. **Commit and push** to GitHub:
   ```bash
   git add .
   git commit -m "Add BMAD parallel agents"
   git push
   ```

### Option 2: GitHub Gist

1. **Create a new Gist** at https://gist.github.com/

2. **Add each file** to the Gist:
   - `architect.md`
   - `pm.md`
   - `po.md`
   - `developer-front.md`
   - `developer-back.md`
   - `install-bmad-parallel.sh`

3. **Make it public** and save

4. **Get raw URLs** for each file:
   - Click "Raw" button next to each file
   - Copy the URL (format: `https://gist.githubusercontent.com/YOUR_USER/GIST_ID/raw/...`)

5. **Update the installation script** with the Gist base URL

## 📥 How to Use the Installation Script in a New Project

Once you've hosted the files, users can install the custom agents in their projects using one of these methods:

### Method 1: Direct Install (One-Liner)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/bmad-parallel-export/install-bmad-parallel.sh)
```

### Method 2: Download and Run

```bash
# Download the script
curl -O https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/bmad-parallel-export/install-bmad-parallel.sh

# Make it executable
chmod +x install-bmad-parallel.sh

# Run it
./install-bmad-parallel.sh
```

### Method 3: Clone and Install Locally

```bash
# Clone your repository
git clone https://github.com/YOUR_USER/YOUR_REPO.git

# Navigate to the export directory
cd YOUR_REPO/bmad-parallel-export

# Run the installation script from your target project
cd /path/to/target/project
bash /path/to/YOUR_REPO/bmad-parallel-export/install-bmad-parallel.sh
```

## 🔧 What the Installation Script Does

The `install-bmad-parallel.sh` script automatically:

1. **Detects** the BMAD configuration directory (`.bmad-core/agents/` or `.bmad/agents/`)
2. **Creates** the directory structure if it doesn't exist
3. **Backs up** existing agent files (if any) to a timestamped backup folder
4. **Downloads** all custom agent files using `curl` or `wget`
5. **Installs** the files into the target project's BMAD directory
6. **Reports** success/failure with clear status messages

## ⚙️ Installation Script Requirements

The script requires:
- **Bash shell** (pre-installed on macOS/Linux, available on Windows via WSL/Git Bash)
- **curl** or **wget** (one of them must be installed)
- **Write permissions** in the target project directory

## 🎨 Customization

If you need to customize the agents further:

1. **Edit the agent files** in this directory
2. **Commit and push** your changes
3. **Re-run the installation script** in target projects to get the updates

## 📝 Notes

- The installation script uses **timestamped backups** to prevent data loss
- If a download fails, the script will report the error and preserve backups
- The script is **idempotent** - you can run it multiple times safely
- All agent files are copied (not moved) so this project continues working

## 🤝 Sharing with Others

To share this installation method with your team:

1. Host the files on GitHub (as described above)
2. Update the `install-bmad-parallel.sh` with your actual URLs
3. Share the one-liner command:
   ```bash
   bash <(curl -fsSL https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export/install-bmad-parallel.sh)
   ```

## 🔄 Updates and Maintenance

When you update the agent files:
1. Commit and push changes to your repository
2. Users can re-run the installation script to get the latest version
3. Old versions are automatically backed up

---

**Made with ❤️ for parallel Frontend/Backend development using BMAD**
