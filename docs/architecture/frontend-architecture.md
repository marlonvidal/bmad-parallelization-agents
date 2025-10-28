# Frontend Architecture

### Component Architecture

#### Component Organization
```
src/
├── components/
│   ├── ui/                    # Reusable UI components
│   │   ├── Button.tsx
│   │   ├── Input.tsx
│   │   ├── Checkbox.tsx
│   │   └── index.ts
│   ├── features/             # Feature-specific components
│   │   ├── TaskList/
│   │   │   ├── TaskList.tsx
│   │   │   ├── TaskItem.tsx
│   │   │   ├── TaskInput.tsx
│   │   │   └── index.ts
│   │   ├── TaskFilter/
│   │   │   ├── TaskFilter.tsx
│   │   │   └── index.ts
│   │   └── Settings/
│   │       ├── SettingsPanel.tsx
│   │       └── index.ts
│   └── layout/               # Layout components
│       ├── Header.tsx
│       ├── Main.tsx
│       └── index.ts
```

#### Component Template
```typescript
import React from 'react';
import { Task } from '@/types';

interface TaskItemProps {
  task: Task;
  onUpdate: (task: Task) => void;
  onDelete: (taskId: string) => void;
}

export const TaskItem: React.FC<TaskItemProps> = ({
  task,
  onUpdate,
  onDelete
}) => {
  const [isEditing, setIsEditing] = React.useState(false);
  const [editText, setEditText] = React.useState(task.text);

  const handleSave = () => {
    onUpdate({ ...task, text: editText, updatedAt: new Date() });
    setIsEditing(false);
  };

  const handleCancel = () => {
    setEditText(task.text);
    setIsEditing(false);
  };

  return (
    <div className="flex items-center gap-3 p-3 bg-white rounded-lg shadow-sm">
      <input
        type="checkbox"
        checked={task.completed}
        onChange={() => onUpdate({ ...task, completed: !task.completed })}
        className="w-4 h-4 text-blue-600 rounded"
      />
      {isEditing ? (
        <input
          value={editText}
          onChange={(e) => setEditText(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === 'Enter') handleSave();
            if (e.key === 'Escape') handleCancel();
          }}
          className="flex-1 px-2 py-1 border rounded"
          autoFocus
        />
      ) : (
        <span
          className={`flex-1 ${task.completed ? 'line-through text-gray-500' : ''}`}
          onClick={() => setIsEditing(true)}
        >
          {task.text}
        </span>
      )}
      <button
        onClick={() => onDelete(task.id)}
        className="text-red-500 hover:text-red-700"
      >
        Delete
      </button>
    </div>
  );
};
```

### State Management Architecture

#### State Structure
```typescript
interface AppState {
  tasks: Task[];
  filter: TaskFilter;
  preferences: UserPreferences;
  isLoading: boolean;
  error: string | null;
}

interface AppAction {
  type: 'CREATE_TASK' | 'UPDATE_TASK' | 'DELETE_TASK' | 'SET_FILTER' | 'UPDATE_PREFERENCES';
  payload: any;
}

const initialState: AppState = {
  tasks: [],
  filter: { type: 'all' },
  preferences: {
    theme: 'system',
    autoFocus: true,
    enterToAdd: true,
    showCompletedCount: true
  },
  isLoading: false,
  error: null
};
```

#### State Management Patterns
- **useReducer**: Centralized state management with predictable updates
- **Context API**: Global state access without prop drilling
- **Custom hooks**: Encapsulate component logic and state interactions
- **Action creators**: Standardized action creation and dispatching

### Routing Architecture

#### Route Organization
```
src/
├── pages/
│   ├── HomePage.tsx          # Main task management page
│   ├── SettingsPage.tsx     # User preferences page
│   └── index.ts
├── router/
│   ├── AppRouter.tsx         # Main router configuration
│   └── index.ts
└── App.tsx                   # Root component with router
```

#### Protected Route Pattern
```typescript
import React from 'react';
import { Navigate } from 'react-router-dom';

interface ProtectedRouteProps {
  children: React.ReactNode;
  isAuthenticated?: boolean;
}

export const ProtectedRoute: React.FC<ProtectedRouteProps> = ({
  children,
  isAuthenticated = true
}) => {
  // For this app, all routes are public since it's single-user
  // This pattern is included for future extensibility
  return isAuthenticated ? <>{children}</> : <Navigate to="/" replace />;
};
```

### Frontend Services Layer

#### API Client Setup
```typescript
// Since this is a frontend-only app, we don't have external APIs
// Instead, we have storage services

class TaskStorageService {
  private static readonly STORAGE_KEY = 'todo-tasks';
  private static readonly PREFERENCES_KEY = 'todo-preferences';

  async saveTasks(tasks: Task[]): Promise<void> {
    try {
      localStorage.setItem(this.STORAGE_KEY, JSON.stringify(tasks));
    } catch (error) {
      // Fallback to IndexedDB if localStorage quota exceeded
      await this.saveToIndexedDB(tasks);
    }
  }

  async loadTasks(): Promise<Task[]> {
    try {
      const data = localStorage.getItem(this.STORAGE_KEY);
      return data ? JSON.parse(data) : [];
    } catch (error) {
      return await this.loadFromIndexedDB();
    }
  }

  private async saveToIndexedDB(tasks: Task[]): Promise<void> {
    // IndexedDB implementation
  }

  private async loadFromIndexedDB(): Promise<Task[]> {
    // IndexedDB implementation
    return [];
  }
}
```

#### Service Example
```typescript
export const useTaskService = () => {
  const storageService = new TaskStorageService();

  const createTask = async (text: string): Promise<Task> => {
    const task: Task = {
      id: crypto.randomUUID(),
      text,
      completed: false,
      createdAt: new Date(),
      updatedAt: new Date(),
      priority: 'normal'
    };

    const tasks = await storageService.loadTasks();
    const updatedTasks = [...tasks, task];
    await storageService.saveTasks(updatedTasks);
    
    return task;
  };

  const updateTask = async (task: Task): Promise<Task> => {
    const tasks = await storageService.loadTasks();
    const updatedTasks = tasks.map(t => t.id === task.id ? task : t);
    await storageService.saveTasks(updatedTasks);
    
    return task;
  };

  const deleteTask = async (taskId: string): Promise<void> => {
    const tasks = await storageService.loadTasks();
    const updatedTasks = tasks.filter(t => t.id !== taskId);
    await storageService.saveTasks(updatedTasks);
  };

  return {
    createTask,
    updateTask,
    deleteTask
  };
};
```
