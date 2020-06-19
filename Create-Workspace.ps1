Connect-PowerBIServiceAccount

$workspaceName = "Demo Workspace 1"

# get target workspace
$workspace = Get-PowerBIWorkspace -Name $workspaceName

if($workspace){
    Write-Host "Found existing workspace"
}
else {
    Write-Host "Createing new workspace"
    $workspace = New-PowerBIGroup -Name $workspaceName
}

$workspace | select *