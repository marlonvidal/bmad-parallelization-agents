# Step 3: Generate Epics and Stories

## STEP GOAL:

To generate all epics with their stories based on the approved epics_list, following the template structure exactly.

## MANDATORY EXECUTION RULES (READ FIRST):

### Universal Rules:

- 🛑 NEVER generate content without user input
- 📖 CRITICAL: Read the complete step file before taking any action
- 🔄 CRITICAL: Process epics sequentially
- 📋 YOU ARE A FACILITATOR, not a content generator
- ✅ YOU MUST ALWAYS SPEAK OUTPUT In your Agent communication style with the config `{communication_language}`

### Role Reinforcement:

- ✅ You are a product strategist and technical specifications writer
- ✅ If you already have been given communication or persona patterns, continue to use those while playing this new role
- ✅ We engage in collaborative dialogue, not command-response
- ✅ You bring story creation and acceptance criteria expertise
- ✅ User brings their implementation priorities and constraints

### Step-Specific Rules:

- 🎯 Generate stories for each epic following the template exactly
- 🚫 FORBIDDEN to deviate from template structure
- 💬 Each story must have clear acceptance criteria
- 🚪 ENSURE each story is completable by a single dev agent
- 🔗 **CRITICAL: Stories MUST NOT depend on future stories within the same epic**
- ⚡ **PARALLEL STORIES: For Full-Stack epics, NEVER create vertical-slice stories — generate paired Backend and Frontend stories**

## EXECUTION PROTOCOLS:

- 🎯 Generate stories collaboratively with user input
- 💾 Append epics and stories to {planning_artifacts}/epics.md following template
- 📖 Process epics one at a time in sequence
- 🚫 FORBIDDEN to skip any epic or rush through stories

## STORY GENERATION PROCESS:

### 1. Load Approved Epic Structure

Load {planning_artifacts}/epics.md and review:

- Approved epics_list from Step 2
- FR coverage map
- All requirements (FRs, NFRs, additional, **UX Design requirements if present**)
- Template structure at the end of the document

**UX Design Integration**: If UX Design Requirements (UX-DRs) were extracted in Step 1, ensure they are visible during story creation. UX-DRs must be covered by stories — either within existing epics (e.g., accessibility fixes for a feature epic) or in a dedicated "Design System / UX Polish" epic.

### 2. Explain Story Creation Approach

**STORY CREATION GUIDELINES:**

For each epic, create stories that:

- Follow the exact template structure
- Are sized for single dev agent completion
- Have clear user value
- Include specific acceptance criteria
- Reference requirements being fulfilled

**🚨 DATABASE/ENTITY CREATION PRINCIPLE:**
Create tables/entities ONLY when needed by the story:

- ❌ WRONG: Epic 1 Story 1 creates all 50 database tables
- ✅ RIGHT: Each story creates/alters ONLY the tables it needs

**🔗 STORY DEPENDENCY PRINCIPLE:**
Stories must be independently completable in sequence:

- ❌ WRONG: Story 1.2 requires Story 1.3 to be completed first
- ✅ RIGHT: Each story can be completed based only on previous stories
- ❌ WRONG: "Wait for Story 1.4 to be implemented before this works"
- ✅ RIGHT: "This story works independently and enables future stories"

**⚡ STORY PARALLELIZATION PRINCIPLE:**

For any **Full-Stack** epic (classified as such in Step 2), NEVER create vertical-slice stories. Always generate a **paired story set** instead:

- 🚫 FORBIDDEN: A single story that implements both the API/DB and the UI together
- ✅ REQUIRED: Two sibling stories that can be worked simultaneously by independent dev agents:
  - **Backend Story (`N.M-BE`)**: implements API endpoints, data models, and business logic only — no UI. Must define an explicit **Data Contract** (request/response schema) as part of its acceptance criteria.
  - **Frontend Story (`N.M-FE`)**: implements all UI/UX components using **mocked contract-based data** — not blocked by backend completion. References the Data Contract from the paired BE story.

**Story naming for parallel pairs:**
- `Story N.M-BE: [Feature Name] – Backend`
- `Story N.M-FE: [Feature Name] – Frontend`

**Data Contract rule:**
- The BE story MUST include an AC that defines and outputs the API contract (endpoint, method, request/response shape)
- The FE story MUST reference that contract by name and implement against mocks — it is **never** blocked waiting for BE completion

**When NOT to parallelize (single story only):**
- Pure backend tasks (data migrations, background jobs) with no UI counterpart
- Pure frontend tasks (static pages, design tokens) consuming an already-existing API
- Non-technical work (documentation, configuration, infrastructure with no UI)
- Epics classified as `Backend-Only`, `Frontend-Only`, or `Non-Technical` in Step 2

**STORY FORMAT — Standard (non-parallel or single-domain):**

```
### Story {N}.{M}: {story_title}

**Story Domain:** Backend | Frontend | Full-Stack
**Paired Story:** N/A
**Data Contract:** N/A

As a {user_type},
I want {capability},
So that {value_benefit}.

**Acceptance Criteria:**

**Given** {precondition}
**When** {action}
**Then** {expected_outcome}
**And** {additional_criteria}

**Blocking Dependencies:**
- Frontend: None
- Backend: None
```

**STORY FORMAT — Parallel Pair (Full-Stack epics):**

```
### Story {N}.{M}-BE: {feature_name} – Backend

**Story Domain:** Backend
**Paired Story:** {N}.{M}-FE – {feature_name} – Frontend
**Data Contract:** {endpoint, method, request/response schema defined in AC below}

As a {user_type},
I want {backend_capability},
So that {value_benefit}.

**Acceptance Criteria:**

**Given** {precondition}
**When** {action}
**Then** {expected_outcome}
**And** Data Contract is defined: {endpoint} {method} returns {response_shape}

**Blocking Dependencies:**
- Frontend: None
- Backend: None

---

### Story {N}.{M}-FE: {feature_name} – Frontend

**Story Domain:** Frontend
**Paired Story:** {N}.{M}-BE – {feature_name} – Backend
**Data Contract:** {reference to contract defined in Story N.M-BE}

As a {user_type},
I want {frontend_capability},
So that {value_benefit}.

**Acceptance Criteria:**

**Given** {precondition with mocked contract data}
**When** {user action}
**Then** {expected UI outcome}
**And** Implementation uses mock for {endpoint} matching the Data Contract

**Blocking Dependencies:**
- Frontend: None
- Backend: None
```

**✅ GOOD STORY EXAMPLES:**

_Epic 1: User Authentication — Full-Stack (parallel pairs)_

- Story 1.1-BE: User Registration – Backend _(API + DB, defines registration contract)_
- Story 1.1-FE: User Registration – Frontend _(registration form using mocked contract)_
- Story 1.2-BE: User Login – Backend _(auth endpoint + session, defines login contract)_
- Story 1.2-FE: User Login – Frontend _(login form using mocked contract)_
- Story 1.3-BE: Password Reset – Backend _(reset token + email flow)_
- Story 1.3-FE: Password Reset – Frontend _(reset UI using mocked contract)_

_Epic 2: Content Creation — Full-Stack (parallel pairs)_

- Story 2.1-BE: Create Blog Post – Backend _(POST /posts endpoint + DB schema)_
- Story 2.1-FE: Create Blog Post – Frontend _(post creation form using mocked contract)_
- Story 2.2-BE: Edit Blog Post – Backend _(PATCH /posts/:id endpoint)_
- Story 2.2-FE: Edit Blog Post – Frontend _(edit form using mocked contract)_

_Epic 3: Notifications — Backend-Only (no parallel needed)_

- Story 3.1: Email Notification Service _(no UI, Backend-Only epic)_
- Story 3.2: Notification Queue Worker _(no UI, Backend-Only epic)_

**❌ BAD STORY EXAMPLES:**

- Story: "Set up database" (no user value)
- Story: "Create all models" (too large, no user value)
- Story: "Build authentication system" (too large)
- Story: "User Login" _(vertical slice — implements backend AND frontend together — FORBIDDEN for Full-Stack epic)_
- Story: "Login UI (depends on Story 1.3 API endpoint)" (future dependency!)
- Story: "Edit post (requires Story 1.4 to be implemented first)" (wrong order!)

### 3. Process Epics Sequentially

For each epic in the approved epics_list:

#### A. Epic Overview

Display:

- Epic number and title
- Epic goal statement
- FRs covered by this epic
- Any NFRs or additional requirements relevant
- Any UX Design Requirements (UX-DRs) relevant to this epic

#### B. Story Breakdown

Work with user to break down the epic into stories:

- Identify distinct user capabilities
- Ensure logical flow within the epic
- Size stories appropriately
- **Check the epic's Implementation Domain** (set in Step 2):
  - If `Full-Stack` → apply the Parallel Pair pattern for every full-stack capability
  - If `Backend-Only`, `Frontend-Only`, or `Non-Technical` → generate standard single stories

#### C. Generate Each Story

For each story (or parallel pair) in the epic:

1. **Story Title**: Clear, action-oriented; append `-BE` / `-FE` suffix for parallel pairs
2. **Story Domain**: Backend | Frontend | Full-Stack
3. **Paired Story**: Reference the sibling story (or N/A)
4. **Data Contract**: API contract reference for BE stories; mock reference for FE stories (or N/A)
5. **User Story**: Complete the As a/I want/So that format
6. **Acceptance Criteria**: Write specific, testable criteria; BE stories must include a contract-definition AC
7. **Blocking Dependencies**: Frontend and Backend dependency declarations

**AC Writing Guidelines:**

- Use Given/When/Then format
- Each AC should be independently testable
- Include edge cases and error conditions
- Reference specific requirements when applicable

#### D. Collaborative Review

After writing each story:

- Present the story to user
- Ask: "Does this story capture the requirement correctly?"
- "Is the scope appropriate for a single dev session?"
- "Are the acceptance criteria complete and testable?"

#### E. Append to Document

When story is approved:

- Append it to {planning_artifacts}/epics.md following template structure
- Use correct numbering (Epic N, Story M)
- Maintain proper markdown formatting

### 4. Epic Completion

After all stories for an epic are complete:

- Display epic summary
- Show count of stories created
- Verify all FRs for the epic are covered
- Get user confirmation to proceed to next epic

### 5. Repeat for All Epics

Continue the process for each epic in the approved list, processing them in order (Epic 1, Epic 2, etc.).

### 6. Final Document Completion

After all epics and stories are generated:

- Verify the document follows template structure exactly
- Ensure all placeholders are replaced
- Confirm all FRs are covered
- **Confirm all UX Design Requirements (UX-DRs) are covered by at least one story** (if UX document was an input)
- Check formatting consistency

## TEMPLATE STRUCTURE COMPLIANCE:

The final {planning_artifacts}/epics.md must follow this structure exactly:

1. **Overview** section with project name
2. **Requirements Inventory** with all three subsections populated
3. **FR Coverage Map** showing requirement to epic mapping
4. **Epic List** with approved epic structure (including Implementation Domain per epic)
5. **Epic sections** for each epic (N = 1, 2, 3...)
   - Epic title and goal
   - All stories for that epic — using the correct format per domain:
     - **Full-Stack epics**: paired `-BE` and `-FE` stories
     - **Single-domain epics**: standard stories
   - Each story includes:
     - Story title and user story (As a / I want / So that)
     - **Story Domain** field
     - **Paired Story** field (or N/A)
     - **Data Contract** field (or N/A)
     - Acceptance Criteria using Given/When/Then format
     - **Blocking Dependencies** (Frontend / Backend)

### 7. Present FINAL MENU OPTIONS

After all epics and stories are complete:

Display: "**Select an Option:** [A] Advanced Elicitation [P] Party Mode [C] Continue"

#### Menu Handling Logic:

- IF A: Invoke the `bmad-advanced-elicitation` skill
- IF P: Invoke the `bmad-party-mode` skill
- IF C: Save content to {planning_artifacts}/epics.md, update frontmatter, then read fully and follow: ./step-04-final-validation.md
- IF Any other comments or queries: help user respond then [Redisplay Menu Options](#7-present-final-menu-options)

#### EXECUTION RULES:

- ALWAYS halt and wait for user input after presenting menu
- ONLY proceed to next step when user selects 'C'
- After other menu items execution, return to this menu
- User can chat or ask questions - always respond and then end with display again of the menu options

## CRITICAL STEP COMPLETION NOTE

ONLY WHEN [C continue option] is selected and [all epics and stories saved to document following the template structure exactly], will you then read fully and follow: `./step-04-final-validation.md` to begin final validation phase.

---

## 🚨 SYSTEM SUCCESS/FAILURE METRICS

### ✅ SUCCESS:

- All epics processed in sequence
- Stories created for each epic
- Template structure followed exactly
- All FRs covered by stories
- Stories appropriately sized
- Acceptance criteria are specific and testable
- Full-Stack epics have paired `-BE` / `-FE` stories with Data Contracts defined
- All stories include Story Domain, Paired Story, Data Contract, and Blocking Dependencies fields
- Document is complete and ready for development

### ❌ SYSTEM FAILURE:

- Deviating from template structure
- Missing epics or stories
- Stories too large or unclear
- Missing acceptance criteria
- Not following proper formatting
- Vertical-slice stories created for Full-Stack epics (backend + frontend in one story)
- Missing Story Domain, Paired Story, Data Contract, or Blocking Dependencies fields

**Master Rule:** Skipping steps, optimizing sequences, or not following exact instructions is FORBIDDEN and constitutes SYSTEM FAILURE.
