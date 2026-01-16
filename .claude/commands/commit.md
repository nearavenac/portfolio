---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*), Bash(git log:*)
argument-hint: [message] | --no-verify
description: Create well-formatted commits with conventional commit format and emoji
model: sonnet
---

# Smart Git Commit

Create well-formatted commit: $ARGUMENTS

## Current Repository State

- Git status: !`git status --porcelain`
- Current branch: !`git branch --show-current`
- Staged changes: !`git diff --cached --stat`
- Unstaged changes: !`git diff --stat`
- Recent commits: !`git log --oneline -5`

## What This Command Does

1. Unless specified with `--no-verify`, automatically runs pre-commit checks:
   - `npm run build` to verify the build succeeds
2. Checks which files are staged with `git status`
3. If 0 files are staged, automatically adds all modified and new files with `git add`
4. Performs a `git diff` to understand what changes are being committed
5. Creates a commit message using emoji conventional commit format

## Commit Format

Use the format `<emoji> <type>: <description>` where:
- ✨ `feat`: New feature
- 🐛 `fix`: Bug fix
- 📝 `docs`: Documentation
- 💄 `style`: Formatting/style
- ♻️ `refactor`: Code refactoring
- ⚡️ `perf`: Performance improvements
- ✅ `test`: Tests
- 🔧 `chore`: Tooling, configuration
- 🚀 `deploy`: Deployment changes
- 🎨 `ui`: UI/UX improvements

## Examples

Good commit messages:
- ✨ feat: add new project card component
- 🐛 fix: resolve image loading issue
- 📝 docs: update README with deploy instructions
- 🎨 ui: improve responsive layout for mobile
- 🚀 deploy: update nginx configuration

## Important Notes

- Keep the first line under 72 characters
- Use present tense, imperative mood (e.g., "add feature" not "added feature")
- If no files are staged, it will automatically stage all modified and new files
