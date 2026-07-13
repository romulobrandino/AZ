# Azure personal notes and commands

This is a personal repository for Azure references, CLI commands, PowerShell commands,
documentation links, courses, etc., for my personal use.

## 🚀 Getting Started

New to a tenant/subscription? Start here: **[01-getting-started/README.md](01-getting-started/README.md)**

That guide walks through, in order:
1. **Prerequisites** — PowerShell 7, Azure PowerShell (Az) module, and Azure CLI (install/version checks, `winget`).
2. **Sign in to Azure** — `Connect-AzAccount` and `az login`.
3. **List and select the subscription** — `Get-AzSubscription` / `az account set`.
4. **[Register Azure Resource Providers](01-getting-started/register-resource-providers.md)** — required before creating any resources (VNets, VMs, Storage, AKS, etc.); ~48 providers across 9 categories, individually or in bulk.
5. **Recommended first steps** — resource group, tags, policy/budgets.
6. **[Microsoft admin portals reference](01-getting-started/admin-portals-reference.md)** — admin portals you'll likely need, grouped by category (Azure Infrastructure, M365, Security & Compliance, AI & Dev): Azure Portal, Entra, M365, Defender, Purview, Foundry, Copilot Studio, Teams, SharePoint, Exchange, Intune, Power Platform, Azure Scout, M365 Copilot Chat.
7. **[Troubleshooting: common first-time setup errors](01-getting-started/troubleshooting.md)** — fixes for `MissingSubscriptionRegistration`, `AuthorizationFailed`, sign-in hangs, and more.

## Repository structure

| Folder | Contents |
|---|---|
| [01-getting-started/](01-getting-started/README.md) | 👉 Start here for any new tenant/subscription — see above. |
| [02-azure-commands/](02-azure-commands/README.md) | Azure CLI/PowerShell install guides (Windows + [Linux: Debian/Ubuntu/Kali, RHEL/CentOS/Fedora, openSUSE/SLES, WSL2](02-azure-commands/linux-azurecli.md)), [Cloud Shell setup](02-azure-commands/cloud-shell.md), cheat-sheets (incl. [resource group + storage account creation](02-azure-commands/storage/create-storage-account.md)), [PowerShell module best practices](02-azure-commands/powershell-module-best-practices.md), sample Bicep, [governance command references](02-azure-commands/governance/) (management groups, subscriptions, resource groups, tags, policy, budgets/alerts, RBAC), and networking command references (e.g. Application Gateway, connectivity testing). |
| [03-labs/](03-labs/README.md) | Hands-on lab scripts organized by topic: `azure-ad/`, `compute/` (incl. domain controllers under `compute/DCs/`), `devops/`, `networking/`, `storage/`, and ARM/Bicep `templates/`. |
| [04-azure-docs/](04-azure-docs/) | Short reference notes per Azure service area (AI, big data/analytics, compute, database, DevOps, IoT, networking, storage). |

