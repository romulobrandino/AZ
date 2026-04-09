# How to move resources

##  Using Azure CLI


1. Create a resource group.
```bash
az group create --name <destination resource group name> --location <location name>
```

2. Get the resource.
```bash
yourResource=$(az resource show --resource-group <resource group name> --name <resource name> --resource-type <resource type> --query id --output tsv)
```

3. Move the resource to another resource group by using the resource ID.
```bash
az resource move --destination-group <destination resource group name> --ids $yourResource
```

4. Return all the resources in your resource group to verify your resource moved.
```bash
az group show --name <destination resource group name>
```
5. Update the resource IDs in any tools and scripts that reference your resources.


## Move resources by using Azure PowerShell

1. Create a resource group.
```powershell
New-AzResourceGroup -Name <destination resource group name> -Location <location name>
```

2. Get the resource.
```powershell
$yourResource = Get-AzResource -ResourceGroupName <resource group name> -ResourceName <resource name>
```

3. Move the resource to another resource group by using the resource ID.
```powershell
Move-AzResource -DestinationResourceGroupName <destination resource group name> -ResourceId $yourResource.ResourceId
```

4. Return all the resources in your resource group to verify your resource moved.
```powershell
Get-AzResource -ResourceGroupName <destination resource group name> | ft
```

5. Update the resource IDs in any tools and scripts that reference your resources.
```powershell
```

Source: 
https://docs.microsoft.com/en-us/learn/modules/move-azure-resources-another-resource-group/6-move-verify-resources






