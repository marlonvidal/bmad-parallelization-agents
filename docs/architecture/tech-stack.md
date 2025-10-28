# Tech Stack

| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| Frontend Language | TypeScript | 5.3+ | Type safety and developer experience | Provides compile-time error checking and excellent IDE support |
| Frontend Framework | React | 18.2+ | Component-based UI development | Industry standard, excellent ecosystem, perfect for interactive UIs |
| UI Component Library | None (Custom) | - | Minimal, focused components | Aligns with simplicity goals, no external dependencies |
| State Management | React Context + useReducer | Built-in | Local state management | Sufficient for single-user app, no external dependencies |
| Backend Language | N/A | - | Frontend-only architecture | Eliminates backend complexity per PRD requirements |
| Backend Framework | N/A | - | Frontend-only architecture | No backend services required |
| API Style | N/A | - | Local storage only | No API calls needed, all data stored locally |
| Database | localStorage + IndexedDB | Native | Client-side data persistence | Meets offline requirements, no external dependencies |
| Cache | Browser Cache | Native | Static asset caching | Handled by Vercel edge caching |
| File Storage | N/A | - | No file uploads | Not required for to-do list functionality |
| Authentication | N/A | - | Single-user application | No authentication needed for personal use |
| Frontend Testing | Vitest + Testing Library | Latest | Unit and integration testing | Fast, modern testing framework with excellent React support |
| Backend Testing | N/A | - | No backend services | Not applicable |
| E2E Testing | Playwright | Latest | End-to-end user workflows | Modern E2E testing with excellent browser support |
| Build Tool | Vite | 5.0+ | Development and production builds | Fast builds, excellent developer experience, optimized output |
| Bundler | Vite (built-in) | 5.0+ | Module bundling and optimization | Integrated with Vite, no additional configuration needed |
| IaC Tool | N/A | - | Static hosting | No infrastructure management needed |
| CI/CD | GitHub Actions | Latest | Automated testing and deployment | Integrated with GitHub, free for public repos |
| Monitoring | Vercel Analytics | Built-in | Performance and usage monitoring | Integrated with hosting platform |
| Logging | Console + Vercel Logs | Native | Development and production logging | Simple logging for debugging and monitoring |
| CSS Framework | Tailwind CSS | 3.4+ | Utility-first styling | Rapid development, consistent design system, small bundle size |
