# PowerShell Module Installation Best Practices

## Problem: Modules Installing to OneDrive

By default, PowerShell installs user-scoped modules to the `Documents\WindowsPowerShell\Modules` (PS5) or `Documents\PowerShell\Modules` (PS7) folder.

When **OneDrive Known Folder Move** (folder backup) is enabled, the `Documents` folder is redirected to OneDrive, causing thousands of DLL and module files to sync unnecessarily. This results in:

- Wasted OneDrive storage (5–10 GB+)
- Slow OneDrive sync due to thousands of small files
- Potential file lock conflicts across devices
- Platform-specific DLLs syncing to incompatible machines

---

## Solution: Always Install Modules for All Users

Use `-Scope AllUsers` to install modules to the system-wide path instead of the user's Documents folder.

> **Requires PowerShell running as Administrator.**

### PowerShell 5 (Windows PowerShell)

```powershell
# Installs to: C:\Program Files\WindowsPowerShell\Modules
Install-Module -Name Az -Scope AllUsers
Install-Module -Name Microsoft.Graph -Scope AllUsers
```

### PowerShell 7+

```powershell
# Installs to: C:\Program Files\PowerShell\7\Modules
Install-Module -Name Az -Scope AllUsers
Install-Module -Name Microsoft.Graph -Scope AllUsers
```

---

## Module Path Reference

| Scope | PS Version | Path |
|---|---|---|
| CurrentUser ❌ | PS5 | `~\Documents\WindowsPowerShell\Modules` (OneDrive!) |
| CurrentUser ❌ | PS7 | `~\Documents\PowerShell\Modules` (OneDrive!) |
| AllUsers ✅ | PS5 | `C:\Program Files\WindowsPowerShell\Modules` |
| AllUsers ✅ | PS7 | `C:\Program Files\PowerShell\7\Modules` |
| Built-in | PS5/7 | `C:\Windows\system32\WindowsPowerShell\v1.0\Modules` ⛔ Never write here |

---

## Migrating Existing Modules Out of OneDrive

If you already have modules in the OneDrive-backed Documents folder, migrate them with:

### PowerShell 5 modules

```powershell
# Run as Administrator
Move-Item -Path "$env:USERPROFILE\OneDrive - Microsoft\Documents\WindowsPowerShell\Modules\*" `
          -Destination "C:\Program Files\WindowsPowerShell\Modules\" -Force
```

> If `Move-Item` fails due to conflicts, use `robocopy`:

```powershell
robocopy "$env:USERPROFILE\OneDrive - Microsoft\Documents\WindowsPowerShell\Modules" `
         "C:\Program Files\WindowsPowerShell\Modules" /E /MOVE /NFL /NDL /NJH /NJS
```

### PowerShell 7 modules

```powershell
# Run as Administrator
robocopy "$env:USERPROFILE\OneDrive - Microsoft\Documents\PowerShell\Modules" `
         "C:\Program Files\PowerShell\7\Modules" /E /MOVE /NFL /NDL /NJH /NJS
```

### Verify and clean up

```powershell
# Confirm modules load from new location
Get-Module -ListAvailable Az | Select-Object Name, Version, ModuleBase | Select-Object -First 3

# Delete empty OneDrive module folders
Remove-Item "$env:USERPROFILE\OneDrive - Microsoft\Documents\WindowsPowerShell\Modules" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:USERPROFILE\OneDrive - Microsoft\Documents\PowerShell\Modules" -Recurse -Force -ErrorAction SilentlyContinue
```

---

## Verify Current Module Paths

```powershell
# Show all paths PowerShell searches for modules
$env:PSModulePath -split ';'
```

Expected output (clean setup):
```
C:\Program Files\PowerShell\7\Modules
C:\Program Files\WindowsPowerShell\Modules
C:\Windows\system32\WindowsPowerShell\v1.0\Modules
```

---

## Going Forward — Cheat Sheet

```powershell
# ✅ Always use this (requires Admin)
Install-Module -Name <ModuleName> -Scope AllUsers

# ✅ Update all modules system-wide
Update-Module -Scope AllUsers

# ✅ Uninstall system-wide
Uninstall-Module -Name <ModuleName> -AllVersions

# ❌ Avoid this (installs to OneDrive-backed Documents)
Install-Module -Name <ModuleName> -Scope CurrentUser
Install-Module -Name <ModuleName>   # Default is CurrentUser
```

---

## Why NOT `C:\Windows\system32\WindowsPowerShell\v1.0\Modules`?

- Reserved for **Windows OS built-in modules only**
- Windows Update can overwrite or delete files without warning
- Mixing custom modules with OS modules makes cleanup difficult
- Use `C:\Program Files\...\Modules` for all user-installed modules

---

## References

- [PowerShell Module Installation Paths — Microsoft Docs](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_modules)
- [Install-Module -Scope parameter](https://learn.microsoft.com/en-us/powershell/module/powershellget/install-module)
- [OneDrive Known Folder Move](https://learn.microsoft.com/en-us/onedrive/redirect-known-folders)
