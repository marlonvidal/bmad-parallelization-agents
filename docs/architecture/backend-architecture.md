# Backend Architecture

Since this is a frontend-only application with local storage persistence, there is no traditional backend architecture required. However, I'll document the client-side "backend" services that handle data persistence and business logic.

### Service Architecture

#### Frontend-Only Architecture
The application uses a **client-side service layer** that handles all data operations, business logic, and persistence without requiring server infrastructure.

**Key Services:**
- **TaskStorageService**: Handles data persistence using localStorage/IndexedDB
- **TaskBusinessLogic**: Manages task operations and validation
- **PreferencesService**: Handles user settings persistence
- **PWAService**: Manages Progressive Web App functionality

#### Function Organization
```
src/
├── services/
│   ├── storage/
│   │   ├── TaskStorageService.ts
│   │   ├── PreferencesService.ts
│   │   └── IndexedDBService.ts
│   ├── business/
│   │   ├── TaskService.ts
│   │   └── ValidationService.ts
│   ├── pwa/
│   │   ├── PWAService.ts
│   │   └── ServiceWorkerManager.ts
│   └── index.ts
```

#### Function Template
```typescript
export class TaskService {
  private storageService: TaskStorageService;
  private validationService: ValidationService;

  constructor() {
    this.storageService = new TaskStorageService();
    this.validationService = new ValidationService();
  }

  async createTask(text: string): Promise<Task> {
    try {
      // Validate input
      if (!text || text.trim().length === 0) {
        throw new ServiceError('VALIDATION_ERROR', 'Task text cannot be empty');
      }

      // Create task
      const task = await this.createTaskObject(text);
      
      // Save to storage
      const tasks = await this.storageService.loadTasks();
      const updatedTasks = [...tasks, task];
      await this.storageService.saveTasks(updatedTasks);
      
      return task;
    } catch (error) {
      if (error instanceof ServiceError) {
        throw error;
      }
      
      // Wrap unknown errors
      throw new ServiceError(
        'UNKNOWN_ERROR',
        'Failed to create task',
        { originalError: error }
      );
    }
  }

  async updateTask(task: Task): Promise<Task> {
    const validationResult = this.validationService.validateTask(task);
    if (!validationResult.isValid) {
      throw new Error(validationResult.error);
    }

    const updatedTask = {
      ...task,
      updatedAt: new Date()
    };

    const tasks = await this.storageService.loadTasks();
    const updatedTasks = tasks.map(t => t.id === task.id ? updatedTask : t);
    await this.storageService.saveTasks(updatedTasks);

    return updatedTask;
  }

  async deleteTask(taskId: string): Promise<void> {
    const tasks = await this.storageService.loadTasks();
    const updatedTasks = tasks.filter(t => t.id !== taskId);
    await this.storageService.saveTasks(updatedTasks);
  }

  async getTasks(filter?: TaskFilter): Promise<Task[]> {
    const tasks = await this.storageService.loadTasks();
    
    if (!filter) return tasks;

    switch (filter.type) {
      case 'active':
        return tasks.filter(task => !task.completed);
      case 'completed':
        return tasks.filter(task => task.completed);
      default:
        return tasks;
    }
  }
}
```

### Database Architecture

#### Schema Design
Since we're using browser storage, the "database" is actually localStorage and IndexedDB with the following structure:

**localStorage Schema:**
```typescript
interface StorageSchema {
  'todo-tasks': Task[];
  'todo-preferences': UserPreferences;
  'todo-app-version': string;
  'todo-migration-history': MigrationRecord[];
}
```

**IndexedDB Schema (Fallback):**
```typescript
interface IndexedDBSchema {
  name: 'TodoAppDB';
  version: 1;
  stores: {
    tasks: {
      keyPath: 'id';
      indexes: {
        completed: 'completed';
        createdAt: 'createdAt';
        priority: 'priority';
      };
    };
    preferences: {
      keyPath: 'user';
    };
  };
}
```

#### Data Access Layer
```typescript
export class TaskStorageService {
  private readonly STORAGE_KEY = 'todo-tasks';
  private readonly PREFERENCES_KEY = 'todo-preferences';
  private readonly VERSION_KEY = 'todo-app-version';

  async saveTasks(tasks: Task[]): Promise<void> {
    try {
      localStorage.setItem(this.STORAGE_KEY, JSON.stringify(tasks));
    } catch (error) {
      if (error.name === 'QuotaExceededError') {
        await this.migrateToIndexedDB(tasks);
      } else {
        throw error;
      }
    }
  }

  async loadTasks(): Promise<Task[]> {
    try {
      const data = localStorage.getItem(this.STORAGE_KEY);
      if (!data) return [];
      
      const tasks = JSON.parse(data);
      return this.migrateTasksIfNeeded(tasks);
    } catch (error) {
      console.warn('Failed to load from localStorage, trying IndexedDB:', error);
      return await this.loadFromIndexedDB();
    }
  }

  private async migrateToIndexedDB(tasks: Task[]): Promise<void> {
    const db = await this.openIndexedDB();
    const transaction = db.transaction(['tasks'], 'readwrite');
    const store = transaction.objectStore('tasks');
    
    // Clear existing data
    await store.clear();
    
    // Add new data
    for (const task of tasks) {
      await store.add(task);
    }
  }

  private async loadFromIndexedDB(): Promise<Task[]> {
    const db = await this.openIndexedDB();
    const transaction = db.transaction(['tasks'], 'readonly');
    const store = transaction.objectStore('tasks');
    
    return await store.getAll();
  }

  private async openIndexedDB(): Promise<IDBDatabase> {
    return new Promise((resolve, reject) => {
      const request = indexedDB.open('TodoAppDB', 1);
      
      request.onerror = () => reject(request.error);
      request.onsuccess = () => resolve(request.result);
      
      request.onupgradeneeded = (event) => {
        const db = (event.target as IDBOpenDBRequest).result;
        
        // Create tasks store
        if (!db.objectStoreNames.contains('tasks')) {
          const taskStore = db.createObjectStore('tasks', { keyPath: 'id' });
          taskStore.createIndex('completed', 'completed', { unique: false });
          taskStore.createIndex('createdAt', 'createdAt', { unique: false });
        }
        
        // Create preferences store
        if (!db.objectStoreNames.contains('preferences')) {
          db.createObjectStore('preferences', { keyPath: 'user' });
        }
      };
    });
  }

  private migrateTasksIfNeeded(tasks: Task[]): Task[] {
    const currentVersion = localStorage.getItem(this.VERSION_KEY) || '1.0.0';
    
    // Apply migrations based on version
    if (currentVersion < '1.1.0') {
      tasks = tasks.map(task => ({
        ...task,
        priority: task.priority || 'normal'
      }));
    }
    
    return tasks;
  }
}
```

### Authentication and Authorization

Since this is a single-user application with no authentication requirements, there is no auth architecture needed. However, I'll document the structure for future extensibility:

#### Auth Flow (Future Extension)
```typescript
// Placeholder for future authentication if needed
interface AuthState {
  isAuthenticated: boolean;
  user: User | null;
  token: string | null;
}

interface User {
  id: string;
  email: string;
  name: string;
}

// Future auth service structure
export class AuthService {
  async login(email: string, password: string): Promise<AuthState> {
    // Future implementation
    throw new Error('Authentication not implemented');
  }

  async logout(): Promise<void> {
    // Future implementation
  }

  async getCurrentUser(): Promise<User | null> {
    // Future implementation
    return null;
  }
}
```
