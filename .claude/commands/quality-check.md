---
allowed-tools: Bash(npm:*)
description: Run build check for the portfolio
model: haiku
---

# Quality Check

Run quality checks for the portfolio project.

## Checks

1. **Build (compile + bundle)**:
   ```bash
   npm run build
   ```

## Execution

Run the build check. If it fails, report the error with details.

## Output

Report summary at the end:
- Build status (passed/failed)
- Any errors or warnings
- Bundle size info
