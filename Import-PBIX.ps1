
$workspaceName = "Wingtip Sales"
$importName = "Wingtip Sales"
$pbixFileName = "WingtipSales.pbix"

# determin path to PBIX file in same folder as this script
$scriptPath = Split-Path -parent $PSCommandPath
$pbixFilePath =   "$scriptPath\$pbixFileName"

# get target workspace
$workspace = Get-PowerBIWorkspace -Name $workspaceName

# import PBIX with CreateOrOverride behavior
$import = New-PowerBIReport -Path $pbixFilePath -Name $importName -Workspace $workspace -ConflictAction CreateOrOverwrite