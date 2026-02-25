# <!-- Powered by BMAD™ Core -->

# Sync to Jira Task

## Purpose

Synchronize PRD epics and stories to Jira, creating a complete hierarchy of Epics → Stories in your Jira project. This task can be called by both PM and SM agents, enabling flexible Jira integration without context switching.

## When to Use

- After creating or updating a PRD
- Before starting story development (to establish tracking)
- When onboarding new team members (to provide Jira visibility)
- Anytime you want to mirror BMAD documents in Jira

## Prerequisites

- Jira MCP must be configured (see JIRA-SETUP.md)
- PRD must exist (monolithic or sharded)
- Core config must have jira section

## SEQUENTIAL Task Execution (Do not proceed until current step is complete)

### Step 0: Verify Jira MCP Availability

**CRITICAL**: This step determines if Jira integration is possible.

1. **Check MCP Configuration**
   - Read file: `~/.cursor/mcp.json`
   - Parse JSON content
   - Look for "jira" key in `mcpServers` object

2. **If Jira MCP Not Found**:
   - Inform user: "Jira MCP is not configured. To enable Jira integration, please follow the complete setup guide in JIRA-SETUP.md. This includes: creating API tokens, configuring mcp.json, and updating core-config.yaml."
   - Ask: "Would you like me to explain the setup process?"
   - **EXIT GRACEFULLY** - do not proceed with sync

3. **If Jira MCP Found**:
   - Confirm to user: "Jira MCP detected. Proceeding with sync..."
   - Note: MCP tools are automatically available
   - Continue to next step

**Reference**: See `jira-utils.md` Pattern 1 for detailed MCP detection

---

### Step 1: Load and Validate Jira Configuration

1. **Read Core Configuration**
   - Read file: `.bmad-core/core-config.yaml`
   - Extract `jira` section
   - If jira section missing, inform user and create with defaults

2. **Validate Project Key**
   - Check `jira.projectKey`
   - **If null or empty**:
     - Prompt user: "What is your Jira project key? (Examples: PROJ, DEV, MYAPP)"
     - Provide guidance: "Find this in Jira by looking at any issue key (e.g., PROJ-123 → key is PROJ)"
     - Wait for user input
     - Update core-config.yaml with provided key

3. **Validate Base URL**
   - Check `jira.baseUrl`
   - **If null or empty**:
     - Prompt user: "What is your Jira base URL? (e.g., https://your-company.atlassian.net)"
     - Wait for user input
     - Update core-config.yaml with provided URL

4. **Extract Issue Type Mappings**
   - `jira.issueTypes.epic` (default: "Epic")
   - `jira.issueTypes.story` (default: "Story")
   - `jira.issueTypes.task` (default: "Task")
   - Store for use in subsequent steps

5. **Display Configuration Summary**
   - Show user: Project Key, Base URL, Issue Types
   - Ask: "Proceed with sync using this configuration? (Y/n)"
   - If no, allow user to update core-config.yaml first

**Reference**: See `jira-utils.md` Pattern 2 for configuration loading

---

### Step 2: Load PRD Content

1. **Determine PRD Location**
   - Read `prd.prdSharded` from core-config.yaml
   - **If sharded (true)**:
     - Location: `prd.prdShardedLocation` (e.g., `docs/prd/`)
     - Pattern: `prd.epicFilePattern` (e.g., `epic-{n}*.md`)
   - **If monolithic (false)**:
     - Location: `prd.prdFile` (e.g., `docs/prd.md`)

2. **Load Epic Information**
   - **For sharded PRD**:
     - List all files matching pattern in prd location
     - Read each epic file
     - Extract: Epic number, title, goal, stories
   - **For monolithic PRD**:
     - Read single PRD file
     - Parse epic sections
     - Extract: Epic numbers, titles, goals, stories

3. **Extract Epic Dependency Graph**
   - Find "Epic Dependency Graph" section in PRD
   - Parse table with columns: Epic, Prerequisite Epics, Can Parallel With, Rationale
   - Store dependency information for each epic
   - This will be included in epic descriptions in Jira

4. **Extract Story Details for Each Epic**
   - For each story in each epic:
     - Story number (e.g., 1.1, 1.2)
     - Story title
     - Story statement (As a... I want... So that...)
     - Acceptance Criteria (numbered list)
     - Dependencies and Parallelism section
       - Story Domain (Frontend/Backend)
       - Paired Story Reference
       - Shared Data Contract
       - Blocking Dependencies

5. **Validation**
   - Verify at least one epic found
   - Verify each epic has at least one story
   - If validation fails, inform user and exit

6. **Display Sync Plan**
   - Show user: "Found X epics with Y total stories"
   - List epic titles
   - Ask: "Proceed with creating these in Jira? (Y/n)"

---

### Step 3: Check for Existing Jira Mapping

1. **Read Mapping File**
   - Location: `jira.mappingFile` from core-config.yaml (default: `.bmad-core/data/jira-mapping.yaml`)
   - **If file exists**:
     - Load existing mappings
     - Display: "Found existing Jira mapping. Last synced: {syncedAt}"
     - Show: X epics, Y stories already synced
     - Ask: "Would you like to: 1) Update existing issues, 2) Create new issues only, 3) Full re-sync (may create duplicates)"
   - **If file doesn't exist**:
     - Initialize empty mapping structure
     - Inform: "No existing mapping found. Will create new Jira issues."

2. **Initialize Mapping Structure**
   ```yaml
   projectKey: {from config}
   baseUrl: {from config}
   syncedAt: {current timestamp}
   epics: {}
   stories: {}
   tasks: {}
   ```

**Reference**: See `jira-utils.md` Pattern 11 for mapping file management

---

### Step 4: Create or Update Jira Epics

**For each epic in PRD**:

1. **Check if Epic Already Exists**
   - Look in mapping: `epics[epicNum]`
   - **If exists**: Decide based on user choice in Step 3 (update vs skip)
   - **If not exists**: Proceed with creation

2. **Prepare Epic Description**
   ```markdown
   {Epic Goal from PRD}
   
   ## Dependencies
   - **Prerequisite Epics**: {from dependency graph}
   - **Can Parallel With**: {from dependency graph}
   - **Rationale**: {from dependency graph}
   
   ## Stories in This Epic
   {List of story titles}
   
   ---
   *Synced from BMAD PRD*
   ```

3. **Create Jira Epic**
   - **Tool**: Use appropriate MCP tool (likely `jira_create_issue`)
   - **Parameters**:
     - `project`: {projectKey from config}
     - `summary`: "{Epic Number}: {Epic Title}"
     - `description`: {formatted description from step 2}
     - `issuetype`: {issueTypes.epic from config}
   - **Handle Errors**: See jira-utils.md Pattern 10
   - Add small delay (500ms) to avoid rate limits

4. **Capture Epic Key**
   - Extract epic key from response (e.g., "PROJ-100")
   - Store in mapping: `epics[epicNum] = epicKey`
   - Save mapping file incrementally (after each epic)

5. **Display Progress**
   - Show: "Created Epic {epicNum}: {epicTitle} → {epicKey}"
   - Include Jira URL: `{baseUrl}/browse/{epicKey}`

6. **Continue for All Epics**
   - Process each epic sequentially
   - Handle errors gracefully (continue on failure, log issue)
   - Keep user informed of progress

**Reference**: See `jira-utils.md` Pattern 4 for epic creation

---

### Step 5: Create or Update Jira Stories

**For each story in each epic**:

1. **Check if Story Already Exists**
   - Look in mapping: `stories["{epicNum}.{storyNum}"]`
   - **If exists**: Decide based on user choice in Step 3
   - **If not exists**: Proceed with creation

2. **Get Parent Epic Key**
   - Look up epic key from mapping: `epics[epicNum]`
   - If epic not found, skip story and log warning

3. **Prepare Story Description**
   ```markdown
   {Story Statement from PRD}
   
   ## Acceptance Criteria
   {Numbered list of ACs from PRD}
   
   ## Dependencies and Parallelism
   - **Story Domain**: {Frontend|Backend}
   - **Paired Story Reference**: {paired story ID}
   - **Shared Data Contract**: {contract reference}
   - **Blocking Dependencies**:
     - Frontend: {dependencies from PRD}
     - Backend: {dependencies from PRD}
   
   ---
   *Synced from BMAD PRD*
   ```

4. **Create Jira Story**
   - **Tool**: Use appropriate MCP tool (likely `jira_create_issue`)
   - **Parameters**:
     - `project`: {projectKey}
     - `summary`: "Story {epicNum}.{storyNum}: {Story Title}"
     - `description`: {formatted description}
     - `issuetype`: {issueTypes.story}
     - `parent`: {parentEpicKey} (or `epicLink` depending on Jira version)
   - **Handle Epic Link Errors**: Try `parent` first, then `epicLink` if that fails
   - Add small delay (300ms) between stories

5. **Capture Story Key**
   - Extract story key from response (e.g., "PROJ-102")
   - Store in mapping: `stories["{epicNum}.{storyNum}"] = storyKey`
   - Save mapping file incrementally (after each epic's stories)

6. **Display Progress**
   - Show: "Created Story {epicNum}.{storyNum}: {storyTitle} → {storyKey}"
   - Include Jira URL
   - Group by epic for clarity

**Reference**: See `jira-utils.md` Pattern 5 for story creation

---

### Step 6: Save Final Mapping File

1. **Update Sync Timestamp**
   - Set `syncedAt` to current ISO 8601 timestamp
   - Example: `2026-02-25T10:30:00Z`

2. **Ensure Directory Exists**
   - Create `.bmad-core/data/` if needed
   - Use: `mkdir -p .bmad-core/data`

3. **Write Mapping File**
   - Format as YAML
   - Location: `jira.mappingFile` from config
   - Example structure:
     ```yaml
     projectKey: PROJ
     baseUrl: https://your-company.atlassian.net
     syncedAt: 2026-02-25T10:30:00Z
     epics:
       1: PROJ-100
       2: PROJ-101
       3: PROJ-102
     stories:
       "1.1": PROJ-103
       "1.2": PROJ-104
       "1.3": PROJ-105
       "2.1": PROJ-106
       "2.2": PROJ-107
     tasks: {}
     ```

4. **Confirm Save**
   - Display: "Mapping file saved to: {mappingFile}"
   - Note: "This file tracks BMAD ↔ Jira relationships. Keep it safe!"

**Reference**: See `jira-utils.md` Pattern 11 for mapping file format

---

### Step 7: Generate Summary Report

1. **Count Results**
   - Total epics created/updated
   - Total stories created/updated
   - Any failures or warnings

2. **Create Summary Table**
   ```markdown
   ## Jira Sync Summary
   
   **Project**: {projectKey}
   **Base URL**: {baseUrl}
   **Synced At**: {timestamp}
   
   ### Epics Created
   | Epic | Title | Jira Key | Link |
   |------|-------|----------|------|
   | Epic 1 | Foundation & Setup | PROJ-100 | [View](url) |
   | Epic 2 | Core Features | PROJ-101 | [View](url) |
   
   ### Stories Created
   | Story | Title | Epic | Jira Key | Link |
   |-------|-------|------|----------|------|
   | 1.1 | Setup Project | Epic 1 | PROJ-103 | [View](url) |
   | 1.2 | Configure Database | Epic 1 | PROJ-104 | [View](url) |
   
   ### Errors/Warnings
   {List any issues encountered}
   
   ### Next Steps
   - Story tasks will be created when SM drafts detailed stories
   - Use `*draft` in SM agent to create next story with Jira sync
   - View all issues: {baseUrl}/browse/{projectKey}
   ```

3. **Display to User**
   - Show formatted summary
   - Provide clickable Jira links
   - Explain what happens next

4. **Optional: Suggest Next Actions**
   - "Ready to draft first story? Switch to SM agent and run *draft"
   - "View dependency map? Run *create-dependency-map"
   - "Need to update PRD? Edit docs/prd.md and re-run *sync-to-jira"

---

## Success Criteria

- [ ] Jira MCP availability verified
- [ ] Jira configuration loaded and validated
- [ ] PRD content successfully parsed (all epics and stories)
- [ ] Jira epics created with dependency information
- [ ] Jira stories created and linked to parent epics
- [ ] Mapping file saved with all relationships
- [ ] Summary report displayed with clickable links
- [ ] User informed of next steps

## Error Handling

**Common Errors** (see jira-utils.md Pattern 10 for details):

1. **MCP Not Found**: Exit gracefully with setup instructions
2. **Authentication Failed**: Guide user to check API token
3. **Project Not Found**: Verify project key with user
4. **Issue Type Not Supported**: Suggest checking Jira project settings
5. **Rate Limit Hit**: Implement backoff, inform user
6. **Partial Failure**: Save progress, continue with remaining items

**General Pattern**:
- Log all errors with context
- Save partial progress to mapping file
- Inform user of what succeeded and what failed
- Provide actionable remediation steps
- Never lose completed work

## Notes

- **Read-only on BMAD side**: This task only reads PRD, doesn't modify it
- **One-way sync**: BMAD → Jira (not bidirectional)
- **Idempotent option**: User can choose to update existing vs create new
- **Incremental saves**: Mapping file updated after each epic to prevent data loss
- **Rate limit friendly**: Small delays between API calls
- **Verbose feedback**: Keep user informed throughout process
- **Callable by both PM and SM**: No agent-specific dependencies
- **Tasks created later**: SM agent creates detailed tasks when drafting stories

## References

- `jira-utils.md` - Detailed MCP patterns and tool usage
- `JIRA-SETUP.md` - Complete setup instructions
- `core-config.yaml` - Configuration file with jira section
- `.bmad-core/data/jira-mapping.yaml` - Generated mapping file
