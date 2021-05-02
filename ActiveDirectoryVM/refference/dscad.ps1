$resourceGroup = "myResourceGroupAD"
$vmName = 'SimpleWinVM'
$storageName = 'w2cuaf2uvxim6sawinvm'
#Publish the configuration script to user storage
Publish-AzVMDscConfiguration -ConfigurationPath .\primary.ps1 -ResourceGroupName $resourceGroup -StorageAccountName $storageName -force
#Set the VM to run the DSC configuration
Set-AzVMDscExtension -Version '2.7' -ResourceGroupName $resourceGroup -VMName $vmName -ArchiveStorageAccountName $storageName -ArchiveBlobName 'primary.ps1.zip' -AutoUpdate -ConfigurationName 'CreateForest'