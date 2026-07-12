# Getting Started: Tenant & Subscription First-Time Setup

Generic, reusable checklist for preparing a **new Azure tenant/subscription** before
deploying any resources (VNets, VMs, Storage, etc.). Covers sign-in, subscription
selection, resource provider registration, and a map of all the Microsoft 365/Azure
admin portals you'll likely need.

> Replace placeholders like `<subscription-id-or-name>`, `<tenant-id>`, and
> `<resource-provider>` with your own values. Never commit real subscription/tenant
> IDs or emails to a public repo.

## 1. Prerequisites: PowerShell 7, Azure PowerShell module, and Azure CLI

Before running `Connect-AzAccount` or `az login`, confirm the customer's machine
has **PowerShell 7** installed (the CLI commands in this guide assume it).

### Check the installed PowerShell version
```powershell
$PSVersionTable.PSVersion
```
Confirm `Major` is `7` or higher. If it isn't, install PowerShell 7 before continuing.

### Install PowerShell 7

**Documentation**: [Installing PowerShell on Windows](https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows)

**Install via winget** (recommended):
```powershell
winget install --id Microsoft.PowerShell --source winget
```

### Don't have winget installed?

The `winget` commands below require the **App Installer** package. Check first:
```powershell
winget --version
```
If it isn't found, install it from the Microsoft Store: [App Installer](https://apps.microsoft.com/detail/9nblggh4nns1)
(or download the latest `.msixbundle` release directly from
[microsoft/winget-cli releases](https://github.com/microsoft/winget-cli/releases) if
Store access isn't available).

### Install the Azure PowerShell (Az) module — for all users

Always install the `Az` module with `-Scope AllUsers` so modules are installed
system-wide instead of the OneDrive-backed `Documents` folder. See
[powershell-module-best-practices.md](../02-azure-commands/powershell-module-best-practices.md)
for the full explanation, path reference, and migration steps.

```powershell
# Run PowerShell 7 as Administrator
Install-Module -Name Az -Scope AllUsers
```

### Check the installed Azure CLI version
```bash
az --version
```
> Requires Azure CLI **2.50+**. If your version is older, update it (see
> [Update the tools](#update-the-tools) below) before continuing.

### Install Azure CLI

Documentation: [Install the Azure CLI on Windows](https://learn.microsoft.com/cli/azure/install-azure-cli-windows)

Install via winget (recommended):
```powershell
winget install --id Microsoft.AzureCLI --source winget
```

### Update the tools

If you already have the Az module or Azure CLI installed, keep them current —
older versions can be missing cmdlets/flags referenced in this guide.

```powershell
# Update the Az module
Update-Module -Name Az -Scope AllUsers
```

```bash
# Update Azure CLI
az upgrade
```

## 2. Sign in to Azure

### PowerShell (Az module)
```powershell
Connect-AzAccount

# Specify a tenant explicitly
Connect-AzAccount -Tenant <tenant-id-or-domain>
```

### Azure CLI

```bash
az login

# If you have access to multiple tenants, specify one explicitly
az login --tenant <tenant-id-or-domain>
```

## 3. List and select the subscription

### PowerShell
```powershell
# List all subscriptions you have access to
Get-AzSubscription | Format-Table Name, Id, TenantId, State -AutoSize

# Set the active/default subscription
Set-AzContext -Subscription "<subscription-id-or-name>"

# Confirm the active context
Get-AzContext
```

### Azure CLI
```bash
# List all subscriptions you have access to
az account list --output table

# Set the active/default subscription for subsequent commands
az account set --subscription "<subscription-id-or-name>"

# Confirm the active subscription
az account show --output table
```

## 4. Register Azure Resource Providers

A brand-new subscription only has a handful of resource providers registered by
default. Before you can create a resource type (VNet, VM, Storage account, AKS,
etc.), its **resource provider (RP)** must be registered in the subscription —
otherwise the deployment fails with an error like `MissingSubscriptionRegistration`.

> 👉 **Required:** [Register Azure Resource Providers](register-resource-providers.md)
> — register all the resource providers you'll need (individually or in
> bulk, PowerShell + Azure CLI) before creating any resources. Includes checking
> registration status and the categorized list of ~48 common providers (Compute,
> Networking, Storage, Databases, Identity & Security, Containers, Monitoring &
> Governance, AI/Analytics, Data & Analytics (Fabric), Integration & Messaging,
> Azure Arc & Hybrid, Management Tools).

Quick check for a specific provider:

**PowerShell**
```powershell
Get-AzResourceProvider -ProviderNamespace Microsoft.Network | Select-Object ProviderNamespace, RegistrationState -Unique
```

**Azure CLI**
```bash
az provider show --namespace Microsoft.Network --query "registrationState" --output tsv
```

## 5. Recommended first steps after provider registration

1. Create a resource group for your workload (naming convention, e.g. `myRG`).
2. Apply subscription-level tags (owner, environment, cost center).
3. Set up Azure Policy / budgets if required by your organization.
4. Only then start creating networking (VNet/NSG), compute (VM/AKS), and storage resources.

## 6. Microsoft admin portals reference

> 👉 **Reference:** [Microsoft admin portals reference](admin-portals-reference.md)
> — full list of the Microsoft admin portals you'll likely need when onboarding a
> tenant (Microsoft 365 admin center, Azure Portal, Entra admin center, Defender,
> Purview, Foundry, Copilot Studio, Teams, SharePoint, Exchange, Intune, Power
> Platform, Azure Scout, M365 Copilot Chat), grouped by category (Azure
> Infrastructure, M365, Security & Compliance, AI & Dev), plus what each one is used for.

## Additional Resources
- [Register Azure Resource Providers (full reference)](register-resource-providers.md)
- [Microsoft admin portals reference](admin-portals-reference.md)
- [Installing PowerShell on Windows](https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows)
- [Resource providers and types](https://learn.microsoft.com/azure/azure-resource-manager/management/resource-providers-and-types)
- [Azure CLI: az provider](https://learn.microsoft.com/cli/azure/provider)
- [PowerShell: Register-AzResourceProvider](https://learn.microsoft.com/powershell/module/az.resources/register-azresourceprovider)
- [Microsoft 365 admin centers overview](https://learn.microsoft.com/microsoft-365/admin/admin-overview/admin-center-overview)
