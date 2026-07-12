# Budgets and Cost Alerts — Commands

> Reference: [governance setup guide](../../01-getting-started/governance.md)

## Azure Portal (recommended for initial setup)
Azure Portal → Cost Management → Budgets → + Add

## Azure CLI

```bash
# Create a budget with email alerts at 80% and 100%
az consumption budget create \
  --budget-name "<budget-name>" \
  --amount <amount> \
  --time-grain Monthly \
  --start-date <YYYY-MM-DD> \
  --end-date <YYYY-MM-DD> \
  --category Cost \
  --notifications \
    "actual_GreaterThan_80_Percent=enabled" \
    "actual_GreaterThan_100_Percent=enabled"

# List budgets
az consumption budget list --output table
```

## PowerShell

```powershell
# List budgets
Get-AzConsumptionBudget

# Get current spend
Get-AzConsumptionUsageDetail -StartDate "<start>" -EndDate "<end>" | Measure-Object -Property PretaxCost -Sum
```

## Additional Resources
- [Create and manage budgets](https://learn.microsoft.com/azure/cost-management-billing/costs/tutorial-acm-create-budgets)
- [Cost Management overview](https://learn.microsoft.com/azure/cost-management-billing/cost-management-billing-overview)
