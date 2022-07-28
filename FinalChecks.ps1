<#
  .DESCRIPTION
    Run this script in the destination PowerShell environment.

    Run this in the destination environment to verify each mailbox shows Success as the value.

    The source CSV exported report from CrossTenantMigration-Report.ps1 .

  .NOTES
    Name: FinalChecks.ps1
    Author: Alex - alexf@macrotg.com
    Version: 1.0
    DateCreated: JUL 2022
#>

$CSV = Import-Csv -Path C:\temp\Export.csv

$Endpoint = Read-Host "Enter Endpoint name to check. This was created earlier in the project."

$CSV | ForEach-Object {
    Write-Host "Checking user: " $_.DisplayName
    Test-MigrationServerAvailability -EndPoint $Endpoint -TestMailbox $_.DestinationSmtp | fl Result,Message
    Write-Host "If result equals SUCCESS, the mail-user can be licensed in Admin center! Once licensed, you can create your batch!" -ForegroundColor Green
}