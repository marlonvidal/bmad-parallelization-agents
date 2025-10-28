# Database Schema

Since this is a frontend-only application using browser storage, there is no traditional database schema. Instead, I'll define the data structures used in localStorage and IndexedDB.

### localStorage Schema

**Primary Storage Keys:**
- `todo-tasks`: JSON array of Task objects
- `todo-preferences`: JSON object of UserPreferences
- `todo-app-version`: String version for data migration

**Task Object Structure:**
```json
{
  "id": "uuid-string",
  "text": "Task description",
  "completed": false,
  "createdAt": "2024-12-19T10:30:00.000Z",
  "updatedAt": "2024-12-19T10:30:00.000Z",
  "priority": "normal"
}
```

**UserPreferences Object Structure:**
```json
{
  "theme": "light",
  "autoFocus": true,
  "enterToAdd": true,
  "showCompletedCount": true
}
```

### IndexedDB Schema (Fallback)

**Database Name:** `TodoAppDB`
**Version:** 1

**Object Stores:**
1. **tasks**
   - Key: `id` (string)
   - Value: Task object
   - Indexes: `completed` (boolean), `createdAt` (Date)

2. **preferences**
   - Key: `user` (string, always "default")
   - Value: UserPreferences object

**IndexedDB Structure:**
```javascript
// Database schema definition
const dbSchema = {
  name: 'TodoAppDB',
  version: 1,
  stores: [
    {
      name: 'tasks',
      keyPath: 'id',
      indexes: [
        { name: 'completed', keyPath: 'completed' },
        { name: 'createdAt', keyPath: 'createdAt' }
      ]
    },
    {
      name: 'preferences',
      keyPath: 'user'
    }
  ]
};
```

### Data Migration Strategy

**Version Management:**
- Each data structure includes version information
- Migration functions handle schema changes
- Backward compatibility maintained for minor updates

**Migration Example:**
```typescript
interface Migration {
  version: number;
  migrate: (oldData: any) => any;
}

const migrations: Migration[] = [
  {
    version: 1,
    migrate: (data) => {
      // Add priority field to existing tasks
      return data.map(task => ({
        ...task,
        priority: task.priority || 'normal'
      }));
    }
  }
];
```
