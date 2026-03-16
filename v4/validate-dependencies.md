# <!-- Powered by BMAD™ Core -->

# Validate Dependencies Task

## Purpose

Validate the consistency and correctness of dependencies declared in epics and stories. This ensures:

1. All paired story references are valid
2. No circular dependencies exist
3. Data contract references are present
4. Dependency format is standardized

## When to Use

- After creating/modifying PRD with epic dependency graph
- Before assigning stories to developers
- During sprint planning
- When dependency issues are suspected

## Instructions

### 1. Locate Files

- Find PRD: `docs/prd.md` or `docs/brownfield-prd.md`
- Check for "Epic Dependency Graph" section
- Find story files in location from `.bmad-core/core-config.yaml`

### 2. Validate Epic Dependencies

- Check all epics are in dependency graph
- Verify no epic references non-existent prerequisites
- Detect circular dependencies (e.g., Epic 2 → Epic 3 → Epic 2)

### 3. Validate Story Dependencies

For each story check:
- "Dependencies and Parallelism" section exists
- Story Domain declared (Frontend/Backend)
- Paired Story reference is valid
- Data Contract is present
- Blocking Dependencies use format: `[Epic.Story] (Domain): Reason`

Valid dependency examples:
- `None`
- `1.4 (Backend): Requires authentication middleware`
- `2.3 (Frontend): Requires shared component library`

### 4. Validate Story Pairs

- Verify Backend/Frontend pairs reference each other
- Verify both reference same Data Contract
- Contract must be specific (e.g., `/api/users`, `UserQuery`)

### 5. Check Cross-Story Dependencies

For dependencies in format `[Epic.Story] (Domain): Reason`:
- Verify referenced story exists
- Check for circular references
- Validate dependencies don't reference future epics

### 6. Generate Report

Create report with:

**Summary:**
```
✓ Total Epics: X
✓ Total Stories: Y
✓ Validation Status: PASS|FAIL|WARNINGS
```

**Issues Found:**
- List any circular dependencies
- List contract mismatches
- List invalid dependency formats
- List orphaned references

### 7. Provide Recommendations

Based on findings:
- How to break circular dependencies
- How to fix invalid formats
- Which contracts need definition
- Which story references need correction

## Success Criteria

- No circular dependencies
- All story pairs have matching contracts
- All dependencies use standardized format
- All referenced stories exist
- Clear parallel execution paths identified

## Notes

- This task is READ-ONLY
- Run after PRD/story changes
- Critical for multi-developer teams
- Some warnings may be acceptable with justification
