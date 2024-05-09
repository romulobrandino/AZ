# Azure VWAN Lab

## Connect Azure Subscription
```PowerShell
Connect-AzAccount
```

## Get all subscriptions in all tenants
```PowerShell
Get-AzSubscription
```

## Get all subscriptions for a specific tenant
```PowerShell
Get-AzSubscription -TenantId "aaaa-aaaa-aaaa-aaaa"
```

## Get all subscriptions in the current tenant
```PowerShell
Get-AzSubscription -TenantId (Get-AzContext).Tenant
```

## Change the current context to use a specific subscription
```PowerShell
Get-AzSubscription -SubscriptionId "xxxx-xxxx-xxxx-xxxx" -TenantId "yyyy-yyyy-yyyy-yyyy" | Set-AzContext
Get-AzSubscription -Subscription 'Subscription-name'
```

## Change the active subscription
```PowerShell
Set-AzContext -Subscription <subscription name or id>
Set-AzContext -Subscription "xxxx-xxxx-xxxx-xxxx"
Set-AzContext -Subscription "subscription name"
```

#get all subscriptions in the current tenant that are authorized for the current user
```PowerShell
Get-AzSubscription -TenantId (Get-AzContext).Tenant
```
#get the specified subscription, and then sets the current context to use it.
```PowerShell
Get-AzSubscription -SubscriptionId "xxxx-xxxx-xxxx-xxxx" -TenantId "yyyy-yyyy-yyyy-yyyy" | Set-AzContext
```
