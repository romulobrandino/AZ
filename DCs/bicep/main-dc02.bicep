// ============================================================
// PHASE 2: DEPLOY DC02 ONLY
// ============================================================
// This template deploys:
//   - DC02 VM with CustomScriptExtension
// Prerequisites:
//   - DC01 must be operational as domain controller
//   - VNet DNS must point to DC01 (10.111.1.10)
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

@description('Resource group containing the VNet')
param networkResourceGroup string = 'rg-connectivity-cus-alz-demo'

@description('Virtual network name')
param vnetName string = 'vnet-sharedservices-cus-demo-alz'

@description('Subnet name for domain controllers')
param subnetName string = 'snet-DCs-shared-cus'

@description('DC02 VM name')
param vm2Name string = 'vm-DC02-cus'

@description('Static private IP for DC02')
param dc02StaticIP string = '10.111.1.11'

@description('Active Directory domain FQDN')
param domainName string = 'corp.cloudthings-app.com'

@description('Primary domain admin username')
param primaryAdmin string = 'romulosilva'

@description('GitHub account for script repository')
param githubAccount string = 'romulobrandino'

@description('GitHub branch for script repository')
param githubBranch string = 'master'

@description('GitHub repository name')
param githubRepo string = 'AZ'

@description('Resource tags applied to all resources')
param resourceTags object = {
  Contact: 'romulosilva@microsoft.com'
  Dept: 'Sales'
  Division: 'InfraCore'
  Environment: 'Demo'
  Application: 'ActiveDirectory'
  Purpose: 'Demo'
  NoAutoShutdown: 'true'
}

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

// ── DC02 — NIC + VM + data disk + setup extension ─────────────────────────────

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
}

// ── Outputs ───────────────────────────────────────────────────────────────────

output dc02Name string = vm2Name
output dc02IP string = dc02StaticIP
output domainFQDN string = domainName
