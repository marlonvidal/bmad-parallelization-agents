# Jira MCP Utility Patterns — BMAD v6

## Purpose

This document provides reusable patterns for interacting with Jira through MCP (Model Context Protocol) within the BMAD v6 `bmad-create-epics-and-stories` workflow. These patterns are referenced by `step-04-final-validation.md` when the user selects `[J] Sync to Jira`.

**BMAD v6 specifics vs. v4:**
- Config lives in `_bmad/bmm/config.yaml` (not `.bmad-core/core-config.yaml`)
- Input document is `{planning_artifacts}/epics.md` (not a PRD file)
- Mapping file goes to `{output_folder}/jira-mapping.yaml`
- Stories may be parallel BE/FE pairs with `-BE`/`-FE` suffixes and Data Contract fields

---

## CRITICAL: Always Check MCP Availability First

Before attempting any Jira operations, verify that Jira MCP is configured.

---

## Pattern 1: Check if Jira MCP is Configured

```
### Step: Verify Jira MCP Availability

1. Read file: ~/.cursor/mcp.json
2. Parse JSON content
3. Look for "jira" key in mcpServers object

If Jira MCP NOT found:
  - Inform user: "Jira MCP is not configured. Follow the setup guide at
    _bmad/bmm/3-solutioning/bmad-create-epics-and-stories/JIRA-SETUP.md"
  - Exit gracefully — do not proceed with Jira operations

If Jira MCP found:
  - Note: Available Jira MCP tools are automatically loaded
  - Proceed to next step
```

---

## Pattern 2: Load Jira Configuration from BMAD v6 Config

```
### Step: Load Jira Configuration

1. Read _bmad/bmm/config.yaml
2. Look for jira: section
3. Extract required fields:
   - projectKey  → prompt user if null
   - baseUrl     → prompt user if null
4. Extract optional fields:
   - issueTypes.epic  (default: "Epic")
   - issueTypes.story (default: "Story")
   - mappingFile      (default: {output_folder}/jira-mapping.yaml)
   - defaultAssignee  (default: null)
   - labels           (default: [])

Config section format to add to _bmad/bmm/config.yaml:

  jira:
    enabled: auto-detect
    projectKey: PROJ
    baseUrl: https://your-company.atlassian.net
    mappingFile: "{output_folder}/jira-mapping.yaml"
    issueTypes:
      epic: Epic
      story: Story
    defaultAssignee: null
    labels: []
```

---

## Pattern 3: Parse epics.md for Epics and Stories

```
### Step: Extract Content from epics.md

Load {planning_artifacts}/epics.md and extract:

EPICS:
  - Epic number (N)
  - Epic title
  - Implementation Domain (Full-Stack | Backend-Only | Frontend-Only | Non-Technical)
  - Epic goal statement

STORIES per epic:
  - Story ID (e.g., "1.1", "1.1-BE", "1.1-FE")
  - Story title
  - Story statement (As a / I want / So that)
  - Acceptance criteria (Given/When/Then)
  - Story Domain (Backend | Frontend | Full-Stack)
  - Paired Story (for BE/FE pairs)
  - Data Contract (for BE stories in Full-Stack epics)
  - Blocking Dependencies

PARALLEL PAIR DETECTION:
  - Story ID ends with "-BE" → Backend member of a parallel pair
  - Story ID ends with "-FE" → Frontend member of a parallel pair
  - Otherwise → standard single-domain story

Group -BE and -FE siblings for display but create as separate Jira stories.
```

---

## Pattern 4: Create Jira Epic

**MCP Tool**: `jira_create_issue`

```
### Step: Create Jira Epic

Tool: jira_create_issue
Parameters:
  project:     {projectKey}
  summary:     "Epic {N}: {epic_title}"
  description: (see format below)
  issuetype:   {issueTypes.epic}

Epic Description Format:
  {epic_goal}

  Implementation Domain: {domain}

  Stories in this Epic:
  {bullet list of story IDs and titles}

  ---
  Synced from BMAD epics.md

Capture response:
  - Extract epic key (e.g., "PROJ-100")
  - Store: epics[N] = "PROJ-100"
  - Save mapping file after each epic
```

---

## Pattern 5a: Create Jira Story — Parallel Pair (BE or FE)

**MCP Tool**: `jira_create_issue`

```
### Step: Create Jira Story (Parallel Pair Member)

Tool: jira_create_issue
Parameters:
  project:     {projectKey}
  summary:     "Story {story_id}: {story_title}"
  description: (see format below)
  issuetype:   {issueTypes.story}
  parent:      {parentEpicKey}   ← try "parent" first, then "epicLink"

Story Description Format (BE or FE parallel pair):
  {story_statement}

  ## Acceptance Criteria
  {ACs in Given/When/Then format}

  ## Parallel Delivery
  - Story Domain: {Backend | Frontend}
  - Paired Story: {paired_story_id} — {paired_story_title}
  - Data Contract: {data_contract_reference_or_definition}
  - Blocking Dependencies:
    - Frontend: None
    - Backend: None

  ---
  Synced from BMAD epics.md

Capture response:
  - Extract story key (e.g., "PROJ-103")
  - Store: stories["N.M-BE"] = "PROJ-103"
  - Save mapping after each epic's story set
```

---

## Pattern 5b: Create Jira Story — Standard (non-parallel)

**MCP Tool**: `jira_create_issue`

```
### Step: Create Jira Story (Standard)

Tool: jira_create_issue
Parameters:
  project:     {projectKey}
  summary:     "Story {story_id}: {story_title}"
  description: (see format below)
  issuetype:   {issueTypes.story}
  parent:      {parentEpicKey}

Story Description Format (standard):
  {story_statement}

  ## Acceptance Criteria
  {ACs in Given/When/Then format}

  ## Story Domain
  {Story Domain}

  ## Blocking Dependencies
  {blocking_dependencies}

  ---
  Synced from BMAD epics.md

Capture response:
  - Extract story key (e.g., "PROJ-105")
  - Store: stories["N.M"] = "PROJ-105"
```

---

## Pattern 6: Construct Jira Issue URLs

```
### Step: Generate Jira Links

URL Format:
  {baseUrl}/browse/{issueKey}

Example:
  https://your-company.atlassian.net/browse/PROJ-103

Use in summary table:
  | Story 1.1-BE | User Registration – Backend | PROJ-103 | [View](url) |
  | Story 1.1-FE | User Registration – Frontend | PROJ-104 | [View](url) |
```

---

## Pattern 7: Mapping File Structure (v6)

```yaml
# {output_folder}/jira-mapping.yaml

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
  "2.1": PROJ-107       # standard non-parallel story
  "2.2-BE": PROJ-108
  "2.2-FE": PROJ-109
```

**Save incrementally** — after each epic and its stories — to prevent data loss on partial failure.

---

## Pattern 8: Error Handling

```
### Error Handling for Jira Operations

Common Errors:

1. Authentication Failed (401)
   - Check API token in mcp.json is valid and not expired
   - Verify email matches Atlassian account
   - Guide user to regenerate token at: https://id.atlassian.com/manage-profile/security/api-tokens

2. Project Not Found
   - Verify projectKey in _bmad/bmm/config.yaml
   - Check user has access to the project in Jira
   - Keys are case-sensitive — must be uppercase (e.g., "PROJ" not "proj")

3. Issue Type Not Supported
   - Check Project Settings → Issue Types in Jira
   - Update issueTypes in _bmad/bmm/config.yaml to match your project

4. Epic Link Field Not Found
   - Try "parent" first, then "epicLink" as fallback
   - Field name varies by Jira version (Cloud vs Server)

5. Rate Limit Hit
   - Add 300-500ms delay between story creates
   - Inform user of progress and wait before retrying

General Pattern:
  - Log error with context
  - Inform user of the specific issue
  - Save partial mapping file
  - Ask: "Continue with remaining items or abort?"
  - Never discard successfully created mappings
```

---

## Pattern 9: Batch Progress Display

```
### Step: Show Sync Progress

For each epic:
  "→ Creating Epic {N}: {title}..."
  "  ✓ Epic {N} → {epicKey} ({url})"

For each story within that epic:
  "  → Story {story_id}: {title} [{domain}]..."
  "  ✓ Story {story_id} → {storyKey} ({url})"

Group output by epic for readability.
After all epics: display full summary table (see step-04 J.8).
```

---

## Quick Reference: Common MCP Tool Names

Names may vary by MCP server. Verify with your Jira MCP server docs.

| Operation | Likely Tool Name |
|-----------|-----------------|
| Create issue | `jira_create_issue` |
| Update issue | `jira_update_issue` |
| Get issue | `jira_get_issue` |
| Search (JQL) | `jira_search_issues` |
| Add comment | `jira_add_comment` |

**References:**
- Setup guide: `_bmad/bmm/3-solutioning/bmad-create-epics-and-stories/JIRA-SETUP.md`
- Trigger: `step-04-final-validation.md` — select `[J] Sync to Jira`
- Mapping file: `{output_folder}/jira-mapping.yaml`
