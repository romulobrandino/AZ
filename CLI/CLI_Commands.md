# Azure cli commands

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
