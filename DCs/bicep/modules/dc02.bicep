// DC02 — NIC + Data Disk + VM (Windows Server 2025, TrustedLaunch)
// + CustomScriptExtension that runs setup-dc02.ps1 server-side.
//
// setup-dc02.ps1 phase 0: disk init + ADDS install + poll for DC01 DNS + domain join.
// setup-dc02.ps1 phase 1 (via scheduled task after reboot): promote as replica DC.
// Polling inside the script means DC02 waits for DC01 regardless of ARM timing.

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

// ── Data Disk for NTDS/SYSVOL ─────────────────────────────────────────────────

resource dataDisk 'Microsoft.Compute/disks@2024-03-02' = {
  name: diskName
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 32
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
      // Attach the separate data disk created above (allows proper tagging)
      dataDisks: [
        {
          lun: 0
          createOption: 'Attach'
          caching: 'None'
          managedDisk: {
            id: dataDisk.id
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

// ── CustomScriptExtension — setup-dc02.ps1 ────────────────────────────────────

resource extension 'Microsoft.Compute/virtualMachines/extensions@2024-07-01' = {
  parent: vm
  name: 'SetupDC02'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        '${scriptsBaseUrl}/setup-dc02.ps1'
      ]
    }
    protectedSettings: {
      commandToExecute: 'powershell.exe -ExecutionPolicy Bypass -File setup-dc02.ps1 -DomainName "${domainName}" -AdminPassword "${adminPassword}" -PrimaryAdmin "${primaryAdmin}"'
    }
  }
}
