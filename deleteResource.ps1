$bicepFile=".\main.bicep"
$paramfile=".\main.parameters.json"
$myrg="myResourceGroupDev"

#delete resource group
az group delete --name $myrg


