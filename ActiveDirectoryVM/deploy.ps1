$bicepFile=".\main.bicep"
$paramfile=".\main.parameters.json"

$myrg="myResourceGroupAD"

az group create   --name $myrg   --location "Japan East"
az deployment group create   --name devenvironment   --resource-group $myrg   --template-file $bicepFile --parameters $paramfile --output json > main.output.json

$json = Get-Content .\main.output.json | ConvertFrom-json

$hostname=$json.properties.outputs.hostname.value
$User=$json.properties.outputs.username.value
$password=$json.properties.outputs.password.value

az vm restart --name "SimpleWinVM" --resource-group $myrg 

#connect VM
cmdkey /generic:TERMSRV/$hostname /user:contoso\$User /pass:$password
mstsc /v:$hostname
#cmdkey /delete:TERMSRV/$hostname

