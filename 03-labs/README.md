# Labs

Hands-on exercises and scripts for practicing Azure services via CLI, PowerShell, and Bash. Organized by topic area.

## Structure

### [azure-ad/](azure-ad)
Microsoft Entra ID (Azure AD) user, group, and resource management.
- [create-groups.ps1](azure-ad/create-groups.ps1) — create an Entra ID group
- [create-users.azcli](azure-ad/create-users.azcli), [create-users-simple.ps1](azure-ad/create-users-simple.ps1) — create a user via CLI/PowerShell
- [create-users.md](azure-ad/create-users.md) — walkthrough for creating and bulk-inviting users
- [move-resource-group.md](azure-ad/move-resource-group.md) — move resources between resource groups (CLI & PowerShell)
- [tags.md](azure-ad/tags.md), [tags-cli.md](azure-ad/tags-cli.md) — resource tagging notes and CLI reference

### [compute/](compute)
Virtual machines and container instances.
- [vm-cli.azcli](compute/vm-cli.azcli), [vm-cli.md](compute/vm-cli.md) — VM image discovery, sizing, resize, and NGINX install walkthrough
- [container.azcli](compute/container.azcli) — Azure Container Instances (ACI), including Cosmos DB integration and file share mounts
- [nginx-html.html](compute/nginx-html.html) — sample HTML page used in the container exercise

### [devops/](devops)
- [aks.azcli](devops/aks.azcli) — deploy, expose, and scale a workload on Azure Kubernetes Service (AKS)

### [networking/](networking)
Virtual networks, VPN gateways, and Private Link.
- [create-vnets.azcli](networking/create-vnets.azcli), [simple-vnet.ps1](networking/simple-vnet.ps1), [simple-vnet-az.azcli](networking/simple-vnet-az.azcli), [simple-vnet-az.sh](networking/simple-vnet-az.sh) — basic VNet/subnet creation (CLI, PowerShell, Bash)
- [vng-active-active-2-vnets.azcli](networking/vng-active-active-2-vnets.azcli), [vng-active-active-2-vnets.ps1](networking/vng-active-active-2-vnets.ps1) — active-active VPN gateways with BGP across two VNets (incomplete/reference notes)
- [active-active-documentation.md](networking/active-active-documentation.md) — reference links for active-active VPN gateway design
- [create-a-private-link-service-using-azure-cli.md](networking/create-a-private-link-service-using-azure-cli.md) — Private Link Service + Private Endpoint walkthrough

### [storage/](storage)
- [create-blob.azcli](storage/create-blob.azcli) — storage account creation, GZRS replication, and blob upload
- [storage.md](storage/storage.md) — durability/availability notes

### [templates/](templates)
- [azure-resource-manager.md](templates/azure-resource-manager.md) — ARM template concepts (parameters, variables, functions, resources, outputs)
- [vnet-brazil.jsonc](templates/vnet-brazil.jsonc) — sample ARM template deploying a VNet with subnets

## Notes
- Resource group/subscription values are generic placeholders (`myRG`, `<subscription-id>`, etc.) — replace with your own before running.
- Some scripts are exploratory/incomplete notes (e.g., the active-active VPN gateway exercise) rather than fully polished runbooks.
