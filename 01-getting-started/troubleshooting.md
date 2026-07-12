# Troubleshooting: Common First-Time Setup Errors

Common errors encountered during first-time tenant/subscription setup (sign-in,
subscription selection, resource provider registration), and how to fix them.

> Part of the [Getting Started: Tenant & Subscription First-Time Setup](README.md) guide.

| Error | Cause | Fix |
|---|---|---|
| `MissingSubscriptionRegistration` | The resource provider (RP) for the resource type you're deploying isn't registered in the subscription | Register the provider — see [register-resource-providers.md](register-resource-providers.md) |
| `AuthorizationFailed` | Your account/service principal is missing the RBAC role needed for the operation | Assign yourself (or the identity) the `Owner` or `Contributor` role on the subscription/resource group |
| `InvalidSubscriptionId` / commands running against the wrong subscription | Active context is pointing at a different subscription/tenant than expected | PowerShell: `Set-AzContext -Subscription "<subscription-id-or-name>"` · CLI: `az account set --subscription "<subscription-id-or-name>"` |
| `Connect-AzAccount` / `az login` hangs or won't open a browser | MFA prompt or no default browser available (e.g. remote session, server core, WSL) | PowerShell: `Connect-AzAccount -UseDeviceAuthentication` · CLI: `az login --use-device-code` |
| `AADSTS...` sign-in errors (various codes) | Conditional Access policy, blocked app, or expired credentials | Check the specific `AADSTS` code against [Entra ID error codes](https://learn.microsoft.com/entra/identity-platform/reference-error-codes), or ask your tenant admin |
| `SubscriptionNotFound` | Typo in the subscription ID/name, or the account doesn't have access to it | Confirm with `Get-AzSubscription` / `az account list --output table` |

## Additional Resources
- [Register Azure Resource Providers](register-resource-providers.md)
- [Common Azure errors and resolutions](https://learn.microsoft.com/azure/azure-resource-manager/troubleshooting/error-register-resource-provider)
- [Microsoft Entra ID error codes](https://learn.microsoft.com/entra/identity-platform/reference-error-codes)
