#vm stop and deallocate
az vm stop --name "SimpleWinVM" --resource-group $myrg 
az vm deallocate  --name "SimpleWinVM" --resource-group $myrg 