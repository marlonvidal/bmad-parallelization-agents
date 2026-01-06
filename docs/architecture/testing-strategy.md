# Testing Strategy

### Testing Pyramid

```
        E2E Tests
       /        \
   Integration Tests
   /            \
Frontend Unit  Backend Unit
```

### Test Organization

#### Frontend Tests
```
tests/
├── components/                 # Component unit tests
│   ├── TaskList.test.tsx
│   ├── TaskItem.test.tsx
│   ├── TaskInput.test.tsx
│   └── TaskFilter.test.tsx
├── services/                   # Service layer tests
│   ├── TaskService.test.ts
│   ├── TaskStorageService.test.ts
│   └── ValidationService.test.ts
├── hooks/                      # Custom hook tests
│   ├── useTasks.test.ts
│   ├── usePreferences.test.ts
│   └── usePWA.test.ts
├── utils/                      # Utility function tests
│   ├── dateUtils.test.ts
│   ├── validationUtils.test.ts
│   └── storageUtils.test.ts
└── setup.ts                    # Test configuration
```

#### Backend Tests
```
tests/
├── services/                   # Service layer tests (client-side)
│   ├── TaskService.test.ts
│   ├── TaskStorageService.test.ts
│   └── ValidationService.test.ts
└── utils/                      # Utility function tests
    ├── storageUtils.test.ts
    └── validationUtils.test.ts
```

#### E2E Tests
```
tests/
├── e2e/                        # End-to-end tests
│   ├── task-management.spec.ts
│   ├── settings.spec.ts
│   ├── pwa.spec.ts
│   └── accessibility.spec.ts
├── fixtures/                   # Test data and fixtures
│   ├── tasks.json
│   └── preferences.json
└── utils/                      # E2E test utilities
    ├── test-helpers.ts
    └── mock-storage.ts
```

### Test Examples

#### Frontend Component Test
```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import { TaskItem } from '@/components/features/TaskList/TaskItem';
import { Task } from '@/types';

describe('TaskItem', () => {
  const mockTask: Task = {
    id: '1',
    text: 'Test task',
    completed: false,
    createdAt: new Date(),
    updatedAt: new Date()
  };

  const mockOnUpdate = jest.fn();
  const mockOnDelete = jest.fn();

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('renders task text', () => {
    render(
      <TaskItem 
        task={mockTask} 
        onUpdate={mockOnUpdate} 
        onDelete={mockOnDelete} 
      />
    );
    
    expect(screen.getByText('Test task')).toBeInTheDocument();
  });

  it('toggles completion status when checkbox is clicked', () => {
    render(
      <TaskItem 
        task={mockTask} 
        onUpdate={mockOnUpdate} 
        onDelete={mockOnDelete} 
      />
    );
    
    const checkbox = screen.getByRole('checkbox');
    fireEvent.click(checkbox);
    
    expect(mockOnUpdate).toHaveBeenCalledWith({
      ...mockTask,
      completed: true
    });
  });

  it('enters edit mode when text is clicked', () => {
    render(
      <TaskItem 
        task={mockTask} 
        onUpdate={mockOnUpdate} 
        onDelete={mockOnDelete} 
      />
    );
    
    const taskText = screen.getByText('Test task');
    fireEvent.click(taskText);
    
    expect(screen.getByDisplayValue('Test task')).toBeInTheDocument();
  });
});
```

#### Backend API Test
```typescript
import { TaskService } from '@/services/business/TaskService';
import { TaskStorageService } from '@/services/storage/TaskStorageService';
import { Task } from '@/types';

// Mock the storage service
jest.mock('@/services/storage/TaskStorageService');

describe('TaskService', () => {
  let taskService: TaskService;
  let mockStorageService: jest.Mocked<TaskStorageService>;

  beforeEach(() => {
    mockStorageService = new TaskStorageService() as jest.Mocked<TaskStorageService>;
    taskService = new TaskService();
    (taskService as any).storageService = mockStorageService;
  });

  it('creates a new task', async () => {
    const taskText = 'New task';
    const mockTasks: Task[] = [];
    
    mockStorageService.loadTasks.mockResolvedValue(mockTasks);
    mockStorageService.saveTasks.mockResolvedValue();

    const result = await taskService.createTask(taskText);

    expect(result.text).toBe(taskText);
    expect(result.completed).toBe(false);
    expect(result.id).toBeDefined();
    expect(mockStorageService.saveTasks).toHaveBeenCalled();
  });

  it('validates task text before creation', async () => {
    const emptyText = '';
    
    await expect(taskService.createTask(emptyText)).rejects.toThrow('Task text cannot be empty');
  });
});
```

#### E2E Test
```typescript
import { test, expect } from '@playwright/test';

test.describe('Task Management', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
  });

  test('should create a new task', async ({ page }) => {
    // Add a new task
    await page.fill('[data-testid="task-input"]', 'Buy groceries');
    await page.click('[data-testid="add-task-button"]');
    
    // Verify task appears in list
    await expect(page.locator('[data-testid="task-item"]')).toContainText('Buy groceries');
  });

  test('should mark task as completed', async ({ page }) => {
    // Create a task first
    await page.fill('[data-testid="task-input"]', 'Complete project');
    await page.click('[data-testid="add-task-button"]');
    
    // Mark as completed
    await page.click('[data-testid="task-checkbox"]');
    
    // Verify completion state
    await expect(page.locator('[data-testid="task-item"]')).toHaveClass(/completed/);
  });

  test('should filter tasks by status', async ({ page }) => {
    // Create multiple tasks
    await page.fill('[data-testid="task-input"]', 'Active task');
    await page.click('[data-testid="add-task-button"]');
    
    await page.fill('[data-testid="task-input"]', 'Completed task');
    await page.click('[data-testid="add-task-button"]');
    
    // Mark second task as completed
    await page.click('[data-testid="task-checkbox"]:nth-child(2)');
    
    // Filter by active tasks
    await page.click('[data-testid="filter-active"]');
    
    // Verify only active tasks are shown
    await expect(page.locator('[data-testid="task-item"]')).toHaveCount(1);
    await expect(page.locator('[data-testid="task-item"]')).toContainText('Active task');
  });
});
```
