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
| [02-azure-commands/](02-azure-commands/README.md) | Azure CLI/PowerShell install guides (Windows + [Linux: Debian/Ubuntu/Kali, RHEL/CentOS/Fedora, openSUSE/SLES, WSL2](02-azure-commands/linux-azurecli.md)), cheat-sheets, [PowerShell module best practices](02-azure-commands/powershell-module-best-practices.md), sample Bicep, and networking command references (e.g. Application Gateway). |
| [03-labs/](03-labs/README.md) | Hands-on lab scripts organized by topic: `azure-ad/`, `compute/` (incl. domain controllers under `compute/DCs/`), `devops/`, `networking/`, `storage/`, and ARM/Bicep `templates/`. |
| [04-azure-docs/](04-azure-docs/) | Short reference notes per Azure service area (AI, big data/analytics, compute, database, DevOps, IoT, networking, storage). |

## Network Topology Architecture

The following diagram illustrates a typical Azure network topology with Application Gateway for web application delivery.

```mermaid
graph TB
    subgraph Internet["Internet"]
        Users[("👥 Users")]
    end
    
    subgraph Azure["Azure Cloud"]
        subgraph VNet["Virtual Network (10.0.0.0/16)"]
            subgraph AppGWSubnet["Application Gateway Subnet<br/>(10.0.1.0/24)"]
                AppGW["🔒 Application Gateway<br/>with WAF"]
            end
            
            subgraph BackendSubnet["Backend Subnet<br/>(10.0.2.0/24)"]
                NSG1["🛡️ NSG"]
                VM1["🖥️ Web Server 1<br/>(10.0.2.4)"]
                VM2["🖥️ Web Server 2<br/>(10.0.2.5)"]
            end
            
            subgraph AppSubnet["App Services Subnet<br/>(10.0.3.0/24)"]
                NSG2["🛡️ NSG"]
                AppSvc["☁️ App Service"]
            end
            
            subgraph DataSubnet["Database Subnet<br/>(10.0.4.0/24)"]
                NSG3["🛡️ NSG"]
                DB[("💾 Azure SQL<br/>Database")]
            end
        end
        
        subgraph Management["Management & Monitoring"]
            Monitor["📊 Azure Monitor"]
            KeyVault["🔑 Key Vault"]
            LogAnalytics["📝 Log Analytics"]
        end
    end
    
    Users -->|HTTPS :443| AppGW
    AppGW -->|HTTP/HTTPS| VM1
    AppGW -->|HTTP/HTTPS| VM2
    AppGW -->|HTTP/HTTPS| AppSvc
    
    VM1 -.->|SQL :1433| DB
    VM2 -.->|SQL :1433| DB
    AppSvc -.->|SQL :1433| DB
    
    AppGW -.->|Diagnostics| Monitor
    AppGW -.->|Logs| LogAnalytics
    AppGW -.->|SSL Certs| KeyVault
    
    NSG1 -.->|Protects| VM1
    NSG1 -.->|Protects| VM2
    NSG2 -.->|Protects| AppSvc
    NSG3 -.->|Protects| DB
    
    style Users fill:#4A90E2
    style AppGW fill:#FF6B6B
    style VM1 fill:#4ECDC4
    style VM2 fill:#4ECDC4
    style AppSvc fill:#95E1D3
    style DB fill:#F38181
    style Monitor fill:#FFA07A
    style KeyVault fill:#FFD93D
    style LogAnalytics fill:#98D8C8
    style NSG1 fill:#A8E6CF
    style NSG2 fill:#A8E6CF
    style NSG3 fill:#A8E6CF
    
    classDef vnetStyle fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    classDef subnetStyle fill:#F5F5F5,stroke:#757575,stroke-width:1px
    
    class VNet vnetStyle
    class AppGWSubnet,BackendSubnet,AppSubnet,DataSubnet subnetStyle
```

### Architecture Components

- **Application Gateway**: Layer 7 load balancer with Web Application Firewall (WAF) protection
- **Backend Pool**: Web servers (VMs) and App Services hosting applications
- **Network Security Groups (NSG)**: Subnet-level security controls
- **Azure SQL Database**: Managed database service with private connectivity
- **Azure Monitor**: Centralized monitoring and diagnostics
- **Key Vault**: Secure storage for SSL certificates and secrets
- **Log Analytics**: Centralized logging and analytics workspace

