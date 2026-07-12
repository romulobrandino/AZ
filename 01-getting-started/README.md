# Getting Started: Tenant & Subscription First-Time Setup

Generic, reusable checklist for preparing a **new Azure tenant/subscription** before
deploying any resources (VNets, VMs, Storage, etc.). Covers sign-in, subscription
selection, resource provider registration, and a map of all the Microsoft 365/Azure
admin portals you'll likely need.

> Replace placeholders like `<subscription-id-or-name>`, `<tenant-id>`, and
> `<resource-provider>` with your own values. Never commit real subscription/tenant
> IDs or emails to a public repo.

## 1. Prerequisites: PowerShell 7 and Azure PowerShell module

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

### Install the Azure PowerShell (Az) module — for all users

Always install the `Az` module with `-Scope AllUsers` so modules are installed
system-wide instead of the OneDrive-backed `Documents` folder. See
[powershell-module-best-practices.md](../02-azure-commands/powershell-module-best-practices.md)
for the full explanation, path reference, and migration steps.

```powershell
# Run PowerShell 7 as Administrator
Install-Module -Name Az -Scope AllUsers
```

## 2. Sign in to Azure

### PowerShell (Az module)
```powershell
Connect-AzAccount

# Specify a tenant explicitly
Connect-AzAccount -Tenant <tenant-id-or-domain>
```

### Azure CLI

Before running `az login`, confirm the customer's machine has the Azure CLI installed.

**Check the installed Azure CLI version**
```bash
az --version
```

**Install Azure CLI**

Documentation: [Install the Azure CLI on Windows](https://learn.microsoft.com/cli/azure/install-azure-cli-windows)

Install via winget (recommended):
```powershell
winget install --id Microsoft.AzureCLI --source winget
```

**Sign in**
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
otherwise the deployment fails with an error like
`MissingSubscriptionRegistration`.

### Check registration status of a specific provider

**PowerShell**
```powershell
Get-AzResourceProvider -ProviderNamespace Microsoft.Network | Select-Object ProviderNamespace, RegistrationState -Unique
```

> `Get-AzResourceProvider` returns one object per **resource type** under the provider (e.g.
> `Microsoft.Network` has ~190 resource types), so without `-Unique` you'll see the same
> `ProviderNamespace`/`RegistrationState` repeated many times. `-Unique` collapses it to one row.

**Azure CLI**
```bash
az provider show --namespace Microsoft.Network --query "registrationState" --output tsv
```

### List all providers and their registration state

**PowerShell**
```powershell
Get-AzResourceProvider -ListAvailable | Select-Object ProviderNamespace, RegistrationState -Unique | Sort-Object ProviderNamespace
```

**Azure CLI**
```bash
az provider list --query "[].{Namespace:namespace, State:registrationState}" --output table
```

### Register a resource provider

**PowerShell**
```powershell
Register-AzResourceProvider -ProviderNamespace <resource-provider>

# Example
Register-AzResourceProvider -ProviderNamespace Microsoft.Network
```

**Azure CLI**
```bash
az provider register --namespace <resource-provider>

# Example
az provider register --namespace Microsoft.Network
```

Registration is asynchronous — it can take a few seconds to a couple of minutes.
Re-run the "check registration status" command until `RegistrationState` shows
`Registered`.

### Common resource providers to register early

Categorized top providers, cross-checked against Microsoft's official resource-provider-to-service mapping.

**Compute**

| Resource Provider | Needed for |
|---|---|
| `Microsoft.Compute` | Virtual Machines, VM Scale Sets, disks, images |
| `Microsoft.Web` | App Service, Azure Functions |
| `Microsoft.ContainerService` | Azure Kubernetes Service (AKS) |

**Networking**

| Resource Provider | Needed for |
|---|---|
| `Microsoft.Network` | VNets, NSGs, load balancers, App Gateway, VPN/ExpressRoute gateways, DNS |
| `Microsoft.Cdn` | Azure CDN / Front Door |

**Storage**

| Resource Provider | Needed for |
|---|---|
| `Microsoft.Storage` | Storage accounts (blob, file, queue, table) |

**Databases**

| Resource Provider | Needed for |
|---|---|
| `Microsoft.Sql` | Azure SQL Database / Managed Instance |
| `Microsoft.DocumentDB` | Azure Cosmos DB |
| `Microsoft.Cache` | Azure Cache for Redis / Managed Redis |

**Identity & Security**

| Resource Provider | Needed for |
|---|---|
| `Microsoft.KeyVault` | Key Vault (secrets, certs, keys) |
| `Microsoft.ManagedIdentity` | User-assigned managed identities |
| `Microsoft.Security` | Microsoft Defender for Cloud |

**Containers**

| Resource Provider | Needed for |
|---|---|
| `Microsoft.ContainerRegistry` | Container Registry |
| `Microsoft.App` | Azure Container Apps |

**Monitoring & Governance**

| Resource Provider | Needed for |
|---|---|
| `Microsoft.OperationalInsights` | Log Analytics |
| `Microsoft.Insights` | Azure Monitor, diagnostics, alerts |
| `Microsoft.PolicyInsights` | Azure Policy compliance |
| `Microsoft.RecoveryServices` | Backup and Site Recovery |

**AI / Analytics**

| Resource Provider | Needed for |
|---|---|
| `Microsoft.CognitiveServices` | Azure AI/Cognitive Services, Azure AI Foundry resources, Azure OpenAI |
| `Microsoft.MachineLearningServices` | Azure Machine Learning, Azure AI Foundry hubs/projects |
| `Microsoft.Search` | Azure AI Search (Cognitive Search) |

**Data & Analytics (Fabric)**

| Resource Provider | Needed for |
|---|---|
| `Microsoft.Fabric` | Microsoft Fabric capacities and workspaces |
| `Microsoft.Synapse` | Azure Synapse Analytics |
| `Microsoft.DataFactory` | Azure Data Factory (ETL/data pipelines) |
| `Microsoft.Databricks` | Azure Databricks |
| `Microsoft.PowerBIDedicated` | Power BI Premium/Embedded capacity |
| `Microsoft.AnalysisServices` | Azure Analysis Services |

**Integration & Messaging**

| Resource Provider | Needed for |
|---|---|
| `Microsoft.EventHub` | Event Hubs |
| `Microsoft.ServiceBus` | Service Bus |

**Azure Arc & Hybrid**

| Resource Provider | Needed for |
|---|---|
| `Microsoft.HybridCompute` | Arc-enabled servers (on-prem/other-cloud machines projected into Azure) |
| `Microsoft.HybridConnectivity` | Arc connectivity (SSH/serial console access to Arc resources) |
| `Microsoft.GuestConfiguration` | Policy/compliance auditing on Arc-enabled servers |
| `Microsoft.Kubernetes` | Arc-enabled Kubernetes (connected clusters) |
| `Microsoft.KubernetesConfiguration` | Arc-enabled Kubernetes extensions, GitOps/Flux |
| `Microsoft.ExtendedLocation` | Custom Locations (used by Arc-enabled Kubernetes and resource bridge) |
| `Microsoft.ResourceConnector` | Arc resource bridge |
| `Microsoft.AzureArcData` | Arc-enabled data services (SQL Managed Instance, PostgreSQL on Arc) |
| `Microsoft.HybridContainerService` | Arc-enabled AKS (hybrid AKS, e.g. on Azure Local) |
| `Microsoft.AzureStackHCI` | Azure Local (Stack HCI), tightly integrated with Arc |
| `Microsoft.ScVmm` | Arc-enabled System Center Virtual Machine Manager |
| `Microsoft.ConnectedVMwarevSphere` | Arc-enabled VMware vSphere |

**Management Tools**

| Resource Provider | Needed for |
|---|---|
| `Microsoft.CloudShell` | Azure Cloud Shell (browser-based bash/PowerShell shell) |

### Register each provider individually

**PowerShell**
```powershell
# Compute
Register-AzResourceProvider -ProviderNamespace Microsoft.Compute
Register-AzResourceProvider -ProviderNamespace Microsoft.Web
Register-AzResourceProvider -ProviderNamespace Microsoft.ContainerService

# Networking
Register-AzResourceProvider -ProviderNamespace Microsoft.Network
Register-AzResourceProvider -ProviderNamespace Microsoft.Cdn

# Storage
Register-AzResourceProvider -ProviderNamespace Microsoft.Storage

# Databases
Register-AzResourceProvider -ProviderNamespace Microsoft.Sql
Register-AzResourceProvider -ProviderNamespace Microsoft.DocumentDB
Register-AzResourceProvider -ProviderNamespace Microsoft.Cache

# Identity & Security
Register-AzResourceProvider -ProviderNamespace Microsoft.KeyVault
Register-AzResourceProvider -ProviderNamespace Microsoft.ManagedIdentity
Register-AzResourceProvider -ProviderNamespace Microsoft.Security

# Containers
Register-AzResourceProvider -ProviderNamespace Microsoft.ContainerRegistry
Register-AzResourceProvider -ProviderNamespace Microsoft.App

# Monitoring & Governance
Register-AzResourceProvider -ProviderNamespace Microsoft.OperationalInsights
Register-AzResourceProvider -ProviderNamespace Microsoft.Insights
Register-AzResourceProvider -ProviderNamespace Microsoft.PolicyInsights
Register-AzResourceProvider -ProviderNamespace Microsoft.RecoveryServices

# AI / Analytics
Register-AzResourceProvider -ProviderNamespace Microsoft.CognitiveServices
Register-AzResourceProvider -ProviderNamespace Microsoft.MachineLearningServices
Register-AzResourceProvider -ProviderNamespace Microsoft.Search

# Data & Analytics (Fabric)
Register-AzResourceProvider -ProviderNamespace Microsoft.Fabric
Register-AzResourceProvider -ProviderNamespace Microsoft.Synapse
Register-AzResourceProvider -ProviderNamespace Microsoft.DataFactory
Register-AzResourceProvider -ProviderNamespace Microsoft.Databricks
Register-AzResourceProvider -ProviderNamespace Microsoft.PowerBIDedicated
Register-AzResourceProvider -ProviderNamespace Microsoft.AnalysisServices

# Integration & Messaging
Register-AzResourceProvider -ProviderNamespace Microsoft.EventHub
Register-AzResourceProvider -ProviderNamespace Microsoft.ServiceBus

# Azure Arc & Hybrid
Register-AzResourceProvider -ProviderNamespace Microsoft.HybridCompute
Register-AzResourceProvider -ProviderNamespace Microsoft.HybridConnectivity
Register-AzResourceProvider -ProviderNamespace Microsoft.GuestConfiguration
Register-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Register-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration
Register-AzResourceProvider -ProviderNamespace Microsoft.ExtendedLocation
Register-AzResourceProvider -ProviderNamespace Microsoft.ResourceConnector
Register-AzResourceProvider -ProviderNamespace Microsoft.AzureArcData
Register-AzResourceProvider -ProviderNamespace Microsoft.HybridContainerService
Register-AzResourceProvider -ProviderNamespace Microsoft.AzureStackHCI
Register-AzResourceProvider -ProviderNamespace Microsoft.ScVmm
Register-AzResourceProvider -ProviderNamespace Microsoft.ConnectedVMwarevSphere

# Management Tools
Register-AzResourceProvider -ProviderNamespace Microsoft.CloudShell
```

**Azure CLI**
```bash
# Compute
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.Web
az provider register --namespace Microsoft.ContainerService

# Networking
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.Cdn

# Storage
az provider register --namespace Microsoft.Storage

# Databases
az provider register --namespace Microsoft.Sql
az provider register --namespace Microsoft.DocumentDB
az provider register --namespace Microsoft.Cache

# Identity & Security
az provider register --namespace Microsoft.KeyVault
az provider register --namespace Microsoft.ManagedIdentity
az provider register --namespace Microsoft.Security

# Containers
az provider register --namespace Microsoft.ContainerRegistry
az provider register --namespace Microsoft.App

# Monitoring & Governance
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.Insights
az provider register --namespace Microsoft.PolicyInsights
az provider register --namespace Microsoft.RecoveryServices

# AI / Analytics
az provider register --namespace Microsoft.CognitiveServices
az provider register --namespace Microsoft.MachineLearningServices
az provider register --namespace Microsoft.Search

# Data & Analytics (Fabric)
az provider register --namespace Microsoft.Fabric
az provider register --namespace Microsoft.Synapse
az provider register --namespace Microsoft.DataFactory
az provider register --namespace Microsoft.Databricks
az provider register --namespace Microsoft.PowerBIDedicated
az provider register --namespace Microsoft.AnalysisServices

# Integration & Messaging
az provider register --namespace Microsoft.EventHub
az provider register --namespace Microsoft.ServiceBus

# Azure Arc & Hybrid
az provider register --namespace Microsoft.HybridCompute
az provider register --namespace Microsoft.HybridConnectivity
az provider register --namespace Microsoft.GuestConfiguration
az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.KubernetesConfiguration
az provider register --namespace Microsoft.ExtendedLocation
az provider register --namespace Microsoft.ResourceConnector
az provider register --namespace Microsoft.AzureArcData
az provider register --namespace Microsoft.HybridContainerService
az provider register --namespace Microsoft.AzureStackHCI
az provider register --namespace Microsoft.ScVmm
az provider register --namespace Microsoft.ConnectedVMwarevSphere

# Management Tools
az provider register --namespace Microsoft.CloudShell
```

### Bulk-register a standard set of providers

**PowerShell**
```powershell
$providers = @(
  "Microsoft.Compute", "Microsoft.Web", "Microsoft.ContainerService",
  "Microsoft.Network", "Microsoft.Cdn",
  "Microsoft.Storage",
  "Microsoft.Sql", "Microsoft.DocumentDB", "Microsoft.Cache",
  "Microsoft.KeyVault", "Microsoft.ManagedIdentity", "Microsoft.Security",
  "Microsoft.ContainerRegistry", "Microsoft.App",
  "Microsoft.OperationalInsights", "Microsoft.Insights", "Microsoft.PolicyInsights", "Microsoft.RecoveryServices",
  "Microsoft.CognitiveServices", "Microsoft.MachineLearningServices", "Microsoft.Search",
  "Microsoft.Fabric", "Microsoft.Synapse", "Microsoft.DataFactory",
  "Microsoft.Databricks", "Microsoft.PowerBIDedicated", "Microsoft.AnalysisServices",
  "Microsoft.EventHub", "Microsoft.ServiceBus",
  "Microsoft.HybridCompute", "Microsoft.HybridConnectivity", "Microsoft.GuestConfiguration",
  "Microsoft.Kubernetes", "Microsoft.KubernetesConfiguration", "Microsoft.ExtendedLocation",
  "Microsoft.ResourceConnector", "Microsoft.AzureArcData", "Microsoft.HybridContainerService",
  "Microsoft.AzureStackHCI", "Microsoft.ScVmm", "Microsoft.ConnectedVMwarevSphere",
  "Microsoft.CloudShell"
)

foreach ($rp in $providers) {
  Register-AzResourceProvider -ProviderNamespace $rp
}
```

**Azure CLI**
```bash
for rp in Microsoft.Compute Microsoft.Web Microsoft.ContainerService \
          Microsoft.Network Microsoft.Cdn \
          Microsoft.Storage \
          Microsoft.Sql Microsoft.DocumentDB Microsoft.Cache \
          Microsoft.KeyVault Microsoft.ManagedIdentity Microsoft.Security \
          Microsoft.ContainerRegistry Microsoft.App \
          Microsoft.OperationalInsights Microsoft.Insights Microsoft.PolicyInsights Microsoft.RecoveryServices \
          Microsoft.CognitiveServices Microsoft.MachineLearningServices Microsoft.Search \
          Microsoft.Fabric Microsoft.Synapse Microsoft.DataFactory \
          Microsoft.Databricks Microsoft.PowerBIDedicated Microsoft.AnalysisServices \
          Microsoft.EventHub Microsoft.ServiceBus \
          Microsoft.HybridCompute Microsoft.HybridConnectivity Microsoft.GuestConfiguration \
          Microsoft.Kubernetes Microsoft.KubernetesConfiguration Microsoft.ExtendedLocation \
          Microsoft.ResourceConnector Microsoft.AzureArcData Microsoft.HybridContainerService \
          Microsoft.AzureStackHCI Microsoft.ScVmm Microsoft.ConnectedVMwarevSphere \
          Microsoft.CloudShell; do
  az provider register --namespace "$rp"
done
```


## 5. Recommended first steps after provider registration

1. Create a resource group for your workload (naming convention, e.g. `myRG`).
2. Apply subscription-level tags (owner, environment, cost center).
3. Set up Azure Policy / budgets if required by your organization.
4. Only then start creating networking (VNet/NSG), compute (VM/AKS), and storage resources.

## 6. Microsoft admin portals reference

Sequence of admin portals commonly used when onboarding a tenant, in the order
you'd typically touch them:

| # | Portal | URL |
|---|---|---|
| 1 | Microsoft 365 admin center | https://admin.microsoft.com |
| 2 | Azure Portal | https://portal.azure.com |
| 3 | Microsoft Entra admin center | https://entra.microsoft.com |
| 4 | Microsoft Defender portal | https://security.microsoft.com |
| 5 | Microsoft Purview portal | https://purview.microsoft.com |
| 6 | Microsoft Foundry (formerly Azure AI Foundry) | https://ai.azure.com |
| 7 | Microsoft Copilot Studio | https://copilotstudio.microsoft.com |
| 8 | Teams admin center | https://admin.teams.microsoft.com |
| 9 | SharePoint admin center | https://admin.microsoft.com/sharepoint |
| 10 | Exchange admin center | https://admin.exchange.microsoft.com |
| 11 | Intune admin center | https://intune.microsoft.com |
| 12 | Power Platform admin center | https://admin.powerplatform.microsoft.com |

### What each portal is typically used for

- **Microsoft 365 admin center** — Manage users, licenses, groups, and overall M365 tenant settings.
- **Azure Portal** — Provision and manage Azure resources (VNets, VMs, Storage, AKS, etc.).
- **Microsoft Entra admin center** — Identity and access management: users, groups, app registrations, Conditional Access, RBAC.
- **Microsoft Defender portal** — Unified security operations: threat detection, incident response, security posture (XDR).
- **Microsoft Purview portal** — Data governance, compliance, data loss prevention (DLP), information protection.
- **Microsoft Foundry** — Build, evaluate, and deploy AI models/agents (formerly Azure AI Foundry / Azure AI Studio).
- **Microsoft Copilot Studio** — Build and manage custom Copilot/agent experiences.
- **Teams admin center** — Manage Microsoft Teams policies, meetings, calling, and devices.
- **SharePoint admin center** — Manage SharePoint sites, storage, and sharing settings.
- **Exchange admin center** — Manage mailboxes, mail flow rules, and email security.
- **Intune admin center** — Device management (MDM/MAM), compliance policies, app deployment.
- **Power Platform admin center** — Manage Power Apps, Power Automate, Power BI, and Dataverse environments.

## Additional Resources
- [Installing PowerShell on Windows](https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows)
- [Resource providers and types](https://learn.microsoft.com/azure/azure-resource-manager/management/resource-providers-and-types)
- [Azure CLI: az provider](https://learn.microsoft.com/cli/azure/provider)
- [PowerShell: Register-AzResourceProvider](https://learn.microsoft.com/powershell/module/az.resources/register-azresourceprovider)
- [Microsoft 365 admin centers overview](https://learn.microsoft.com/microsoft-365/admin/admin-overview/admin-center-overview)
