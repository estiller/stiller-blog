[CmdletBinding()]
Param(
    [string]$resourceGroupName = 'StillerBlog',
    [string]$location = 'westeurope',
    [string]$artifactsResourceGroupName = 'StillerBlogDeployment',
    [string]$artifactsStorageAccountName = 'stillerblogdeployment'
)

$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -Location $location -ErrorAction SilentlyContinue
if (!$resourceGroup)
{
    $resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
}

$artifactsStorageAccount = Get-AzureRmStorageAccount -ResourceGroupName $artifactsResourceGroupName -Name $artifactsStorageAccountName -ErrorAction SilentlyContinue
if (!$artifactsStorageAccount)
{
    $artifactsStorageAccount = New-AzureRmStorageAccount -ResourceGroupName $artifactsResourceGroupName -Name $artifactsStorageAccountName -SkuName Standard_LRS -Location $location -Kind Storage -ErrorAction Stop
}
$artifactsStorageAccountKey = Get-AzureRmStorageAccountKey -ResourceGroupName $artifactsResourceGroupName -Name $artifactsStorageAccountName

$storageContext = New-AzureStorageContext -StorageAccountName $artifactsStorageAccountName -StorageAccountKey $artifactsStorageAccountKey[0].Value

$containerName = 'artifacts'
New-AzureStorageContainer -Name $containerName -Permission Off -Context $storageContext -ErrorAction SilentlyContinue

$scriptName = 'install-azurefile-dockervolumedriver.sh'
Set-AzureStorageBlobContent -File "../artifacts/$scriptName" -Container $containerName -Blob $scriptName -Context $storageContext -Force
$scriptSasUri = New-AzureStorageBlobSASToken -Container $containerName -Blob $scriptName -Context $storageContext -Permission "r" -FullUri

$composeName = 'docker-compose.yml'
Set-AzureStorageBlobContent -File "../artifacts/$composeName" -Container $containerName -Blob $composeName -Context $storageContext -Force
$composeSasUri = New-AzureStorageBlobSASToken -Container $containerName -Blob $composeName -Context $storageContext -Permission "r" -FullUri

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
    -TemplateFile './azuredeploy.json' -TemplateParameterFile './azuredeploy.parameters.json' -dockerVolumeInstallScriptUri $scriptSasUri -dockerComposeFileUri $composeSasUri