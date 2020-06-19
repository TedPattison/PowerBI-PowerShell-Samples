Connect-PowerBIServiceAccount

$workspaces = Get-PowerBIWorkspace

foreach($workspace in $workspaces){
  $workspaceId = $workspace.Id
  $url = "groups/$workspaceId/"    
  Invoke-PowerBIRestMethod -Method Delete -Url $url
}

# check to ensure all workspaces have been deleted
Get-PowerBIWorkspace
