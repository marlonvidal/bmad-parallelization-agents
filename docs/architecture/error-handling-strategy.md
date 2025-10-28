# Error Handling Strategy

### Error Flow

```
sequenceDiagram
    participant User
    participant Component
    participant Service
    participant Storage
    participant ErrorBoundary

    User->>Component: Performs action
    Component->>Service: Calls service method
    Service->>Storage: Attempts storage operation
    Storage-->>Service: Throws error
    Service->>Service: Catches and wraps error
    Service-->>Component: Returns error result
    Component->>ErrorBoundary: Dispatches error action
    ErrorBoundary->>User: Shows error message
```

### Error Response Format

```typescript
interface ApiError {
  error: {
    code: string;
    message: string;
    details?: Record<string, any>;
    timestamp: string;
    requestId: string;
  };
}

interface ServiceError {
  code: 'STORAGE_ERROR' | 'VALIDATION_ERROR' | 'NETWORK_ERROR' | 'UNKNOWN_ERROR';
  message: string;
  details?: any;
  timestamp: Date;
}
```

### Frontend Error Handling

```typescript
// Error boundary component
import React, { Component, ErrorInfo, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error?: Error;
}

export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Error caught by boundary:', error, errorInfo);
    // Log to error tracking service
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback || (
        <div className="error-boundary">
          <h2>Something went wrong</h2>
          <p>Please refresh the page and try again.</p>
          <button onClick={() => window.location.reload()}>
            Refresh Page
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}

// Custom hook for error handling
export const useErrorHandler = () => {
  const [error, setError] = React.useState<ServiceError | null>(null);

  const handleError = React.useCallback((error: Error) => {
    const serviceError: ServiceError = {
      code: 'UNKNOWN_ERROR',
      message: error.message,
      timestamp: new Date()
    };
    setError(serviceError);
  }, []);

  const clearError = React.useCallback(() => {
    setError(null);
  }, []);

  return { error, handleError, clearError };
};
```

### Backend Error Handling

```typescript
// Service error handling
export class TaskService {
  async createTask(text: string): Promise<Task> {
    try {
      // Validate input
      if (!text || text.trim().length === 0) {
        throw new ServiceError('VALIDATION_ERROR', 'Task text cannot be empty');
      }

      // Create task
      const task = await this.createTaskObject(text);
      
      // Save to storage
      await this.storageService.saveTasks([...this.tasks, task]);
      
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
}

// Custom error class
export class ServiceError extends Error {
  constructor(
    public code: ServiceError['code'],
    message: string,
    public details?: any
  ) {
    super(message);
    this.name = 'ServiceError';
  }
}

// Storage service error handling
export class TaskStorageService {
  async saveTasks(tasks: Task[]): Promise<void> {
    try {
      localStorage.setItem(this.STORAGE_KEY, JSON.stringify(tasks));
    } catch (error) {
      if (error.name === 'QuotaExceededError') {
        throw new ServiceError(
          'STORAGE_ERROR',
          'Storage quota exceeded. Please delete some tasks.',
          { quotaExceeded: true }
        );
      }
      
      throw new ServiceError(
        'STORAGE_ERROR',
        'Failed to save tasks',
        { originalError: error }
      );
    }
  }
}
```
