# Create a Resource Group + Storage Account (PowerShell & Azure CLI)

Quick reference for creating a resource group in a chosen Azure region, then a
storage account with a globally-unique name in that same region.

> For the full resource group command reference (tagging, locking, moving
> resources), see [../governance/resource-groups.md](../governance/resource-groups.md).

## Naming rules for storage accounts
- 3–24 characters, **lowercase letters and numbers only** (no hyphens/underscores).
- Must be globally unique across **all** of Azure — not just your subscription.
- Pattern used below: `st<workload><random-suffix>`.

## PowerShell

```powershell
$rgName    = "<rg-name>"
$location  = "<location>"          # e.g. eastus, westeurope

# 1. Create the resource group
New-AzResourceGroup -Name $rgName -Location $location

# 2. Build a unique storage account name and check availability
$storageAccountName = ("st" + (Get-Random -Minimum 100000 -Maximum 999999))
Get-AzStorageAccountNameAvailability -Name $storageAccountName

# 3. Create the storage account in the same region as the resource group
New-AzStorageAccount `
  -ResourceGroupName $rgName `
  -Name $storageAccountName `
  -Location $location `
  -SkuName Standard_LRS `
  -Kind StorageV2

# 4. Confirm
Get-AzStorageAccount -ResourceGroupName $rgName -Name $storageAccountName | Format-Table StorageAccountName, Location, Sku.Name
```

## Azure CLI

```bash
rgName="<rg-name>"
location="<location>"              # e.g. eastus, westeurope

# 1. Create the resource group
az group create --name "$rgName" --location "$location"

# 2. Build a unique storage account name and check availability
storageAccountName="st$RANDOM$RANDOM"
az storage account check-name --name "$storageAccountName"

# 3. Create the storage account in the same region as the resource group
az storage account create \
  --name "$storageAccountName" \
  --resource-group "$rgName" \
  --location "$location" \
  --sku Standard_LRS \
  --kind StorageV2

# 4. Confirm
az storage account show --name "$storageAccountName" --resource-group "$rgName" --output table
```

## Notes
- `Standard_LRS` is the cheapest redundancy option for learning/dev; use
  `Standard_GRS`/`Standard_GZRS` for production workloads that need
  geo-redundancy (see [03-labs/storage/create-blob.azcli](../../03-labs/storage/create-blob.azcli)
  for a GZRS example with blob upload).
- Always create the storage account in the **same region** as the resource
  group/workload to avoid cross-region latency and egress costs.

## Additional Resources
- [Storage account overview](https://learn.microsoft.com/azure/storage/common/storage-account-overview)
- [Naming rules for Azure resources](https://learn.microsoft.com/azure/azure-resource-manager/management/resource-name-rules)
- [az storage account create](https://learn.microsoft.com/cli/azure/storage/account#az-storage-account-create)
- [New-AzStorageAccount](https://learn.microsoft.com/powershell/module/az.storage/new-azstorageaccount)
