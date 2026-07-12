# Resource Groups — Commands

> Reference: [governance setup guide](../../01-getting-started/governance.md)

## Naming Convention
Pattern: `<workload>-<environment>-<region>-rg`
Example: `network-prod-eastus-rg`

## PowerShell

```powershell
# Create a resource group
New-AzResourceGroup -Name "<rg-name>" -Location "<location>" -Tag @{ environment="prod"; owner="team@company.com" }

# List resource groups
Get-AzResourceGroup | Format-Table ResourceGroupName, Location, ProvisioningState -AutoSize

# Apply tags to existing resource group
Set-AzResourceGroup -Name "<rg-name>" -Tag @{ environment="prod"; cost-center="CC-1234" }

# Lock a resource group (prevent deletion)
New-AzResourceLock -LockName "DoNotDelete" -LockLevel CanNotDelete -ResourceGroupName "<rg-name>"

# Delete a resource group
Remove-AzResourceGroup -Name "<rg-name>" -Force
```

## Azure CLI

```bash
# Create a resource group
az group create --name "<rg-name>" --location "<location>" \
  --tags environment=prod owner=team@company.com

# List resource groups
az group list --output table

# Apply tags
az group update --name "<rg-name>" --tags environment=prod cost-center=CC-1234

# Lock resource group
az lock create --name "DoNotDelete" --lock-type CanNotDelete --resource-group "<rg-name>"

# Delete resource group
az group delete --name "<rg-name>" --yes --no-wait
```

## Move resources to another resource group

**Azure CLI**
```bash
# 1. Get the resource ID
yourResource=$(az resource show --resource-group "<source-rg>" --name "<resource-name>" --resource-type "<resource-type>" --query id --output tsv)

# 2. Move it to the destination resource group
az resource move --destination-group "<destination-rg>" --ids $yourResource

# 3. Verify
az group show --name "<destination-rg>"
```

**PowerShell**
```powershell
# 1. Get the resource
$yourResource = Get-AzResource -ResourceGroupName "<source-rg>" -ResourceName "<resource-name>"

# 2. Move it to the destination resource group
Move-AzResource -DestinationResourceGroupName "<destination-rg>" -ResourceId $yourResource.ResourceId

# 3. Verify
Get-AzResource -ResourceGroupName "<destination-rg>" | Format-Table
```

> Update any tools/scripts that reference the old resource IDs after moving.

## Additional Resources
- [Manage resource groups](https://learn.microsoft.com/azure/azure-resource-manager/management/manage-resource-groups-portal)
- [Resource naming conventions (CAF)](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Move resources to a new resource group or subscription](https://learn.microsoft.com/azure/azure-resource-manager/management/move-resource-group-and-subscription)
