# Unified Project Structure

```
simple-todo-app/
├── .github/                    # CI/CD workflows
│   └── workflows/
│       ├── ci.yaml
│       └── deploy.yaml
├── public/                     # Static assets
│   ├── manifest.json           # PWA manifest
│   ├── service-worker.js      # Service worker
│   ├── icons/                  # PWA icons
│   └── favicon.ico
├── src/                        # Application source code
│   ├── components/             # React components
│   │   ├── ui/                 # Reusable UI components
│   │   │   ├── Button.tsx
│   │   │   ├── Input.tsx
│   │   │   ├── Checkbox.tsx
│   │   │   ├── Modal.tsx
│   │   │   └── index.ts
│   │   ├── features/           # Feature-specific components
│   │   │   ├── TaskList/
│   │   │   │   ├── TaskList.tsx
│   │   │   │   ├── TaskItem.tsx
│   │   │   │   ├── TaskInput.tsx
│   │   │   │   ├── EmptyState.tsx
│   │   │   │   └── index.ts
│   │   │   ├── TaskFilter/
│   │   │   │   ├── TaskFilter.tsx
│   │   │   │   ├── FilterButton.tsx
│   │   │   │   └── index.ts
│   │   │   ├── Settings/
│   │   │   │   ├── SettingsPanel.tsx
│   │   │   │   ├── ThemeToggle.tsx
│   │   │   │   ├── DataExport.tsx
│   │   │   │   └── index.ts
│   │   │   └── PWA/
│   │   │       ├── InstallPrompt.tsx
│   │   │       ├── OfflineIndicator.tsx
│   │   │       └── index.ts
│   │   └── layout/             # Layout components
│   │       ├── Header.tsx
│   │       ├── Main.tsx
│   │       ├── Footer.tsx
│   │       └── index.ts
│   ├── hooks/                  # Custom React hooks
│   │   ├── useTasks.ts
│   │   ├── usePreferences.ts
│   │   ├── usePWA.ts
│   │   ├── useLocalStorage.ts
│   │   └── index.ts
│   ├── services/               # Business logic and data services
│   │   ├── storage/
│   │   │   ├── TaskStorageService.ts
│   │   │   ├── PreferencesService.ts
│   │   │   ├── IndexedDBService.ts
│   │   │   └── index.ts
│   │   ├── business/
│   │   │   ├── TaskService.ts
│   │   │   ├── ValidationService.ts
│   │   │   └── index.ts
│   │   ├── pwa/
│   │   │   ├── PWAService.ts
│   │   │   ├── ServiceWorkerManager.ts
│   │   │   └── index.ts
│   │   └── index.ts
│   ├── context/                # React Context providers
│   │   ├── AppStateProvider.tsx
│   │   ├── PreferencesProvider.tsx
│   │   └── index.ts
│   ├── types/                  # TypeScript type definitions
│   │   ├── Task.ts
│   │   ├── UserPreferences.ts
│   │   ├── AppState.ts
│   │   └── index.ts
│   ├── utils/                  # Utility functions
│   │   ├── dateUtils.ts
│   │   ├── validationUtils.ts
│   │   ├── storageUtils.ts
│   │   └── index.ts
│   ├── styles/                 # Global styles and themes
│   │   ├── globals.css
│   │   ├── themes.css
│   │   └── components.css
│   ├── pages/                  # Page components
│   │   ├── HomePage.tsx
│   │   ├── SettingsPage.tsx
│   │   └── index.ts
│   ├── router/                 # Routing configuration
│   │   ├── AppRouter.tsx
│   │   └── index.ts
│   ├── App.tsx                 # Root component
│   ├── main.tsx                # Application entry point
│   └── vite-env.d.ts           # Vite type definitions
├── tests/                       # Test files
│   ├── components/             # Component tests
│   │   ├── TaskList.test.tsx
│   │   ├── TaskItem.test.tsx
│   │   └── TaskInput.test.tsx
│   ├── services/               # Service tests
│   │   ├── TaskService.test.ts
│   │   ├── TaskStorageService.test.ts
│   │   └── ValidationService.test.ts
│   ├── hooks/                  # Hook tests
│   │   ├── useTasks.test.ts
│   │   └── usePreferences.test.ts
│   ├── e2e/                    # End-to-end tests
│   │   ├── task-management.spec.ts
│   │   ├── settings.spec.ts
│   │   └── pwa.spec.ts
│   ├── utils/                  # Test utilities
│   │   ├── test-utils.tsx
│   │   ├── mock-storage.ts
│   │   └── index.ts
│   └── setup.ts                # Test setup
├── docs/                       # Documentation
│   ├── prd.md
│   ├── architecture.md
│   ├── api.md
│   ├── deployment.md
│   └── contributing.md
├── scripts/                    # Build and deployment scripts
│   ├── build.sh
│   ├── deploy.sh
│   ├── test.sh
│   └── lint.sh
├── .env.example                # Environment variables template
├── .gitignore                  # Git ignore rules
├── .eslintrc.js                # ESLint configuration
├── .prettierrc                 # Prettier configuration
├── tailwind.config.js          # Tailwind CSS configuration
├── vite.config.ts              # Vite configuration
├── vitest.config.ts            # Vitest configuration
├── playwright.config.ts        # Playwright configuration
├── package.json                # Dependencies and scripts
├── tsconfig.json               # TypeScript configuration
└── README.md                   # Project documentation
```
