# RBAC Role Assignments — Commands

> Reference: [governance setup guide](../../01-getting-started/governance.md)

## Common Roles
| Role | Description |
|---|---|
| Owner | Full access including RBAC management |
| Contributor | Create/manage resources, no RBAC |
| Reader | Read-only access |
| Cost Management Reader | View costs and budgets |
| User Access Administrator | Manage user access only |

## PowerShell

```powershell
# List role assignments at subscription scope
Get-AzRoleAssignment -Scope "/subscriptions/<subscription-id>" | Format-Table DisplayName, RoleDefinitionName, SignInName

# Assign a role
New-AzRoleAssignment -SignInName "<user@domain.com>" `
  -RoleDefinitionName "Contributor" `
  -Scope "/subscriptions/<subscription-id>"

# Assign role at resource group scope
New-AzRoleAssignment -SignInName "<user@domain.com>" `
  -RoleDefinitionName "Contributor" `
  -ResourceGroupName "<rg-name>"

# Remove a role assignment
Remove-AzRoleAssignment -SignInName "<user@domain.com>" `
  -RoleDefinitionName "Contributor" `
  -Scope "/subscriptions/<subscription-id>"
```

## Azure CLI

```bash
# List role assignments
az role assignment list --subscription "<subscription-id>" --output table

# Assign a role
az role assignment create \
  --assignee "<user@domain.com>" \
  --role "Contributor" \
  --scope /subscriptions/<subscription-id>

# Assign at resource group scope
az role assignment create \
  --assignee "<user@domain.com>" \
  --role "Contributor" \
  --resource-group "<rg-name>"

# Remove a role assignment
az role assignment delete \
  --assignee "<user@domain.com>" \
  --role "Contributor" \
  --scope /subscriptions/<subscription-id>
```

## Additional Resources
- [Azure RBAC overview](https://learn.microsoft.com/azure/role-based-access-control/overview)
- [Built-in roles](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles)
