# Technical Assumptions

### Repository Structure: Monorepo
Single repository containing all application code, documentation, and configuration files. This simplifies development, deployment, and maintenance for a focused application.

### Service Architecture
**Frontend-Only Architecture**: Client-side application with no backend services required. All data persistence handled through browser localStorage. This eliminates server complexity, reduces hosting costs, and ensures offline functionality.

### Testing Requirements
**Unit + Integration Testing**: Comprehensive testing approach including:
- Unit tests for individual components and functions
- Integration tests for user workflows and data persistence
- Manual testing convenience methods for rapid iteration
- No end-to-end testing initially (can be added later if needed)

### Additional Technical Assumptions and Requests
- **Framework**: Modern JavaScript framework (React, Vue, or vanilla JS) for component-based UI
- **Build Tools**: Modern build system (Vite, Webpack, or similar) for development and production builds
- **Styling**: CSS-in-JS or modern CSS framework for responsive design
- **Deployment**: Static site hosting (Netlify, Vercel, GitHub Pages) for simple deployment
- **Browser Support**: Modern browsers (last 2 versions of major browsers)
- **Development Environment**: Node.js-based development with hot reloading
- **Code Quality**: ESLint and Prettier for code formatting and linting
- **Version Control**: Git with conventional commit messages
