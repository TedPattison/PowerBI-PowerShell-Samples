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
$import | select Name, WebUrl

$dataset = Get-PowerBIDataset -Workspace $workspace | where Name -eq $importName


$datasource = Get-PowerBIDatasource -WorkspaceId $workspace.Id -DatasetId $dataset.Id

$datasource | select *