param adminUserName string

param adminPassword string = concat('P', uniqueString(resourceGroup().id, adminUserName), 'x', '!')
param dnsLabelPrefix string

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

@description('Size of the virtual machine.')
param vmSize string = 'Standard_B2s'

@description('location for all resources')
param location string = resourceGroup().location

var vmName = 'SimpleWinVM'

var virtualNetworkName = 'MyVNET'

module VN './vnet.bicep' = {
  name: virtualNetworkName
  params: {
    virtualNetworkName: virtualNetworkName
    location: location
  }
}
var subnetName = 'Subnet'
var subnetRef = '${VN.outputs.result}/subnets/${subnetName}'

module VM './vm.bicep' = {
  name: 'vm1'
  params: {
    dnsLabelPrefix: dnsLabelPrefix
    adminUserName: adminUserName
    adminPassword: adminPassword
    subnetRef: subnetRef
    vmSize: vmSize
  }
}

output hostname string = VM.outputs.hostname
output username string = VM.outputs.username
output password string = adminPassword


