# Azure CLI commands

List account --output could be in Json, Yaml, table...

```Bash
az account list --output table
az account list --output yaml
```

Change the default account

```Bash
az account set --subscription <Your_account>
```
Example:
```Bash
az account set --subscription "My Demos"
```
**Create VM**
1. Linux Ubuntu
```Bash
az vm create --subscription "My Demos" --resource-group v-romubr --name NewVM --image Ubuntu
```
2. Windows Server 2016
```Bash
az vm create \
    --resource-group v-romubr \
    --name myVM \
    --image win2016datacenter \
    --admin-username azureuser
```

[Reference](https://docs.microsoft.com/en-us/cli/azure/manage-azure-subscriptions-azure-cli?view=azure-cli-latest)


# Change Account in PowerShell

1. Get a list of all subscription names in your account with the command:
```PowerShell
Get-AzSubscription
```

2. Change the subscription by passing the name of the one to select.
```PowerShell
Select-AzSubscription -Subscription "Visual Studio Enterprise"
```
## Get-AzResourceGroup

You can retrieve a list of all Resource Groups in the active subscription:
```PowerShell
Get-AzResourceGroup
```
To get a more concise view, you can send the output from the Get-AzResourceGroup to the Format-Table cmdlet using a pipe '|'.
```PowerShell
Get-AzResourceGroup | Format-Table
```
