# Azure Policy — Commands

> Reference: [governance setup guide](../../01-getting-started/governance.md)

## PowerShell

```powershell
# List all policy definitions
Get-AzPolicyDefinition | Select-Object Name, @{N="DisplayName";E={$_.Properties.DisplayName}} | Format-Table

# Get a specific built-in policy
Get-AzPolicyDefinition -Name "<policy-definition-id>"

# Assign a policy to a subscription
New-AzPolicyAssignment -Name "<assignment-name>" -DisplayName "<Display Name>" `
  -Scope "/subscriptions/<subscription-id>" `
  -PolicyDefinition (Get-AzPolicyDefinition -Name "<policy-definition-id>")

# Check compliance state
Get-AzPolicyState -SubscriptionId "<subscription-id>" | Where-Object { $_.ComplianceState -eq "NonCompliant" }
```

## Azure CLI

```bash
# List all policy definitions
az policy definition list --query "[].{Name:name, DisplayName:displayName}" --output table

# Assign a policy
az policy assignment create --name "<assignment-name>" \
  --display-name "<Display Name>" \
  --scope /subscriptions/<subscription-id> \
  --policy "<policy-definition-id>"

# Check compliance
az policy state list --subscription "<subscription-id>" \
  --filter "complianceState eq 'NonCompliant'" --output table
```

## Additional Resources
- [Azure Policy overview](https://learn.microsoft.com/azure/governance/policy/overview)
- [Built-in policy definitions](https://learn.microsoft.com/azure/governance/policy/samples/built-in-policies)
