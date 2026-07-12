// Creates the NSG with all Active Directory required port rules.
// Subnet association is handled by deploy.ps1 via
//   az network vnet subnet update --network-security-group
// to avoid overwriting other subnet properties we don't own.

param nsgName string
param location string
param tags object = {}

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: nsgName
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'Allow-DNS'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '53'
          description: 'DNS resolution (TCP/UDP)'
        }
      }
      {
        name: 'Allow-Kerberos'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '88'
          description: 'Kerberos authentication (TCP/UDP)'
        }
      }
      {
        name: 'Allow-RPC'
        properties: {
          priority: 120
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '135'
          description: 'RPC endpoint mapper'
        }
      }
      {
        name: 'Allow-LDAP'
        properties: {
          priority: 130
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '389'
          description: 'LDAP directory queries (TCP/UDP)'
        }
      }
      {
        name: 'Allow-SMB'
        properties: {
          priority: 140
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '445'
          description: 'SMB/CIFS file sharing'
        }
      }
      {
        name: 'Allow-KerberosPwd'
        properties: {
          priority: 150
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '464'
          description: 'Kerberos password change (TCP/UDP)'
        }
      }
      {
        name: 'Allow-LDAPS'
        properties: {
          priority: 160
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '636'
          description: 'LDAP over SSL'
        }
      }
      {
        name: 'Allow-GC'
        properties: {
          priority: 170
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3268'
          description: 'Global Catalog LDAP'
        }
      }
      {
        name: 'Allow-GCSSL'
        properties: {
          priority: 180
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3269'
          description: 'Global Catalog LDAP over SSL'
        }
      }
      {
        name: 'Allow-RDP'
        properties: {
          priority: 190
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
          description: 'Remote Desktop for management'
        }
      }
      {
        name: 'Allow-DynamicRPC'
        properties: {
          priority: 200
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '49152-65535'
          description: 'Dynamic RPC range for AD replication'
        }
      }
    ]
  }
}

output nsgId string = nsg.id
output nsgName string = nsg.name
