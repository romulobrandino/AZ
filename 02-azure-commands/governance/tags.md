# Tags — Commands

> Reference: [governance setup guide](../../01-getting-started/governance.md)

## Recommended Tags
| Tag | Example |
|---|---|
| `owner` | `team@company.com` |
| `environment` | `prod` / `dev` / `staging` |
| `cost-center` | `CC-1234` |
| `workload` | `webapp` |
| `created-date` | `2026-07-12` |

## PowerShell

```powershell
# Apply tags to a resource group
Set-AzResourceGroup -Name "<rg-name>" -Tag @{ owner="team@company.com"; environment="prod" }

# Apply tags to a resource
Set-AzResource -ResourceId "<resource-id>" -Tag @{ environment="prod" } -Force

# Bulk tag all resources in a resource group
Get-AzResource -ResourceGroupName "<rg-name>" | ForEach-Object {
    Set-AzResource -ResourceId $_.ResourceId -Tag @{ environment="prod"; cost-center="CC-1234" } -Force
}

# Find all resources missing a required tag
Get-AzResource | Where-Object { -not $_.Tags.ContainsKey("owner") }
```

## Azure CLI

```bash
# Apply tags to a resource group
az group update --name "<rg-name>" --tags owner=team@company.com environment=prod

# Apply tags to a resource
az resource update --ids "<resource-id>" --set tags.environment=prod tags.owner=team@company.com

# List all resources missing a tag
az resource list --query "[?tags.owner==null].{Name:name, Type:type}" --output table

# List all distinct tag names in use in the subscription
az tag list --query "[].tagName" --output table
```

## Additional Resources
- [Use tags to organize resources](https://learn.microsoft.com/azure/azure-resource-manager/management/tag-resources)
