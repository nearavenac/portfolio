---
paths:
  - "src/**/*.jsx"
  - "src/**/*.js"
---

# React/JavaScript Rules

## Naming Conventions
- PascalCase: React components, files containing components
- camelCase: functions, variables, methods, hooks
- SCREAMING_SNAKE_CASE: constants

## Component Structure
- One component per file
- Props destructuring in function parameters
- Export default for components

## Imports
- Group imports: external → internal → relative
- React imports first

## React Patterns
- Use functional components with hooks
- Prefer derived values over state + useEffect
- Always provide dependency arrays for hooks
- Keep components small and focused

## Styling
- Use CSS classes from index.css
- Follow existing CSS variable naming (--color-*, --border-radius, etc.)
- Mobile-first responsive design

## Project-Specific
- Add new projects in `src/data/projects.js`
- Use `getProjectUrl()` for dynamic domain URLs
- Images go in `public/projects/` with cache busting query params
