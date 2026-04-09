// DC01 — NIC + VM (Windows Server 2025, TrustedLaunch) + 32 GB data disk inline
// + CustomScriptExtension that runs setup-dc01.ps1 server-side.
//
// setup-dc01.ps1 phase 0 (runs during extension): disk init + ADDS install + forest promotion.
// setup-dc01.ps1 phase 1 (runs via scheduled task after reboot): UPN suffix + OUs + admin user.
// ARM considers the extension complete when phase 0 exits, so the dc02 module
// starts while DC01 is rebooting. setup-dc02.ps1 polls DC01 DNS before joining.

param vmName string
param staticIP string
param subnetId string

@secure()
param adminPassword string

param location string
param domainName string
param primaryAdmin string

@description('Base URL for scripts (GitHub raw URL)')
param scriptsBaseUrl string

param tags object = {}

var nicName = '${vmName}-nic'
var diskName = '${vmName}-datadisk-adds'
var osDiskName = '${vmName}-osdisk'

// ── NIC ───────────────────────────────────────────────────────────────────────

resource nic 'Microsoft.Network/networkInterfaces@2024-05-01' = {
  name: nicName
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: { id: subnetId }
          privateIPAllocationMethod: 'Static'
          privateIPAddress: staticIP
        }
      }
    ]
  }
}

// ── VM ────────────────────────────────────────────────────────────────────────

resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: vmName
  location: location
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2as_v5'
    }
    storageProfile: {
      osDisk: {
        name: osDiskName
        caching: 'ReadWrite'
        createOption: 'FromImage'
        diskSizeGB: 127
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-azure-edition'
        version: 'latest'
      }
      // 32 GB data disk for NTDS / SYSVOL — avoids separate disk create + attach steps
      dataDisks: [
        {
          name: diskName
          lun: 0
          createOption: 'Empty'
          diskSizeGB: 32
          caching: 'None'
          managedDisk: {
            storageAccountType: 'Standard_LRS'
          }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        { id: nic.id }
      ]
    }
    osProfile: {
      computerName: vmName
      adminUsername: 'azureuser'
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: false
        patchSettings: {
          patchMode: 'AutomaticByPlatform'
        }
      }
    }
    securityProfile: {
      securityType: 'TrustedLaunch'
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
    }
    licenseType: 'Windows_Server'
  }
}

// ── CustomScriptExtension — setup-dc01.ps1 ────────────────────────────────────
// protectedSettings keeps the SAS token and password out of ARM deployment history.

resource extension 'Microsoft.Compute/virtualMachines/extensions@2024-07-01' = {
  parent: vm
  name: 'SetupDC01'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        '${scriptsBaseUrl}/setup-dc01.ps1'
      ]
    }
    protectedSettings: {
      commandToExecute: 'powershell.exe -ExecutionPolicy Bypass -File setup-dc01.ps1 -DomainName "${domainName}" -AdminPassword "${adminPassword}" -PrimaryAdmin "${primaryAdmin}"'
    }
  }
}
