# <!-- Powered by BMAD™ Core -->

# Jira MCP Utility Patterns

## Purpose

This document provides reusable patterns for interacting with Jira through MCP (Model Context Protocol). Use these patterns in tasks that need to create, update, or query Jira issues.

## CRITICAL: Always Check MCP Availability First

Before attempting any Jira operations, you MUST verify that Jira MCP is configured.

## Pattern 1: Check if Jira MCP is Configured

```markdown
### Step: Verify Jira MCP Availability

1. **Read MCP Configuration**
   - Read file: `~/.cursor/mcp.json`
   - Parse JSON content
   - Look for "jira" key in mcpServers object

2. **If Jira MCP Not Found**:
   - Inform user: "Jira MCP is not configured. To enable Jira integration, please follow the setup guide in JIRA-SETUP.md"
   - Exit gracefully (do not proceed with Jira operations)

3. **If Jira MCP Found**:
   - Extract configuration details
   - Note: Available Jira MCP tools will be automatically loaded
   - Proceed to next step
```

## Pattern 2: Load Jira Configuration from Core Config

```markdown
### Step: Load Jira Configuration

1. **Read Core Config**
   - Read file: `.bmad-core/core-config.yaml`
   - Extract jira section

2. **Validate Required Fields**:
   - `projectKey`: If null, prompt user for Jira project key
   - `baseUrl`: If null, prompt user for Jira base URL
   - Store these values for use in subsequent steps

3. **Extract Issue Type Mappings**:
   - `issueTypes.epic` (default: "Epic")
   - `issueTypes.story` (default: "Story")
   - `issueTypes.task` (default: "Task")
```

## Pattern 3: Search for Existing Issues

**MCP Tool**: Likely `jira_search_issues` or similar (check MCP server docs)

```markdown
### Step: Search for Existing Jira Issues

**Purpose**: Check if issues already exist before creating duplicates

**Tool Call Pattern**:
- Tool: jira_search_issues
- Parameters:
  - jql: "project = {projectKey} AND summary ~ '{search_term}'"
  - maxResults: 50

**Example JQL Queries**:
- Find epic by name: `project = PROJ AND type = Epic AND summary ~ 'User Authentication'`
- Find stories in epic: `project = PROJ AND type = Story AND 'Epic Link' = PROJ-100`
- Find all stories: `project = PROJ AND type = Story`

**Handle Results**:
- If matching issues found: Inform user and ask if they want to update or skip
- If no matches: Proceed with creation
```

## Pattern 4: Create Jira Epic

**MCP Tool**: Likely `jira_create_issue` or `jira_create_epic`

```markdown
### Step: Create Jira Epic

**Tool Call Pattern**:
- Tool: jira_create_issue
- Parameters:
  - project: {projectKey}
  - summary: "{Epic Title from PRD}"
  - description: "{Epic Goal + Dependency Info}"
  - issuetype: {issueTypes.epic} (from config, default "Epic")

**Epic Description Format**:
```markdown
{Epic Goal from PRD}

## Dependencies
{Prerequisite Epics info from PRD Dependency Graph}
{Can Parallel With info from PRD}

## Stories in This Epic
{List story titles}
```

**Capture Response**:
- Extract epic key (e.g., "PROJ-100")
- Store in mapping: `epics: {epicNum: epicKey}`
```

## Pattern 5: Create Jira Story

**MCP Tool**: Likely `jira_create_issue`

```markdown
### Step: Create Jira Story

**Tool Call Pattern**:
- Tool: jira_create_issue
- Parameters:
  - project: {projectKey}
  - summary: "{Story Title from PRD}"
  - description: "{Story Statement + Acceptance Criteria + Dependencies}"
  - issuetype: {issueTypes.story} (from config, default "Story")
  - parent: {parentEpicKey} (link to epic, field name may vary)

**Alternative Epic Link Field Names** (try in order):
- `parent` (Jira Cloud standard)
- `epicLink` (Jira Server/older versions)
- Check your Jira MCP server docs for exact field name

**Story Description Format**:
```markdown
{Story Statement from PRD}

## Acceptance Criteria
{Numbered list of ACs from PRD}

## Dependencies and Parallelism
- Story Domain: {Frontend|Backend}
- Paired Story Reference: {paired story ID}
- Shared Data Contract: {contract reference}
- Blocking Dependencies: {dependencies from PRD}
```

**Capture Response**:
- Extract story key (e.g., "PROJ-102")
- Store in mapping: `stories: {"{epicNum}.{storyNum}": storyKey}`
```

## Pattern 6: Create Jira Task

**MCP Tool**: Likely `jira_create_issue`

```markdown
### Step: Create Jira Tasks

**Tool Call Pattern**:
- Tool: jira_create_issue
- Parameters:
  - project: {projectKey}
  - summary: "{Task description from story file}"
  - description: "{Task details if any}"
  - issuetype: {issueTypes.task} (from config, default "Task")
  - parent: {parentStoryKey} (link to story)

**Task Description Format**:
```markdown
{Task description from story Tasks/Subtasks section}

Related AC: {acceptance criteria numbers}
```

**Capture Response**:
- Extract task key (e.g., "PROJ-105")
- Store in mapping: `tasks: {"{epicNum}.{storyNum}.{taskNum}": taskKey}`
```

## Pattern 7: Update Jira Issue

**MCP Tool**: Likely `jira_update_issue`

```markdown
### Step: Update Jira Issue

**Tool Call Pattern**:
- Tool: jira_update_issue
- Parameters:
  - issueKey: {jiraKey} (e.g., "PROJ-102")
  - fields:
    - description: "{updated description}"
    - summary: "{updated title}" (optional)
    - labels: {array of labels} (optional)

**Common Update Scenarios**:
1. **Update Story Description** (when SM drafts story with full details)
2. **Add Comment** (use jira_add_comment tool if available)
3. **Update Status** (future: use jira_transition_issue if available)
```

## Pattern 8: Get Jira Issue Details

**MCP Tool**: Likely `jira_get_issue`

```markdown
### Step: Get Jira Issue Details

**Tool Call Pattern**:
- Tool: jira_get_issue
- Parameters:
  - issueKey: {jiraKey} (e.g., "PROJ-102")

**Use Cases**:
- Verify issue exists before updating
- Check current status before syncing
- Retrieve issue summary for display
```

## Pattern 9: Construct Jira Issue URLs

```markdown
### Step: Generate Jira Links

**URL Format**:
- Issue: `{baseUrl}/browse/{issueKey}`
- Example: `https://your-company.atlassian.net/browse/PROJ-102`

**Usage in Story Files**:
```markdown
## Jira Links
- Epic: [PROJ-100](https://your-company.atlassian.net/browse/PROJ-100)
- Story: [PROJ-102](https://your-company.atlassian.net/browse/PROJ-102)
- Tasks:
  - [PROJ-105](https://your-company.atlassian.net/browse/PROJ-105) - Setup database schema
  - [PROJ-106](https://your-company.atlassian.net/browse/PROJ-106) - Create API endpoint
```
```

## Pattern 10: Error Handling

```markdown
### Error Handling for Jira Operations

**Common Errors and Solutions**:

1. **Authentication Failed**
   - Check API token in mcp.json is valid
   - Verify email matches Atlassian account
   - Inform user to regenerate token if expired

2. **Project Not Found**
   - Verify projectKey in core-config.yaml
   - Check user has access to project in Jira
   - Ask user to confirm correct project key

3. **Issue Type Not Found**
   - Check issueTypes in core-config.yaml
   - Verify these issue types exist in Jira project
   - Provide instructions to check: Project Settings → Issue Types

4. **Epic Link Field Not Found**
   - Try alternative field names: parent, epicLink
   - Check Jira MCP server documentation
   - May need to create story without epic link initially

5. **Rate Limiting**
   - Implement backoff strategy
   - Add delays between batch operations
   - Inform user of progress

**General Error Pattern**:
```markdown
**On Error**:
1. Log the error message
2. Inform user of the specific issue
3. Provide actionable remediation steps
4. Ask if user wants to continue or abort
5. Don't lose progress - save partial mapping file
```
```

## Pattern 11: Mapping File Management

```markdown
### Step: Read Mapping File

**File**: `.bmad-core/data/jira-mapping.yaml`

**Check if Exists**:
- If exists: Load existing mappings
- If not exists: Initialize empty structure

**Mapping File Structure**:
```yaml
projectKey: PROJ
baseUrl: https://your-company.atlassian.net
syncedAt: 2026-02-25T10:30:00Z
epics:
  1: PROJ-100
  2: PROJ-101
stories:
  "1.1": PROJ-102
  "1.2": PROJ-103
  "2.1": PROJ-110
tasks:
  "1.1.1": PROJ-105
  "1.1.2": PROJ-106
```

### Step: Write Mapping File

**Ensure Directory Exists**:
- Create `.bmad-core/data/` if needed

**Write YAML**:
- Preserve existing mappings
- Add new mappings
- Update syncedAt timestamp
- Write to file atomically

**Inform User**:
- Confirm mapping file location
- Mention it tracks BMAD ↔ Jira relationships
```

## Pattern 12: Batch Operations

```markdown
### Step: Batch Create Jira Issues

**For Multiple Epics**:
1. Show progress: "Creating epic 1 of 5..."
2. Create each epic with error handling
3. Store successful mappings incrementally
4. Continue on error (don't abort all)
5. Summary report at end

**For Multiple Stories**:
1. Group by epic for clarity
2. Show progress: "Creating stories for Epic 1 (3 stories)..."
3. Create with parent epic reference
4. Handle partial failures gracefully

**Best Practices**:
- Add small delays (500ms-1s) between creates to avoid rate limits
- Save mapping file after each successful epic/story
- Provide detailed progress updates
- Summarize successes and failures at end
```

## Quick Reference: Common MCP Tool Names

These may vary by MCP server implementation. Check your Jira MCP server docs.

**Likely Tool Names** (cosmix/jira-mcp):
- `jira_search_issues` - Search using JQL
- `jira_create_issue` - Create any issue type
- `jira_update_issue` - Update existing issue
- `jira_get_issue` - Get issue details
- `jira_add_comment` - Add comment to issue
- `jira_get_epic_children` - Get stories in epic
- `jira_add_attachment` - Attach file to issue

**Alternative Names** (check docs):
- `searchIssues`, `createIssue`, `updateIssue`
- `getIssue`, `addComment`, `getEpicChildren`

## Notes

- **Always check MCP server documentation** for exact tool names and parameters
- **MCP tools are auto-discovered** - no manual registration needed
- **Error messages from MCP** are usually descriptive - show them to user
- **JQL is powerful** - use for complex searches and filtering
- **Mapping file is critical** - back it up and don't lose it
- **Jira field names vary** - parent vs epicLink, check your Jira version
