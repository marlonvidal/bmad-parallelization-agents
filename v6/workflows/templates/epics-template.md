---
stepsCompleted: []
inputDocuments: []
---

# {{project_name}} - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for {{project_name}}, decomposing the requirements from the PRD, UX Design if it exists, and Architecture requirements into implementable stories.

## Requirements Inventory

### Functional Requirements

{{fr_list}}

### NonFunctional Requirements

{{nfr_list}}

### Additional Requirements

{{additional_requirements}}

### UX Design Requirements

{{ux_design_requirements}}

### FR Coverage Map

{{requirements_coverage_map}}

## Epic List

{{epics_list}}

<!-- Repeat for each epic in epics_list (N = 1, 2, 3...) -->

## Epic {{N}}: {{epic_title_N}}

{{epic_goal_N}}

**Implementation Domain:** {{Full-Stack | Backend-Only | Frontend-Only | Non-Technical}}

<!-- Repeat for each story (or parallel pair) within epic N -->
<!-- For Full-Stack epics: use the parallel pair format below (N.M-BE + N.M-FE) -->
<!-- For single-domain epics: use the standard story format below -->

<!-- PARALLEL PAIR FORMAT (Full-Stack epics only) -->

### Story {{N}}.{{M}}-BE: {{story_title_N_M}} – Backend

**Story Domain:** Backend
**Paired Story:** {{N}}.{{M}}-FE – {{story_title_N_M}} – Frontend
**Data Contract:** {{endpoint, method, request/response schema — defined in AC below}}

As a {{user_type}},
I want {{backend_capability}},
So that {{value_benefit}}.

**Acceptance Criteria:**

<!-- for each AC on this story -->

**Given** {{precondition}}
**When** {{action}}
**Then** {{expected_outcome}}
**And** Data Contract is defined: {{endpoint}} {{method}} returns {{response_shape}}

**Blocking Dependencies:**
- Frontend: None
- Backend: None

---

### Story {{N}}.{{M}}-FE: {{story_title_N_M}} – Frontend

**Story Domain:** Frontend
**Paired Story:** {{N}}.{{M}}-BE – {{story_title_N_M}} – Backend
**Data Contract:** {{reference to contract defined in Story N.M-BE}}

As a {{user_type}},
I want {{frontend_capability}},
So that {{value_benefit}}.

**Acceptance Criteria:**

<!-- for each AC on this story -->

**Given** {{precondition with mocked contract data}}
**When** {{user action}}
**Then** {{expected UI outcome}}
**And** Implementation uses mock for {{endpoint}} matching the Data Contract

**Blocking Dependencies:**
- Frontend: None
- Backend: None

<!-- END PARALLEL PAIR -->

<!-- STANDARD STORY FORMAT (Backend-Only, Frontend-Only, or Non-Technical epics) -->

### Story {{N}}.{{M}}: {{story_title_N_M}}

**Story Domain:** {{Backend | Frontend | Full-Stack}}
**Paired Story:** N/A
**Data Contract:** N/A

As a {{user_type}},
I want {{capability}},
So that {{value_benefit}}.

**Acceptance Criteria:**

<!-- for each AC on this story -->

**Given** {{precondition}}
**When** {{action}}
**Then** {{expected_outcome}}
**And** {{additional_criteria}}

**Blocking Dependencies:**
- Frontend: None
- Backend: None

<!-- End story repeat -->
