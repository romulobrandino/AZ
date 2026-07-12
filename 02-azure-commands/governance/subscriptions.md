# Subscriptions — Commands

> Reference: [governance setup guide](../../01-getting-started/governance.md)

## PowerShell

```powershell
# List all subscriptions
Get-AzSubscription | Format-Table Name, Id, TenantId, State -AutoSize

# Set active subscription
Set-AzContext -Subscription "<subscription-id-or-name>"

# Get current context
Get-AzContext

# Apply tag to subscription
Update-AzTag -ResourceId "/subscriptions/<subscription-id>" -Tag @{ environment="prod"; owner="team@company.com" } -Operation Merge
```

## Azure CLI

```bash
# List all subscriptions
az account list --output table

# Set active subscription
az account set --subscription "<subscription-id-or-name>"

# Show current subscription
az account show --output table

# Tag a subscription
az tag update --resource-id /subscriptions/<subscription-id> \
  --operation merge \
  --tags environment=prod owner=team@company.com
```

## Additional Resources
- [Manage Azure subscriptions](https://learn.microsoft.com/azure/cost-management-billing/manage/manage-azure-subscription-policy)
