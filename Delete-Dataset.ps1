
$workspaceName = "Wingtip Sales"
$datasetName = "Northwind"

# get object for target workspace
$workspace = Get-PowerBIWorkspace -Name $workspaceName

# get object for new dataset
$dataset = Get-PowerBIDataset -WorkspaceId $workspace.Id | Where-Object Name -eq $datasetName

$workspaceId = $workspace.Id
$datasetId = $dataset.Id

$restUrl = "groups/$workspaceId/datasets/$datasetId"

Invoke-PowerBIRestMethod -Method Delete -Url $restUrl


