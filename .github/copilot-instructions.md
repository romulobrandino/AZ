# Copilot instructions for this repo (AZ)

This is a personal collection of Azure notes, scripts, and IaC templates (CLI cheat-sheets,
Bicep templates, PowerShell/bash labs, documentation). There is no build/test pipeline —
changes are files (Markdown, `.bicep`, `.bicepparam`, `.ps1`, `.azcli`, `.sh`, `.jsonc`).

## Naming conventions
- File and folder names: lowercase, kebab-case, no spaces (e.g. `create-azure-vm.md`,
  `vm-cli.azcli`). Exception: `DCs/` folder itself is still PascalCase (not yet renamed);
  don't rename it unless explicitly asked.
- Use the correct extension for content: `.md` for docs, `.bicep`/`.bicepparam` for Bicep,
  `.ps1` for PowerShell scripts, `.azcli`/`.sh` for CLI command collections, `.jsonc` for
  commented JSON/ARM samples.

## Sensitive data — always sanitize
Never introduce real personal/tenant data into committed files. Use placeholders instead:
- Resource group names → `myRG`
- Usernames in comments/prompts → `user`
- Subscription IDs, tenant IDs, emails, custom domains → generic placeholders
  (e.g. `<subscription-id>`, `user@example.com`, `example.com`)
If you find real secrets/IDs/emails while editing a file, flag them and offer to replace
with placeholders rather than leaving them in place.

## Git identity
- This repo uses a **local** git identity, separate from the global one (kept out of this
  file since the repo is public). Don't change global git config; if identity looks wrong,
  check `git config --local user.name/user.email` first.

## Windows/git case-only rename gotcha
When renaming a file/folder where **only the case** changes (e.g. `Compute` → `compute`):
- Windows NTFS resolves paths case-insensitively, so `git add -A` / `git status` can miss
  the rename for files with unchanged content, leaving a stale duplicate entry under the
  OLD case in git's index/tree — invisible until you check `git ls-files` or
  `git ls-tree -r --name-only HEAD`.
- After any case-only rename, run `git ls-files | Select-String <name>` (or
  `git ls-tree -r --name-only HEAD`) to check for duplicate old-case/new-case entries.
  If found, `git rm --cached "OldCase/path"` (index-only, safe) then commit.
- Setting `git config core.ignorecase false` before `git reset` + `git add -A` helps
  detect most case renames, but doesn't fully prevent the stale-duplicate issue.

## Working style
- These are lightweight reference/lab files, not production code — prefer clarity and
  runnable examples over heavy abstraction or error handling.
- Don't add build tooling, linters, or CI unless explicitly requested.
