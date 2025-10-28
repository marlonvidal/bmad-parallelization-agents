# Components

### TaskList

**Responsibility:** Renders the main task list with filtering, sorting, and task management functionality.

**Key Interfaces:**
- `tasks: Task[]` - Array of tasks to display
- `filter: TaskFilter` - Current filter settings
- `onTaskUpdate: (task: Task) => void` - Callback for task updates
- `onTaskDelete: (taskId: string) => void` - Callback for task deletion

**Dependencies:** TaskItem, TaskFilter, TaskStorage

**Technology Stack:** React functional component with TypeScript, Tailwind CSS for styling

### TaskItem

**Responsibility:** Renders individual task items with inline editing, completion toggle, and delete functionality.

**Key Interfaces:**
- `task: Task` - Task data to display
- `onUpdate: (task: Task) => void` - Callback for task updates
- `onDelete: (taskId: string) => void` - Callback for task deletion
- `isEditing: boolean` - Whether item is in edit mode

**Dependencies:** Task model, TaskActions

**Technology Stack:** React functional component with hooks for state management

### TaskInput

**Responsibility:** Handles new task creation with input validation and keyboard shortcuts.

**Key Interfaces:**
- `onTaskCreate: (text: string) => void` - Callback for new task creation
- `placeholder: string` - Input placeholder text
- `autoFocus: boolean` - Whether to focus on mount

**Dependencies:** Task model, UserPreferences

**Technology Stack:** React functional component with useRef for input management

### TaskFilter

**Responsibility:** Provides filtering controls (All/Active/Completed) with visual state indication.

**Key Interfaces:**
- `currentFilter: TaskFilter` - Current filter state
- `onFilterChange: (filter: TaskFilter) => void` - Callback for filter changes
- `taskCounts: { total: number, active: number, completed: number }` - Task counts for display

**Dependencies:** TaskFilter model

**Technology Stack:** React functional component with button group styling

### TaskStorage

**Responsibility:** Handles all data persistence operations using localStorage with IndexedDB fallback.

**Key Interfaces:**
- `saveTasks: (tasks: Task[]) => Promise<void>` - Save tasks to storage
- `loadTasks: () => Promise<Task[]>` - Load tasks from storage
- `savePreferences: (preferences: UserPreferences) => Promise<void>` - Save user preferences
- `loadPreferences: () => Promise<UserPreferences>` - Load user preferences

**Dependencies:** Browser localStorage/IndexedDB APIs

**Technology Stack:** TypeScript service class with async/await patterns

### AppStateProvider

**Responsibility:** Manages global application state using React Context and useReducer.

**Key Interfaces:**
- `state: AppState` - Complete application state
- `dispatch: React.Dispatch<AppAction>` - State update dispatcher
- `actions: AppActions` - Action creators for state updates

**Dependencies:** AppState model, TaskStorage

**Technology Stack:** React Context with useReducer for state management

### SettingsPanel

**Responsibility:** Provides user preference management and data export/import functionality.

**Key Interfaces:**
- `preferences: UserPreferences` - Current user preferences
- `onPreferencesChange: (preferences: UserPreferences) => void` - Callback for preference updates
- `onDataExport: () => void` - Callback for data export
- `onDataClear: () => void` - Callback for data clearing

**Dependencies:** UserPreferences model, TaskStorage

**Technology Stack:** React functional component with form controls

### PWA Manager

**Responsibility:** Handles Progressive Web App functionality including service worker and offline capabilities.

**Key Interfaces:**
- `registerServiceWorker: () => Promise<void>` - Register service worker
- `showInstallPrompt: () => void` - Show PWA install prompt
- `isOffline: boolean` - Current offline status

**Dependencies:** Browser PWA APIs, Service Worker

**Technology Stack:** TypeScript service class with browser API integration
