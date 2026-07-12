# Management Groups — Commands

> Reference: [governance setup guide](../../01-getting-started/governance.md)

## PowerShell

```powershell
# List all management groups
Get-AzManagementGroup

# Create a management group
New-AzManagementGroup -GroupName "<mg-name>" -DisplayName "<Display Name>"

# Move a subscription into a management group
New-AzManagementGroupSubscription -GroupName "<mg-name>" -SubscriptionId "<subscription-id>"

# Get management group hierarchy
Get-AzManagementGroup -GroupName "<mg-name>" -Expand -Recurse
```

## Azure CLI

```bash
# List all management groups
az account management-group list --output table

# Create a management group
az account management-group create --name "<mg-name>" --display-name "<Display Name>"

# Add a subscription to a management group
az account management-group subscription add --name "<mg-name>" --subscription "<subscription-id>"

# Show hierarchy
az account management-group show --name "<mg-name>" --expand --recurse
```

## Additional Resources
- [Management Groups docs](https://learn.microsoft.com/azure/governance/management-groups/overview)
