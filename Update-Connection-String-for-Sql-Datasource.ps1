cls

$workspaceName = "Wingtip Sales"
$importName = "Wingtip Sales"

# add credentials for SQL datasource
$sqlDatabaseServer = "cpt.database.windows.net"
$sqlDatabaseName = "WingtipSalesDb"

# get object for target workspace
$workspace = Get-PowerBIWorkspace -Name $workspaceName

# get object for new dataset
$dataset = Get-PowerBIDataset -WorkspaceId $workspace.Id | Where-Object Name -eq $importName

# get object for new SQL datasource
$datasource = Get-PowerBIDatasource -WorkspaceId $workspace.Id -DatasetId $dataset.Id

# parse REST to determine gateway Id and datasource Id
$workspaceId = $workspace.Id
$datasetId = $dataset.Id
$datasourceUrl = "groups/$workspaceId/datasets/$datasetId/datasources"

# execute REST call to determine gateway Id and datasource Id
$datasourcesResult = Invoke-PowerBIRestMethod -Method Get -Url $datasourceUrl | ConvertFrom-Json

# parse REST URL used to patch datasource credentials
$datasource = $datasourcesResult.value[0]
$gatewayId = $datasource.gatewayId
$datasourceId = $datasource.datasourceId
$sqlDatabaseServerCurrent = $datasource.connectionDetails.server
$sqlDatabaseNameCurrent = $datasource.connectionDetails.database

$datasourePatchUrl = "groups/$workspaceId/datasets/$datasetId/Default.UpdateDatasources"


# create HTTP request body to patch datasource credentials
$patchBody = @{
  "updateDetails" = @(
   @{
    "connectionDetails" = @{
      "server" = "$sqlDatabaseServer"
      "database" = "$sqlDatabaseName"
    }
    "datasourceSelector" = @{
      "datasourceType" = "Sql"
      "connectionDetails" = @{
        "server" = "$sqlDatabaseServerCurrent"
        "database" = "$sqlDatabaseNameCurrent"
      }
      "gatewayId" = "$gatewayId"
      "datasourceId" = "$datasourceId"
    }
  })
}

# convert body contents to JSON
$patchBodyJson = ConvertTo-Json -InputObject $patchBody -Depth 6 -Compress

# execute PATCH request to set datasource credentials
Invoke-PowerBIRestMethod -Method Post -Url $datasourePatchUrl -Body $patchBodyJson

# parse REST URL for dataset refresh
$datasetRefreshUrl = "groups/$workspaceId/datasets/$datasetId/refreshes"

# execute POST to begin dataset refresh
Invoke-PowerBIRestMethod -Method Post -Url $datasetRefreshUrl -WarningAction Ignore

