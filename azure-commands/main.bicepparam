using './main.bicep'

param location = 'eastus'
param aiServices = 'foundry'
param modelName = 'gpt-4.1'
param modelFormat = 'OpenAI'
param modelVersion = '2025-04-14'
param modelSkuName = 'GlobalStandard'
param modelCapacity = 30
param firstProjectName = 'project'
param projectDescription = 'A project for the AI Foundry account with network secured deployed Agent'
param displayName = 'project'
param peSubnetName = 'pe-subnet'

// ──────────────────────────────────────────────────────────────────────────────
// SPLIT-SUBSCRIPTION EXAMPLE
// ──────────────────────────────────────────────────────────────────────────────
// Subscription 1 (AI Services)  – deploy this template into subscription_1 / RG "XYZ".
//   The Foundry account, project, Cosmos DB, AI Search and Storage are created here.
//
// Subscription 2 (Networking)   – hosts the existing VNet, subnets, private endpoints
//   and (optionally) private DNS zones.
//
// To use this layout, fill in the parameters below:
//   1. existingVnetResourceId          → full ARM ID of the VNet in subscription_2
//   2. agentSubnetName / peSubnetName  → names of the subnets inside that VNet
//   3. dnsZonesSubscriptionId          → subscription_2 ID (if DNS zones live there)
//   4. dnsZonesResourceGroup           → resource group in subscription_2 that holds DNS zones
//   5. existingDnsZones                → per-zone RG overrides (or leave empty to use dnsZonesResourceGroup)
//
// Example values (replace placeholders with real IDs):
//   param existingVnetResourceId = '/subscriptions/<subscription_2>/resourceGroups/<networking-rg>/providers/Microsoft.Network/virtualNetworks/<vnet-name>'
//   param dnsZonesSubscriptionId = '<subscription_2>'
//   param dnsZonesResourceGroup  = '<networking-rg>'
// ──────────────────────────────────────────────────────────────────────────────

// Resource IDs for existing resources
// If you provide these, the deployment will use the existing resources instead of creating new ones
// Example: '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/virtualNetworks/<vnet-name>'
param existingVnetResourceId = '/subscriptions/c278129e-f84c-4eeb-8830-00b1e96166c6/resourceGroups/rg-connectivity-cus-alz-demo/providers/Microsoft.Network/virtualNetworks/vnet-aiservices-cea-demo-alz'
param vnetName = 'vnet-aiservices-cea-demo-alz'
param agentSubnetName = 'agent-subnet'
param aiSearchResourceId = ''
param azureStorageAccountResourceId = ''
param azureCosmosDBAccountResourceId = ''

// Subscription ID where the VNet and DNS zones are located (leave empty to use deployment subscription)
// ⚠️ If set to a different subscription, ALL zones below MUST have resource groups specified
param dnsZonesSubscriptionId = 'c278129e-f84c-4eeb-8830-00b1e96166c6'
param dnsZonesResourceGroup = 'rg-connectivity-cus-alz-demo'

// DNS zone map: provide resource group name to use existing zone, or leave empty to create new
// Note: Empty values only allowed when dnsZonesSubscriptionId is empty or matches current subscription
param existingDnsZones = {
  'privatelink.services.ai.azure.com': ''
  'privatelink.openai.azure.com': ''
  'privatelink.cognitiveservices.azure.com': ''               
  'privatelink.search.windows.net': ''           
  'privatelink.blob.core.windows.net': ''                            
  'privatelink.documents.azure.com': ''
  'privatelink.file.core.windows.net': ''                       
}

//DNSZones names for validating if they exist
param dnsZoneNames = [
  'privatelink.services.ai.azure.com'
  'privatelink.openai.azure.com'
  'privatelink.cognitiveservices.azure.com'
  'privatelink.search.windows.net'
  'privatelink.blob.core.windows.net'
  'privatelink.documents.azure.com'
  'privatelink.file.core.windows.net'
]

// Network configuration (behavior depends on `existingVnetResourceId`)
//
// - NEW VNet (existingVnetResourceId is empty):
//     The values below are used to CREATE the VNet and the two subnets.
//     Provide explicit, non-overlapping CIDR ranges when creating a new VNet.
//
// - EXISTING VNet (existingVnetResourceId is provided):
//     The module will reference the existing VNet. Subnet handling depends on the
//     values you provide:
//       * If `agentSubnetPrefix` or `peSubnetPrefix` are empty, the module may
//         auto-derive subnet CIDRs from the existing VNet's address space
//         (using cidrSubnet). This can produce /24 (or configured) subnets
//         starting at index 0, 1, etc.
//       * If you provide explicit subnet prefixes, the module will attempt to
//         create or update subnets with those prefixes in the existing VNet.
//
// Important operational notes and risks (when existingVnetResourceId is provided):
// - Avoid CIDR overlaps with any existing subnets in the target VNet. Overlap
//   leads to `NetcfgSubnetRangesOverlap` and failed deployments.
// - For highest safety when using an existing VNet, supply the existing `agentSubnetPrefix` and `peSubnetPrefix`. 
param vnetAddressPrefix = '10.100.4.0/23'
param agentSubnetPrefix = '10.100.4.0/24'
param peSubnetPrefix = '10.100.5.0/24'

