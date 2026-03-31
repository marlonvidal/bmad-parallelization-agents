# Step 4: Final Validation

## STEP GOAL:

To validate complete coverage of all requirements and ensure stories are ready for development. Optionally sync the approved epics and stories to Jira.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:

- 🛑 NEVER generate content without user input
- 📖 CRITICAL: Read the complete step file before taking any action
- 🔄 CRITICAL: Process validation sequentially without skipping
- 📋 YOU ARE A FACILITATOR, not a content generator
- ✅ YOU MUST ALWAYS SPEAK OUTPUT In your Agent communication style with the config `{communication_language}`

### Role Reinforcement:

- ✅ You are a product strategist and technical specifications writer
- ✅ If you already have been given communication or persona patterns, continue to use those while playing this new role
- ✅ We engage in collaborative dialogue, not command-response
- ✅ You bring validation expertise and quality assurance
- ✅ User brings their implementation priorities and final review

### Step-Specific Rules:

- 🎯 Focus ONLY on validating complete requirements coverage
- 🚫 FORBIDDEN to skip any validation checks
- 💬 Validate FR coverage, story completeness, and dependencies
- 🚪 ENSURE all stories are ready for development

## EXECUTION PROTOCOLS:

- 🎯 Validate every requirement has story coverage
- 💾 Check story dependencies and flow
- 📖 Verify architecture compliance
- 🚫 FORBIDDEN to approve incomplete coverage

## CONTEXT BOUNDARIES:

- Available context: Complete epic and story breakdown from previous steps
- Focus: Final validation of requirements coverage and story readiness
- Limits: Validation only, no new content creation
- Dependencies: Completed story generation from Step 3

## VALIDATION PROCESS:

### 1. FR Coverage Validation

Review the complete epic and story breakdown to ensure EVERY FR is covered:

**CRITICAL CHECK:**

- Go through each FR from the Requirements Inventory
- Verify it appears in at least one story
- Check that acceptance criteria fully address the FR
- No FRs should be left uncovered

### 2. Architecture Implementation Validation

**Check for Starter Template Setup:**

- Does Architecture document specify a starter template?
- If YES: Epic 1 Story 1 must be "Set up initial project from starter template"
- This includes cloning, installing dependencies, initial configuration

**Database/Entity Creation Validation:**

- Are database tables/entities created ONLY when needed by stories?
- ❌ WRONG: Epic 1 creates all tables upfront
- ✅ RIGHT: Tables created as part of the first story that needs them
- Each story should create/modify ONLY what it needs

### 3. Story Quality Validation

**Each story must:**

- Be completable by a single dev agent
- Have clear acceptance criteria
- Reference specific FRs it implements
- Include necessary technical details
- **Not have forward dependencies** (can only depend on PREVIOUS stories)
- Be implementable without waiting for future stories

### 4. Epic Structure Validation

**Check that:**

- Epics deliver user value, not technical milestones
- Dependencies flow naturally
- Foundation stories only setup what's needed
- No big upfront technical work

### 5. Dependency Validation (CRITICAL)

**Epic Independence Check:**

- Does each epic deliver COMPLETE functionality for its domain?
- Can Epic 2 function without Epic 3 being implemented?
- Can Epic 3 function standalone using Epic 1 & 2 outputs?
- ❌ WRONG: Epic 2 requires Epic 3 features to work
- ✅ RIGHT: Each epic is independently valuable

**Within-Epic Story Dependency Check:**
For each epic, review stories in order:

- Can Story N.1 be completed without Stories N.2, N.3, etc.?
- Can Story N.2 be completed using only Story N.1 output?
- Can Story N.3 be completed using only Stories N.1 & N.2 outputs?
- ❌ WRONG: "This story depends on a future story"
- ❌ WRONG: Story references features not yet implemented
- ✅ RIGHT: Each story builds only on previous stories

### 6. Parallel Pair Validation (Full-Stack Epics)

For any epic classified as `Full-Stack`, verify that:

- Every feature has a `-BE` and `-FE` story pair — no vertical-slice stories exist
- Each `-BE` story defines a **Data Contract** in its acceptance criteria
- Each `-FE` story references the Data Contract from its paired `-BE` story
- **Blocking Dependencies** for both `-BE` and `-FE` stories are set to `None` (they are parallelizable)
- `-FE` stories use mocked contract data and are NOT blocked by `-BE` completion

### 7. Complete and Save

If all validations pass:

- Update any remaining placeholders in the document
- Ensure proper formatting
- Save the final epics.md

**Present Final Menu:**

Display: "**Select an Option:** [J] Sync to Jira (optional) [C] Complete Workflow"

HALT — wait for user input before proceeding.

#### Menu Handling Logic:

- IF J: Execute the JIRA SYNC FLOW below
- IF C: Workflow is complete — invoke the `bmad-help` skill and offer to answer any questions about the Epics and Stories
- IF Any other comments or queries: help user respond then redisplay the menu

---

## JIRA SYNC FLOW

Execute this flow ONLY when user selects [J] from the final menu.

### J.1 — Verify Jira MCP Availability

**CRITICAL:** This step determines if Jira integration is possible.

1. Read file: `~/.cursor/mcp.json`
2. Parse JSON and look for `"jira"` key in `mcpServers` object

**If Jira MCP NOT found:**
- Inform user: "Jira MCP is not configured. To enable Jira integration, follow the setup guide at `_bmad/bmm/3-solutioning/bmad-create-epics-and-stories/JIRA-SETUP.md`."
- Ask: "Would you like me to explain the setup process?"
- **Return to menu** — do not proceed with sync

**If Jira MCP found:**
- Confirm: "Jira MCP detected. Proceeding with sync..."

### J.2 — Load Jira Configuration

1. Read `_bmad/bmm/config.yaml`
2. Look for `jira:` section

**If `jira:` section missing or `projectKey` is null:**
- Prompt user: "What is your Jira project key? (e.g., `PROJ`, `MYAPP`)"
- Prompt user: "What is your Jira base URL? (e.g., `https://your-company.atlassian.net`)"
- Inform: "Please add a `jira:` section to `_bmad/bmm/config.yaml` — see JIRA-SETUP.md for the exact format."
- Continue with user-provided values for this session

**Extract:**
- `projectKey` (required)
- `baseUrl` (required)
- `issueTypes.epic` (default: `Epic`)
- `issueTypes.story` (default: `Story`)
- `mappingFile` (default: `{output_folder}/jira-mapping.yaml`)

Display configuration summary and ask: "Proceed with sync using this configuration? (Y/n)"

### J.3 — Load epics.md and Extract Content

Load `{planning_artifacts}/epics.md` and extract:

1. **All Epics** — title, epic number, Implementation Domain, goal statement
2. **All Stories per Epic** — story ID, title, story statement, acceptance criteria, Story Domain, Paired Story, Data Contract, Blocking Dependencies

**Parallel pair detection:**
- If story ID ends in `-BE` or `-FE`, it is a parallel pair member
- Group `-BE` and `-FE` siblings together for display

Display: "Found {N} epics and {M} stories ({P} parallel pairs). Proceed? (Y/n)"

### J.4 — Check Existing Mapping

Read `{output_folder}/jira-mapping.yaml` (path from config or default):

- **If file exists:** Display "Found existing Jira mapping. Ask: "1) Update existing issues  2) Create new only  3) Full re-sync"
- **If file doesn't exist:** Initialize empty mapping structure

```yaml
projectKey: {projectKey}
baseUrl: {baseUrl}
syncedAt: {ISO 8601 timestamp}
epics: {}
stories: {}
```

### J.5 — Create Jira Epics

For each epic in the approved epics list:

1. Check if already in mapping — skip or update per J.4 choice
2. Create Jira Epic using MCP tool `jira_create_issue`:
   - `project`: `{projectKey}`
   - `summary`: "Epic {N}: {epic_title}"
   - `issuetype`: `{issueTypes.epic}`
   - `description`:
     ```
     {epic_goal}

     Implementation Domain: {domain}

     Stories in this Epic:
     {list of story titles}

     ---
     Synced from BMAD epics.md
     ```
3. Store returned epic key in mapping: `epics: { N: "PROJ-100" }`
4. Save mapping file after each epic (incremental)
5. Show progress: "Created Epic {N}: {title} → {epicKey} — {baseUrl}/browse/{epicKey}"

### J.6 — Create Jira Stories

For each story in each epic:

1. Check if already in mapping — skip or update per J.4 choice
2. Look up parent epic key from mapping
3. Build story description based on story type:

**For parallel pair stories (`-BE` / `-FE`):**

```
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
```

**For standard stories:**

```
{story_statement}

## Acceptance Criteria
{ACs in Given/When/Then format}

## Story Domain
{Story Domain}

## Blocking Dependencies
{blocking_dependencies}

---
Synced from BMAD epics.md
```

4. Create via `jira_create_issue`:
   - `project`: `{projectKey}`
   - `summary`: "Story {story_id}: {story_title}"
   - `issuetype`: `{issueTypes.story}`
   - `parent`: `{parentEpicKey}` (try `parent` first, then `epicLink` if that fails)
   - `description`: formatted description above
5. Store in mapping: `stories: { "N.M-BE": "PROJ-103" }`
6. Save mapping after each epic's stories (incremental)
7. Show progress grouped by epic

### J.7 — Save Final Mapping File

1. Set `syncedAt` to current ISO 8601 timestamp
2. Write mapping to `{output_folder}/jira-mapping.yaml`
3. Confirm: "Mapping saved to: `{mappingFile}`"

### J.8 — Display Summary Report

```
## Jira Sync Summary

Project: {projectKey}
Base URL: {baseUrl}

### Epics Created
| Epic | Title | Jira Key | Link |
|------|-------|----------|------|
| Epic 1 | ... | PROJ-100 | [View]({url}) |

### Stories Created
| Story | Title | Domain | Jira Key | Link |
|-------|-------|--------|----------|------|
| 1.1-BE | ... | Backend | PROJ-103 | [View]({url}) |
| 1.1-FE | ... | Frontend | PROJ-104 | [View]({url}) |

### Errors/Warnings
{any failures}
```

After displaying the summary, **redisplay the final menu:**

Display: "**Select an Option:** [J] Sync to Jira (re-run) [C] Complete Workflow"

---

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:

- All FRs validated as covered by stories
- Story quality checks pass
- Epic structure validates as user-value focused
- Dependency ordering validated
- Full-Stack epics have valid parallel BE/FE pairs
- Document saved and formatted correctly
- (If J selected) Jira epics and stories created with mapping file saved

### ❌ SYSTEM FAILURE:

- FRs missing from story coverage
- Stories with forward dependencies
- Vertical-slice stories in Full-Stack epics
- (If J selected) Jira sync completed with no mapping file saved

**Master Rule:** Skipping steps, optimizing sequences, or not following exact instructions is FORBIDDEN and constitutes SYSTEM FAILURE.
