$currentDir = Split-Path $MyInvocation.MyCommand.path
Set-Location $currentDir

$bicepFile=".\main.bicep"
$paramfile=".\main.parameters.json"
$myrg="proxy"

#az group create   --name $myrg   --location "Japan East"
az group create   --name $myrg   --location "East US"

az deployment group create   --name devenvironment   --resource-group $myrg   --template-file $bicepFile --parameters $paramfile --output json > main.output.json
#az deployment group create   --name devenvironment   --resource-group $myrg   --template-file $bicepFile --parameters $paramfile --verbose
$json = Get-Content .\main.output.json | ConvertFrom-json

$hostname=$json.properties.outputs.hostname.value
$User=$json.properties.outputs.username.value
$password=$json.properties.outputs.password.value

#az vm user update --name "SimpleWinVM" --resource-group $myrg --username $User --password $password

#connect VM
cmdkey /generic:TERMSRV/$hostname /user:$User /pass:$password
mstsc /v:$hostname
#cmdkey /delete:TERMSRV/$hostname

