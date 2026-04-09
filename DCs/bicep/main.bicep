// ============================================================
// DEPLOY AZURE DOMAIN CONTROLLERS — BICEP VERSION
// ============================================================
// Equivalent to DCs-01.ps1 but uses VM Extensions so all AD
// setup runs server-side. The deployment survives a broken
// terminal — re-running `az deployment group create` is safe.
//
// deploy.ps1 handles:
//   • Key Vault password retrieval
//   • Script upload to staging blob storage
//   • NSG ↔ subnet association (partial update, safe)
//   • VNet DNS updates (before / midway / after)
//   • Calling this template
// ============================================================

targetScope = 'resourceGroup' // deploy to rg-compute-cus-alz-demo

// ── Parameters ────────────────────────────────────────────────────────────────

@description('Azure subscription ID (optional, defaults to current subscription).')
param subscriptionId string = subscription().subscriptionId

@description('Admin password for local admin and DSRM. Retrieve from Key Vault before deploying.')
@secure()
param adminPassword string

@description('Azure region for compute resources.')
param location string = resourceGroup().location

@description('Resource group containing the VNet and NSG.')
param networkResourceGroup string = 'rg-connectivity-cus-alz-demo'

@description('Virtual network name.')
param vnetName string = 'vnet-sharedservices-cus-demo-alz'

@description('Subnet name for domain controllers.')
param subnetName string = 'snet-DCs-shared-cus'

@description('DC01 VM name.')
param vm1Name string = 'vm-DC01-cus'

@description('DC02 VM name.')
param vm2Name string = 'vm-DC02-cus'

@description('Static private IP for DC01.')
param dc01StaticIP string = '10.111.1.10'

@description('Static private IP for DC02.')
param dc02StaticIP string = '10.111.1.11'

@description('NSG name for the DC subnet.')
param nsgName string = 'nsg-DCs-shared-cus'

@description('Active Directory domain FQDN.')
param domainName string = 'corp.cloudthings-app.com'

@description('Primary domain admin username to create.')
param primaryAdmin string = 'romulosilva'

@description('GitHub account for script repository')
param githubAccount string = 'romulobrandino'

@description('GitHub branch for script repository')
param githubBranch string = 'main'

@description('GitHub repository name')
param githubRepo string = 'AZ'

@description('Resource tags applied to all resources.')
param resourceTags object = {
  Contact: 'romulosilva@microsoft.com'
  Dept: 'Sales'
  Division: 'InfraCore'
  Environment: 'Demo'
  Application: 'ActiveDirectory'
  Purpose: 'Demo'
}

// ── Variables ─────────────────────────────────────────────────────────────────

var scriptsBaseUrl = 'https://raw.githubusercontent.com/${githubAccount}/${githubRepo}/${githubBranch}/dcs-auto/bicep/scripts'

// ── Existing subnet (cross-RG reference, used to get subnet ID) ────────────────

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: vnetName
  scope: resourceGroup(networkResourceGroup)
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' existing = {
  parent: vnet
  name: subnetName
}

// ── NSG (deployed to the network RG) ──────────────────────────────────────────

module nsgDeployment 'modules/nsg.bicep' = {
  name: 'nsgDeployment'
  scope: resourceGroup(networkResourceGroup)
  params: {
    nsgName: nsgName
    location: location
    tags: resourceTags
  }
}

// ── DC01 — NIC + VM + data disk + setup extension ─────────────────────────────

module dc01 'modules/dc01.bicep' = {
  name: 'dc01Deployment'
  params: {
    vmName: vm1Name
    staticIP: dc01StaticIP
    subnetId: subnet.id
    adminPassword: adminPassword
    location: location
    domainName: domainName
    primaryAdmin: primaryAdmin
    scriptsBaseUrl: scriptsBaseUrl
    scriptsSasToken: scriptsSasToken
    tags: resourceTags
  }
  dependsOn: [
    nsgDeployment   // wait for NSG to be created before NICs go online
  ]
}

// ── DC02 — NIC + VM + data disk + setup extension ─────────────────────────────
// Starts only after DC01's extension completes (phase 0: disk + ADDS + promote).
// The setup-dc02.ps1 script polls DC01's DNS internally before joining.

module dc02 'modules/dc02.bicep' = {
  name: 'dc02Deployment'
  params: {
    vmName: vm2Name
    staticIP: dc02StaticIP
    subnetId: subnet.id
    adminPassword: adminPassword
    location: location
    domainName: domainName
    primaryAdmin: primaryAdmin
    scriptsBaseUrl: scriptsBaseUrl
    tags: resourceTags
  }
  dependsOn: [
    dc01
  ]
}

// ── Outputs ───────────────────────────────────────────────────────────────────

output dc01Name string = vm1Name
output dc02Name string = vm2Name
output domainFQDN string = domainName
output primaryAdminUPN string = '${primaryAdmin}@${domainName}'
