# 02 — Azure Commands

CLI/PowerShell installation guides, command cheat-sheets, and sample Bicep. For
first-time tenant/subscription setup (sign-in, subscription selection, resource
provider registration), see [01-getting-started/](../01-getting-started/README.md)
instead — the files here assume that part is already done.

## Contents

| File / Folder | Contents |
|---|---|
| [linux-azurecli.md](linux-azurecli.md) | Install/check/upgrade/remove the Azure CLI on Debian/Ubuntu/Kali, RHEL/CentOS/Fedora, openSUSE/SLES, and WSL2. For Windows-native install + `az login`, see [01-getting-started/README.md](../01-getting-started/README.md). |
| [powershell-commands.md](powershell-commands.md) | `Get-AzResourceGroup` and networking diagnostics (`Test-Connection`, `netsh`, `psping`, `tcping`). Sign-in/subscription commands live in [01-getting-started/README.md](../01-getting-started/README.md). |
| [powershell-module-best-practices.md](powershell-module-best-practices.md) | Why/how to install PowerShell modules with `-Scope AllUsers` instead of the OneDrive-backed `CurrentUser` scope, plus migration steps. |
| [create-azure-vm.md](create-azure-vm.md) | Full Azure CLI tutorial for creating VMs, querying resource details with JMESPath, and cleaning up. |
| [python-versions-ubuntu.md](python-versions-ubuntu.md) | Managing/upgrading Python versions on Ubuntu/Linux. |
| [main.bicep](main.bicep) / [main.bicepparam](main.bicepparam) | Sample Bicep template + parameters for a secured network setup. |
| [compute/webservers.md](compute/webservers.md) | Install and manage IIS on Windows Server via PowerShell. |
| [networking/application-gateway-commands.md](networking/application-gateway-commands.md) | Application Gateway start/stop/status commands (Azure CLI + PowerShell). |

## Additional Resources
- [01-getting-started/](../01-getting-started/README.md) — tenant/subscription first-time setup (sign-in, subscription selection, resource provider registration, admin portals, troubleshooting).
- [03-labs/](../03-labs/README.md) — hands-on lab scripts organized by topic.
