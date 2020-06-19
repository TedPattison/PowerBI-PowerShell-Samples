$userName = "ADD_USER_EMAIL_HERE"
$password = "ADD_USER_PASSWORD_HERE"

$securePassword = ConvertTo-SecureString �String $password �AsPlainText -Force
$credential = New-Object �TypeName System.Management.Automation.PSCredential `
                         �ArgumentList $userName, $securePassword

Disconnect-PowerBIServiceAccount
$user = Connect-PowerBIServiceAccount -Environment Public -Credential $credential
$userName = $user.UserName

Write-Host
Write-Host "Now logged in as $userName"
Write-Host
