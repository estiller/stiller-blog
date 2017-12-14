[CmdletBinding()]
Param(
    [string]$resourceGroupName = 'StillerBlog',
    [string]$location = 'westeurope'
)

$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -Location $location -ErrorAction SilentlyContinue
if (!$resourceGroup)
{
    $resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
}

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
    -TemplateFile './azuredeploy.json' -TemplateParameterFile './azuredeploy.parameters.json'