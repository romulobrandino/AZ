// ============================================================
// BICEP PARAMETERS FILE
// ============================================================
// Parameter values for main.bicep deployment.
// Usage:
//   az deployment group create \
//     --resource-group <your-compute-rg> \
//     --template-file main.bicep \
//     --parameters main.bicepparam
//
// Or combine with a personal parameters file:
//   --parameters main.bicepparam \
//   --parameters personal-project.bicepparam
//
// Scripts are downloaded from your public GitHub repository.
// ============================================================

using 'main.bicep'

// ── Subscription Configuration ────────────────────────────────────────────────

param subscriptionId = '<your-subscription-id>'  // Azure subscription ID (defaults to current subscription if not specified)

// ── Secrets (override at deployment time or use Key Vault reference) ─────────
// If not using getSecret(), provide via CLI:
//   --parameters adminPassword=$adminPwd

param adminPassword = ''  // Retrieved from Azure Key Vault or passed at deployment time

// ── Script Repository Configuration ───────────────────────────────────────────

param githubAccount = '<your-github-username>'     // Example: 'myusername'
param githubRepo = '<your-repo-name>'              // Example: 'azure-templates'
param githubBranch = 'main'                       // Example: 'main', 'develop'

// ── Network Configuration ─────────────────────────────────────────────────────

param networkResourceGroup = '<your-network-rg>'  // Example: 'rg-connectivity-eastus'
param vnetName = '<your-vnet-name>'                // Example: 'vnet-hub-eastus'
param subnetName = '<your-dc-subnet-name>'         // Example: 'snet-domaincontrollers'
param nsgName = '<your-nsg-name>'                  // Example: 'nsg-domaincontrollers'

// ── VM Configuration ──────────────────────────────────────────────────────────

param vm1Name = '<your-dc01-name>'       // Example: 'vm-DC01'
param vm2Name = '<your-dc02-name>'       // Example: 'vm-DC02'
param dc01StaticIP = '<your-dc01-ip>'    // Example: '10.0.1.10'
param dc02StaticIP = '<your-dc02-ip>'    // Example: '10.0.1.11'

// ── Active Directory Configuration ────────────────────────────────────────────

param domainName = '<your-domain-fqdn>'      // Example: 'corp.contoso.com'
param primaryAdmin = '<your-admin-username>' // Example: 'adminuser'

// ── Resource Configuration ────────────────────────────────────────────────────

param location = '<your-azure-region>'  // Example: 'eastus', 'westus2', 'centralus'

param resourceTags = {
  Environment: 'Production'          // Example: 'Production', 'Development', 'Test'
  Application: 'ActiveDirectory'
  Owner: '<your-email>'              // Example: 'admin@contoso.com'
  CostCenter: '<your-cost-center>'   // Example: 'IT-Infrastructure'
}
