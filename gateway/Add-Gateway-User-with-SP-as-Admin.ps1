# login as user with admn permissions on gateway
Connect-DataGatewayServiceAccount -Environment Public

# determine service principal ID of application - this is not application ID
$servicePrincipalObjectId = "ADD_SERVICE_PRINCIPAL_ID"

# this script assumes tenant has single gateway (aka gateway cluster)
$gateway = Get-DataGatewayCluster 

Add-DataGatewayClusterUser -GatewayClusterId $gateway.Id -PrincipalObjectId $servicePrincipalObjectId -Role Admin 