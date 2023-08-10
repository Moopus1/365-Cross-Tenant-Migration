<#
  .DESCRIPTION
    Run this script in the destination PowerShell environment.

    This script creates the respective MailUsers in the destination location. It will create them with needed fields: DisplayName, ExternalEmailAddresses
    (this is their source email), MicrosoftOnlineServicesID (this is their destination UPN / email), and lastly the mail users Password. By default, I've
    simply mapped them to all be Apples123!. You can change it below.

    After creating the MailUser, it will match the source ExchangeGuid, source ArchiveGuid, and add the original LegacyExchageDN as X500 proxy, and any
    additional X500 addresses.

    The source CSV exported report from CrossTenantMigration-Report.ps1 .

  .NOTES
    Name: DestinationUserCreation.ps1
    Author: Alex - alexf@macrotg.com
    Version: 1.1
    DateCreated: AUG 2023
#>

$CSV = Import-Csv -Path C:\temp\Export.csv

Write-Host "Creating mail users!"

$CSV | ForEach-Object {
    # Creation of user below --------------------------------------------------------------------------------
    $trunk = "x500:"+$_.LegacyExchangeDN
    $AdditionalX500 = $_.AdditionalX500
    $AdditionalX500Array = $AdditionalX500 -split ";"
    $Secure = ConvertTo-SecureString "Apples123!" -AsPlainText -Force
    Write-Host "Creating user" $_.DisplayName -ForegroundColor Yellow
    New-MailUser -Name $_.DisplayName -ExternalEmailAddress $_.PrimarySmtp -MicrosoftOnlineServicesID $_.DestinationSmtp -Password $Secure
    Write-Host "Waiting..." -ForegroundColor Green
    Start-Sleep -Seconds 2

    # Setting of values below ---------------------------------------------------------------------------------
    Write-Host "Setting new user's values!" -ForegroundColor Green
    Set-MailUser -Identity $_.DisplayName -ExchangeGuid $_.ExchangeGuid -ArchiveGuid $_.ArchiveGuid -EmailAddresses @{add=$trunk}
    Start-Sleep -Seconds 1

    #Add Additional X500 Addresses
    Set-MailUser -Identity $_.DisplayName -EmailAddresses @{add=$AdditionalX500Array} -ErrorAction SilentlyContinue
}