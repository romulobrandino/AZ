// ============================================================
// PHASE 1: DEPLOY DC01 ONLY
// ============================================================
// This template deploys:
//   - NSG for domain controllers
//   - DC01 VM with CustomScriptExtension
// DC02 will be deployed separately after DC01 is ready
// ============================================================

targetScope = 'resourceGroup'

// ── Parameters ────────────────────────────────────────────────────────────────

@description('Azure subscription ID')
param subscriptionId string = subscription().subscriptionId

@description('Admin password for local admin and DSRM')
@secure()
param adminPassword string

@description('Azure region for compute resources')
param location string = resourceGroup().location

@description('Resource group containing the VNet and NSG')
param networkResourceGroup string = 'rg-connectivity-cus-alz-demo'

@description('Virtual network name')
param vnetName string = 'vnet-sharedservices-cus-demo-alz'

@description('Subnet name for domain controllers')
param subnetName string = 'snet-DCs-shared-cus'

@description('DC01 VM name')
param vm1Name string = 'vm-DC01-cus'

@description('Static private IP for DC01')
param dc01StaticIP string = '10.111.1.10'

@description('NSG name for the DC subnet')
param nsgName string = 'nsg-DCs-shared-cus'

@description('Active Directory domain FQDN')
param domainName string = 'corp.cloudthings-app.com'

@description('Primary domain admin username to create')
param primaryAdmin string = 'romulosilva'

@description('GitHub account for script repository')
param githubAccount string = 'romulobrandino'

@description('GitHub branch for script repository')
param githubBranch string = 'master'

@description('GitHub repository name')
param githubRepo string = 'AZ'

@description('Resource tags applied to all resources')
param resourceTags object = {}

// ── Variables ─────────────────────────────────────────────────────────────────

var scriptsBaseUrl = 'https://raw.githubusercontent.com/${githubAccount}/${githubRepo}/${githubBranch}/DCs/bicep/scripts'

// ── Existing subnet (cross-RG reference) ──────────────────────────────────────

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
    tags: resourceTags
  }
  dependsOn: [
    nsgDeployment
  ]
}

// ── Outputs ───────────────────────────────────────────────────────────────────

output dc01Name string = vm1Name
output dc01IP string = dc01StaticIP
output domainFQDN string = domainName
output primaryAdminUPN string = '${primaryAdmin}@${domainName}'
