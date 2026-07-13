# Enable / Create Azure Cloud Shell — Step by Step

Azure Cloud Shell is a free, browser-based shell (Bash or PowerShell) with the
Azure CLI and Az module pre-installed — useful when you don't want to install
tools locally, or need a consistent environment across machines.

## 1. Open Cloud Shell
Pick one:
- Azure Portal → click the **Cloud Shell icon** (`>_`) in the top toolbar.
- Go directly to [shell.azure.com](https://shell.azure.com).
- VS Code with the Azure Account extension → **Azure: Open Bash in Cloud Shell** /
  **Azure: Open PowerShell in Cloud Shell** (Command Palette).

## 2. Choose your shell
On first launch you're prompted to pick **Bash** or **PowerShell**. You can
switch between them later from the dropdown in the Cloud Shell toolbar — this
doesn't affect the persisted files in your `$Home`.

## 3. First-time storage setup (required)
Cloud Shell needs an Azure Files share to persist your `$Home` directory
(scripts, `.azure` config, SSH keys) between sessions.

- **Quick create (recommended for a first try)**: accept the default prompt —
  Azure creates a new resource group, storage account, and file share
  automatically in a supported region.
- **Advanced / choose existing storage**: select **Show advanced settings** to
  pick an existing subscription, resource group, region, storage account, and
  file share (useful if you want to control naming/region or reuse storage
  created via [storage/create-storage-account.md](storage/create-storage-account.md)).

> Cost note: this creates a small Azure Files share (billed per GB/transactions) —
> trivial for typical use, but not literally free.

## 4. Confirm you're connected
```bash
az account show --output table
```
```powershell
Get-AzContext
```

## 5. Useful things to know
- **Persistence**: only `$Home` (and anything under it, e.g. `clouddrive`) is
  persisted — the container itself resets each session, so tools installed
  outside `$Home` won't survive.
- **Upload/download files**: use the **Upload/Download** icon in the toolbar,
  or `azcopy` for larger transfers.
- **Restart the session**: use the **Restart Cloud Shell** icon if the shell
  becomes unresponsive.
- **Reset the environment**: Settings (gear icon) → **Reset User Settings** —
  wipes the storage association if you need to start over with a different
  storage account/region.
- **Session timeout**: disconnects after ~20 minutes of inactivity; just
  reopen it, your `$Home` is still there.

## Additional Resources
- [Overview of Azure Cloud Shell](https://learn.microsoft.com/azure/cloud-shell/overview)
- [Persisting shell storage](https://learn.microsoft.com/azure/cloud-shell/persisting-shell-storage)
- [Quickstart for Bash in Cloud Shell](https://learn.microsoft.com/azure/cloud-shell/quickstart)
- [Quickstart for PowerShell in Cloud Shell](https://learn.microsoft.com/azure/cloud-shell/quickstart-powershell)
