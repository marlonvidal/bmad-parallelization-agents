# BMAD Parallel Agents - Enhanced Dependency Tracking

## Version 2.1 - Enhanced Features

This enhanced version adds **Epic Dependency Tracking** and **Standardized Dependency Format** to support multi-developer teams working in parallel.

---

## 🎯 What's New

### 1. **Epic Dependency Graph** (in PRD Template)

A new section in the PRD that explicitly documents which epics can run in parallel and which have blocking dependencies.

**Format:**
```
| Epic | Prerequisite Epics | Can Parallel With | Rationale |
|------|-------------------|------------------|-----------|
| Epic 1 | None | All (once contracts defined) | Foundation setup |
| Epic 2 | Epic 1 (contracts defined) | Epic 3, 4 | Requires auth system |
| Epic 3 | Epic 1 (contracts defined) | Epic 2, 4 | Independent feature |
```

**Benefits:**
- Makes parallel execution opportunities crystal clear
- Helps with sprint planning and team allocation
- Prevents accidental blocking dependencies
- Essential for coordinating 5+ developers

### 2. **Standardized Dependency Format** (in Story Template)

Enhanced the "Dependencies and Parallelism" section with a standardized format for cross-story dependencies.

**Format:** `[Epic.Story] (Domain): Reason`

**Examples:**
- `1.4 (Backend): Requires authentication middleware`
- `2.3 (Frontend): Requires shared component library`
- `None` (expected default)

**Before (old format):**
```
- **Blocking Dependencies**: Story 1.4 needs auth
```

**After (new standardized format):**
```
- **Blocking Dependencies**: 
  - Frontend: None (uses mocked auth from contract)
  - Backend: 1.4 (Backend): Requires authentication middleware
```

**Benefits:**
- Clear, parseable format for dependency tracking
- Separates Frontend and Backend dependencies
- Enables automated validation
- Reduces ambiguity

### 3. **Validate Dependencies Task**

New task that validates:
- ✅ No circular dependencies (epic or story level)
- ✅ All story pairs have matching contracts
- ✅ All cross-story dependencies use standardized format
- ✅ All referenced stories exist
- ✅ Dependency format is correct

**Usage:**
```
PM Agent: *validate-dependencies
PO Agent: *validate-dependencies
```

**Output:**
- Validation report with PASS/FAIL/WARNINGS
- List of issues found
- Actionable recommendations

### 4. **Create Dependency Map Task**

New task that generates visual dependency graphs using Mermaid diagrams:

- Epic-level dependency graph
- Story-level dependency graphs (per epic)
- Cross-epic dependency visualization
- Backend vs Frontend parallel execution timeline
- Contract dependency matrix
- Team allocation suggestions
- Summary dashboard

**Usage:**
```
PM Agent: *create-dependency-map
PO Agent: *create-dependency-map
```

**Output:**
- `docs/dependency-map.md` with all visualizations
- Mermaid diagrams (render in GitHub, GitLab, VS Code)
- Parallel execution opportunities highlighted
- Critical path identified

---

## 📦 What Gets Overridden

The installation script now installs:

### Agents (5 files → `.bmad-core/agents/`)
- `architect.md`
- `pm.md` ← **Enhanced with new commands**
- `po.md` ← **Enhanced with new commands**
- `developer-front.md`
- `developer-back.md`

### Templates (2 files → `.bmad-core/templates/`) ← **OVERRIDES**
- `prd-tmpl.yaml` ← **Enhanced with Epic Dependency Graph**
- `story-tmpl.yaml` ← **Enhanced with Standardized Dependency Format**

### Tasks (2 files → `.bmad-core/tasks/`) ← **OVERRIDES**
- `validate-dependencies.md` ← **NEW**
- `create-dependency-map.md` ← **NEW**

---

## 🚀 New PM/PO Commands

### PM Agent Commands

```
*validate-dependencies   - Check for circular dependencies
*create-dependency-map   - Generate visual dependency diagrams
*create-prd             - Uses enhanced PRD template (with Epic Dependency Graph)
```

### PO Agent Commands

```
*validate-dependencies   - Check for circular dependencies
*create-dependency-map   - Generate visual dependency diagrams
```

---

## 💡 How to Use

### 1. Create PRD with Dependency Tracking

```
@pm *create-prd
```

The PM will now:
1. Create epic list as usual
2. **NEW:** Create Epic Dependency Graph showing which epics can run in parallel
3. Create detailed stories with standardized dependency format

### 2. Validate Dependencies

Before assigning stories to developers:

```
@pm *validate-dependencies
```

This will:
- Check for circular dependencies
- Validate all story references
- Verify contract consistency
- Report any issues with recommendations

### 3. Generate Dependency Map

To visualize the project structure:

```
@pm *create-dependency-map
```

This creates:
- Visual Mermaid diagrams
- Parallel execution timeline
- Team allocation suggestions
- Saved to `docs/dependency-map.md`

---

## 📊 Example Workflow

### Phase 1: Planning
1. PM creates PRD with `*create-prd`
2. PM reviews Epic Dependency Graph with team
3. PM runs `*validate-dependencies` to check for issues
4. PM runs `*create-dependency-map` for visual planning

### Phase 2: Development
1. Team uses dependency map to understand parallel opportunities
2. Frontend team works on all FE stories using mocked contracts
3. Backend team works on all BE stories
4. No blocking between teams within each epic

### Phase 3: Sprint Planning
1. PM/PO use Epic Dependency Graph to plan sprints
2. Identify which epics can be tackled in parallel
3. Allocate teams based on dependency visualization
4. Re-validate dependencies after any story changes

---

## 🎯 Key Benefits for Multi-Developer Teams

| Feature | Benefit |
|---------|---------|
| **Epic Dependency Graph** | Know which epics can run in parallel at a glance |
| **Standardized Dependencies** | Clear, unambiguous dependency notation |
| **Dependency Validation** | Catch circular dependencies early |
| **Visual Dependency Maps** | Communicate structure to entire team |
| **Team Allocation Suggestions** | Optimize parallel execution |
| **Contract Matrix** | Track which contracts enable which story pairs |

---

## ⚠️ Important Notes

### Templates Are Overridden

The installation script **OVERRIDES** these core templates:
- `.bmad-core/templates/prd-tmpl.yaml`
- `.bmad-core/templates/story-tmpl.yaml`

**This is by design** - the enhancements are additive and maintain backward compatibility.

### Backup Created Automatically

The installer automatically backs up existing files with timestamps:
- `.bmad-core/agents/.backup-YYYYMMDD-HHMMSS/`

### Re-run Anytime

The installer is idempotent - safe to re-run for updates:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export/install-bmad-parallel.sh)
```

---

## 📝 Example Epic Dependency Graph

```markdown
| Epic | Prerequisite Epics | Can Parallel With | Rationale |
|------|-------------------|------------------|-----------|
| Epic 1: Foundation | None | All (once contracts defined) | Sets up API contracts, auth foundation |
| Epic 2: User Management | Epic 1 (contracts) | Epic 3, 4, 5 | Requires auth middleware from Epic 1 |
| Epic 3: Product Catalog | Epic 1 (contracts) | Epic 2, 4, 5 | Independent feature domain |
| Epic 4: Shopping Cart | Epic 1 (contracts) | Epic 2, 3, 5 | Independent feature domain |
| Epic 5: Checkout | Epic 1, 3, 4 | None | Requires product catalog and cart |
```

**Parallel Execution:**
- Epic 1 runs first (foundation)
- Epic 2, 3, 4 run in parallel after Epic 1 completes
- Epic 5 runs after Epic 3 and 4 complete

**Team Allocation:**
- Phase 1: All teams on Epic 1 (foundation)
- Phase 2: Team A on Epic 2, Team B on Epic 3, Team C on Epic 4 (parallel)
- Phase 3: Team A+B on Epic 5

---

## 📖 Documentation

Full documentation available:
- [README.md](README.md) - Main overview
- [QUICKSTART.md](QUICKSTART.md) - Quick setup guide
- [INDEX.md](INDEX.md) - Navigation guide

---

**Made with ❤️ for parallel development with BMAD**
