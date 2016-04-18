$WorkspaceID = ''
$WorkspaceKey = ''
$GetDate = Get-Date -UFormat '%Y%m%d%H%M%S'
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

$ServerFile = "$scriptDir\serveur_Henner.csv"

$ServerFileCSV = Import-csv $ServerFile

foreach ($Server in $ServerFileCSV)
{
    $ServerName = $Server.Serveur
    Write-Host -ForegroundColor Yellow $ServerName
    
    Copy-item "$scriptDir\MMASetup-AMD64.exe" -container -recurse \\$ServerName\c$\windows\temp\
    
    $Session = New-PSSession -ComputerName $ServerName
    $Script = {C:\Windows\Temp\MMASetup-AMD64.exe "/C:/setup.exe /qn ADD_OPINSIGHTS_WORKSPACE=1 OPINSIGHTS_WORKSPACE_ID=$using:WorkspaceID OPINSIGHTS_WORKSPACE_KEY=$using:WorkspaceKey AcceptEndUserLicenseAgreement=1"}
    Invoke-Command -Session $Session -ScriptBlock $Script
}