# Data Models

### Task

**Purpose:** Core business entity representing a user's to-do item with all necessary properties for task management functionality.

**Key Attributes:**
- id: string - Unique identifier for the task (UUID)
- text: string - The task description/content
- completed: boolean - Whether the task is completed or not
- createdAt: Date - When the task was created
- updatedAt: Date - When the task was last modified
- priority: 'low' \| 'normal' \| 'high' - Task priority level (optional for future enhancement)

#### TypeScript Interface
```typescript
interface Task {
  id: string;
  text: string;
  completed: boolean;
  createdAt: Date;
  updatedAt: Date;
  priority?: 'low' | 'normal' | 'high';
}
```

#### Relationships
- Tasks are independent entities with no direct relationships
- Tasks are grouped by completion status (active/completed) for filtering
- Tasks belong to a single user (implicit, no multi-user support)

### TaskFilter

**Purpose:** Represents the current view state for filtering tasks in the UI.

**Key Attributes:**
- type: 'all' \| 'active' \| 'completed' - Current filter type
- searchQuery: string - Optional search text for filtering tasks

#### TypeScript Interface
```typescript
interface TaskFilter {
  type: 'all' | 'active' | 'completed';
  searchQuery?: string;
}
```

#### Relationships
- TaskFilter controls which tasks are displayed
- TaskFilter is a UI state, not persisted data

### UserPreferences

**Purpose:** Stores user customization settings and preferences for the application.

**Key Attributes:**
- theme: 'light' \| 'dark' \| 'system' - User's preferred theme
- autoFocus: boolean - Whether to auto-focus input on page load
- enterToAdd: boolean - Whether Enter key adds tasks
- showCompletedCount: boolean - Whether to show completed task count

#### TypeScript Interface
```typescript
interface UserPreferences {
  theme: 'light' | 'dark' | 'system';
  autoFocus: boolean;
  enterToAdd: boolean;
  showCompletedCount: boolean;
}
```

#### Relationships
- UserPreferences affects UI behavior and appearance
- UserPreferences are persisted to localStorage
- Single preferences object per user

### AppState

**Purpose:** Represents the complete application state including tasks, filters, and UI state.

**Key Attributes:**
- tasks: Task[] - Array of all user tasks
- filter: TaskFilter - Current filter settings
- preferences: UserPreferences - User customization settings
- isLoading: boolean - Loading state for async operations
- error: string \| null - Current error message if any

#### TypeScript Interface
```typescript
interface AppState {
  tasks: Task[];
  filter: TaskFilter;
  preferences: UserPreferences;
  isLoading: boolean;
  error: string | null;
}
```

#### Relationships
- AppState is the root state object
- Contains all other data models
- Managed by React Context and useReducer
