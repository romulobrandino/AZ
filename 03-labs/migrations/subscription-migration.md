# Azure Subscription Migration Guide

A comprehensive guide for migrating Azure subscription configurations using Infrastructure as Code (IaC) approaches.

## Overview

This guide covers best practices and recommended tools for migrating Azure resources between subscriptions, whether you're consolidating subscriptions, changing billing models, or rebuilding infrastructure in a new subscription.

---

## Infrastructure as Code (IaC) Migration Approaches

### Option 1 — `aztfexport` (Terraform Export) ⭐ **Recommended**

**Best for**: Full infrastructure-as-code capture + clean redeploy

#### Installation & Usage

**Windows:**
```powershell
# Install aztfexport using winget
winget install Microsoft.Aztfexport

# Export entire subscription
az login
az account set --subscription <source-subscription-id>
aztfexport subscription --subscription-id <source-subscription-id>

# Review and edit the generated Terraform files
# Update provider block and resource IDs as needed

# Then target the new subscription and apply
az account set --subscription <target-subscription-id>
terraform init && terraform apply
```

**Linux/Mac:**
```bash
# Install aztfexport using Homebrew
brew install aztfexport

# Or install using Go
go install github.com/Azure/aztfexport@latest

# Or download binary directly
curl -Lo aztfexport.zip https://github.com/Azure/aztfexport/releases/latest/download/aztfexport_linux_amd64.zip
unzip aztfexport.zip
chmod +x aztfexport
sudo mv aztfexport /usr/local/bin/

# Export entire subscription
az login
az account set --subscription <source-subscription-id>
aztfexport subscription --subscription-id <source-subscription-id>

# Review and edit the generated Terraform files
# Update provider block and resource IDs as needed

# Then target the new subscription and apply
az account set --subscription <target-subscription-id>
terraform init && terraform apply
```

#### Pros
- ✅ Captures everything — Resource Groups, networking, VMs, storage, RBAC, policies
- ✅ Produces clean Terraform you can version control and diff
- ✅ Enables repeatable deployments
- ✅ Full state management capabilities

#### Considerations
- ⚠️ Requires review of `provider` block and resource IDs before applying
- ⚠️ Some resource-specific configurations may need manual adjustment
- ⚠️ Large subscriptions may take significant time to export

#### What to Review Before Applying

After exporting with `aztfexport`, you must review and update subscription-specific references:

**1. Provider Block**

The exported provider configuration will reference your source subscription:

```hcl
provider "azurerm" {
  features {}
  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  # OLD subscription
}
```

Update it to target your new subscription:

```hcl
provider "azurerm" {
  features {}
  subscription_id = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"  # NEW subscription
}
```

**2. Hardcoded Resource IDs**

Azure resource IDs embed the subscription ID. Look for patterns like:

```hcl
# ❌ Bad: Hardcoded subscription ID in resource reference
network_security_group_id = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-rg/providers/Microsoft.Network/networkSecurityGroups/my-nsg"

# ✅ Good: Use Terraform resource references instead
network_security_group_id = azurerm_network_security_group.my_nsg.id
```

**3. Data Source References**

```hcl
data "azurerm_client_config" "current" {
  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  # Update this!
}
```

**4. Pre-Apply Checklist**

**Windows/PowerShell:**
```powershell
# Search for old subscription ID in all Terraform files
Get-ChildItem -Recurse -Filter "*.tf" | Select-String "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# Alternative: Search in current directory only
Select-String -Path *.tf -Pattern "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# Verify correct Azure context
az account show

# Run plan first to preview changes
terraform plan

# Review plan output carefully before applying
terraform apply
```

**Linux/Mac/Bash:**
```bash
# Search for old subscription ID in all Terraform files
grep -r "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" *.tf

# Alternative: More detailed search with line numbers
grep -rn "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" .

# Find and replace old subscription ID with new one (use with caution!)
find . -name "*.tf" -type f -exec sed -i 's/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy/g' {} \;

# Verify correct Azure context
az account show

# Run plan first to preview changes
terraform plan

# Review plan output carefully before applying
terraform apply
```

**Why This Matters:**
- Without these updates, Terraform may target the wrong subscription
- Cross-resource references will fail if they point to non-existent resources
- You risk accidentally modifying resources in the source subscription

---

### Option 2 — ARM Template Export (Built-in Azure Portal/CLI)

**Best for**: Quick export of specific resource groups

#### Usage

```bash
# Export resource group to ARM template
az group export --name <rg-name> --subscription <source-subscription-id> > rg-template.json

# Review and edit the template as needed

# Redeploy to new subscription
az deployment group create \
  --subscription <target-subscription-id> \
  --resource-group <rg-name> \
  --template-file rg-template.json
```

#### Pros
- ✅ Native Azure tooling, no extra installations required
- ✅ Quick for resource group-level migrations
- ✅ Familiar to Azure administrators

#### Considerations
- ⚠️ Export is incomplete — some resource types don't export fully (VMs, managed disks, etc.)
- ⚠️ Doesn't capture subscription-level configuration (policies, RBAC assignments)
- ⚠️ May require significant manual editing

---

### Option 3 — Azure Resource Mover

**Best for**: Moving actual live resources (not just configuration) like VMs, NICs, disks

#### Usage

**Portal-based approach:**
1. Navigate to **Azure Resource Mover** in Azure Portal
2. Select source and target subscriptions
3. Choose resources to move
4. Validate dependencies
5. Execute the move

**Supported Resources:**
- Virtual Machines
- Network Interface Cards (NICs)
- Network Security Groups (NSGs)
- Load Balancers
- Public IPs
- Virtual Networks (VNets)
- Managed Disks

#### Pros
- ✅ Moves actual resources with their data intact
- ✅ Preserves resource configurations
- ✅ Guided portal experience

#### Considerations
- ⚠️ Limited resource type support — verify your resources are supported
- ⚠️ May require downtime for certain resources
- ⚠️ Check [supported resources documentation](https://learn.microsoft.com/azure/resource-mover/move-region-within-resource-group)

---

### Option 4 — Azure Bicep via Decompile

**Best for**: Teams preferring Bicep over Terraform for IaC

#### Usage

```bash
# Export ARM template first
az group export --name <rg-name> --subscription <source-subscription-id> > rg-template.json

# Decompile ARM template to Bicep
az bicep decompile --file rg-template.json

# Review and edit the generated .bicep file

# Deploy to new subscription
az deployment sub create \
  --template-file main.bicep \
  --location <azure-region> \
  --subscription <target-subscription-id>
```

#### Pros
- ✅ Native Azure IaC language
- ✅ Better syntax and readability than ARM JSON
- ✅ Strong integration with Azure tooling

#### Considerations
- ⚠️ Inherits ARM export limitations
- ⚠️ Decompilation may require manual cleanup

---

### Option 5 — PowerShell / Azure CLI Scripted Audit

**Best for**: Auditing what's in the old subscription before choosing a migration tool

#### Usage

```powershell
# Set context to source subscription
az account set --subscription <source-subscription-id>

# Inventory resources
az resource list --output table > inventory.txt

# Inventory RBAC assignments
az role assignment list --all --output table >> inventory.txt

# Inventory policy assignments
az policy assignment list --output table >> inventory.txt

# Inventory resource locks
az lock list --output table >> inventory.txt

# Export to JSON for detailed analysis
az resource list --output json > resources-detailed.json
```

#### Additional PowerShell Commands

```powershell
# Get all resource groups with tags
az group list --query "[].{name:name, location:location, tags:tags}" --output table

# Check for resources with specific tags
az resource list --tag Environment=Production --output table

# Export cost analysis
az consumption usage list --start-date 2026-06-01 --end-date 2026-06-30 --output json > cost-analysis.json
```

---

## Migration Approach Recommendation Matrix

| **Goal** | **Recommended Tool** | **Complexity** | **Time Investment** |
|----------|---------------------|----------------|---------------------|
| Full faithful rebuild with version control | `aztfexport` → Terraform | High | High |
| Quick resource group-level copy | ARM export/deploy | Medium | Low |
| Move live VMs/resources with data | Azure Resource Mover | Low-Medium | Low |
| IaC for Azure-native teams | Bicep decompile | Medium | Medium |
| Initial audit/inventory before migration | PowerShell/CLI scripted audit | Low | Very Low |

---

## General Migration Workflow

### Phase 1: Pre-Migration Assessment

1. **Inventory Current State**
   ```bash
   # Run the audit scripts (Option 5)
   az account set --subscription <source-subscription-id>
   az resource list --output json > resources.json
   az role assignment list --all --output json > rbac.json
   az policy assignment list --output json > policies.json
   ```

2. **Analyze Dependencies**
   - Map inter-resource dependencies
   - Document networking topology
   - Identify service endpoints and private endpoints
   - Review managed identities and their role assignments

3. **Document Configurations**
   - Subscription-level settings (policies, budgets, alerts)
   - RBAC assignments at subscription, resource group, and resource levels
   - Custom roles and policy definitions
   - Resource tags and naming conventions

### Phase 2: Choose Migration Strategy

Select the appropriate option based on:
- Resource types involved
- Need for version control
- Team's IaC expertise (Terraform vs. Bicep)
- Downtime tolerance
- Compliance requirements

### Phase 3: Execute Migration

1. **Prepare Target Subscription**
   - Apply subscription-level policies
   - Create required resource groups
   - Set up networking (VNets, NSGs, route tables)
   - Configure custom RBAC roles

2. **Export Infrastructure Code**
   - Use chosen tool (aztfexport, ARM export, etc.)
   - Review and validate generated code
   - Make necessary adjustments

3. **Deploy to Target**
   - Run validation/what-if deployment
   - Deploy in stages (networking → compute → data → apps)
   - Verify each stage before proceeding

4. **Restore Configurations**
   - Apply RBAC assignments
   - Restore tags
   - Configure monitoring and alerts
   - Update DNS records

### Phase 4: Post-Migration Validation

1. **Verify Resources**
   ```bash
   az account set --subscription <target-subscription-id>
   az resource list --output table
   ```

2. **Test Applications**
   - Connectivity tests
   - Application functionality
   - Performance validation

3. **Update Documentation**
   - Update runbooks and documentation
   - Record lessons learned
   - Archive migration artifacts

---

## Best Practices

### Security
- ✅ Never commit subscription IDs, credentials, or sensitive data to version control
- ✅ Use service principals with least-privilege for automation
- ✅ Review and validate RBAC assignments after migration
- ✅ Audit policy compliance in target subscription

### Testing
- ✅ Always test migration procedures in a dev/test environment first
- ✅ Use `terraform plan` or `az deployment what-if` before applying changes
- ✅ Maintain rollback procedures

### Version Control
- ✅ Store all IaC code in Git
- ✅ Use meaningful commit messages
- ✅ Tag releases for production deployments
- ✅ Use `.gitignore` to exclude sensitive files

### Documentation
- ✅ Maintain a migration log
- ✅ Document all manual steps
- ✅ Keep an inventory of resources and their purposes
- ✅ Record configuration decisions

---

## Common Challenges & Solutions

### Challenge: ARM Export Missing Properties
**Solution**: Manually add missing properties by referencing Azure Resource Manager reference docs

### Challenge: Resource Dependencies During Export
**Solution**: Use `aztfexport` resource mode to export resources in dependency order

### Challenge: RBAC Assignments Not Captured
**Solution**: Script RBAC export/import separately using Azure CLI

```bash
# Export RBAC
az role assignment list --subscription <source-sub> --output json > rbac-export.json

# Apply to target (requires custom script to parse JSON and recreate assignments)
```

### Challenge: Terraform State Management
**Solution**: Configure remote state backend (Azure Storage) before running `terraform apply`

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate"
    container_name       = "tfstate"
    key                  = "migration.tfstate"
  }
}
```

---

## Additional Resources

- [aztfexport GitHub Repository](https://github.com/Azure/aztfexport)
- [Azure Resource Mover Documentation](https://learn.microsoft.com/azure/resource-mover/)
- [Azure Bicep Documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Move Azure Resources](https://learn.microsoft.com/azure/azure-resource-manager/management/move-resource-group-and-subscription)

---

## Contributing

If you have suggestions or improvements for this migration guide, please submit a pull request or open an issue.

---

**Last Updated**: 2026-07-14