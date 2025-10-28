# Development Workflow

### Local Development Setup

#### Prerequisites
```bash
# Required software versions
node --version  # >= 18.0.0
npm --version   # >= 9.0.0
git --version   # >= 2.30.0

# Optional but recommended
code --version  # VS Code for development
```

#### Initial Setup
```bash
# Clone repository
git clone <repository-url>
cd simple-todo-app

# Install dependencies
npm install

# Copy environment template
cp .env.example .env.local

# Start development server
npm run dev

# Run tests
npm run test

# Run linting
npm run lint
```

#### Development Commands
```bash
# Start all services
npm run dev

# Start frontend only
npm run dev:frontend

# Start backend only (N/A for this project)
npm run dev:backend

# Run tests
npm run test                    # Unit tests
npm run test:watch             # Watch mode
npm run test:coverage          # Coverage report
npm run test:e2e               # End-to-end tests
npm run test:e2e:ui            # E2E tests with UI

# Build and deployment
npm run build                  # Production build
npm run preview                # Preview production build
npm run deploy                 # Deploy to Vercel

# Code quality
npm run lint                   # ESLint
npm run lint:fix               # Fix ESLint issues
npm run format                 # Prettier formatting
npm run type-check             # TypeScript type checking

# PWA specific
npm run build:pwa              # Build with PWA optimizations
npm run analyze                # Bundle analysis
```

### Environment Configuration

#### Required Environment Variables
```bash
# Frontend (.env.local)
VITE_APP_NAME="Simple To-Do List"
VITE_APP_VERSION="1.0.0"
VITE_APP_DESCRIPTION="A simple, offline-first to-do list application"

# PWA Configuration
VITE_PWA_NAME="Simple To-Do List"
VITE_PWA_SHORT_NAME="TodoApp"
VITE_PWA_DESCRIPTION="Personal task management"
VITE_PWA_THEME_COLOR="#3b82f6"
VITE_PWA_BACKGROUND_COLOR="#ffffff"

# Analytics (Optional)
VITE_VERCEL_ANALYTICS_ID=""
VITE_GOOGLE_ANALYTICS_ID=""

# Development
VITE_DEV_MODE="true"
VITE_DEBUG_STORAGE="false"
```

#### Shared Environment Variables
```bash
# Build Configuration
NODE_ENV="development"
VITE_NODE_ENV="development"

# Feature Flags
VITE_ENABLE_PWA="true"
VITE_ENABLE_ANALYTICS="false"
VITE_ENABLE_DEBUG="true"
```
