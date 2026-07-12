# Microsoft Admin Portals Reference

Admin portals commonly used when onboarding a tenant, grouped by category. Within
each category they're listed in the order you'd typically touch them first.

> Part of the [Getting Started: Tenant & Subscription First-Time Setup](README.md) guide.

## 🔵 Azure Infrastructure

| Portal | URL | Quick Access |
|---|---|---|
| Azure Portal | https://portal.azure.com | Resource groups: https://portal.azure.com/#view/HubsExtension/BrowseResourceGroups |
| Microsoft Entra admin center | https://entra.microsoft.com | Identity → Users; Applications → App registrations |

## 🟢 Microsoft 365

| Portal | URL | Quick Access |
|---|---|---|
| Microsoft 365 admin center | https://admin.microsoft.com | Users → Active users: https://admin.microsoft.com/#/users |
| Teams admin center | https://admin.teams.microsoft.com | Users: https://admin.teams.microsoft.com/users |
| Exchange admin center | https://admin.exchange.microsoft.com | Recipients → Mailboxes: https://admin.exchange.microsoft.com/#/mailboxes |
| SharePoint admin center | https://admin.microsoft.com/sharepoint | Sites → Active sites: https://admin.microsoft.com/sharepoint#/sites |
| Intune admin center | https://intune.microsoft.com | Devices → All devices |

## 🔴 Security & Compliance

| Portal | URL | Quick Access |
|---|---|---|
| Microsoft Defender portal | https://security.microsoft.com | Incidents & alerts: https://security.microsoft.com/incidents |
| Microsoft Purview portal | https://purview.microsoft.com | Compliance Manager |

## 🟡 AI & Dev

| Portal | URL | Quick Access |
|---|---|---|
| Microsoft Foundry (formerly Azure AI Foundry) | https://ai.azure.com | — |
| Microsoft Copilot Studio | https://copilotstudio.microsoft.com | — |
| Power Platform admin center | https://admin.powerplatform.microsoft.com | Environments: https://admin.powerplatform.microsoft.com/environments |
| Azure Scout (Copilot for Azure) | https://aka.ms/scout | — |
| M365 Copilot Chat | https://m365.cloud.microsoft/chat | — |

> **Note on Quick Access links**: entries with a full URL are stable, documented
> deep links. Entries showing a navigation path (e.g., "Identity → Users") point to
> menu items whose underlying blade URLs change between portal releases — use the
> in-portal search/navigation instead of a hardcoded link for those.

## What each portal is typically used for

- **Azure Portal** — Provision and manage Azure resources (VNets, VMs, Storage, AKS, etc.).
- **Microsoft Entra admin center** — Identity and access management: users, groups, app registrations, Conditional Access, RBAC.
- **Microsoft 365 admin center** — Manage users, licenses, groups, and overall M365 tenant settings.
- **Microsoft Defender portal** — Unified security operations: threat detection, incident response, security posture (XDR).
- **Microsoft Purview portal** — Data governance, compliance, data loss prevention (DLP), information protection.
- **Microsoft Foundry** — Build, evaluate, and deploy AI models/agents (formerly Azure AI Foundry / Azure AI Studio).
- **Microsoft Copilot Studio** — Build and manage custom Copilot/agent experiences.
- **Teams admin center** — Manage Microsoft Teams policies, meetings, calling, and devices.
- **SharePoint admin center** — Manage SharePoint sites, storage, and sharing settings.
- **Exchange admin center** — Manage mailboxes, mail flow rules, and email security.
- **Intune admin center** — Device management (MDM/MAM), compliance policies, app deployment.
- **Power Platform admin center** — Manage Power Apps, Power Automate, Power BI, and Dataverse environments.
- **Azure Scout** — AI-assisted Azure guidance/copilot experience for exploring and troubleshooting Azure resources.
- **M365 Copilot Chat** — General-purpose Microsoft 365 Copilot chat experience across Word, Excel, Teams, and the web.

## Additional Resources
- [Microsoft 365 admin centers overview](https://learn.microsoft.com/microsoft-365/admin/admin-overview/admin-center-overview)
