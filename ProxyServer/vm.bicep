param adminUserName string

@secure()
param adminPassword string

param dnsLabelPrefix string

@description('location for all resources')
param location string = resourceGroup().location

@description('Size of the virtual machine.')
param vmSize string = 'Standard_B2s'

var nicName = 'myVMNic'
var dnsname = concat(dnsLabelPrefix,uniqueString(resourceGroup().id))
var publicIPAddressName = 'myPublicIP'

param subnetRef string



@allowed([
  '2008-R2-SP1'
  '2012-Datacenter'
  '2012-R2-Datacenter'
  '2016-Nano-Server'
  '2016-Datacenter-with-Containers'
  '2016-Datacenter'
  '2019-Datacenter'
  '2019-datacenter-smalldisk-g2'
])
@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version.')
param windowsOSVersion string = '2019-datacenter-smalldisk-g2'

var vmName = 'SimpleWinVM'

resource pip 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: publicIPAddressName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: dnsname
    }
  }
}
resource nInter 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip.id
          }
          subnet: {
            id: subnetRef
          }
        }
      }
    ]
  }
}
var storageAccountName = concat(uniqueString(resourceGroup().id), 'sawinvm')
resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}
resource VM 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUserName
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: windowsOSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: [
        {
          diskSizeGB: 1023
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nInter.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: stg.properties.primaryEndpoints.blob
      }
    }
  }
}

output hostname string = pip.properties.dnsSettings.fqdn
output username string = VM.properties.osProfile.adminUsername
