$tenantId = "ADD_TENANT_ID_HERE"
$applictionId = "ADD_APPLICATION_ID_HERE"
$certificateThumbprint = "ADD_CERTIFICATE_THUMBPRINT_HERE"

# Disconnect-PowerBIServiceAccount
$sp = Connect-PowerBIServiceAccount -ServicePrincipal -ApplicationId $applictionId -CertificateThumbprint $certificateThumbprint -Tenant $tenantId

$AppId = $sp.UserName

Write-Host
Write-Host "Logged on as service principal with AppID of $AppId"
Write-Host
