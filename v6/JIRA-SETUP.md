# Jira MCP Integration — Setup Guide (BMAD v6)

## Overview

This guide walks you through setting up optional Jira integration with the BMAD v6 `bmad-create-epics-and-stories` workflow. After setup, you can sync your approved epics and stories to Jira at the end of the workflow by selecting `[J] Sync to Jira` in the final validation step.

**Time to Complete**: 15-20 minutes (one-time setup)

**Integration is completely optional.** The full v6 workflow — parallel BE/FE story generation, Implementation Domains, Data Contracts — works without Jira.

---

## What Gets Synced

| BMAD | Jira |
|------|------|
| Epic | Jira Epic (with Implementation Domain and story list) |
| Standard story | Jira Story (with ACs and Story Domain) |
| Parallel `-BE` story | Jira Story (with Data Contract definition) |
| Parallel `-FE` story | Jira Story (with Data Contract reference and mock note) |

One-way only: BMAD → Jira. The `epics.md` file is always the source of truth.

---

## Part 1: Choose a Jira MCP Server

### Option A: cosmix/jira-mcp (Recommended)

Works with Jira Cloud and Jira Server/Data Center. Simple `npx` setup — no global install needed.

- Repository: `https://github.com/cosmix/jira-mcp`

### Option B: Atlassian Rovo MCP Server (Official, Cloud only)

Official Atlassian solution with OAuth 2.1. More complex setup.

- Repository: `https://github.com/atlassian/atlassian-mcp-server`

**Recommendation:** Use cosmix/jira-mcp for most projects.

---

## Part 2: Obtain Jira Credentials

### For Jira Cloud

#### Step 1: Get Your Jira Site URL

Format: `https://your-company.atlassian.net`

#### Step 2: Create an API Token

1. Go to: `https://id.atlassian.com/manage-profile/security/api-tokens`
2. Click **Create API token**
3. Label it: `BMAD v6 MCP Integration`
4. **Copy the token immediately** — you won't see it again
5. Store it securely

**Security note:** API tokens grant full account access. Never commit them to version control.

#### Step 3: Identify Your Project Key

Look at any Jira issue key — e.g., `MYAPP-123` → project key is `MYAPP`.

Or go to: **Project Settings → Details → Key**

#### Step 4: Note Your Email

The email address associated with your Atlassian account (used with the API token for authentication).

### For Jira Server/Data Center

Use your Jira Server base URL (e.g., `https://jira.your-company.com`) and create a **Personal Access Token** from your profile settings. The process is the same otherwise.

---

## Part 3: Install Node.js (if needed)

`cosmix/jira-mcp` runs via `npx`. Verify Node.js is installed:

```bash
node --version
```

If not installed, download from: `https://nodejs.org/`

---

## Part 4: Configure Cursor MCP Settings

### Locate or Create `~/.cursor/mcp.json`

```bash
# macOS/Linux
nano ~/.cursor/mcp.json

# Windows
notepad %USERPROFILE%\.cursor\mcp.json
```

### Add Jira Configuration

**For Jira Cloud:**

```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "@cosmix/jira-mcp"],
      "env": {
        "JIRA_API_TOKEN": "ATATT3xFfGF0...",
        "JIRA_BASE_URL": "https://your-company.atlassian.net",
        "JIRA_USER_EMAIL": "your-email@company.com"
      }
    }
  }
}
```

**If you already have other MCP servers**, add `jira` alongside them:

```json
{
  "mcpServers": {
    "existing-server": { "...": "..." },
    "jira": {
      "command": "npx",
      "args": ["-y", "@cosmix/jira-mcp"],
      "env": {
        "JIRA_API_TOKEN": "your_token_here",
        "JIRA_BASE_URL": "https://your-company.atlassian.net",
        "JIRA_USER_EMAIL": "your-email@company.com"
      }
    }
  }
}
```

---

## Part 5: Restart Cursor

**Critical:** Cursor must be fully restarted (not just the window) to load the new MCP configuration.

- macOS: `Cmd + Q` → reopen
- Windows: `Alt + F4` → reopen
- Linux: Close all windows → reopen

---

## Part 6: Add Jira Config to Your BMAD Project

Add a `jira:` section to `_bmad/bmm/config.yaml` in your project:

```yaml
# Add to _bmad/bmm/config.yaml

jira:
  # auto-detect reads ~/.cursor/mcp.json — set to false to disable entirely
  enabled: auto-detect

  # Your Jira project key (required) — e.g., "PROJ", "MYAPP"
  projectKey: null

  # Your Jira base URL (required)
  # Cloud:  https://your-company.atlassian.net
  # Server: https://jira.your-company.com
  baseUrl: null

  # Where the BMAD ↔ Jira mapping file is saved
  mappingFile: "{output_folder}/jira-mapping.yaml"

  # Match these to your Jira project's issue types
  # Check: Project Settings → Issue Types
  issueTypes:
    epic: Epic
    story: Story

  # Optional: default assignee (Jira username or email)
  defaultAssignee: null

  # Optional: labels added to all synced issues
  labels: []
```

**Note:** If you skip this step, the workflow will prompt you interactively for `projectKey` and `baseUrl` when you select `[J]`.

---

## Part 7: Verify the Integration

1. Open your BMAD v6 project in Cursor
2. Run the `bmad-create-epics-and-stories` workflow through to Step 4
3. At the final menu, select `[J] Sync to Jira`
4. The workflow will detect Jira MCP, load your config, and begin syncing

**Test Jira MCP is available** (before running the full workflow):

In Cursor chat, type:
```
What Jira MCP tools are available?
```

You should see `jira_create_issue`, `jira_search_issues`, etc.

---

## Part 8: Mapping File

After a successful sync, the mapping file is saved at `{output_folder}/jira-mapping.yaml` (default: `_bmad-output/jira-mapping.yaml`).

**Example:**

```yaml
projectKey: PROJ
baseUrl: https://your-company.atlassian.net
syncedAt: 2026-03-30T10:30:00Z
epics:
  1: PROJ-100
  2: PROJ-101
stories:
  "1.1-BE": PROJ-103
  "1.1-FE": PROJ-104
  "1.2-BE": PROJ-105
  "1.2-FE": PROJ-106
  "2.1": PROJ-107
```

**Optional:** Add to `.gitignore` if you don't want Jira IDs tracked in version control:

```bash
echo "_bmad-output/jira-mapping.yaml" >> .gitignore
```

---

## Troubleshooting

### "Jira MCP not found"

- Verify `~/.cursor/mcp.json` exists with valid JSON
- Validate JSON syntax at: `https://jsonlint.com/`
- Fully quit and reopen Cursor
- Check Cursor logs: `~/Library/Logs/Cursor/` (macOS)

### "Authentication failed" / 401

- Regenerate API token at: `https://id.atlassian.com/manage-profile/security/api-tokens`
- Verify email matches your Atlassian account
- Test manually:
  ```bash
  curl -u your-email@company.com:YOUR_API_TOKEN \
    https://your-company.atlassian.net/rest/api/3/myself
  ```

### "Project not found"

- Verify `projectKey` is uppercase and matches exactly
- Confirm you have access to the project in Jira
- Try navigating to the project in Jira's web UI

### "Cannot create Epic issue type"

- Go to **Project Settings → Issue Types** in Jira
- Update `issueTypes.epic` in `_bmad/bmm/config.yaml` to match exactly

### Issues not linked to Epic

- The workflow tries `parent` field first, then `epicLink`
- If both fail, stories are created unlinked — manually link in Jira

### MCP tools not appearing in Cursor

- Verify Node.js: `node --version`
- Test npx directly: `npx @cosmix/jira-mcp`
- If behind a corporate firewall, configure npm proxy settings

---

## Security Best Practices

- `~/.cursor/mcp.json` contains your API token — **never commit it**
- It lives in your home directory and is not part of any project repo
- Rotate API tokens every 90 days
- Use minimal-permission tokens (read/write issues only)
- Consider adding `_bmad-output/jira-mapping.yaml` to `.gitignore`

---

## Additional Resources

- `jira-utils.md` — Jira MCP patterns reference (in workflow folder)
- `step-04-final-validation.md` — where Jira sync is triggered (select `[J]`)
- `_bmad/bmm/config.yaml` — BMAD v6 project config (add `jira:` section here)
- cosmix/jira-mcp docs: `https://github.com/cosmix/jira-mcp`
- Atlassian API Tokens: `https://id.atlassian.com/manage-profile/security/api-tokens`

---

## Setup Checklist

- [ ] Chosen Jira MCP server (cosmix/jira-mcp recommended)
- [ ] Created Jira API token
- [ ] Identified Jira project key
- [ ] Node.js installed and verified
- [ ] Added `jira` server to `~/.cursor/mcp.json`
- [ ] Restarted Cursor completely
- [ ] Verified Jira MCP tools appear in Cursor
- [ ] Added `jira:` section to `_bmad/bmm/config.yaml`
- [ ] Tested `[J] Sync to Jira` from step-04 final menu
- [ ] Optionally added `jira-mapping.yaml` to `.gitignore`
