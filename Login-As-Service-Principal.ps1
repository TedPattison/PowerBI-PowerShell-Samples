cls
$tenantId = "ADD_TENANT_ID_HERE"
$applictionId = "ADD_APPLICATION_ID_HERE"
$applicationSecret = "ADD_APPLICATION_SECRET_HERE"

$SecuredApplicationSecret = ConvertTo-SecureString –String $applicationSecret –AsPlainText -Force
$credential = New-Object –TypeName System.Management.Automation.PSCredential `
                         –ArgumentList $applictionId, $SecuredApplicationSecret

Disconnect-PowerBIServiceAccount
$sp = Connect-PowerBIServiceAccount -Environment Public -ServicePrincipal  -Credential $credential -Tenant $tenantId

$AppId = $sp.UserName

Write-Host
Write-Host "Logged on as service principal with AppID of $AppId"
Write-Host
