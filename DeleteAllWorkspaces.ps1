cls
# log into Azure AD
$userName = "tedp@mstdev2020.onMicrosoft.com"
$password = "Pa`$`$word!"

$securePassword = ConvertTo-SecureString –String $password –AsPlainText -Force
$credential = New-Object –TypeName System.Management.Automation.PSCredential `
                         –ArgumentList $userName, $securePassword

$workspaceName = "Bluto"
$importName = "Northwind111"
$pbixFilePath = "C:\DevProjects\Northwind.pbix"

$conn = Connect-PowerBIServiceAccount -Environment Public -Credential $credential


$workspaces = Get-PowerBIWorkspace

foreach($workspace in $workspaces){
  $workspaceId = $workspace.Id
  $url = "groups/$workspaceId/"    
  Invoke-PowerBIRestMethod -Method Delete -Url $url
}

Get-PowerBIWorkspace
