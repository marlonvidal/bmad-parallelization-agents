<!-- Powered by BMAD™ Core -->

# Create Next Story Task (Enhanced with Jira Sync)

## Purpose

To identify the next logical story based on project progress and epic definitions, and then to prepare a comprehensive, self-contained, and actionable story file using the `Story Template`. This task ensures the story is enriched with all necessary technical context, requirements, and acceptance criteria, making it ready for efficient implementation by a Developer Agent with minimal need for additional research or finding its own context.

**Enhancement**: This version includes optional Jira synchronization to keep story tracking in sync with development progress.

## SEQUENTIAL Task Execution (Do not proceed until current Task is complete)

### 0. Load Core Configuration and Check Workflow

- Load `.bmad-core/core-config.yaml` from the project root
- If the file does not exist, HALT and inform the user: "core-config.yaml not found. This file is required for story creation. You can either: 1) Copy it from GITHUB bmad-core/core-config.yaml and configure it for your project OR 2) Run the BMad installer against your project to upgrade and add the file automatically. Please add and configure core-config.yaml before proceeding."
- Extract key configurations: `devStoryLocation`, `prd.*`, `architecture.*`, `workflow.*`, `jira.*`

### 1. Identify Next Story for Preparation

#### 1.1 Locate Epic Files and Review Existing Stories

- Based on `prdSharded` from config, locate epic files (sharded location/pattern or monolithic PRD sections)
- If `devStoryLocation` has story files, load the highest `{epicNum}.{storyNum}.story.md` file
- **If highest story exists:**
  - Verify status is 'Done'. If not, alert user: "ALERT: Found incomplete story! File: {lastEpicNum}.{lastStoryNum}.story.md Status: [current status] You should fix this story first, but would you like to accept risk & override to create the next story in draft?"
  - If proceeding, select next sequential story in the current epic
  - If epic is complete, prompt user: "Epic {epicNum} Complete: All stories in Epic {epicNum} have been completed. Would you like to: 1) Begin Epic {epicNum + 1} with story 1 2) Select a specific story to work on 3) Cancel story creation"
  - **CRITICAL**: NEVER automatically skip to another epic. User MUST explicitly instruct which story to create.
- **If no story files exist:** The next story is ALWAYS 1.1 (first story of first epic)
- Announce the identified story to the user: "Identified next story for preparation: {epicNum}.{storyNum} - {Story Title}"

### 2. Gather Story Requirements and Previous Story Context

- Extract story requirements from the identified epic file
- If previous story exists, review Dev Agent Record sections for:
  - Completion Notes and Debug Log References
  - Implementation deviations and technical decisions
  - Challenges encountered and lessons learned
- Extract relevant insights that inform the current story's preparation

### 3. Gather Architecture Context

#### 3.1 Determine Architecture Reading Strategy

- **If `architectureVersion: >= v4` and `architectureSharded: true`**: Read `{architectureShardedLocation}/index.md` then follow structured reading order below
- **Else**: Use monolithic `architectureFile` for similar sections

#### 3.2 Read Architecture Documents Based on Story Type

**For ALL Stories:** tech-stack.md, unified-project-structure.md, coding-standards.md, testing-strategy.md

**For Backend/API Stories, additionally:** data-models.md, database-schema.md, backend-architecture.md, rest-api-spec.md, external-apis.md

**For Frontend/UI Stories, additionally:** frontend-architecture.md, components.md, core-workflows.md, data-models.md

**For Full-Stack Stories:** Read both Backend and Frontend sections above

#### 3.3 Extract Story-Specific Technical Details

Extract ONLY information directly relevant to implementing the current story. Do NOT invent new libraries, patterns, or standards not in the source documents.

Extract:

- Specific data models, schemas, or structures the story will use
- API endpoints the story must implement or consume
- Component specifications for UI elements in the story
- File paths and naming conventions for new code
- Testing requirements specific to the story's features
- Security or performance considerations affecting the story

ALWAYS cite source documents: `[Source: architecture/{filename}.md#{section}]`

### 4. Verify Project Structure Alignment

- Cross-reference story requirements with Project Structure Guide from `docs/architecture/unified-project-structure.md`
- Ensure file paths, component locations, or module names align with defined structures
- Document any structural conflicts in "Project Structure Notes" section within the story draft

### 5. Populate Story Template with Full Context

- Create new story file: `{devStoryLocation}/{epicNum}.{storyNum}.story.md` using Story Template
- Fill in basic story information: Title, Status (Draft), Story statement, Acceptance Criteria from Epic
- **`Dev Notes` section (CRITICAL):**
  - CRITICAL: This section MUST contain ONLY information extracted from architecture documents. NEVER invent or assume technical details.
  - Include ALL relevant technical details from Steps 2-3, organized by category:
    - **Previous Story Insights**: Key learnings from previous story
    - **Data Models**: Specific schemas, validation rules, relationships [with source references]
    - **API Specifications**: Endpoint details, request/response formats, auth requirements [with source references]
    - **Component Specifications**: UI component details, props, state management [with source references]
    - **File Locations**: Exact paths where new code should be created based on project structure
    - **Testing Requirements**: Specific test cases or strategies from testing-strategy.md
    - **Technical Constraints**: Version requirements, performance considerations, security rules
  - Every technical detail MUST include its source reference: `[Source: architecture/{filename}.md#{section}]`
  - If information for a category is not found in the architecture docs, explicitly state: "No specific guidance found in architecture docs"
- **`Tasks / Subtasks` section:**
  - Generate detailed, sequential list of technical tasks based ONLY on: Epic Requirements, Story AC, Reviewed Architecture Information
  - Each task must reference relevant architecture documentation
  - Include unit testing as explicit subtasks based on the Testing Strategy
  - Link tasks to ACs where applicable (e.g., `Task 1 (AC: 1, 3)`)
- Add notes on project structure alignment or discrepancies found in Step 4

### 6. Optional Jira Synchronization (NEW - ENHANCED)

**Purpose**: Keep Jira tracking in sync with story development progress

1. **Check for Jira Mapping File**
   - Look for file at: `jira.mappingFile` from core-config.yaml (default: `.bmad-core/data/jira-mapping.yaml`)
   - **If mapping file DOES NOT exist:**
     - Inform user: "No Jira mapping found. This means the PRD hasn't been synced to Jira yet."
     - Ask user: "Would you like to sync the PRD to Jira now? This will create epics and stories in Jira for tracking. (Y/n)"
     - **If YES**:
       - Inform: "Running *sync-to-jira command to create Jira issues..."
       - Execute sync-to-jira.md task
       - After sync completes, continue with step 2 below
     - **If NO**:
       - Inform: "Skipping Jira sync. You can sync later with *sync-to-jira command"
       - Continue to Step 7 (skip rest of Step 6)
   - **If mapping file EXISTS**: Proceed to step 2

2. **Load Jira Mapping and Find Story**
   - Read mapping file
   - Extract: projectKey, baseUrl, stories mapping
   - Look for current story key: `stories["{epicNum}.{storyNum}"]`
   - **If story key NOT found in mapping:**
     - Log warning: "Story {epicNum}.{storyNum} not found in Jira mapping (PRD may have been updated after sync)"
     - Continue to Step 7 (skip Jira update)
   - **If story key found**: Store jiraStoryKey for use below

3. **Update Jira Story Description**
   - Read the story file that was just created
   - Format story content as Jira-compatible markdown description:
     ```markdown
     {Story Statement}
     
     ## Acceptance Criteria
     {Numbered list from story}
     
     ## Technical Details
     {Summary of Dev Notes - key points only}
     
     ## Tasks
     {List of tasks from story Tasks/Subtasks section}
     
     ## Dependencies
     {From Dependencies and Parallelism section}
     
     ---
     *Detailed story drafted by SM agent - ready for development*
     ```
   - **MCP Tool Call**: Use Jira MCP to update story
     - Tool: likely `jira_update_issue`
     - Parameters:
       - issueKey: {jiraStoryKey}
       - fields:
         - description: {formatted description above}
   - **Error Handling**: If update fails, log warning but continue (don't block story creation)

4. **Create Jira Tasks for Story Subtasks**
   - For each task in the story's Tasks/Subtasks section:
     - **MCP Tool Call**: Create Jira task
       - Tool: likely `jira_create_issue`
       - Parameters:
         - project: {projectKey from mapping}
         - summary: "{Task description}"
         - description: "Related AC: {AC numbers}\n\n{Task details if any}"
         - issuetype: {issueTypes.task from config, default "Task"}
         - parent: {jiraStoryKey}
     - **Capture Task Key**: Store in mapping
     - Add small delay (300ms) between task creations
   - **Error Handling**: Continue on individual task creation failures, log issues

5. **Update Mapping File with Task IDs**
   - Add task mappings:
     ```yaml
     tasks:
       "{epicNum}.{storyNum}.1": PROJ-200
       "{epicNum}.{storyNum}.2": PROJ-201
     ```
   - Update syncedAt timestamp
   - Save mapping file

6. **Add Jira Links to Story File Header**
   - Read story file
   - Add section after title (if not exists):
     ```markdown
     ## Jira Links
     - Epic: [{epicKey}]({baseUrl}/browse/{epicKey})
     - Story: [{jiraStoryKey}]({baseUrl}/browse/{jiraStoryKey})
     - Tasks:
       - [{taskKey1}]({baseUrl}/browse/{taskKey1}) - {Task 1 title}
       - [{taskKey2}]({baseUrl}/browse/{taskKey2}) - {Task 2 title}
     ```
   - Save updated story file

7. **Inform User of Jira Sync Results**
   - If sync successful:
     - "Jira story updated with full details"
     - "Created {N} tasks in Jira"
     - Display Jira story link
   - If sync skipped or failed:
     - Explain why (no mapping, errors, etc.)
     - Suggest remediation if needed

**Reference**: See `jira-utils.md` for MCP tool patterns

### 7. Story Draft Completion and Review

- Review all sections for completeness and accuracy
- Verify all source references are included for technical details
- Ensure tasks align with both epic requirements and architecture constraints
- Update status to "Draft" and save the story file
- Execute `.bmad-core/tasks/execute-checklist` `.bmad-core/checklists/story-draft-checklist`
- Provide summary to user including:
  - Story created: `{devStoryLocation}/{epicNum}.{storyNum}.story.md`
  - Status: Draft
  - Key technical components included from architecture docs
  - Any deviations or conflicts noted between epic and architecture
  - Jira sync status (if applicable)
  - Checklist Results
  - Next steps: For Complex stories, suggest the user carefully review the story draft and also optionally have the PO run the task `.bmad-core/tasks/validate-next-story`

## Success Criteria

- [ ] Story file created with all required sections
- [ ] Architecture context extracted and cited
- [ ] Tasks/subtasks align with ACs and architecture
- [ ] Jira story updated with full details (if mapping exists)
- [ ] Jira tasks created for story subtasks (if mapping exists)
- [ ] Jira links added to story file (if sync successful)
- [ ] Checklist executed and passed
- [ ] User informed of next steps

## Notes

- **Jira Integration is Optional**: All Jira steps are conditional - story creation works perfectly without Jira
- **Graceful Degradation**: Jira failures don't block story creation
- **Story File is Source of Truth**: Jira is a mirror, not the authoritative source
- **SM Can Sync PRD**: If mapping doesn't exist, SM can run sync-to-jira directly (no need to switch to PM)
- **Incremental Sync**: Tasks are synced when story is drafted, not during initial PRD sync
- **Reference Documentation**: See JIRA-SETUP.md for prerequisites, jira-utils.md for MCP patterns
