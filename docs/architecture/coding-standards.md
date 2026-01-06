# Coding Standards

### Critical Fullstack Rules

- **Type Sharing:** Always define types in `src/types/` and import from there - never define types inline in components
- **Storage Operations:** Never access localStorage directly - always use TaskStorageService for all data persistence
- **State Updates:** Never mutate state directly - use proper dispatch actions through AppStateProvider
- **Error Handling:** All service operations must use try-catch blocks and provide meaningful error messages
- **Component Props:** Always define TypeScript interfaces for component props - never use `any` type
- **Service Dependencies:** Never import services directly in components - use custom hooks to encapsulate service calls
- **Validation:** Always validate user input before processing - use ValidationService for all input validation
- **Testing:** Every new component must have corresponding test file with at least 3 test cases
- **Accessibility:** All interactive elements must have proper ARIA labels and keyboard navigation support
- **Performance:** Never use `useEffect` without dependency array - always specify dependencies or use empty array

### Naming Conventions

| Element | Frontend | Backend | Example |
|---------|----------|---------|---------|
| Components | PascalCase | - | `TaskItem.tsx` |
| Hooks | camelCase with 'use' | - | `useTasks.ts` |
| Services | PascalCase with 'Service' | - | `TaskStorageService.ts` |
| Types/Interfaces | PascalCase | - | `Task.ts` |
| Constants | UPPER_SNAKE_CASE | - | `STORAGE_KEYS.ts` |
| Test Files | PascalCase.test.ts | - | `TaskItem.test.tsx` |
| Utility Functions | camelCase | - | `formatDate.ts` |
| CSS Classes | kebab-case | - | `task-item` |
