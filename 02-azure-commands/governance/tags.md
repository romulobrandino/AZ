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

The commands below work against any **resource, resource group, or subscription
ID** — set `$resource` (PowerShell) / `resource` (bash) to whichever scope you're
tagging.

## Create tags

> ⚠️ `New-AzTag` / `az tag create` **replace the entire tag set** on that ID —
> any existing tags not included are removed. Use **Update tags** below to
> add/merge tags without losing existing ones.

### PowerShell
```powershell
$resource = "<resource-id>"   # resource, resource group, or subscription ID
New-AzTag -ResourceId $resource -Tag @{ Team = "Compliance"; Environment = "Production" }
```

### Azure CLI
```bash
resource="<resource-id>"   # resource, resource group, or subscription ID
az tag create --resource-id $resource --tags Team=Compliance Environment=Production
```

## Update tags (add/merge without removing existing)

### PowerShell
```powershell
Update-AzTag -ResourceId $resource -Tag @{ CostCenter = "CC-1234" } -Operation Merge
```

### Azure CLI
```bash
az tag update --resource-id $resource --operation Merge --tags CostCenter=CC-1234
```

> `-Operation` / `--operation` also accepts **Replace** (same behavior as
> `New-AzTag`/`az tag create` — replaces the whole set) and **Delete** (removes
> just the specified keys — see below).

## Add and remove individual tags

### Add or update a single tag
```powershell
Update-AzTag -ResourceId $resource -Tag @{ owner = "team@company.com" } -Operation Merge
```
```bash
az tag update --resource-id $resource --operation Merge --tags owner=team@company.com
```

### Remove a specific tag (keeps the rest)
```powershell
Update-AzTag -ResourceId $resource -Tag @{ environment = "" } -Operation Delete
```
```bash
az tag update --resource-id $resource --operation Delete --tags environment=""
```

### Remove ALL tags from a resource
```powershell
Remove-AzTag -ResourceId $resource
```
```bash
az tag delete --resource-id $resource --yes
```

### List current tags on a resource
```powershell
Get-AzTag -ResourceId $resource
```
```bash
az tag list --resource-id $resource
```

## Resource-group-specific shortcuts

For the common case of tagging a resource group directly (rather than via
`-ResourceId`/`--resource-id`), the resource-group cmdlets below also work:

### PowerShell

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

### Azure CLI

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

> Note: `Set-AzResourceGroup -Tag` / `az group update --tags` **replace** the
> entire tag set on the resource group (same caveat as `New-AzTag`/`az tag
> create` above) — list all existing tags first if you need to preserve them.

## Additional Resources
- [Use tags to organize resources](https://learn.microsoft.com/azure/azure-resource-manager/management/tag-resources)
- [Tag resources, resource groups, and subscriptions with Azure CLI](https://learn.microsoft.com/azure/azure-resource-manager/management/tag-resources-cli)
- [Tag resources, resource groups, and subscriptions with PowerShell](https://learn.microsoft.com/azure/azure-resource-manager/management/tag-resources-powershell)
