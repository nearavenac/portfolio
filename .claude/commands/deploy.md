---
allowed-tools: Bash(make:*), Bash(npm:*)
description: Deploy portfolio to production (build + nginx)
model: haiku
---

# Deploy Portfolio

Deploy the portfolio to production.

## What This Command Does

1. Runs `make deploy` which:
   - Builds the project with `npm run build`
   - Fixes permissions on the dist folder
   - Copies nginx configuration
   - Reloads nginx

## Execution

```bash
make deploy
```

## Output

- Build status
- Nginx configuration status
- Final URLs where the site is available
