# Core Workflows

### Task Creation Workflow

```
sequenceDiagram
    participant User
    participant TaskInput
    participant AppState
    participant TaskStorage
    participant TaskList

    User->>TaskInput: Types task text
    User->>TaskInput: Presses Enter/Add button
    TaskInput->>AppState: dispatch(createTask(text))
    AppState->>AppState: Generate task ID, timestamps
    AppState->>AppState: Add task to state
    AppState->>TaskStorage: saveTasks(updatedTasks)
    TaskStorage->>TaskStorage: localStorage.setItem()
    AppState->>TaskList: Update tasks prop
    TaskList->>User: Display new task
    TaskInput->>TaskInput: Clear input field
```

### Task Completion Workflow

```
sequenceDiagram
    participant User
    participant TaskItem
    participant AppState
    participant TaskStorage
    participant TaskList

    User->>TaskItem: Clicks completion checkbox
    TaskItem->>AppState: dispatch(toggleTaskCompletion(id))
    AppState->>AppState: Update task completed status
    AppState->>AppState: Update task updatedAt timestamp
    AppState->>TaskStorage: saveTasks(updatedTasks)
    TaskStorage->>TaskStorage: localStorage.setItem()
    AppState->>TaskList: Update tasks prop
    TaskList->>User: Show visual completion state
```

### Task Filtering Workflow

```
sequenceDiagram
    participant User
    participant TaskFilter
    participant AppState
    participant TaskList

    User->>TaskFilter: Clicks filter button (All/Active/Completed)
    TaskFilter->>AppState: dispatch(setFilter(filterType))
    AppState->>AppState: Update filter state
    AppState->>TaskList: Pass filtered tasks
    TaskList->>TaskList: Filter tasks based on completion status
    TaskList->>User: Display filtered task list
    TaskFilter->>User: Show active filter state
```

### Data Persistence Workflow

```
sequenceDiagram
    participant App
    participant TaskStorage
    participant localStorage
    participant IndexedDB

    App->>TaskStorage: loadTasks()
    TaskStorage->>localStorage: getItem('tasks')
    alt localStorage available
        localStorage->>TaskStorage: Return task data
    else localStorage quota exceeded
        TaskStorage->>IndexedDB: Fallback to IndexedDB
        IndexedDB->>TaskStorage: Return task data
    end
    TaskStorage->>App: Return parsed tasks
    App->>App: Initialize application state
```

### PWA Installation Workflow

```
sequenceDiagram
    participant User
    participant PWA Manager
    participant Service Worker
    participant Browser

    User->>PWA Manager: Clicks install button
    PWA Manager->>Browser: requestInstallPrompt()
    Browser->>User: Show install dialog
    User->>Browser: Confirms installation
    Browser->>PWA Manager: Installation complete
    PWA Manager->>Service Worker: Register service worker
    Service Worker->>PWA Manager: Registration successful
    PWA Manager->>User: Show success message
```
