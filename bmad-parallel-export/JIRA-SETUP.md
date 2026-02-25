# <!-- Powered by BMAD™ Core -->

# Jira MCP Integration - Complete Setup Guide

## Overview

This guide walks you through setting up Jira integration with BMAD parallel agents. After completing these steps, you'll be able to sync PRD epics and stories directly to Jira from both PM and SM agents.

**Time to Complete**: 15-20 minutes

**Prerequisites**:
- Jira Cloud account (or Jira Server/Data Center)
- Admin access to create API tokens
- Node.js installed (for MCP server)
- Cursor IDE installed

---

## Part 1: Choose a Jira MCP Server

You need an MCP (Model Context Protocol) server to bridge Cursor and Jira. Two main options:

### Option A: cosmix/jira-mcp (Recommended for Simplicity)

**Pros**:
- Works with both Jira Cloud and Server/Data Center
- Simple npx installation (no global install needed)
- Active development and community support
- Full feature set: search, CRUD, comments, attachments

**Cons**:
- Community project (not official Atlassian)

**Repository**: `https://github.com/cosmix/jira-mcp`

### Option B: Atlassian Rovo MCP Server (Official)

**Pros**:
- Official Atlassian solution
- OAuth 2.1 authorization
- Enterprise support

**Cons**:
- More complex setup
- Requires OAuth configuration
- Cloud-only (no Server/Data Center support)

**Repository**: `https://github.com/atlassian/atlassian-mcp-server`

**Recommendation**: Use **cosmix/jira-mcp** for most use cases. It's simpler and works with all Jira versions.

---

## Part 2: Obtain Jira API Credentials

### For Jira Cloud (Most Common)

#### Step 1: Get Your Jira Site URL

1. Log into your Jira Cloud instance
2. Copy the URL from your browser
3. Format: `https://your-company.atlassian.net`
4. Note this down - you'll need it later

**Example**: If you see `https://acme-corp.atlassian.net/jira/projects/MYAPP`, your site URL is `https://acme-corp.atlassian.net`

#### Step 2: Create an API Token

1. Go to: **https://id.atlassian.com/manage-profile/security/api-tokens**
2. Click **"Create API token"**
3. Give it a descriptive label: `BMAD MCP Integration`
4. Click **"Create"**
5. **COPY THE TOKEN IMMEDIATELY** - you won't see it again!
6. Store it securely (you'll add it to mcp.json later)

**Security Note**: API tokens grant full access to your Jira account. Keep them secure and never commit them to version control.

#### Step 3: Get Your Email Address

- Use the email address associated with your Atlassian account
- This is used for authentication along with the API token
- Example: `john.doe@company.com`

#### Step 4: Identify Your Project Key

1. Go to your Jira project
2. Look at any issue key (e.g., `MYAPP-123`)
3. The project key is the prefix before the dash: `MYAPP`

**Alternative**: Go to Project Settings → Details → Key

**Example Project Keys**: `PROJ`, `DEV`, `MYAPP`, `ENG`

---

### For Jira Server/Data Center

#### Step 1: Get Your Jira Base URL

1. Log into your Jira Server instance
2. Copy the base URL
3. Format: `https://jira.your-company.com`
4. Note this down

#### Step 2: Create Personal Access Token (PAT)

1. Go to your Jira profile (top right corner)
2. Select **"Personal Access Tokens"**
3. Click **"Create token"**
4. Give it a name: `BMAD MCP Integration`
5. Set appropriate permissions (read/write issues)
6. **COPY THE TOKEN IMMEDIATELY**
7. Store it securely

**Note**: PAT support varies by Jira Server version. If not available, you may need to use username/password (less secure).

#### Step 3: Identify Your Project Key

Same as Jira Cloud - look at issue keys or Project Settings.

---

## Part 3: Install Jira MCP Server

### Method 1: Using npx (Recommended - No Installation Needed)

No installation required! The `npx` command will download and run the MCP server on-demand.

**Verify Node.js is installed**:

```bash
node --version
```

If not installed, download from: **https://nodejs.org/**

### Method 2: Global npm Installation (Optional)

If you prefer a global install:

```bash
npm install -g @cosmix/jira-mcp
```

**Verification**:

```bash
jira-mcp --version
```

---

## Part 4: Configure Cursor MCP Settings

### Step 1: Locate or Create mcp.json

**File Location**: `~/.cursor/mcp.json`

**On macOS/Linux**:
```bash
nano ~/.cursor/mcp.json
```

**On Windows**:
```powershell
notepad %USERPROFILE%\.cursor\mcp.json
```

### Step 2: Add Jira Configuration

#### For Jira Cloud (cosmix/jira-mcp):

```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "@cosmix/jira-mcp"],
      "env": {
        "JIRA_API_TOKEN": "ATATT3xFfGF0ABcDef123456...",
        "JIRA_BASE_URL": "https://your-company.atlassian.net",
        "JIRA_USER_EMAIL": "your-email@company.com"
      }
    }
  }
}
```

**Replace**:
- `ATATT3xFfGF0ABcDef123456...` → Your actual API token from Part 2
- `your-company.atlassian.net` → Your Jira site URL
- `your-email@company.com` → Your Atlassian account email

#### For Jira Server/Data Center:

```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "@cosmix/jira-mcp"],
      "env": {
        "JIRA_API_TOKEN": "your_personal_access_token_here",
        "JIRA_BASE_URL": "https://jira.your-company.com",
        "JIRA_USER_EMAIL": "your-email@company.com"
      }
    }
  }
}
```

#### If You Already Have Other MCP Servers:

Add the jira configuration alongside existing servers:

```json
{
  "mcpServers": {
    "context7": {
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "ctx7sk-..."
      }
    },
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

### Step 3: Save the File

Make sure the JSON is valid (use a JSON validator if unsure).

---

## Part 5: Restart Cursor

**Critical Step**: Cursor must be restarted to load the new MCP configuration.

### macOS:
1. Press `Cmd + Q` to quit Cursor completely
2. Reopen Cursor from Applications

### Windows:
1. Press `Alt + F4` or close all windows
2. Reopen Cursor from Start menu

### Linux:
1. Close all Cursor windows
2. Reopen from your application launcher

**Important**: Just closing the window isn't enough - you must fully quit the application.

---

## Part 6: Verify MCP Installation

### Step 1: Test MCP Connection

1. Open Cursor
2. Start a new chat (Cmd+L or Ctrl+L)
3. Type: "What MCP tools are available?"
4. Look for jira-related tools in the response

**Expected Tools** (names may vary):
- `jira_search_issues`
- `jira_create_issue`
- `jira_update_issue`
- `jira_get_issue`
- `jira_add_comment`

### Step 2: Test Jira Connection

In Cursor chat, try:

```
Search for issues in Jira project PROJ (replace PROJ with your project key)
```

If successful, you should see Jira issues listed (or "no issues found" if project is empty).

**If this fails**, proceed to Troubleshooting section below.

---

## Part 7: Configure BMAD Core Config

### Step 1: Locate Your Project's Core Config

**File**: `.bmad-core/core-config.yaml` in your BMAD project root

If this file doesn't exist, copy from `bmad-parallel-export/core-config.yaml` template.

### Step 2: Add Jira Configuration

Add or update the `jira` section:

```yaml
jira:
  enabled: auto-detect
  projectKey: PROJ        # REPLACE with your project key
  baseUrl: https://your-company.atlassian.net  # REPLACE with your Jira URL
  mappingFile: .bmad-core/data/jira-mapping.yaml
  issueTypes:
    epic: Epic
    story: Story
    task: Task
  defaultAssignee: null
  labels: []
```

**Customize**:
- `projectKey`: Your Jira project key from Part 2
- `baseUrl`: Your Jira site URL from Part 2
- `issueTypes`: Match your Jira project's issue types (check Project Settings → Issue Types)
- `defaultAssignee`: Leave null or set to Jira username/email
- `labels`: Add any labels you want on synced issues (e.g., `["bmad", "ai-generated"]`)

### Step 3: Create Data Directory

Ensure the directory exists for the mapping file:

```bash
mkdir -p .bmad-core/data
```

### Step 4: Add to .gitignore (Optional)

If you don't want to track Jira mappings in version control:

```bash
echo ".bmad-core/data/jira-mapping.yaml" >> .gitignore
```

---

## Part 8: Test the Integration

### Step 1: Open Your BMAD Project in Cursor

Navigate to your project with BMAD installed.

### Step 2: Start PM Agent

In Cursor chat:

```
@pm
```

### Step 3: Check for Jira Command

Type:

```
*help
```

Look for `*sync-to-jira` in the command list.

### Step 4: Test Sync (Optional)

If you have a PRD already created:

```
*sync-to-jira
```

The agent should:
1. Detect Jira MCP is configured
2. Prompt for project key (if not set in core-config.yaml)
3. Read your PRD
4. Create epics and stories in Jira
5. Save mapping file
6. Display Jira links

**If you don't have a PRD yet**, that's okay - you can test this after creating one with `*create-prd`.

---

## Troubleshooting

### Problem: "Jira MCP not found" or "MCP tools not available"

**Possible Causes**:
- `mcp.json` file not saved correctly
- Cursor not fully restarted
- JSON syntax error in `mcp.json`

**Solutions**:
1. Verify `~/.cursor/mcp.json` exists and has correct JSON syntax
2. Use a JSON validator: **https://jsonlint.com/**
3. Fully quit Cursor (Cmd+Q / Alt+F4) and reopen
4. Check Cursor logs for MCP errors:
   - macOS: `~/Library/Logs/Cursor/`
   - Windows: `%APPDATA%\Cursor\logs\`
   - Linux: `~/.config/Cursor/logs/`

### Problem: "Authentication failed" or "401 Unauthorized"

**Possible Causes**:
- API token expired or invalid
- Wrong email address
- Token copied incorrectly (with spaces or newlines)

**Solutions**:
1. Regenerate API token at: **https://id.atlassian.com/manage-profile/security/api-tokens**
2. Verify email matches your Atlassian account
3. Check token has no trailing spaces or newlines
4. For Jira Cloud: Ensure you're using API token, NOT your account password
5. Test token manually with curl:

```bash
curl -u your-email@company.com:YOUR_API_TOKEN \
  https://your-company.atlassian.net/rest/api/3/myself
```

### Problem: "Project not found" or "Project PROJ does not exist"

**Possible Causes**:
- Wrong project key in `core-config.yaml`
- No access to the project
- Project key is case-sensitive

**Solutions**:
1. Verify project key in Jira: Project Settings → Details
2. Ensure project key is uppercase (e.g., `PROJ`, not `proj`)
3. Check you have access to the project (try opening it in Jira web UI)
4. Confirm you're connected to the right Jira instance (Cloud vs Server)

### Problem: "Cannot create Epic issue type"

**Possible Causes**:
- Project doesn't support Epic issue type
- Different issue type name in your Jira
- Simplified workflow without epics

**Solutions**:
1. Check available issue types: Project Settings → Issue Types
2. Update `core-config.yaml` issueTypes to match your project:
   ```yaml
   issueTypes:
     epic: Feature  # or whatever your Jira uses
     story: User Story
     task: Sub-task
   ```
3. If your project doesn't use epics, you may need to modify the sync task

### Problem: MCP tools not showing up in Cursor

**Possible Causes**:
- Node.js not installed
- npx can't download the package
- Network/firewall blocking npm registry

**Solutions**:
1. Verify Node.js is installed:
   ```bash
   node --version
   npm --version
   ```
2. Test npx directly:
   ```bash
   npx @cosmix/jira-mcp
   ```
3. If behind corporate firewall, configure npm proxy
4. Try global install instead:
   ```bash
   npm install -g @cosmix/jira-mcp
   ```
   Then update mcp.json command to `jira-mcp` instead of `npx`

### Problem: "Rate limit exceeded"

**Possible Causes**:
- Too many API calls in short time
- Jira Cloud free tier limits

**Solutions**:
1. Wait a few minutes before retrying
2. Reduce batch size (sync fewer epics at once)
3. Upgrade Jira plan if hitting consistent limits
4. Check Jira's rate limiting docs for your plan

### Problem: Issues created but not linked to Epic

**Possible Causes**:
- Epic link field name varies by Jira version
- Permissions don't allow epic linking

**Solutions**:
1. Check `jira-utils.md` for alternative field names
2. Try both `parent` and `epicLink` fields
3. Manually link in Jira if needed
4. Check project permissions for epic linking

---

## Security Best Practices

### 1. Never Commit Credentials

- `~/.cursor/mcp.json` contains API tokens - **NEVER commit this**
- It's in your home directory, so typically safe
- If you create project-specific MCP configs, add to `.gitignore`

### 2. Use Restricted Tokens

- Create API tokens with minimal required permissions
- For testing, use read-only tokens first
- Rotate tokens every 90 days

### 3. Protect Mapping Files

The `jira-mapping.yaml` file contains Jira issue IDs. If your Jira projects are confidential:

```bash
echo ".bmad-core/data/jira-mapping.yaml" >> .gitignore
```

### 4. Use Environment Variables (Advanced)

For team setups, consider environment variables instead of hardcoded values:

```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "@cosmix/jira-mcp"],
      "env": {
        "JIRA_API_TOKEN": "${JIRA_API_TOKEN}",
        "JIRA_BASE_URL": "${JIRA_BASE_URL}",
        "JIRA_USER_EMAIL": "${JIRA_USER_EMAIL}"
      }
    }
  }
}
```

Then set in your shell:

```bash
export JIRA_API_TOKEN="your_token"
export JIRA_BASE_URL="https://your-company.atlassian.net"
export JIRA_USER_EMAIL="your-email@company.com"
```

### 5. Regular Security Audits

- Review active API tokens quarterly
- Revoke unused tokens
- Monitor Jira audit logs for unexpected API activity

---

## Next Steps

✅ **Setup Complete!** You can now:

1. **Create PRD with Jira Sync**:
   - Start PM agent: `@pm`
   - Create PRD: `*create-prd`
   - At the end, opt to sync to Jira

2. **Sync Existing PRD**:
   - Start PM agent: `@pm`
   - Run: `*sync-to-jira`

3. **Draft Stories with Jira Updates**:
   - Start SM agent: `@sm`
   - Draft story: `*draft`
   - If mapping exists, Jira will auto-update

4. **Learn More**:
   - Read `README-JIRA.md` for workflow examples
   - Check `jira-utils.md` for MCP patterns
   - Review `sync-to-jira.md` task for technical details

---

## Additional Resources

### Documentation Links

- **Jira REST API**: https://developer.atlassian.com/cloud/jira/platform/rest/v3/
- **cosmix/jira-mcp GitHub**: https://github.com/cosmix/jira-mcp
- **Atlassian API Tokens**: https://id.atlassian.com/manage-profile/security/api-tokens
- **MCP Protocol**: https://modelcontextprotocol.io/

### Support

- **BMAD Issues**: Check BMAD documentation
- **MCP Issues**: Check cosmix/jira-mcp GitHub issues
- **Jira API Issues**: Atlassian Community forums

---

## Summary Checklist

Use this checklist to verify setup completion:

- [ ] Chosen Jira MCP server (cosmix/jira-mcp recommended)
- [ ] Created Jira API token
- [ ] Identified Jira project key
- [ ] Node.js installed and verified
- [ ] Created `~/.cursor/mcp.json` with Jira configuration
- [ ] Restarted Cursor completely
- [ ] Verified MCP tools are available in Cursor
- [ ] Updated `.bmad-core/core-config.yaml` with Jira section
- [ ] Created `.bmad-core/data/` directory
- [ ] Tested `*sync-to-jira` command with PM agent
- [ ] Added `jira-mapping.yaml` to `.gitignore` (if needed)

**Setup Time**: Most users complete this in 15-20 minutes.

**Congratulations!** You're ready to use Jira integration with BMAD parallel agents.
