cls
# log into Azure AD
$userName = "tedp@mstdev2020.onMicrosoft.com"
$password = "Pa`$`$word!"

$securePassword = ConvertTo-SecureString –String $password –AsPlainText -Force
$credential = New-Object –TypeName System.Management.Automation.PSCredential `
                         –ArgumentList $userName, $securePassword

$workspaceName = "Wingtip Sales"
$importName = "Northwind"
$pbixFilePath = "C:\DevProjects\Northwind.pbix"

#Connect-PowerBIServiceAccount -Environment Public -Credential $credential


# get target workspace
$workspace = Get-PowerBIWorkspace -Name $workspaceName

if($workspace){
    Write-Host "Found existing workspace"
}
else {
    Write-Host "Createing new workspace"
    $workspace = New-PowerBIGroup -Name $workspaceName
}

$import = New-PowerBIReport -Path $pbixFilePath -Name $importName -Workspace $workspace -ConflictAction CreateOrOverwrite

Write-Host "PBIX file has been published"
$import | Format-List Name, WebUrl

$dataset = Get-PowerBIDataset -Workspace $workspace | Where-Object Name -eq $importName

$datasource = Get-PowerBIDatasource -WorkspaceId $workspace.Id -DatasetId $dataset.Id -Scope Individual

$workspaceId = $workspace.Id
$datasetId = $dataset.Id
$datasourceUrl = "groups/$workspaceId/datasets/$datasetId/datasources"

$datasourcesResult = Invoke-PowerBIRestMethod -Method Get -Url $datasourceUrl | ConvertFrom-Json

$datasource = $datasourcesResult.value[0]
$gatewayId = $datasource.gatewayId
$datasourceId = $datasource.datasourceId

$datasourePatchUrl = "gateways/$gatewayId/datasources/$datasourceId"

$patchBody = @{
  "credentialDetails" = @{
    "credentials" = "{""credentialData"":[]}"
    "credentialType" = "Anonymous"
    "encryptedConnection" =  "NotEncrypted"
    "encryptionAlgorithm" = "None"
    "privacyLevel" = "None"
  }
}

$patchBodyJson = ConvertTo-Json -InputObject $patchBody -Depth 4 -Compress

Invoke-PowerBIRestMethod -Method Patch -Url $datasourePatchUrl -Body $patchBodyJson

